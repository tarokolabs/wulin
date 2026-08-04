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
| `platform/` | 平台（tk8s）條件部署用的素材——管理主機（tkadm）的 manifest 與執行期腳本 |
| `bin/` | 工具腳本——image 建置（`build-images.sh`）、第三方依賴取得（`fetch-deps.sh`） |
| `legacy/` | 舊世代內容與課綱未再使用者的暫存區，見該目錄的 README |

## 與平台的關係

這裡的工作負載**不依賴 Taroko 平台**。它們只用 `kubectl`、`podman`、`docker`、`kustomize`，
可以部署到任何 Kubernetes 叢集。

平台側的元件（CNI、MetalLB、Gateway、管理主機等）在 `tk8s`，不在這裡。

## 想參與

- 發現問題、想提需求 → 開 [issue](https://github.com/tarokolabs/wulin/issues/new)
- 還不確定要不要做、想討論方向 → 開 [Discussion](https://github.com/tarokolabs/tk8s/discussions)
- **不確定該開哪個 → 開 issue 就好**，維護者會幫你轉

進度看 [Taroko Roadmap](https://github.com/orgs/tarokolabs/projects/1)。

## 建置素材（第三方二進位）

lab image 的建置與部分 lab 需要不隨 repo 散佈的第三方檔案（授權合規與供應鏈信任——使用者應能自行驗證來源）。取得方式：

```bash
bin/fetch-deps.sh            # 全部
bin/fetch-deps.sh mariadb    # 只取檔名含關鍵字的項目
```

每一項都自權威來源（Maven Central、Apache archive、Ubuntu archive、Spark 官方發行版）下載並以 SHA256 釘死，校驗失敗即中止。其中 OpenSSL 1.1.1f 的 deb 已 EOL——僅限教學叢集內部使用，適用範圍與決議見 tk8s#14。

## 授權

本專案採 **GPL-2.0-or-later**（GNU GPL v2，或依你的選擇任何更新版本），與 `tk8s` 一致，見 [LICENSE](LICENSE)。第三方元件的授權見各自目錄。
