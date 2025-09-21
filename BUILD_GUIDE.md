# 🎉 RK3566 Yocto构建系统搭建成功！

## 📁 当前状态

✅ **Yocto环境已完成搭建**  
✅ **所有依赖包已安装**  
✅ **RK3566机器配置已创建**  
✅ **构建脚本已准备就绪**

## 🚀 开始构建

您现在可以开始构建RK3566的Linux镜像了！

### 方法1: 使用便捷脚本 (推荐)

```bash
# 构建最小镜像 (约50MB，适合嵌入式设备)
./build-image.sh core-image-minimal

# 构建基础镜像 (约200MB，推荐用于开发)
./build-image.sh core-image-base

# 构建完整桌面镜像 (约800MB，带图形界面)
./build-image.sh core-image-sato
```

### 方法2: 手动构建

```bash
# 1. 设置环境
./setup-env.sh

# 2. 或者手动设置
cd poky
source oe-init-build-env ../build

# 3. 开始构建
bitbake core-image-base
```

## 📊 构建信息

| 镜像类型 | 大小 | 构建时间 | 适用场景 |
|----------|------|----------|----------|
| `core-image-minimal` | ~50MB | 30-60分钟 | 嵌入式产品，IoT设备 |
| `core-image-base` | ~200MB | 1-2小时 | **开发测试推荐** |
| `core-image-sato` | ~800MB | 2-3小时 | 桌面应用，多媒体 |

## 📁 输出文件位置

构建完成后，镜像文件将位于：
```
yocto-rk3566/build/tmp/deploy/images/rk3566-tspi/
```

主要文件：
- **`*.wic`** - 完整SD卡镜像 (推荐)
- **`*.ext4`** - 根文件系统镜像
- **`*.tar.bz2`** - 根文件系统压缩包
- **`Image`** - Linux内核
- **`*.dtb`** - 设备树文件

## 💾 烧写到SD卡

```bash
# 查看SD卡设备
lsblk

# 烧写完整镜像 (替换/dev/sdX为实际设备)
sudo dd if=core-image-base-rk3566-tspi.wic of=/dev/sdX bs=1M status=progress

# 同步写入
sync
```

## ⚠️ 注意事项

1. **首次构建耗时较长** - 需要下载大量源代码包，请保持网络连接稳定
2. **磁盘空间需求** - 完整构建需要约30-50GB空间
3. **构建过程** - 可能需要1-3小时，请耐心等待
4. **网络要求** - 确保网络连接稳定，避免下载中断

## 🔧 常用命令

```bash
# 查看可用镜像类型
bitbake -s | grep image

# 清理特定镜像的构建
bitbake -c clean core-image-base

# 查看构建任务
bitbake -c listtasks core-image-base

# 构建SDK
bitbake core-image-base -c populate_sdk

# 查看镜像内容
bitbake -g core-image-base && cat pn-buildlist | grep -ve "native" | sort | uniq
```

## 🐛 故障排除

### 网络问题
如果遇到下载失败：
```bash
# 设置代理 (如需要)
export http_proxy=http://proxy:port
export https_proxy=http://proxy:port

# 重新开始构建
bitbake core-image-base
```

### 磁盘空间不足
```bash
# 清理下载缓存
rm -rf downloads/*

# 清理状态缓存
rm -rf sstate-cache/*

# 启用自动清理 (已在配置中启用)
# INHERIT += "rm_work"
```

### 构建失败
```bash
# 清理并重新构建
bitbake -c clean core-image-base
bitbake core-image-base

# 查看详细日志
bitbake -v core-image-base
```

## 🎯 下一步

1. **选择镜像类型** - 建议先从 `core-image-base` 开始
2. **开始构建** - 运行 `./build-image.sh core-image-base`
3. **测试镜像** - 烧写到SD卡并在RK3566设备上测试
4. **自定义镜像** - 根据需要修改配置文件

---

**🚀 祝您构建成功！如有问题，请检查构建日志或参考Yocto官方文档。**