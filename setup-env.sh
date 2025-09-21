#!/bin/bash
# Yocto环境设置脚本

echo "设置Yocto构建环境..."
cd poky
source oe-init-build-env ../build

echo ""
echo "Yocto环境已就绪！"
echo "当前目录: $(pwd)"
echo ""
echo "常用命令:"
echo "  bitbake core-image-minimal      # 构建最小镜像"
echo "  bitbake core-image-base          # 构建基础镜像"
echo "  bitbake core-image-sato          # 构建桌面镜像"
echo "  bitbake -c listtasks core-image-base  # 查看任务列表"
echo "  bitbake -c clean core-image-base      # 清理构建"
echo ""
