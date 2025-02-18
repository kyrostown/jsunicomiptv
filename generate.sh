#!/bin/bash

# 檢查 input.txt 是否存在
if [ ! -f "input.txt" ]; then
  echo "錯誤：找不到 input.txt 檔案"
  exit 1
fi

# 清空 jsunicom.m3u 檔案 (如果存在) 或創建一個新檔案
> jsunicom.m3u  # 這樣可以避免 SHA 衝突，確保每次都是從乾淨的檔案開始

# 寫入 #EXTM3U 標籤
echo "#EXTM3U" >> jsunicom.m3u

# 讀取 input.txt 的每一行
while IFS=',' read -r group name url; do
  # 移除所有變數前後多餘的空白
  group=$(echo "$group" | xargs)
  name=$(echo "$name" | xargs)
  url=$(echo "$url" | xargs)

  # 檢查 URL 是否為空
  if [ -z "$url" ]; then
    echo "警告：發現空的 URL，已跳過"
    continue
  fi

  # 檢查名稱是否為空
  if [ -z "$name" ]; then
    echo "警告：發現空的名稱，已跳過"
    continue
  fi

  # 檢查組別是否為空
  if [ -z "$group" ]; then
    echo "警告：發現空的組別，已跳過"
    continue
  fi

  # 寫入 #EXTINF 行
  echo "#EXTINF:-1 tvg-name=\"$name\" tvg-id=\"$name\" tvg-logo=\"https://live.fanmingming.cn/tv/$name.png\" group-title=\"$group\",$name" >> jsunicom.m3u

  # 寫入 URL 行
  echo "$url" >> jsunicom.m3u
done < input.txt

echo "jsunicom.m3u 生成完成"
