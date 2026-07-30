# 武林 (wulin)

Taroko 的教材、工作負載與技術文件。

平台本體在 [tarokolabs/tk8s](https://github.com/tarokolabs/tk8s)。

## 這裡有什麼

| 目錄 | 內容 |
|---|---|
| `docs/` | 技術文件——Kubernetes、Linux、VMware、Backstage 等主題 |
| `workloads/` | 可部署的工作負載——監控、資料庫、儲存、應用 |
| `labs/` | 成套的課程專案 |
| `examples/` | 單檔教學範例——K8s manifest、Python、Argo Workflows |
| `images/` | 工作負載的容器建置 |
| `legacy/` | 舊世代（VMware + Talos）內容的暫存區，見該目錄的 README |

## 與平台的關係

這裡的工作負載**不依賴 Taroko 平台**。它們只用 `kubectl`、`podman`、`docker`、`kustomize`，
可以部署到任何 Kubernetes 叢集。

平台側的元件（CNI、MetalLB、Gateway、管理主機等）在 `tk8s`，不在這裡。

## 想參與

- 發現問題、想提需求 → 開 [issue](https://github.com/tarokolabs/wulin/issues/new)
- 還不確定要不要做、想討論方向 → 開 [Discussion](https://github.com/tarokolabs/tk8s/discussions)
- **不確定該開哪個 → 開 issue 就好**，維護者會幫你轉

進度看 [Taroko Roadmap](https://github.com/orgs/tarokolabs/projects/1)。

## 授權

GPL-2.0，與 `tk8s` 一致。第三方元件的授權見各自目錄。
