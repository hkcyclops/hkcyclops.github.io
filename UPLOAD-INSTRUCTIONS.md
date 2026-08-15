# Calculator Hub · GitHub Pages 手动上传说明

此压缩包内的文件是已经构建好的静态站点。请**解压后上传文件夹内的全部内容**，不要上传外层压缩包或额外再套一层目录；`index.html` 必须位于仓库根目录。

| 步骤 | 操作 |
| --- | --- |
| 1 | 打开 `https://github.com/hkcyclops/hkcyclops.github.io`，切换至 `main` 分支。 |
| 2 | 删除或替换仓库根目录中的旧站点文件，然后上传本包解压后的**全部内容**。 |
| 3 | 提交变更后，进入 **Settings → Pages**。选择 **Deploy from a branch**、分支 `main`、目录 `/(root)`，然后保存。 |
| 4 | 等待 GitHub Pages 构建完成后，访问 `https://hkcyclops.github.io/`。 |

## 包内关键文件

- `index.html`：统一首页。
- `tools/`：五个原始计算器的独立静态页面与资源。
- `assets/`：主应用打包资源。
- `manus-storage/`：入口页的品牌标识与视觉图像。
- `404.html`：使 `/workspace/irr` 等直接链接能回退至单页应用。
- `.nojekyll`：关闭 Jekyll 处理，确保带下划线的静态资源保持可访问。

> 若更新后仍看到旧版本，请以无痕窗口打开，或在网址末尾加入 `?v=1` 后刷新。
