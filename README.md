# GitHub Pages 站点（用户主页）

这是一个已经初始化好的 GitHub Pages 仓库骨架。  
你只需要：把自己做好的 HTML 放进来 → 推送到 GitHub → 开启 Pages，网站就上线了。

## 目录说明

- `index.html` —— 网站首页（**必须叫这个名字**）。现在是占位页，直接覆盖成你自己的内容。
- 其它 `.css` / `.js` / 图片等，放同级目录，用相对路径引用即可。
- `deploy.sh` —— 一键推送/更新脚本（改完内容后运行它就能更新线上）。

## 发布步骤（只需做一次）

### 1. 在 GitHub 上建仓库

- 登录 GitHub，右上角 **New repository**。
- **仓库名必须填**：`你的用户名.github.io`（例如用户名是 `tom`，就填 `tom.github.io`）。
- 选 **Public**，其它默认，点 **Create repository**。
- ⚠️ 仓库名拼错就不会生效，严格按 `用户名.github.io` 来。

### 2. 把仓库地址里的用户名改对

打开本目录下的 `deploy.sh`，把第一行的：

```
USERNAME="YOUR_USERNAME"
```

改成你的 GitHub 用户名（和上面仓库名前缀一致）。

### 3. 推送上线

在本目录下打开终端（Git Bash），运行：

```bash
bash deploy.sh
```

首次会让你输入 GitHub 账号密码/令牌（见下方说明）。

### 4. 开启 GitHub Pages（通常自动，但确认一下）

- 进入仓库 **Settings → Pages**。
- Source 选 **Deploy from a branch**，Branch 选 **main**，文件夹选 **/ (root)**，点 **Save**。
- 等 1 分钟左右，访问 `https://你的用户名.github.io` 就能看到网站了。

## 之后怎么更新

改完本地文件后，直接再运行一次 `bash deploy.sh` 即可，线上会自动更新（通常几十秒生效）。

## 关于登录（推送认证）

GitHub 自 2021 年起**不再接受账号密码推送到 HTTPS**，需要用：

- **Personal Access Token (PAT)**：GitHub → Settings → Developer settings → Personal access tokens → 生成一个有 `repo` 权限的 token，推送时密码处粘贴这个 token；或
- 更省事：安装并登录 `gh` CLI（`gh auth login`），然后用 `gh repo clone` / `git push` 走授权。

## 进阶（可选）：绑定自己的域名

如果你买了自己的域名（如 `example.com`）：

1. 域名DNS 加一条 `CNAME` 记录指向 `你的用户名.github.io`（或用 A 记录指向 GitHub 的 IP）。
2. 仓库 Settings → Pages → Custom domain 填上你的域名，勾选 Enforce HTTPS。  
   免费托管不变，只是多花一个域名钱（约 ¥10–70/年）。

---

本地文件夹放在哪里都行，GitHub Pages 只看仓库内容，不看你电脑上的位置。
