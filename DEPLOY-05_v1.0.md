# 05 匯兌計算機 · 上線部署指引 v1.0

> 目標：把本機已跑通的 05 匯兌推上 `hkcyclops.github.io`，並部署 Cloudflare Worker 打通即時匯率。
> 全程只做**增量**，不會動到線上任何既有頁面。

---

## 0 · 現在的狀態

### 已經做好（本機）

| 項目 | 狀態 |
|---|---|
| 05 匯兌雙通道接線 | ✅ Actions 每日快照 + Worker 即時，四級降級 |
| 開頁自動刷新一次 | ✅ 徽章直接顯示「已讀取 AIA 當日數據」 |
| Worker 程式碼 | ✅ 白名單已收緊、本地模擬測試 6/6 通過 |
| 端到端聯調 | ✅ 05 → Worker → AIA，13 種貨幣、USD 7.8431、0 JS 錯誤 |
| 本機 Git 提交 | ✅ `28cc1b7`（在 `_deploy/`，**尚未推送**） |

### 待你做的四件事

| # | 事項 | 為什麼必須你做 |
|---|---|---|
| A | 推送到 GitHub | 本機沒有任何 Git 憑據 |
| B | 開通 Actions 寫入權限 | 沒開，每日匯率更新會靜默失敗 |
| C | 部署 Cloudflare Worker | 需要 Cloudflare 帳號登入 |
| D | 把 Worker 網址填回 05 | Worker 網址要部署完才知道 |

---

## A · 推送到 GitHub

### A-1 · 授權（擇一）

**方式 1 · 瀏覽器登入（最簡單，不用產生任何金鑰）**

直接執行推送指令，Git Credential Manager 會開瀏覽器要你登入 GitHub，跟著畫面按授權即可。

**方式 2 · Personal Access Token（瀏覽器沒反應時用）**

1. 開 https://github.com/settings/personal-access-tokens → **Generate new token (fine-grained)**
2. Repository access 選 **Only select repositories** → `hkcyclops.github.io`
3. Permissions → **Contents: Read and write**
4. 產生後複製那串 `github_pat_...`
5. 推送時，使用者名稱填 `hkcyclops`，**密碼欄貼上那串 token**（不是你的 GitHub 密碼）

### A-2 · 推送

```bash
cd "C:/Users/Administrator/WorkBuddy/2026-08-28-22-11-18/calculator-hub/_deploy"
git push origin HEAD
```

成功會看到 `To https://github.com/hkcyclops/hkcyclops.github.io.git` 與 `main -> main`。

### A-3 · 這一次推了什麼

```
05-exchange-calculator.html            980,119 B   新增
data/rates.js                              407 B   新增
.github/workflows/update-rates.yml       2,580 B   新增
```

三個都是**新增**，線上原本沒有同名檔案，所以舊站完全不受影響。

---

## B · 開通 Actions 寫入權限（**這步不做，每日匯率不會更新**）

1. 開 https://github.com/hkcyclops/hkcyclops.github.io/settings/actions
2. 拉到最底 **Workflow permissions**
3. 改選 **Read and write permissions** → Save

驗證方式：
1. https://github.com/hkcyclops/hkcyclops.github.io/actions
2. 左側選 **Update AIA Exchange Rates** → **Run workflow** → **Run workflow**
3. 約 20 秒後看結果，成功會印出 `日期: 08/29/2026 幣種數: 13`

> 之後每天香港時間 08:00 自動跑一次（GitHub 有時會延遲 5–30 分鐘，偶爾跳過）。
> 匯率沒變就不會提交，不會用空 commit 洗版。

---

## C · 部署 Cloudflare Worker

不用裝 `wrangler`，純 Dashboard 貼上即可。

1. 登入 https://dash.cloudflare.com/
2. 左側 **Workers & Pages** → **Create** → **Create Worker**
3. Name 填 `aia-rates` → **Deploy**
4. 進到 Worker 頁面 → **Edit code**
5. 把編輯器裡的預設程式碼**整段刪掉**，貼上 `cloudflare-worker/aia-rates.js` 的完整內容
6. **Deploy**

部署完成後，網址會長這樣（請記下來，步驟 D 要用）：

```
https://aia-rates.<你的子網域>.workers.dev
```

### 驗證 Worker

瀏覽器直接開那個網址，應該看到：

```json
{ "ok": true, "service": "aia-rates", "upstream": "https://www1.aia.com.hk/..." }
```

開 `https://aia-rates.<子網域>.workers.dev/rates` 則會看到 AIA 的原始匯率陣列（14 筆：1 個 date + 13 種貨幣）。

### 安全設定說明

Worker 已改成**來源白名單**，不再是 `*`：

