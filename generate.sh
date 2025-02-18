#!/bin/bash

# 检查 input.txt 是否存在
if [ ! -f "input.txt" ]; then
  echo "錯誤：找不到 input.txt 檔案"
  exit 1
fi

# 清空 jsunicom.m3u 檔案 (或创建新文件)
> jsunicom.m3u

# 写入 #EXTM3U 标签
echo "#EXTM3U" >> jsunicom.m3u

# 使用 awk 处理 input.txt (UTF-8 编码)
awk -F',' '{
  group = $1;
  name = $2;
  url = $3;

  # 移除所有变量前后多余的空白
  gsub(/^ *| *$/, "", group);
  gsub(/^ *| *$/, "", name);
  gsub(/^ *| *$/, "", url);

  # 检查 URL 是否有效
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

# 确保文件是 UTF-8 编码 (如果需要，可省略)
#iconv -c -t UTF-8 -o jsunicom.m3u jsunicom.m3u.tmp && mv jsunicom.m3u.tmp jsunicom.m3u

# 转换换行符为 Unix 格式 (非常重要)
dos2unix jsunicom.m3u

# 删除 BOM (如果存在)
sed -i '1 s/^\xEF\xBB\xBF//' jsunicom.m3u

echo "jsunicom.m3u 生成完成"
