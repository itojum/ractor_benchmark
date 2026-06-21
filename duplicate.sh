#!/bin/bash

COUNT=10000          # 複製する数
SOURCE="origin.md"

if [ ! -f "$SOURCE" ]; then
  echo "Error: $SOURCE が見つかりません" >&2
  exit 1
fi

for i in $(seq 1 "$COUNT"); do
  DEST="app/${SOURCE%.md}_${i}.md"
  cp "$SOURCE" "$DEST"
  echo "作成: $DEST"
done
