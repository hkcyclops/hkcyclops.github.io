# 保險計算工具 · GitHub Pages 站點

基於 GitHub Pages 的免費靜態站點，收錄四個保險／理財計算工具，採用統一的 AIA 紅／炭黑視覺風格。

## 站點內容（四個工具）

| 頁面 | 工具 | 說明 |
|------|------|------|
| `index.html` | 封面首頁 | 四個工具的入口，含品牌 hero 與黑色表頭導覽 |
| `premium-financing.html` | 保費融資計算機 | 整付保單融資 ROI、客戶自付與年化收益率（IRR）測算 |
| `medical-insurance.html` | 醫療保費查詢器 | 依年齡／方案／自付額估算醫療險保費 |
| `irr-calculator.html` | IRR 回報計算機 | 整付／年繳保費的內部報酬率（IRR）純數值測算 |
| `mortgage-calculator.html` | 按揭貸款計算機 | 等额本息／等额本金的每月還款、總利息與還款走勢 |

每頁黑色表頭內都內嵌四個工具連結（當前頁以紅色藥丸高亮），可直接互跳；右上角「← 返回首頁」回到 `index.html`。

## 目錄結構

```
github-pages/
├─ index.html              首頁（封面）
├─ premium-financing.html  保費融資計算機
├─ medical-insurance.html  醫療保費查詢器
├─ irr-calculator.html     IRR 回報計算機
├─ mortgage-calculator.html 按揭貸款計算機
├─ assets/                 圖片資源（hero 圖等）
├─ deploy.sh               一鍵推送腳本
└─ README.md               本文件
```

## 發布步驟（首次）

本倉庫已是 `hkcyclops.github.io` 的用戶站點，`deploy.sh` 中的 `USERNAME` 已設為 `hkcyclops`，一般無需修改。

1. **確認 GitHub Pages 已開啟**：倉庫 **Settings → Pages** → Source 選 **Deploy from a branch**，Branch 選 **main**，資料夾 **/ (root)**，Save。
2. **推送**：在本目錄開終端（Git Bash）執行
   ```bash
   bash deploy.sh
   ```
   首次推送需用 **Personal Access Token (PAT)** 代替密碼（見下方認證說明）。
3. 約 1 分鐘後造訪 `https://hkcyclops.github.io` 即可看到網站。

## 之後怎麼更新

改完本地檔案後再跑一次 `bash deploy.sh` 即可（`deploy.sh` 會 `git add -A` 並提交推送）。GitHub Pages 通常幾十秒到一分鐘生效。

> 💡 手機瀏覽器緩存較頑固：若改版後手機仍看到舊頁，在網址後加 `?v=N`（例如 `index.html?v=5`）強制刷新。

## 關於推送認證（HTTPS）

GitHub 自 2021 年起不再接受帳號密碼推送 HTTPS，請用：

- **Personal Access Token (PAT)**：GitHub → Settings → Developer settings → Personal access tokens → 生成具 `repo` 權限的 token；推送時「密碼」處貼上此 token。或
- **gh CLI**：`gh auth login` 後以授權方式 `git push`。

## 綁定自有域名（可選）

1. 域名 DNS 加 `CNAME` 指向 `hkcyclops.github.io`（或 A 記錄指向 GitHub IP）。
2. 倉庫 Settings → Pages → Custom domain 填域名，勾選 Enforce HTTPS。

---

本地資料夾位置不拘，GitHub Pages 只看倉庫內容，不看你電腦上的位置。
