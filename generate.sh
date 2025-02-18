#!/bin/bash

# 检查 input.txt 是否存在
if [ ! -f "input.txt" ]; then
  echo "错误：找不到 input.txt 檔案"
  exit 1
fi

# 检查 jsunicom.m3u 是否存在，如果不存在则创建
if [ ! -f "jsunicom.m3u" ]; then
    > jsunicom.m3u
fi

# 在 jsunicom.m3u 文件中写入 #EXTM3U 标签
echo "#EXTM3U" > jsunicom.m3u

# 讀取 input.txt 的每一行
while IFS=',' read -r group name url; do
  # 移除所有变量前后多余的空白
  group=$(echo "$group" | xargs)
  name=$(echo "$name" | xargs)
  url=$(echo "$url" | xargs)

    # 检查 URL 是否为空
    if [ -z "$url" ]; then
        echo "警告：發現空的 URL，已跳過"
        continue
    fi

    # 检查名称是否为空
    if [ -z "$name" ]; then
        echo "警告：發現空的名稱，已跳過"
        continue
    fi

    # 检查组别是否为空
    if [ -z "$group" ]; then
        echo "警告：发现空的组别，已跳过"
        continue
    fi
  
  # 检查 jsunicom.m3u 中是否已存在相同的 URL
  if grep -q "$url" jsunicom.m3u; then
    echo "警告：URL '$url' 已存在於 jsunicom.m3u 中，已跳過"
    continue
  fi

  # 将内容写入 jsunicom.m3u
  echo "#EXTINF:-1 tvg-name=\"$name\" tvg-id=\"$name\" tvg-logo=\"https://live.fanmingming.cn/tv/$name.png\" group-title=\"$group\",$name" >> jsunicom.m3u
  echo "$url" >> jsunicom.m3u
done < input.txt

echo "jsunicom.m3u 更新完成"
