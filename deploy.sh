#!/usr/bin/env bash
# 一键推送 / 更新 GitHub Pages 站点
# 用法：在本目录下运行  bash deploy.sh
set -e

# ↓↓↓ 改成你的 GitHub 用户名（必须和仓库名前缀一致）↓↓↓
USERNAME="hkcyclops"
# ↑↑↑ 改成你的 GitHub 用户名 ↑↑↑

REMOTE="https://github.com/$USERNAME/$USERNAME.github.io.git"

# 设置远程仓库（已存在则更新地址）
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE"
else
  git remote add origin "$REMOTE"
fi

git add -A
git commit -m "update site $(date +%F_%T)" || echo "没有需要提交的改动"
git branch -M main
git push -u origin main

echo ""
echo "✅ 推送完成。访问 https://$USERNAME.github.io 查看（首次约 1 分钟生效）。"
