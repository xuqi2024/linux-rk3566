#!/bin/bash
# Yocto镜像构建脚本

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查参数
if [[ $# -eq 0 ]]; then
    echo "用法: $0 <image-name>"
    echo ""
    echo "可用的镜像类型:"
    echo "  core-image-minimal    # 最小镜像 (~50MB)"
    echo "  core-image-base       # 基础镜像 (~200MB) [推荐]"
    echo "  core-image-sato       # 桌面镜像 (~800MB)"
    echo ""
    echo "示例: $0 core-image-base"
    exit 1
fi

IMAGE_NAME="$1"

log_step "开始构建镜像: $IMAGE_NAME"

# 设置环境
cd poky
source oe-init-build-env ../build

# 记录开始时间
START_TIME=$(date +%s)
log_info "构建开始时间: $(date)"

# 执行构建
log_info "执行: bitbake $IMAGE_NAME"
bitbake "$IMAGE_NAME"

# 计算构建时间
END_TIME=$(date +%s)
BUILD_TIME=$((END_TIME - START_TIME))
log_info "构建完成！耗时: $((BUILD_TIME/60))分钟$((BUILD_TIME%60))秒"

# 显示结果
echo ""
echo "=============================================="
echo "          构建完成！"
echo "=============================================="
echo ""
echo "镜像输出位置:"
echo "  $(pwd)/tmp/deploy/images/rk3566-tspi/"
echo ""
echo "主要文件:"
ls -lh tmp/deploy/images/rk3566-tspi/ 2>/dev/null | grep -E '\.(ext4|tar|wic)$' || echo "  (构建可能仍在进行中)"
echo ""
