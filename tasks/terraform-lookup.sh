#!/bin/bash
# Terraform Documentation Lookup Script

FILE="$1"
ROW="$2"
COLUMN="$3"

# ファイルが存在しない、または .tf ファイルでない場合はエラー
if [[ ! -f "$FILE" ]] || [[ ! "$FILE" =~ \.tf$ ]]; then
  osascript -e 'display notification "Not a Terraform file" with title "Terraform Lookup"'
  exit 1
fi

# カーソル位置から上方向に resource/data 行を探す
FOUND_LINE=""
CURRENT_ROW=$ROW

while [[ $CURRENT_ROW -ge 1 ]]; do
  LINE=$(sed -n "${CURRENT_ROW}p" "$FILE")
  
  # resource または data の開始行を見つけた
  if [[ "$LINE" =~ ^[[:space:]]*(resource|data)[[:space:]]+\"([a-z0-9]+)_([a-z0-9_]+)\" ]]; then
    FOUND_LINE="$LINE"
    break
  fi
  
  # 別のブロックの終わり（閉じ括弧のみの行）に到達したら終了
  if [[ "$LINE" =~ ^[[:space:]]*\}[[:space:]]*$ ]] && [[ $CURRENT_ROW -lt $ROW ]]; then
    break
  fi
  
  CURRENT_ROW=$((CURRENT_ROW - 1))
done

# resource/data が見つからなかった場合
if [[ -z "$FOUND_LINE" ]]; then
  osascript -e 'display notification "No resource/data found" with title "Terraform Lookup"'
  exit 1
fi

# resource または data 行を解析
if [[ "$FOUND_LINE" =~ ^[[:space:]]*(resource|data)[[:space:]]+\"([a-z0-9]+)_([a-z0-9_]+)\" ]]; then
  TYPE="${BASH_REMATCH[1]}"       # resource or data
  PROVIDER="${BASH_REMATCH[2]}"   # aws, google, etc.
  RESOURCE="${BASH_REMATCH[3]}"   # ecr_repository, eks_cluster, etc.
else
  osascript -e 'display notification "Failed to parse resource/data" with title "Terraform Lookup"'
  exit 1
fi

# プロバイダーの namespace をマッピング
case "$PROVIDER" in
  aws|google|azurerm|kubernetes|vault|consul|nomad|local|null|random|template|tls|http|external|archive)
    NAMESPACE="hashicorp"
    ;;
  datadog)
    NAMESPACE="datadog"
    ;;
  mongodbatlas)
    NAMESPACE="mongodb"
    ;;
  github)
    NAMESPACE="integrations"
    ;;
  *)
    # 不明な場合は hashicorp を試す
    NAMESPACE="hashicorp"
    ;;
esac

# URL 構築
if [[ "$TYPE" == "resource" ]]; then
  URL="https://registry.terraform.io/providers/${NAMESPACE}/${PROVIDER}/latest/docs/resources/${RESOURCE}"
else
  URL="https://registry.terraform.io/providers/${NAMESPACE}/${PROVIDER}/latest/docs/data-sources/${RESOURCE}"
fi

# ブラウザで開く
open "$URL"
