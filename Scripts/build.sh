#!/bin/bash
# 自动构建并打包 MyDesktopPet 应用

set -e  # 遇到错误立即退出

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 开始构建 MyDesktopPet...${NC}"
echo ""

# 进入项目根目录
cd "$(dirname "$0")/.."

# 1. 清理旧文件
echo -e "${BLUE}🧹 清理旧文件...${NC}"
killall MyDesktopPet 2>/dev/null || true
rm -rf MyDesktopPet.app MyDesktopPet.dmg

# 2. 使用 Swift Package Manager 构建
echo -e "${BLUE}🔨 编译应用 (Release 模式)...${NC}"
swift build -c release

# 3. 创建 .app 包结构
echo -e "${BLUE}📦 创建应用包结构...${NC}"
mkdir -p MyDesktopPet.app/Contents/{MacOS,Resources,Frameworks}

# 4. 复制可执行文件
echo -e "${BLUE}📋 复制可执行文件...${NC}"
cp .build/release/MyDesktopPet MyDesktopPet.app/Contents/MacOS/

# 5. 复制资源文件
echo -e "${BLUE}🎨 复制资源文件...${NC}"
cp -r Sources/Resources/Animations MyDesktopPet.app/Contents/Resources/

# 6. 复制应用图标
if [ -f "Assets/Icons/AppIcon.icns" ]; then
    echo -e "${BLUE}🎭 复制应用图标...${NC}"
    cp Assets/Icons/AppIcon.icns MyDesktopPet.app/Contents/Resources/
fi

# 7. 复制 Lottie 框架
echo -e "${BLUE}📚 复制 Lottie 框架...${NC}"
LOTTIE_FRAMEWORK=".build/release/Lottie.framework"
if [ -d "$LOTTIE_FRAMEWORK" ]; then
    cp -r "$LOTTIE_FRAMEWORK" MyDesktopPet.app/Contents/Frameworks/
    # 修改 rpath
    install_name_tool -add_rpath @executable_path/../Frameworks MyDesktopPet.app/Contents/MacOS/MyDesktopPet 2>/dev/null || true
else
    echo -e "${RED}⚠️  警告: 找不到 Lottie.framework，应用可能无法运行${NC}"
fi

# 8. 创建 Info.plist
echo -e "${BLUE}📝 创建 Info.plist...${NC}"
cat > MyDesktopPet.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleExecutable</key>
    <string>MyDesktopPet</string>
    <key>CFBundleIdentifier</key>
    <string>com.mydesktoppet.lottie</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>我的桌面宠物</string>
    <key>CFBundleDisplayName</key>
    <string>我的桌面宠物</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>2.0</string>
    <key>CFBundleVersion</key>
    <string>2.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSUIElement</key>
    <false/>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
EOF

# 9. 创建 DMG
echo -e "${BLUE}💿 创建 DMG 安装包...${NC}"
hdiutil create -volname "我的桌面宠物" -srcfolder MyDesktopPet.app -ov -format UDZO MyDesktopPet.dmg > /dev/null 2>&1

# 10. 完成
echo ""
echo -e "${GREEN}✅ 构建完成！${NC}"
echo ""
echo -e "${GREEN}📁 生成的文件：${NC}"
echo "   - MyDesktopPet.app    $(du -sh MyDesktopPet.app | cut -f1)"
echo "   - MyDesktopPet.dmg    $(du -sh MyDesktopPet.dmg | cut -f1)"
echo ""
echo -e "${BLUE}💡 提示：${NC}"
echo "   - 运行应用: open MyDesktopPet.app"
echo "   - 分享给朋友: 发送 MyDesktopPet.dmg"
echo ""
