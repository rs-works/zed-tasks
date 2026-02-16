#!/bin/bash
# 現在のGitブランチに対応するCircleCIのWeb画面を開く

cd "$ZED_WORKTREE_ROOT" 2>/dev/null || cd "$(git rev-parse --show-toplevel)"

branch=$(git symbolic-ref --short HEAD 2>/dev/null)
if [ -z "$branch" ]; then
  echo "Error: Gitブランチを取得できませんでした" >&2
  exit 1
fi

# リモートURLからオーナー/リポジトリ名を取得
remote_url=$(git remote get-url origin 2>/dev/null)
# git@github.com:owner/repo.git or https://github.com/owner/repo.git
repo=$(echo "$remote_url" | sed -E 's#(git@github\.com:|https://github\.com/)##;s#\.git$##')

if [ -z "$repo" ]; then
  echo "Error: リポジトリ情報を取得できませんでした" >&2
  exit 1
fi

# ブランチ名をURLエンコード（/→%2F）
encoded_branch="${branch//\//%2F}"

url="https://app.circleci.com/pipelines/github/${repo}?branch=${encoded_branch}"
open "$url"
