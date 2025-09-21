#!/bin/bash
# 完整的Yocto构建脚本

set -e

# 设置颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查参数
if [[ $# -eq 0 ]]; then
    echo "用法: $0 <image-name>"
    echo ""
    echo "可用的镜像类型:"
    echo "  core-image-minimal      - 最小镜像 (~50MB)"
    echo "  core-image-base         - 基础镜像 (~200MB) [推荐]"
    echo "  core-image-sato         - 桌面镜像 (~800MB)"
    echo ""
    exit 1
fi

IMAGE_NAME="$1"

echo "=================================================="
echo "🚀 Yocto RK3566 镜像构建"
echo "=================================================="

# 1. 设置locale
log_step "设置locale环境"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
log_info "✅ Locale设置为: $LANG"

# 2. 进入工作目录
log_step "进入工作目录"
cd /home/xuqi/Proj/yocto/yocto-rk3566
log_info "✅ 当前目录: $(pwd)"

# 3. 初始化Yocto环境
log_step "初始化Yocto构建环境"
source poky/oe-init-build-env build

# 4. 验证环境
log_step "验证构建环境"
log_info "BitBake版本: $(bitbake --version | head -1)"
log_info "当前机器: $(bitbake -e | grep '^MACHINE=' | cut -d'"' -f2)"
log_info "当前目录: $(pwd)"

# 5. 显示layers信息
log_step "当前配置的Layers:"
bitbake-layers show-layers

# 6. 开始构建
echo ""
echo "=================================================="
log_step "开始构建镜像: $IMAGE_NAME"
echo "=================================================="
log_info "构建开始时间: $(date)"
log_info "执行: bitbake $IMAGE_NAME"

# 实际构建命令
bitbake "$IMAGE_NAME"

# 7. 构建完成
echo ""
echo "=================================================="
log_info "🎉 构建完成!"
echo "=================================================="
log_info "构建结束时间: $(date)"

# 8. 显示输出文件
log_step "构建产物位置:"
OUTPUT_DIR="$(pwd)/tmp/deploy/images/rk3566-tspi"
if [[ -d "$OUTPUT_DIR" ]]; then
    echo "📁 镜像文件位于: $OUTPUT_DIR"
    echo ""
    log_info "主要文件:"
    ls -lh "$OUTPUT_DIR"/*.wic 2>/dev/null || echo "  (*.wic文件未找到)"
    ls -lh "$OUTPUT_DIR"/*.ext4 2>/dev/null || echo "  (*.ext4文件未找到)"
    ls -lh "$OUTPUT_DIR"/Image 2>/dev/null || echo "  (内核镜像未找到)"
    echo ""
    log_info "💾 烧写命令示例:"
    echo "  sudo dd if=$OUTPUT_DIR/${IMAGE_NAME}-rk3566-tspi.wic of=/dev/sdX bs=1M status=progress"
else
    log_warn "输出目录未找到: $OUTPUT_DIR"
fi

echo ""
log_info "✅ 构建流程完成!"