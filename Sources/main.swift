import Cocoa
import Lottie

// 内置动画配置
struct BuiltInAnimation {
    let name: String
    let filename: String
    let displayName: String
}

let builtInAnimations: [BuiltInAnimation] = [
    BuiltInAnimation(name: "cute_doggie", filename: "cute_doggie.json", displayName: "可爱小狗"),
    BuiltInAnimation(name: "norm_dog", filename: "norm_dog.json", displayName: "卡通狗狗")
]

// 自定义动画管理器
class CustomAnimationManager {
    static let shared = CustomAnimationManager()

    let customAnimationsDirectory: URL

    private init() {
        // 获取应用支持目录
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = appSupport.appendingPathComponent("MyDesktopPet")
        customAnimationsDirectory = appDirectory.appendingPathComponent("CustomAnimations")

        // 创建目录
        try? FileManager.default.createDirectory(at: customAnimationsDirectory, withIntermediateDirectories: true)

        print("📁 自定义动画目录: \(customAnimationsDirectory.path)")
    }

    // 获取所有自定义动画
    func getCustomAnimations() -> [(name: String, path: String)] {
        guard let files = try? FileManager.default.contentsOfDirectory(at: customAnimationsDirectory, includingPropertiesForKeys: nil) else {
            return []
        }

        return files
            .filter { $0.pathExtension == "json" }
            .map { url in
                let name = url.deletingPathExtension().lastPathComponent
                return (name: name, path: url.path)
            }
            .sorted { $0.name < $1.name }
    }

    // 导入动画（复制文件）
    func importAnimation(from sourceURL: URL) -> Bool {
        let filename = sourceURL.lastPathComponent
        let destinationURL = customAnimationsDirectory.appendingPathComponent(filename)

        // 如果文件已存在，添加编号
        var finalURL = destinationURL
        var counter = 1
        while FileManager.default.fileExists(atPath: finalURL.path) {
            let nameWithoutExt = sourceURL.deletingPathExtension().lastPathComponent
            let ext = sourceURL.pathExtension
            let newFilename = "\(nameWithoutExt)_\(counter).\(ext)"
            finalURL = customAnimationsDirectory.appendingPathComponent(newFilename)
            counter += 1
        }

        do {
            try FileManager.default.copyItem(at: sourceURL, to: finalURL)
            print("✅ 已导入动画: \(finalURL.lastPathComponent)")
            return true
        } catch {
            print("❌ 导入失败: \(error)")
            return false
        }
    }

    // 删除动画
    func deleteAnimation(path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            print("✅ 已删除动画: \(path)")
            return true
        } catch {
            print("❌ 删除失败: \(error)")
            return false
        }
    }
}

// Lottie 动画视图
class LottiePetView: NSView {
    var animationView: LottieAnimationView!
    var isDragging = false
    var dragOffset = NSPoint.zero
    var currentAnimationName: String?
    var currentAnimationPath: String?

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor

        // 创建 Lottie 动画视图
        animationView = LottieAnimationView()
        animationView.frame = self.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        self.addSubview(animationView)

        // 加载第一个可用动画
        loadFirstAvailableAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadFirstAvailableAnimation() {
        // 优先加载内置动画
        if let firstAnimation = builtInAnimations.first {
            loadBuiltInAnimation(firstAnimation.name)
        } else {
            // 如果没有内置，尝试加载自定义
            let customAnimations = CustomAnimationManager.shared.getCustomAnimations()
            if let firstCustom = customAnimations.first {
                loadAnimation(from: firstCustom.path, name: firstCustom.name)
            }
        }
    }

    func loadBuiltInAnimation(_ name: String) {
        if let animation = builtInAnimations.first(where: { $0.name == name }) {
            // 从 Bundle 资源路径加载
            if let resourcePath = Bundle.main.resourcePath {
                let animationPath = (resourcePath as NSString).appendingPathComponent("Animations/\(animation.filename)")
                if FileManager.default.fileExists(atPath: animationPath) {
                    loadAnimation(from: animationPath, name: animation.displayName)
                    return
                }
            }

            // 备用路径（开发时使用）
            let possiblePaths = [
                "Sources/Resources/Animations/\(animation.filename)",
                "Resources/Animations/\(animation.filename)",
                "./Sources/Resources/Animations/\(animation.filename)"
            ]

            for path in possiblePaths {
                if FileManager.default.fileExists(atPath: path) {
                    loadAnimation(from: path, name: animation.displayName)
                    return
                }
            }

            print("❌ 找不到动画文件: \(animation.filename)")
        }
    }

    func loadCustomAnimation(_ path: String) {
        let name = (path as NSString).lastPathComponent.replacingOccurrences(of: ".json", with: "")
        loadAnimation(from: path, name: name)
    }