| 來源 | 結果 |
|---|---|
| `https://hkcyclops.github.io` | ✅ 放行 |
| `http://localhost:*` / `http://127.0.0.1:*` | ✅ 放行（本機預覽用） |
| 其他任何網域 | ❌ 403 `origin not allowed` |

上線穩定後可以把 `aia-rates.js` 裡的 `const ALLOW_LOCAL = true` 改成 `false`。

---

## D · 把 Worker 網址填回 05

1. 開 `calculator-hub/05-exchange-calculator.html`
2. 找到第 60 行：

```js
window.__FX_CONFIG__ = { workerUrl: '', autoRefreshOnLoad: true };
```

3. 把 `workerUrl: ''` 改為：

```js
window.__FX_CONFIG__ = { workerUrl: 'https://aia-rates.<你的子網域>.workers.dev/rates', autoRefreshOnLoad: true };
```

4. 重新推送：

```bash
cd "C:/Users/Administrator/WorkBuddy/2026-08-28-22-11-18/calculator-hub"
"C:/Users/Administrator/.workbuddy/binaries/python/versions/3.14.3/python.exe" scripts/publish.py --push -m "chore(05): 填入 Worker 网址"
```

> 留空也能正常運作，只是改走 Actions 每日快照（`workerUrl` 留空時頁面完全不發外部請求）。

---

## E · 驗收清單

推送約 30–60 秒後，逐項確認：

| # | 檢查 | 預期 |
|---|---|---|
| 1 | 開 https://hkcyclops.github.io/05-exchange-calculator.html | 正常顯示，表頭、圖標、LANG 都在 |
| 2 | 開 https://hkcyclops.github.io/data/rates.js | 看到 `window.AIA_RATES = {...}` |
| 3 | 05 頁面狀態徽章 | 「已讀取 AIA 當日數據」（開頁自動刷新，不用點） |
| 4 | 05 頁面「匯率日期」 | 顯示當天日期 |
| 5 | 輸入 1 USD | 港幣金額 = 匯率 × 1（例如 7.8431） |
| 6 | 按「重新讀取」 | 數字不變、日期維持當天、無錯誤 |
| 7 | 按 F12 → Console | 無紅字錯誤 |
| 8 | 舊站 https://hkcyclops.github.io/ | 仍顯示**舊版**首頁（未受影響） |
| 9 | 舊工具頁 `irr-calculator.html` 等 | 仍可開（未受影響） |

### 已知現象（不是 bug）

- 05 表頭下拉選單點 01–06 會 404 —— 因為這次只推了 05，其餘還沒上。
- 本機 `127.0.0.1` 預覽時，按「重新讀取」會打 Manus 已失效的後端噴 404。
  這是原始碼裡 `a = Jw()` 依 hostname 判斷的正常分支，正式網域不會發生。

---

## F · 回滾

這次是純增量，回滾很單純——把那三個檔案刪掉即可：

```bash
cd "C:/Users/Administrator/WorkBuddy/2026-08-28-22-11-18/calculator-hub/_deploy"
git revert HEAD --no-edit
git push origin HEAD
```

或者只停掉每日更新：到 Actions 頁面把 **Update AIA Exchange Rates** 停用。

---

## G · 以後怎麼維護

日常改動就用這支腳本，它會自動擋下任何「會蓋掉線上既有檔案」的動作：

```bash
cd "C:/Users/Administrator/WorkBuddy/2026-08-28-22-11-18/calculator-hub"

# 看看會動到哪些檔案（不寫入）
"<python>" scripts/publish.py --status

# 同步並提交（不推送）
"<python>" scripts/publish.py

# 同步 + 提交 + 推送
"<python>" scripts/publish.py --push

# 追加其他檔案（例如之後要上首頁）
"<python>" scripts/publish.py --add index.html --allow-overwrite --push
```

`<python>` = `C:/Users/Administrator/.workbuddy/binaries/python/versions/3.14.3/python.exe`

> 注意：Actions 每天會更新 `data/rates.js`，所以本機 clone 會過期。
> 推送前先 `cd _deploy && git pull`。

---

## 附錄 · 四級降級機制

```
1. Cloudflare Worker 即時抓取 AIA  ← 按「重新讀取」時走這條
            ↓ 失敗
2. GitHub Actions 每日快照 data/rates.js  ← 主力，每天 HKT 08:00
            ↓ 失敗
3. localStorage 本機快取  ← 上次成功讀到的
            ↓ 失敗
4. 內建 13 種貨幣快照  ← 保底，永遠不會開天窗
```

任何一層掛掉，頁面都還是有數字可用，不會出現空白或錯誤畫面。
