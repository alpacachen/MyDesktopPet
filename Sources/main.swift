import Cocoa
import Lottie

// Built-in animation configuration
struct BuiltInAnimation {
    let name: String
    let filename: String
    let displayName: String
}

let builtInAnimations: [BuiltInAnimation] = [
    BuiltInAnimation(name: "cute_doggie", filename: "cute_doggie.json", displayName: "Cute Doggie"),
    BuiltInAnimation(name: "norm_dog", filename: "norm_dog.json", displayName: "Norm Dog")
]

// Custom animation manager
class CustomAnimationManager {
    static let shared = CustomAnimationManager()

    let customAnimationsDirectory: URL

    private init() {
        // Get application support directory
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = appSupport.appendingPathComponent("MyDesktopPet")
        customAnimationsDirectory = appDirectory.appendingPathComponent("CustomAnimations")

        // Create directory
        try? FileManager.default.createDirectory(at: customAnimationsDirectory, withIntermediateDirectories: true)

        print("📁 Custom animations directory: \(customAnimationsDirectory.path)")
    }

    // Get all custom animations
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

    // Import animation (copy file)
    func importAnimation(from sourceURL: URL) -> Bool {
        let filename = sourceURL.lastPathComponent
        let destinationURL = customAnimationsDirectory.appendingPathComponent(filename)

        // If file exists, add number suffix
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
            print("✅ Animation imported: \(finalURL.lastPathComponent)")
            return true
        } catch {
            print("❌ Import failed: \(error)")
            return false
        }
    }

    // Delete animation
    func deleteAnimation(path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            print("✅ Animation deleted: \(path)")
            return true
        } catch {
            print("❌ Delete failed: \(error)")
            return false
        }
    }
}

// Lottie animation view
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

        // Create Lottie animation view
        animationView = LottieAnimationView()
        animationView.frame = self.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        self.addSubview(animationView)

        // Load first available animation
        loadFirstAvailableAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadFirstAvailableAnimation() {
        // Load built-in animation first
        if let firstAnimation = builtInAnimations.first {
            loadBuiltInAnimation(firstAnimation.name)
        } else {
            // If no built-in, try loading custom animation
            let customAnimations = CustomAnimationManager.shared.getCustomAnimations()
            if let firstCustom = customAnimations.first {
                loadAnimation(from: firstCustom.path, name: firstCustom.name)
            }
        }
    }

    func loadBuiltInAnimation(_ name: String) {
        if let animation = builtInAnimations.first(where: { $0.name == name }) {
            // Load from Bundle resource path
            if let resourcePath = Bundle.main.resourcePath {
                let animationPath = (resourcePath as NSString).appendingPathComponent("Animations/\(animation.filename)")
                if FileManager.default.fileExists(atPath: animationPath) {
                    loadAnimation(from: animationPath, name: animation.displayName)
                    return
                }
            }

            // Fallback paths (for development)
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

            print("❌ Animation file not found: \(animation.filename)")
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
            print("✅ Animation loaded: \(name)")
        } else {
            print("❌ Cannot load animation: \(path)")
        }
    }

    override func layout() {
        super.layout()
        animationView.frame = self.bounds
    }

    // Mouse dragging
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

    // Right-click menu
    override func rightMouseDown(with event: NSEvent) {
        let menu = NSMenu()

        // Built-in animations
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
        let builtInMenuItem = NSMenuItem(title: "Built-in Animations", action: nil, keyEquivalent: "")
        builtInMenuItem.submenu = builtInMenu
        menu.addItem(builtInMenuItem)

        // Custom animations
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
            customMenu.addItem(NSMenuItem(title: "Manage Custom Animations...", action: #selector(manageCustomAnimations), keyEquivalent: ""))

            let customMenuItem = NSMenuItem(title: "Custom Animations", action: nil, keyEquivalent: "")
            customMenuItem.submenu = customMenu
            menu.addItem(customMenuItem)
        }

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Import Animation...", action: #selector(importCustomAnimation), keyEquivalent: "i"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Visit LottieFiles.com", action: #selector(openLottieFiles), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

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
        openPanel.title = "Import Custom Lottie Animation"
        openPanel.message = "The selected file will be copied to app directory and persist across launches"
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [.json]

        if openPanel.runModal() == .OK, let url = openPanel.url {
            if CustomAnimationManager.shared.importAnimation(from: url) {
                // Import successful, load immediately
                let customAnimations = CustomAnimationManager.shared.getCustomAnimations()
                if let imported = customAnimations.first(where: { $0.path.contains(url.deletingPathExtension().lastPathComponent) }) {
                    loadCustomAnimation(imported.path)
                }

                // Notify AppDelegate to update menu
                NotificationCenter.default.post(name: NSNotification.Name("UpdateMenu"), object: nil)
            }
        }
    }

    @objc func manageCustomAnimations() {
        // Open custom animations folder
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

// Application delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var petView: LottiePetView!
    var statusItem: NSStatusItem?
    var currentScale: CGFloat = 1.0
    let baseSize: CGFloat = 300

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("✅ Desktop Pet launched (Lottie version)")

        // Listen for menu update notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateStatusBarMenu),
            name: NSNotification.Name("UpdateMenu"),
            object: nil
        )

        // Create transparent borderless window
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

        // Add Lottie view
        petView = LottiePetView(frame: window.contentView!.bounds)
        petView.autoresizingMask = [.width, .height]
        window.contentView = petView

        window.center()
        window.makeKeyAndOrderFront(nil)

        // Create menu bar icon
        setupStatusBarMenu()

        NSApp.setActivationPolicy(.accessory)

        print("💡 Right-click to switch animations")
        print("💡 Use menu bar to control and switch")
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
            button.image = NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "Desktop Pet")
        }

        updateStatusBarMenu()
    }

    @objc func updateStatusBarMenu() {
        let menu = NSMenu()

        // Built-in animations
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

        // Custom animations
        let customAnimations = CustomAnimationManager.shared.getCustomAnimations()
        if !customAnimations.isEmpty {
            menu.addItem(NSMenuItem.separator())

            let customHeader = NSMenuItem(title: "Custom Animations", action: nil, keyEquivalent: "")
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

        // Scale submenu
        let scaleMenu = NSMenu()
        let scales: [(String, CGFloat)] = [
            ("50%", 0.5),
            ("75%", 0.75),
            ("100% (Default)", 1.0),
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

        let scaleMenuItem = NSMenuItem(title: "Scale", action: nil, keyEquivalent: "")
        scaleMenuItem.submenu = scaleMenu
        menu.addItem(scaleMenuItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Import Animation...", action: #selector(importCustomAnimation), keyEquivalent: "i"))
        menu.addItem(NSMenuItem(title: "Manage Custom Animations...", action: #selector(manageCustomAnimations), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Show/Hide", action: #selector(toggleWindow), keyEquivalent: "h"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Visit LottieFiles", action: #selector(openLottieFiles), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

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

// Launch application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
