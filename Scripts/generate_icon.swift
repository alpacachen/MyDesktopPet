import Cocoa

// 生成可爱哈士奇图标
func generateHuskyIcon(size: CGSize) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()

    let center = CGPoint(x: size.width / 2, y: size.height / 2)
    let radius = size.width * 0.32

    // 渐变背景 - 冰蓝色系
    let bgGradient = NSGradient(colors: [
        NSColor(red: 0.85, green: 0.92, blue: 0.98, alpha: 1.0),
        NSColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
    ])
    bgGradient?.draw(in: NSBezierPath(rect: CGRect(origin: .zero, size: size)), angle: -45)

    // 哈士奇的脸 - 白色底
    NSColor.white.setFill()
    let facePath = NSBezierPath(ovalIn: CGRect(
        x: center.x - radius,
        y: center.y - radius * 0.8,
        width: radius * 2,
        height: radius * 2
    ))
    facePath.fill()

    // 左耳 - 黑色三角耳朵（竖起来的）
    NSColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0).setFill()
    let leftEarPath = NSBezierPath()
    leftEarPath.move(to: CGPoint(x: center.x - radius * 0.7, y: center.y + radius * 0.6))
    leftEarPath.line(to: CGPoint(x: center.x - radius * 0.95, y: center.y + radius * 1.5))
    leftEarPath.line(to: CGPoint(x: center.x - radius * 0.3, y: center.y + radius * 0.8))
    leftEarPath.close()
    leftEarPath.fill()

    // 右耳
    let rightEarPath = NSBezierPath()
    rightEarPath.move(to: CGPoint(x: center.x + radius * 0.7, y: center.y + radius * 0.6))
    rightEarPath.line(to: CGPoint(x: center.x + radius * 0.95, y: center.y + radius * 1.5))
    rightEarPath.line(to: CGPoint(x: center.x + radius * 0.3, y: center.y + radius * 0.8))
    rightEarPath.close()
    rightEarPath.fill()

    // 耳朵内部 - 白色
    NSColor.white.setFill()
    let leftInnerEar = NSBezierPath()
    leftInnerEar.move(to: CGPoint(x: center.x - radius * 0.65, y: center.y + radius * 0.7))
    leftInnerEar.line(to: CGPoint(x: center.x - radius * 0.8, y: center.y + radius * 1.2))
    leftInnerEar.line(to: CGPoint(x: center.x - radius * 0.45, y: center.y + radius * 0.85))
    leftInnerEar.close()
    leftInnerEar.fill()

    let rightInnerEar = NSBezierPath()
    rightInnerEar.move(to: CGPoint(x: center.x + radius * 0.65, y: center.y + radius * 0.7))
    rightInnerEar.line(to: CGPoint(x: center.x + radius * 0.8, y: center.y + radius * 1.2))
    rightInnerEar.line(to: CGPoint(x: center.x + radius * 0.45, y: center.y + radius * 0.85))
    rightInnerEar.close()
    rightInnerEar.fill()

    // 面具花纹 - 左边黑色区域
    NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).setFill()
    let leftMaskPath = NSBezierPath()
    leftMaskPath.move(to: CGPoint(x: center.x - radius * 0.85, y: center.y + radius * 0.5))
    leftMaskPath.curve(
        to: CGPoint(x: center.x - radius * 0.4, y: center.y - radius * 0.1),
        controlPoint1: CGPoint(x: center.x - radius * 0.9, y: center.y + radius * 0.2),
        controlPoint2: CGPoint(x: center.x - radius * 0.7, y: center.y - radius * 0.2)
    )
    leftMaskPath.curve(
        to: CGPoint(x: center.x - radius * 0.2, y: center.y + radius * 0.3),
        controlPoint1: CGPoint(x: center.x - radius * 0.3, y: center.y + radius * 0.1),
        controlPoint2: CGPoint(x: center.x - radius * 0.25, y: center.y + radius * 0.2)
    )
    leftMaskPath.curve(
        to: CGPoint(x: center.x - radius * 0.85, y: center.y + radius * 0.5),
        controlPoint1: CGPoint(x: center.x - radius * 0.4, y: center.y + radius * 0.5),
        controlPoint2: CGPoint(x: center.x - radius * 0.7, y: center.y + radius * 0.6)
    )
    leftMaskPath.fill()

    // 右边黑色区域
    let rightMaskPath = NSBezierPath()
    rightMaskPath.move(to: CGPoint(x: center.x + radius * 0.85, y: center.y + radius * 0.5))
    rightMaskPath.curve(
        to: CGPoint(x: center.x + radius * 0.4, y: center.y - radius * 0.1),
        controlPoint1: CGPoint(x: center.x + radius * 0.9, y: center.y + radius * 0.2),
        controlPoint2: CGPoint(x: center.x + radius * 0.7, y: center.y - radius * 0.2)
    )
    rightMaskPath.curve(
        to: CGPoint(x: center.x + radius * 0.2, y: center.y + radius * 0.3),
        controlPoint1: CGPoint(x: center.x + radius * 0.3, y: center.y + radius * 0.1),
        controlPoint2: CGPoint(x: center.x + radius * 0.25, y: center.y + radius * 0.2)
    )
    rightMaskPath.curve(
        to: CGPoint(x: center.x + radius * 0.85, y: center.y + radius * 0.5),
        controlPoint1: CGPoint(x: center.x + radius * 0.4, y: center.y + radius * 0.5),
        controlPoint2: CGPoint(x: center.x + radius * 0.7, y: center.y + radius * 0.6)
    )
    rightMaskPath.fill()

    // 眼睛 - 哈士奇标志性的蓝眼睛
    NSColor(red: 0.4, green: 0.7, blue: 0.95, alpha: 1.0).setFill()

    // 左眼
    NSBezierPath(ovalIn: CGRect(
        x: center.x - radius * 0.55,
        y: center.y + radius * 0.15,
        width: radius * 0.3,
        height: radius * 0.35
    )).fill()

    // 右眼
    NSBezierPath(ovalIn: CGRect(
        x: center.x + radius * 0.25,
        y: center.y + radius * 0.15,
        width: radius * 0.3,
        height: radius * 0.35
    )).fill()

    // 瞳孔 - 黑色
    NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).setFill()
    NSBezierPath(ovalIn: CGRect(
        x: center.x - radius * 0.48,
        y: center.y + radius * 0.22,
        width: radius * 0.16,
        height: radius * 0.2
    )).fill()

    NSBezierPath(ovalIn: CGRect(
        x: center.x + radius * 0.32,
        y: center.y + radius * 0.22,
        width: radius * 0.16,
        height: radius * 0.2
    )).fill()

    // 眼睛高光
    NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8).setFill()
    NSBezierPath(ovalIn: CGRect(
        x: center.x - radius * 0.44,
        y: center.y + radius * 0.35,
        width: radius * 0.08,
        height: radius * 0.1
    )).fill()

    NSBezierPath(ovalIn: CGRect(
        x: center.x + radius * 0.36,
        y: center.y + radius * 0.35,
        width: radius * 0.08,
        height: radius * 0.1
    )).fill()

    // 鼻子 - 黑色
    NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).setFill()
    NSBezierPath(ovalIn: CGRect(
        x: center.x - radius * 0.15,
        y: center.y - radius * 0.2,
        width: radius * 0.3,
        height: radius * 0.25
    )).fill()

    // 鼻子高光
    NSColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0).setFill()
    NSBezierPath(ovalIn: CGRect(
        x: center.x - radius * 0.08,
        y: center.y - radius * 0.1,
        width: radius * 0.08,
        height: radius * 0.08
    )).fill()

    // 嘴巴 - 哈士奇的微笑
    NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).setStroke()

    // 中线
    let centerLine = NSBezierPath()
    centerLine.move(to: CGPoint(x: center.x, y: center.y - radius * 0.2))
    centerLine.line(to: CGPoint(x: center.x, y: center.y - radius * 0.45))
    centerLine.lineWidth = radius * 0.06
    centerLine.lineCapStyle = .round
    centerLine.stroke()

    // 左边微笑
    let leftSmile = NSBezierPath()
    leftSmile.move(to: CGPoint(x: center.x, y: center.y - radius * 0.45))
    leftSmile.curve(
        to: CGPoint(x: center.x - radius * 0.4, y: center.y - radius * 0.5),
        controlPoint1: CGPoint(x: center.x - radius * 0.15, y: center.y - radius * 0.55),
        controlPoint2: CGPoint(x: center.x - radius * 0.3, y: center.y - radius * 0.6)
    )
    leftSmile.lineWidth = radius * 0.06
    leftSmile.lineCapStyle = .round
    leftSmile.stroke()

    // 右边微笑
    let rightSmile = NSBezierPath()
    rightSmile.move(to: CGPoint(x: center.x, y: center.y - radius * 0.45))
    rightSmile.curve(
        to: CGPoint(x: center.x + radius * 0.4, y: center.y - radius * 0.5),
        controlPoint1: CGPoint(x: center.x + radius * 0.15, y: center.y - radius * 0.55),
        controlPoint2: CGPoint(x: center.x + radius * 0.3, y: center.y - radius * 0.6)
    )
    rightSmile.lineWidth = radius * 0.06
    rightSmile.lineCapStyle = .round
    rightSmile.stroke()

    // 舌头（俏皮表情）
    NSColor(red: 1.0, green: 0.5, blue: 0.6, alpha: 1.0).setFill()
    let tonguePath = NSBezierPath()
    tonguePath.move(to: CGPoint(x: center.x, y: center.y - radius * 0.5))
    tonguePath.curve(
        to: CGPoint(x: center.x + radius * 0.12, y: center.y - radius * 0.7),
        controlPoint1: CGPoint(x: center.x + radius * 0.08, y: center.y - radius * 0.5),
        controlPoint2: CGPoint(x: center.x + radius * 0.12, y: center.y - radius * 0.6)
    )
    tonguePath.curve(
        to: CGPoint(x: center.x, y: center.y - radius * 0.8),
        controlPoint1: CGPoint(x: center.x + radius * 0.12, y: center.y - radius * 0.75),
        controlPoint2: CGPoint(x: center.x + radius * 0.06, y: center.y - radius * 0.8)
    )
    tonguePath.curve(
        to: CGPoint(x: center.x - radius * 0.12, y: center.y - radius * 0.7),
        controlPoint1: CGPoint(x: center.x - radius * 0.06, y: center.y - radius * 0.8),
        controlPoint2: CGPoint(x: center.x - radius * 0.12, y: center.y - radius * 0.75)
    )
    tonguePath.curve(
        to: CGPoint(x: center.x, y: center.y - radius * 0.5),
        controlPoint1: CGPoint(x: center.x - radius * 0.12, y: center.y - radius * 0.6),
        controlPoint2: CGPoint(x: center.x - radius * 0.08, y: center.y - radius * 0.5)
    )
    tonguePath.fill()

    image.unlockFocus()
    return image
}

// 保存图标
let sizes = [16, 32, 64, 128, 256, 512, 1024]

for size in sizes {
    let icon = generateHuskyIcon(size: CGSize(width: size, height: size))

    if let tiffData = icon.tiffRepresentation,
       let bitmap = NSBitmapImageRep(data: tiffData),
       let pngData = bitmap.representation(using: .png, properties: [:]) {
        let filename = "AppIcon_\(size).png"
        try? pngData.write(to: URL(fileURLWithPath: filename))
        print("✅ 生成: \(filename)")
    }
}

print("\n🎉 哈士奇图标生成完成！")
