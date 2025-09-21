#!/bin/bash
# Yocto构建locale环境设置

# 设置英文locale (Yocto推荐)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 确保UTF-8编码
export LC_CTYPE=en_US.UTF-8

echo "✅ Locale已设置为: $LANG"
