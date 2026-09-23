# RuntimeClass 範例

tk8s 建好的叢集已有兩個 RuntimeClass（由平台的 `manifests/runtimeclass.yaml` 建立），CRI-O 與 containerd 兩種 runtime 路徑一致：

| RuntimeClass | handler | 說明 |
|---|---|---|
| `crun` | `crun` | 一般容器，也是節點的預設 runtime |
| `gvisor` | `runsc` | gVisor 沙箱，pod 內 `uname -r` 會看到 gVisor 核心 |

**gVisor 需要叢集以 veth datapath 建立**：`CILIUM_DATAPATH=veth tkctl cluster create <名>`。平台預設（核心 ≥6.8）是 netkit，gVisor 沙箱在 netkit 下起得來但沒有網路（tk8s#56 實測）。

| 檔案 | 用途 |
|---|---|
| `pod-crun.yaml`、`pod-crio.yaml` | 用 `crun` 跑 pod |
| `pod-gvisor.yaml` | 用 `gvisor` 跑 pod；`kubectl exec base-gvisor -- uname -r` |
| `rc-crun.yaml`、`rc-gvisor.yaml` | 與平台建立的 RuntimeClass 相同，讀懂 RuntimeClass 長什麼樣用；重複 apply 無害 |
| `rc-crio.yaml` | **範本**：自訂 handler（`crioclass` → `mycrio`）。節點的 CRI 沒有註冊 `mycrio` 之前，用它的 pod 會卡 `failed to find runtime handler`——要先在節點的 `/etc/crio/crio.conf.d/` 加對應 `[crio.runtime.runtimes.mycrio]` 並重載 crio |
