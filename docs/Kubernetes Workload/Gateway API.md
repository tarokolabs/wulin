# Gateway API

* Gateway API 就是用來取代 Ingress 的。
* 在 Kubernetes 中，Gateway API 是一種用於管理和保護 API 流量的軟體。它充當單一入口點，可讓客戶端訪問後端服務。
* Kubernetes Gateway API 是 Kubernetes 1.18 版本引進的一種新的 API 規範，是 Kubernetes 官方正在開發的新的 API，Ingress 是 Kubernetes 已有的 API。Gateway API 會成為 Ingress 的下一代替代方案。Gateway API 提供更豐富的功能，支援 TCP、UDP、TLS 等，不只是 HTTP。Ingress 主要面向 HTTP 流量。Gateway API 具有更強的擴充性，透過 CRD 可以輕易新增特定的 Gateway 類型。 


## 架構圖
![image](https://hackmd.io/_uploads/ByMs9xzM0.png)
## 運作原理
![image](https://hackmd.io/_uploads/rJYs5efMR.png)
* GatewayClass： 一組共用通用設定和行為的 Gateway 集合，就像 IngressClass、StorageClass 一樣。
* Gateway：就是 GatewayClass 的具體實現，聲明後由 GatewayClass 的基礎設備提供者提供一個具體存在的 Pod，充當了進入 Kubernetes 集群的流量的入口，負責流量接入以及往後轉發，同時還可以起到一個初步過濾的效果。
* HTTPRoute： 定義特定於 HTTP 的規則，用於將流量從 Gateway 導入到應到後端的服務。這些端點通常表示為 Service。

## Gateway API 在 tk8s 平台上的實作

tk8s 建叢集時已裝好 Gateway API CRD（v1.6.1，experimental channel，含 TCPRoute、UDPRoute、TLSRoute、GRPCRoute），Gateway API 的 controller 由 **cilium 內建**提供，LoadBalancer IP 由 cilium 的 LB-IPAM 配發（節點網段 `.200`–`.219`），**不需要另外安裝 controller 或 MetalLB**。

* 查看已安裝的 CRD 資源
```
$ kubectl get crd | grep gateway.networking.k8s.io
backendtlspolicies.gateway.networking.k8s.io   ...
gatewayclasses.gateway.networking.k8s.io       ...
gateways.gateway.networking.k8s.io             ...
grpcroutes.gateway.networking.k8s.io           ...
httproutes.gateway.networking.k8s.io           ...
listenersets.gateway.networking.k8s.io         ...
referencegrants.gateway.networking.k8s.io      ...
tcproutes.gateway.networking.k8s.io            ...
tlsroutes.gateway.networking.k8s.io            ...
udproutes.gateway.networking.k8s.io            ...
```
* 流量入口是 cilium 的 envoy（每個節點一個，DaemonSet）
```
$ kubectl get pod -n kube-system -l k8s-app=cilium-envoy
NAME                 READY   STATUS    RESTARTS   AGE
cilium-envoy-2xk7p   1/1     Running   0          10m
cilium-envoy-8wq4d   1/1     Running   0          10m
cilium-envoy-pl9zc   1/1     Running   0          10m
```

> 在其他叢集（非 tk8s）上自行安裝時：先 `kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.6.1/experimental-install.yaml`，再選一個 Gateway API 的實作（cilium `gatewayAPI.enabled=true`、Envoy Gateway、Istio 等）並確保叢集能配發 LoadBalancer IP。

## GatewayClass

GatewayClass `cilium` 由平台建好，直接使用即可（不用自己建）：
```
$ kubectl get gatewayclass
NAME     CONTROLLER                     ACCEPTED   AGE
cilium   io.cilium/gateway-controller   True       10m
```

## gateway api 測試
* 部屬測試用 backend deployment
```
$ echo $'apiVersion: v1
kind: Service
metadata:
  name: svc-backend
  labels:
    app: backend
    service: backend
spec:
  ports:
    - name: http
      port: 3000
      targetPort: 3000
  selector:
    app: backend
---
apiVersion: v1
kind: Service
metadata:
  name: svc-backend2
  labels:
    app: backend2
    service: backend2
spec:
  ports:
    - name: http
      port: 3000
      targetPort: 3000
  selector:
    app: backend2
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
      version: v1
  template:
    metadata:
      labels:
        app: backend
        version: v1
    spec:
      containers:
        - image: docker.io/taiwanese/echoserver
          imagePullPolicy: IfNotPresent
          name: backend
          ports:
            - containerPort: 3000
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend2
      version: v1
  template:
    metadata:
      labels:
        app: backend2
        version: v1
    spec:
      containers:
        - image: docker.io/taiwanese/echoserver
          imagePullPolicy: IfNotPresent
          name: backend2
          ports:
            - containerPort: 3000
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace' | kubectl apply -f -
```
```
$ kubectl get svc,pod
NAME                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/kubernetes     ClusterIP   10.43.0.1      <none>        443/TCP    76d
service/svc-backend    ClusterIP   10.43.144.57   <none>        3000/TCP   4m10s
service/svc-backend2   ClusterIP   10.43.198.74   <none>        3000/TCP   4m10s

NAME                            READY   STATUS    RESTARTS   AGE
pod/backend-6c74b76b4-r6npw     1/1     Running   0          7h52m
pod/backend2-67c74bfb48-6q78n   1/1     Running   0          5h54m
```

* 部屬 gateway resource
* 設定 gateway 對外開的 port 是 80
```
$ echo 'apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
spec:
  gatewayClassName: cilium
  listeners:
    - name: http
      protocol: HTTP
      port: 80' | kubectl apply -f -
```
```
$ kubectl get gateway
NAME         CLASS    ADDRESS        PROGRAMMED   AGE
my-gateway   cilium   172.22.0.200   True         15s
```
* cilium 會在 **Gateway 所在的 namespace** 建一個 LoadBalancer 型 Service，名稱是 `cilium-gateway-<Gateway 名稱>`，對外 IP 從 LB-IPAM 的池子取得；流量進到該 IP 後交給節點上的 cilium-envoy 處理。
```
$ kubectl get svc cilium-gateway-my-gateway
NAME                        TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
cilium-gateway-my-gateway   LoadBalancer   10.98.0.168   172.22.0.200   80:30682/TCP   20s
```

* 部屬 httproute resource
* 來自 Gateway 的 HTTP 流量， 如果 Host 的 header 設定為 `www.example.com` 且請求路徑指定為 `/backend`， 將被路由至 svc-backend ，如果請求路徑指定為 `/backend2` 將被路由至 svc-backend2。

```
$ echo 'apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: backend
spec:
  parentRefs:
    - name: my-gateway
  hostnames:
    - "www.example.com"
  rules:
    - backendRefs:
        - group: ""
          kind: Service
          name: svc-backend
          port: 3000
          weight: 1
      matches:
        - path:
            type: PathPrefix
            value: /backend
    - backendRefs:
        - group: ""
          kind: Service
          name: svc-backend2
          port: 3000
          weight: 1
      matches:
        - path:
            type: PathPrefix
            value: /backend2' | kubectl apply -f -
```
```
$ kubectl get httproute
NAME      HOSTNAMES             AGE
backend   ["www.example.com"]   4m18s
```
* 檢查 HTTPRoute 已被 Gateway 接受
```
$ kubectl get httproute backend -o jsonpath='{.status.parents[0].conditions[*].type}{"\n"}'
Accepted ResolvedRefs
```

## request 流程圖
![image](https://hackmd.io/_uploads/rJ9TffffC.png)

1. Client 開始準備 URL 為 `http://www.example.com` 的 HTTP 請求 
2. Client 的 DNS 會先做名稱解析到對應的 IP。 
3. Client 向 Gateway IP 位址發送 request；反向代理接收 HTTP request 並使用 header 匹配 Gateway 和 HTTPRoute 的設定。 
4. 反向代理可以根據 HTTPRoute 的匹配規則針對 request 所帶的 path 需要符合規則。 
5. 反向代理可以修改 request；例如，根據 HTTPRoute 的過濾規則新增或刪除 header。 
6. 最後，反向代理將請求轉送到一個或多個後端。

* 在叢集外（tk8s 主機）測試打 request，可以透過不同的 path 將流量導入到不同的服務。後端看到的 `X-Forwarded-For` 是客戶端（主機）的 IP。
```
$ curl -H "host: www.example.com" http://172.22.0.200/backend
{
 "path": "/backend",
 "host": "www.example.com",
 "method": "GET",
 "proto": "HTTP/1.1",
 "headers": {
  "Accept": [
   "*/*"
  ],
  "User-Agent": [
   "curl/8.0.1"
  ],
  "X-Forwarded-For": [
   "172.22.0.254"
  ],
  "X-Forwarded-Proto": [
   "http"
  ],
  "X-Request-Id": [
   "c218884d-3a8d-4ca1-b280-4f027c7acc3d"
  ]
 },
 "namespace": "default",
 "ingress": "",
 "service": "",
 "pod": "backend-6c74b76b4-r6npw"
}

$ curl -H "host: www.example.com" http://172.22.0.200/backend2
{
 "path": "/backend2",
 "host": "www.example.com",
 "method": "GET",
 "proto": "HTTP/1.1",
 "headers": {
  "Accept": [
   "*/*"
  ],
  "User-Agent": [
   "curl/8.0.1"
  ],
  "X-Forwarded-For": [
   "172.22.0.254"
  ],
  "X-Forwarded-Proto": [
   "http"
  ],
  "X-Request-Id": [
   "f7ff826f-2c47-47a0-9940-abe4898b6517"
  ]
 },
 "namespace": "default",
 "ingress": "",
 "service": "",
 "pod": "backend2-67c74bfb48-6q78n"
}
```

* 環境清除
```
$ kubectl delete httproute backend

$ kubectl delete gateway my-gateway
```
