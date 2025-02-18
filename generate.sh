#!/bin/bash

# 检查 input.txt 是否存在
if [ ! -f "input.txt" ]; then
  echo "錯誤：找不到 input.txt 檔案"
  exit 1
fi

# 清空 jsunicom.m3u 檔案
> jsunicom.m3u

# 寫入 #EXTM3U 標籤
echo "#EXTM3U" >> jsunicom.m3u

# 使用 awk 处理 input.txt
awk -F',' '{
  group = $1;
  name = $2;
  url = $3;

  # 移除所有变量前后多余的空白
  gsub(/^ *| *$/, "", group);
  gsub(/^ *| *$/, "", name);
  gsub(/^ *| *$/, "", url);

  # 检查 URL 是否有效（简单检查，可根据需求扩展）
  if (url !~ /^https?:\/\//) {
    printf "警告：URL '%s' 无效，已跳过\n", url;
    next;
  }

  if (name == "") {
    printf "警告：名称为空，已跳过\n";
    next;
  }

  if (group == "") {
    printf "警告：组别为空，已跳过\n";
    next;
  }

  printf "#EXTINF:-1 tvg-name=\"%s\" tvg-id=\"%s\" tvg-logo=\"https://live.fanmingming.cn/tv/%s.png\" group-title=\"%s\",%s\n", name, name, name, group, name >> "jsunicom.m3u";
  printf "%s\n", url >> "jsunicom.m3u";
}' input.txt

echo "jsunicom.m3u 生成完成"