    func loadAnimation(from path: String, name: String) {
        currentAnimationName = name
        currentAnimationPath = path

        if let animation = LottieAnimation.filepath(path) {
            animationView.animation = animation
            animationView.play()
            print("✅ 已加载动画: \(name)")
        } else {
            print("❌ 无法加载动画: \(path)")
        }
    }

    override func layout() {
        super.layout()
        animationView.frame = self.bounds
    }

    // 鼠标拖拽
    override func mouseDown(with event: NSEvent) {
        isDragging = true
        let locationInWindow = event.locationInWindow
        dragOffset = NSPoint(x: locationInWindow.x, y: locationInWindow.y)
    }

    override func mouseDragged(with event: NSEvent) {
        if isDragging {
            let currentLocation = NSEvent.mouseLocation
            let newOrigin = NSPoint(
                x: currentLocation.x - dragOffset.x,
                y: currentLocation.y - dragOffset.y
            )
            self.window?.setFrameOrigin(newOrigin)
        }
    }

    override func mouseUp(with event: NSEvent) {
        isDragging = false
    }

    // 右键菜单
    override func rightMouseDown(with event: NSEvent) {
        let menu = NSMenu()

        // 预设动画
        let builtInMenu = NSMenu()
        for animation in builtInAnimations {
            let item = NSMenuItem(
                title: animation.displayName,
                action: #selector(switchToBuiltInAnimation(_:)),
                keyEquivalent: ""
            )
            item.representedObject = animation.name
            if animation.displayName == currentAnimationName {
                item.state = .on
            }
            builtInMenu.addItem(item)
        }
        let builtInMenuItem = NSMenuItem(title: "预设动画", action: nil, keyEquivalent: "")
        builtInMenuItem.submenu = builtInMenu
        menu.addItem(builtInMenuItem)

        // 自定义素材
        let customAnimations = CustomAnimationManager.shared.getCustomAnimations()
        if !customAnimations.isEmpty {
            let customMenu = NSMenu()
            for animation in customAnimations {
                let item = NSMenuItem(
                    title: animation.name,
                    action: #selector(switchToCustomAnimation(_:)),
                    keyEquivalent: ""
                )
                item.representedObject = animation.path
                if animation.path == currentAnimationPath {
                    item.state = .on
                }
                customMenu.addItem(item)
            }

            customMenu.addItem(NSMenuItem.separator())
            customMenu.addItem(NSMenuItem(title: "管理自定义素材...", action: #selector(manageCustomAnimations), keyEquivalent: ""))

            let customMenuItem = NSMenuItem(title: "自定义素材", action: nil, keyEquivalent: "")
            customMenuItem.submenu = customMenu
            menu.addItem(customMenuItem)
        }

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "导入自定义素材...", action: #selector(importCustomAnimation), keyEquivalent: "i"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "访问 LottieFiles.com", action: #selector(openLottieFiles), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitApp), keyEquivalent: "q"))

        NSMenu.popUpContextMenu(menu, with: event, for: self)
    }

    @objc func switchToBuiltInAnimation(_ sender: NSMenuItem) {
        if let animationName = sender.representedObject as? String {
            loadBuiltInAnimation(animationName)
        }
    }

    @objc func switchToCustomAnimation(_ sender: NSMenuItem) {
        if let path = sender.representedObject as? String {
            loadCustomAnimation(path)
        }
    }

    @objc func importCustomAnimation() {
        let openPanel = NSOpenPanel()
        openPanel.title = "导入自定义 Lottie 动画"
        openPanel.message = "选择的文件会被复制到应用目录，下次启动仍然可用"
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [.json]

        if openPanel.runModal() == .OK, let url = openPanel.url {
            if CustomAnimationManager.shared.importAnimation(from: url) {
                // 导入成功，立即加载
                let customAnimations = CustomAnimationManager.shared.getCustomAnimations()
                if let imported = customAnimations.first(where: { $0.path.contains(url.deletingPathExtension().lastPathComponent) }) {
                    loadCustomAnimation(imported.path)
                }

                // 通知 AppDelegate 更新菜单
                NotificationCenter.default.post(name: NSNotification.Name("UpdateMenu"), object: nil)
            }
        }
    }

    @objc func manageCustomAnimations() {
        // 打开自定义动画文件夹
        NSWorkspace.shared.open(CustomAnimationManager.shared.customAnimationsDirectory)
    }

    @objc func openLottieFiles() {
        if let url = URL(string: "https://lottiefiles.com/featured") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

// 应用委托
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var petView: LottiePetView!
    var statusItem: NSStatusItem?
    var currentScale: CGFloat = 1.0
    let baseSize: CGFloat = 300

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("✅ 桌面宠物启动（Lottie 版本）")

        // 监听更新菜单通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateStatusBarMenu),
            name: NSNotification.Name("UpdateMenu"),
            object: nil
        )

        // 创建透明无边框窗口
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: baseSize, height: baseSize),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.hasShadow = false

        // 添加 Lottie 视图
        petView = LottiePetView(frame: window.contentView!.bounds)
        petView.autoresizingMask = [.width, .height]
        window.contentView = petView

        window.center()
        window.makeKeyAndOrderFront(nil)

        // 创建菜单栏图标
        setupStatusBarMenu()

        NSApp.setActivationPolicy(.accessory)

        print("💡 右键点击可切换动画")
        print("💡 菜单栏可以控制和切换")
    }

