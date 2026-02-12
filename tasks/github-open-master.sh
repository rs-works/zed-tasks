#!/bin/bash
# Open current file on GitHub (master branch)

FILE="$1"

# Git リポジトリのルートを取得
REPO_ROOT=$(git -C "$(dirname "$FILE")" rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$REPO_ROOT" ]]; then
  osascript -e 'display notification "Not a Git repository" with title "GitHub Open"'
  exit 1
fi

# リモート URL を取得
REMOTE_URL=$(git -C "$REPO_ROOT" config --get remote.origin.url)
if [[ -z "$REMOTE_URL" ]]; then
  osascript -e 'display notification "No remote origin found" with title "GitHub Open"'
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
  osascript -e 'display notification "Not a GitHub repository" with title "GitHub Open"'
  exit 1
fi

# ファイルの相対パスを取得
RELATIVE_PATH="${FILE#$REPO_ROOT/}"

# GitHub URL を構築 (master ブランチ固定)
URL="${GITHUB_REPO}/blob/master/${RELATIVE_PATH}"

# ブラウザで開く
open "$URL"
