# 贡献指南 / Contributing Guide

感谢你考虑为 MyDesktopPet 做出贡献！

## 如何贡献

### 报告 Bug

如果你发现了 Bug，请创建一个 Issue 并提供以下信息：

- 问题描述
- 重现步骤
- 预期行为
- 实际行为
- 系统环境（macOS 版本、芯片类型等）
- 截图（如果适用）

### 提出新功能

如果你有新功能建议：

1. 先在 Issues 中搜索是否已有类似建议
2. 创建新 Issue 描述你的想法
3. 说明该功能的使用场景和价值

### 提交代码

1. **Fork 项目**
   ```bash
   # 在 GitHub 上 Fork 本项目
   git clone https://github.com/你的用户名/MyDesktopPet.git
   cd MyDesktopPet
   ```

2. **创建功能分支**
   ```bash
   git checkout -b feature/你的功能名称
   ```

3. **进行修改**
   - 遵循项目现有代码风格
   - 确保代码能够正常编译运行
   - 添加必要的注释

4. **测试你的修改**
   ```bash
   # 编译测试
   swift build

   # 运行应用
   ./Scripts/run.sh

   # 完整打包测试
   ./Scripts/build.sh
   ```

5. **提交代码**
   ```bash
   git add .
   git commit -m "feat: 添加新功能描述"
   git push origin feature/你的功能名称
   ```

6. **创建 Pull Request**
   - 在 GitHub 上创建 Pull Request
   - 清晰描述你的修改
   - 关联相关的 Issue（如果有）

## 代码规范

### Swift 代码风格

- 使用 4 个空格缩进（不使用 Tab）
- 类名使用大驼峰命名（PascalCase）
- 变量和函数使用小驼峰命名（camelCase）
- 保持函数简洁，单一职责
- 添加必要的注释说明复杂逻辑

### 提交信息规范

使用语义化提交信息：

- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `style:` 代码格式调整（不影响功能）
- `refactor:` 代码重构
- `perf:` 性能优化
- `test:` 测试相关
- `chore:` 构建过程或辅助工具的变动

示例：
```
feat: 添加动画播放速度控制功能
fix: 修复自定义动画导入失败的问题
docs: 更新 README 中的安装说明
```

## 开发环境设置

### 必需工具

- macOS 13.0+
- Xcode Command Line Tools 或完整 Xcode
- Swift 5.9+

### 依赖安装

项目使用 Swift Package Manager 管理依赖：

```bash
# SPM 会自动下载依赖
swift build
```

### 项目结构说明

```
Sources/main.swift           # 主程序，包含三个核心类
├── AppDelegate              # 应用控制器，管理窗口和菜单
├── LottiePetView           # 视图类，处理动画渲染和交互
└── CustomAnimationManager   # 自定义动画管理

Sources/Resources/          # 资源文件
└── Animations/             # 内置动画 JSON 文件

Assets/Icons/               # 应用图标
Scripts/                    # 构建和运行脚本
```

## 添加新功能的建议

### 简单任务（适合新手）

- [ ] 添加更多内置可爱动画
- [ ] 改进菜单图标和 UI 文案
- [ ] 优化应用图标设计
- [ ] 完善文档和注释
- [ ] 添加更多语言支持

### 中等任务

- [ ] 添加动画播放速度控制
- [ ] 支持拖拽导入动画文件
- [ ] 添加开机自启动选项
- [ ] 记住上次选择的动画和位置
- [ ] 添加快捷键支持

### 复杂任务

- [ ] 添加多个宠物同时显示
- [ ] 实现宠物自动漫游
- [ ] 添加交互功能（点击宠物有反应）
- [ ] 集成 AI 对话功能
- [ ] 添加声音效果系统
- [ ] 支持自定义动画触发条件

## 需要帮助？

- 查看 [README.md](README.md) 了解项目基本信息
- 浏览 [Issues](../../issues) 查看已知问题和功能请求
- 在 [Discussions](../../discussions) 参与讨论

## 行为准则

- 尊重所有贡献者
- 保持友好和建设性的讨论
- 接受建设性批评
- 专注于对项目最有利的事情

---

再次感谢你的贡献！🎉
