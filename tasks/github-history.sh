#!/bin/bash
# Open commit history on GitHub (current branch)

FILE="$1"

# Git リポジトリのルートを取得
REPO_ROOT=$(git -C "$(dirname "$FILE")" rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$REPO_ROOT" ]]; then
  osascript -e 'display notification "Not a Git repository" with title "GitHub History"'
  exit 1
fi

# リモート URL を取得
REMOTE_URL=$(git -C "$REPO_ROOT" config --get remote.origin.url)
if [[ -z "$REMOTE_URL" ]]; then
  osascript -e 'display notification "No remote origin found" with title "GitHub History"'
  exit 1
fi

# GitHub URL に変換
if [[ "$REMOTE_URL" =~ ^git@github\.com:(.+)\.git$ ]]; then
  GITHUB_REPO="https://github.com/${BASH_REMATCH[1]}"
elif [[ "$REMOTE_URL" =~ ^https://github\.com/(.+)\.git$ ]]; then
  GITHUB_REPO="https://github.com/${BASH_REMATCH[1]}"
elif [[ "$REMOTE_URL" =~ ^https://github\.com/(.+)$ ]]; then
  GITHUB_REPO="https://github.com/${BASH_REMATCH[1]}"
else
  osascript -e 'display notification "Not a GitHub repository" with title "GitHub History"'
  exit 1
fi

# 現在のブランチを取得
BRANCH=$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD)

# ファイルの相対パスを取得
RELATIVE_PATH="${FILE#$REPO_ROOT/}"

# GitHub コミット履歴 URL を構築
URL="${GITHUB_REPO}/commits/${BRANCH}/${RELATIVE_PATH}"

# ブラウザで開く
open "$URL"
