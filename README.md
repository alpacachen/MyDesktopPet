# 🐕 我的桌面宠物 / MyDesktopPet

<div align="center">

一个可爱的 macOS 桌面宠物应用，使用 Lottie 动画让你的桌面更有趣！

[简体中文](#简体中文) | [English](#english)

<img src="Assets/Icons/AppIcon.icns" width="128" alt="App Icon"/>

</div>

---

## 简体中文

### ✨ 功能特性

- 🎨 **Lottie 动画支持** - 流畅的矢量动画，不失真
- 🐾 **内置可爱动画** - 预置两只可爱小狗动画
- 📁 **自定义动画导入** - 支持导入自己的 Lottie JSON 文件
- 🔄 **等比缩放** - 50%、75%、100%、150%、200% 五档缩放
- 🪟 **透明悬浮窗口** - 无边框，始终显示在最前面
- 🖱️ **可拖拽移动** - 鼠标拖动到桌面任意位置
- 📍 **全桌面显示** - 在所有虚拟桌面空间都可见
- 🎯 **菜单栏控制** - 爪印图标，完整的菜单控制

### 📸 截图

*(建议添加应用运行时的截图)*

### 🚀 快速开始

#### 方式一：下载安装包（推荐）

1. 从 [Releases](../../releases) 下载最新的 `MyDesktopPet.dmg`
2. 打开 DMG 文件，将应用拖入应用程序文件夹
3. 双击运行即可

#### 方式二：从源码构建

**系统要求：**
- macOS 13.0+
- Xcode Command Line Tools 或完整 Xcode

**构建步骤：**

```bash
# 1. 克隆仓库
git clone https://github.com/你的用户名/MyDesktopPet.git
cd MyDesktopPet

# 2. 构建应用
swift build -c release

# 3. 打包应用（可选）
./Scripts/build.sh
```

### 📖 使用说明

#### 基本操作

- **移动宠物**：鼠标按住宠物拖动到任意位置
- **切换动画**：点击菜单栏爪印图标 🐾，选择动画
- **调整大小**：菜单栏 > 缩放 > 选择倍率
- **导入自定义动画**：菜单栏 > 导入动画，选择 Lottie JSON 文件
- **隐藏宠物**：菜单栏 > 显示/隐藏宠物
- **退出应用**：右键点击宠物 > 退出

#### 自定义动画

支持导入任意 Lottie JSON 动画文件：

1. 从 [LottieFiles](https://lottiefiles.com) 下载喜欢的动画
2. 点击菜单栏图标 > "导入动画"
3. 选择 `.json` 文件即可

**动画存储位置：**
- 内置动画：`MyDesktopPet.app/Contents/Resources/Animations/`
- 自定义动画：`~/Library/Application Support/MyDesktopPet/CustomAnimations/`

### 🏗️ 项目结构

```
MyDesktopPet/
├── Sources/
│   ├── main.swift                    # 主程序代码
│   └── Resources/
│       └── Animations/               # 内置动画资源
│           ├── cute_doggie.json
│           └── norm_dog.json
├── Assets/
│   └── Icons/
│       └── AppIcon.icns              # 应用图标
├── Scripts/
│   ├── build.sh                      # 构建打包脚本
│   ├── run.sh                        # 快速运行脚本
│   └── generate_icon.swift           # 图标生成脚本
├── Package.swift                     # Swift Package 配置
├── Package.resolved                  # 依赖锁定文件
└── README.md                         # 项目说明
```

### 🔧 代码架构

**核心类：**

- `AppDelegate` - 应用主控制器，管理窗口和菜单栏
- `LottiePetView` - 自定义视图，处理 Lottie 动画渲染和交互
- `CustomAnimationManager` - 自定义动画管理器，处理文件导入和存储

**技术栈：**

- Swift + AppKit (原生 macOS 开发)
- [Lottie for iOS](https://github.com/airbnb/lottie-spm) - 动画渲染引擎
- Swift Package Manager - 依赖管理

### 🛠️ 开发指南

#### 添加新的内置动画

1. 将 `.json` 文件放入 `Sources/Resources/Animations/`
2. 在 `main.swift` 中添加到 `builtInAnimations` 数组：

```swift
let builtInAnimations: [BuiltInAnimation] = [
    // ...
    BuiltInAnimation(name: "new_animation", filename: "new_animation.json", displayName: "新动画")
]
```

#### 修改窗口大小

在 `AppDelegate` 类中修改 `baseSize`：

```swift
let baseSize: CGFloat = 300  // 默认 300，可改为其他值
```

#### 调整动画速度

Lottie 动画的速度在 JSON 文件中定义，也可以代码控制：

```swift
animationView.animationSpeed = 1.5  // 1.5倍速
```

### 📦 构建和发布

#### 构建 Release 版本

```bash
swift build -c release
```

#### 打包 .app 和 .dmg

```bash
./Scripts/build.sh
```

生成文件：
- `MyDesktopPet.app` - 应用程序包
- `MyDesktopPet.dmg` - DMG 安装镜像

### 🤝 贡献

欢迎提交 Issue 和 Pull Request！

**贡献方向：**
- 添加更多可爱的内置动画
- 改进 UI/UX 设计
- 添加新功能（声音、交互、AI 对话等）
- 性能优化
- Bug 修复

### 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

### 🙏 致谢

- [Lottie](https://airbnb.io/lottie/) - 强大的动画库
- [LottieFiles](https://lottiefiles.com) - 丰富的动画资源

---

## English

### ✨ Features

- 🎨 **Lottie Animation Support** - Smooth vector animations with no quality loss
- 🐾 **Built-in Cute Animations** - Two adorable dog animations included
- 📁 **Custom Animation Import** - Import your own Lottie JSON files
- 🔄 **Proportional Scaling** - Five scaling levels: 50%, 75%, 100%, 150%, 200%
- 🪟 **Transparent Floating Window** - Borderless, always on top
- 🖱️ **Draggable** - Move your pet anywhere on the desktop
- 📍 **All Desktop Spaces** - Visible across all virtual desktops
- 🎯 **Menu Bar Control** - Paw print icon with full menu control

### 🚀 Quick Start

#### Option 1: Download Release (Recommended)

1. Download the latest `MyDesktopPet.dmg` from [Releases](../../releases)
2. Open the DMG file and drag the app to Applications folder
3. Double-click to run

#### Option 2: Build from Source

**Requirements:**
- macOS 13.0+
- Xcode Command Line Tools or full Xcode

**Build Steps:**

```bash
# 1. Clone repository
git clone https://github.com/yourusername/MyDesktopPet.git
cd MyDesktopPet

# 2. Build the app
swift build -c release

# 3. Package the app (optional)
./Scripts/build.sh
```

### 📖 Usage

#### Basic Operations

- **Move Pet**: Click and drag the pet to anywhere
- **Switch Animation**: Click menu bar paw icon 🐾, select animation
- **Adjust Size**: Menu Bar > Scale > Select size
- **Import Custom Animation**: Menu Bar > Import Animation, select Lottie JSON file
- **Hide Pet**: Menu Bar > Show/Hide Pet
- **Quit App**: Right-click pet > Quit

#### Custom Animations

Import any Lottie JSON animation:

1. Download animations from [LottieFiles](https://lottiefiles.com)
2. Click menu bar icon > "Import Animation"
3. Select `.json` file

**Storage Locations:**
- Built-in animations: `MyDesktopPet.app/Contents/Resources/Animations/`
- Custom animations: `~/Library/Application Support/MyDesktopPet/CustomAnimations/`

### 🏗️ Project Structure

```
MyDesktopPet/
├── Sources/
│   ├── main.swift                    # Main application code
│   └── Resources/
│       └── Animations/               # Built-in animation resources
│           ├── cute_doggie.json
│           └── norm_dog.json
├── Assets/
│   └── Icons/
│       └── AppIcon.icns              # Application icon
├── Scripts/
│   ├── build.sh                      # Build and packaging script
│   ├── run.sh                        # Quick run script
│   └── generate_icon.swift           # Icon generator script
├── Package.swift                     # Swift Package configuration
├── Package.resolved                  # Dependency lock file
└── README.md                         # Project documentation
```

### 🔧 Architecture

**Core Classes:**

- `AppDelegate` - Main app controller, manages window and menu bar
- `LottiePetView` - Custom view, handles Lottie animation rendering and interactions
- `CustomAnimationManager` - Manages custom animation import and storage

**Tech Stack:**

- Swift + AppKit (Native macOS development)
- [Lottie for iOS](https://github.com/airbnb/lottie-spm) - Animation engine
- Swift Package Manager - Dependency management

### 🤝 Contributing

Issues and Pull Requests are welcome!

**Contribution Ideas:**
- Add more cute built-in animations
- Improve UI/UX design
- Add new features (sound, interactions, AI chat, etc.)
- Performance optimization
- Bug fixes

### 📄 License

MIT License - see [LICENSE](LICENSE) file for details

### 🙏 Acknowledgments

- [Lottie](https://airbnb.io/lottie/) - Powerful animation library
- [LottieFiles](https://lottiefiles.com) - Rich animation resources

---

<div align="center">

Made with ❤️ by [Your Name]

If you like this project, please give it a ⭐️!

</div>
