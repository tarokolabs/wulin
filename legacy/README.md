# legacy — 舊世代內容的暫存區

> **這是暫存區，不是歸宿。** 這裡的內容有明確的處置方向，進度見下方追蹤 issue。

## 這裡是什麼

VMware Workstation + Talos Linux 世代（VMTK2024）的內容，來自平台 repo（[tarokolabs/tk8s](https://github.com/tarokolabs/tk8s)）重整前的狀態。

| 目錄 | 內容 |
|---|---|
| `Workload/` | 上一代的工作負載（`wulin/` `DevOps/` `GitOps/` `open-webui/` `base-images/`） |
| `examples/` | 上一代的範例 |
| `TM/` | 僅一個 README |

## 為什麼還留著

它們不一定過時——`DevOps/` 與 `GitOps/` 底下有現行世代沒有的內容，直接刪掉會弄丟東西。所以先集中放這裡，逐項判斷。

已知部分檔案與現行內容**完全相同**（重整時 git 的 rename 偵測找到多個 100% 相同的配對），那些可以放心刪。

## 每一項的結局只有兩種

1. **整理進 `docs/` / `workloads/` / `examples/`** — 內容仍有價值
2. **刪除** — 已被現行世代取代

刪除是安全的：這些檔案的完整歷史仍在 [tarokolabs/tk8s](https://github.com/tarokolabs/tk8s)（`git log --all -- <path>`），且 tag [`pre-restructure-2026-07-29`](https://github.com/tarokolabs/tk8s/tree/pre-restructure-2026-07-29) 釘住了重整前的完整狀態。

## 不要做的事

- **不要**在這裡新增內容。這是單向的出口，只會變少不會變多。
- **不要**讓它無限期存在。若追蹤 issue 關了而這個目錄還在，就是流程失效了。

## 追蹤

處置進度見本 repo 的 `legacy` 標籤 issue。
