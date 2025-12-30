#!/bin/bash
# 快速运行 MyDesktopPet (开发模式)

# 进入项目根目录
cd "$(dirname "$0")/.."

echo "🔨 正在编译 (Debug 模式)..."
swift build

if [ $? -eq 0 ]; then
    echo "✅ 编译成功"
    echo "🚀 启动桌面宠物..."
    .build/debug/MyDesktopPet &
    echo ""
    echo "✨ 桌面宠物已启动！"
    echo ""
    echo "💡 使用提示："
    echo "   - 拖动宠物到任意位置"
    echo "   - 点击菜单栏爪印图标切换动画和调整大小"
    echo "   - 可以导入自己的 Lottie 动画"
    echo "   - 右键点击宠物退出"
    echo ""
else
    echo "❌ 编译失败"
    exit 1
fi