    func setScale(_ scale: CGFloat) {
        currentScale = scale
        let newSize = baseSize * scale
        let oldFrame = window.frame

        let centerX = oldFrame.midX
        let centerY = oldFrame.midY
        let newFrame = NSRect(
            x: centerX - newSize / 2,
            y: centerY - newSize / 2,
            width: newSize,
            height: newSize
        )

        window.setFrame(newFrame, display: true, animate: true)
        updateStatusBarMenu()
    }

    func setupStatusBarMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "桌面宠物")
        }

        updateStatusBarMenu()
    }

    @objc func updateStatusBarMenu() {
        let menu = NSMenu()

        // 预设动画
        for animation in builtInAnimations {
            let item = NSMenuItem(
                title: animation.displayName,
                action: #selector(switchToBuiltInAnimation(_:)),
                keyEquivalent: ""
            )
            item.representedObject = animation.name
            if animation.displayName == petView.currentAnimationName {
                item.state = .on
            }
            menu.addItem(item)
        }

        // 自定义素材
        let customAnimations = CustomAnimationManager.shared.getCustomAnimations()
        if !customAnimations.isEmpty {
            menu.addItem(NSMenuItem.separator())

            let customHeader = NSMenuItem(title: "自定义素材", action: nil, keyEquivalent: "")
            customHeader.isEnabled = false
            menu.addItem(customHeader)

            for animation in customAnimations {
                let item = NSMenuItem(
                    title: "  " + animation.name,
                    action: #selector(switchToCustomAnimation(_:)),
                    keyEquivalent: ""
                )
                item.representedObject = animation.path
                if animation.path == petView.currentAnimationPath {
                    item.state = .on
                }
                menu.addItem(item)
            }
        }

        menu.addItem(NSMenuItem.separator())

        // 缩放子菜单
        let scaleMenu = NSMenu()
        let scales: [(String, CGFloat)] = [
            ("50%", 0.5),
            ("75%", 0.75),
            ("100%（默认）", 1.0),
            ("150%", 1.5),
            ("200%", 2.0)
        ]

        for (title, scale) in scales {
            let item = NSMenuItem(
                title: title,
                action: #selector(changeScale(_:)),
                keyEquivalent: ""
            )
            item.representedObject = scale
            if abs(scale - currentScale) < 0.01 {
                item.state = .on
            }
            scaleMenu.addItem(item)
        }

        let scaleMenuItem = NSMenuItem(title: "缩放大小", action: nil, keyEquivalent: "")
        scaleMenuItem.submenu = scaleMenu
        menu.addItem(scaleMenuItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "导入自定义素材...", action: #selector(importCustomAnimation), keyEquivalent: "i"))
        menu.addItem(NSMenuItem(title: "管理自定义素材...", action: #selector(manageCustomAnimations), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "显示/隐藏", action: #selector(toggleWindow), keyEquivalent: "h"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "访问 LottieFiles", action: #selector(openLottieFiles), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    @objc func changeScale(_ sender: NSMenuItem) {
        if let scale = sender.representedObject as? CGFloat {
            setScale(scale)
        }
    }

    @objc func switchToBuiltInAnimation(_ sender: NSMenuItem) {
        if let animationName = sender.representedObject as? String {
            petView.loadBuiltInAnimation(animationName)
            updateStatusBarMenu()
        }
    }

    @objc func switchToCustomAnimation(_ sender: NSMenuItem) {
        if let path = sender.representedObject as? String {
            petView.loadCustomAnimation(path)
            updateStatusBarMenu()
        }
    }

    @objc func importCustomAnimation() {
        petView.importCustomAnimation()
    }

    @objc func manageCustomAnimations() {
        NSWorkspace.shared.open(CustomAnimationManager.shared.customAnimationsDirectory)
    }

    @objc func toggleWindow() {
        if window.isVisible {
            window.orderOut(nil)
        } else {
            window.makeKeyAndOrderFront(nil)
        }
    }

    @objc func openLottieFiles() {
        if let url = URL(string: "https://lottiefiles.com/featured") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

// 启动应用
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
