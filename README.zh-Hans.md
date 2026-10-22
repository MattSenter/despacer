<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Despacer App 图标">
</p>

<h1 align="center">Despacer</h1>

<p align="center">
  在终端中从 <b>Claude Code</b> 和 <b>Codex</b> 复制长命令，粘贴时依然完整。
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <b>简体中文</b> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

在终端中运行的 AI 编程智能体，比如 **Claude Code** 和 **Codex**，会自己处理长行的换行。它们不让终端去折行，而是直接在长命令里输出真正的换行符和缩进。所以当你从 iTerm 或 Terminal 复制一条命令再粘贴时，它会被拆成好几段，根本无法运行：

```
  curl --fail --location --retry 3 --connect-timeout 10 --max-time 120
  --output premail-demo.zip
  "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately
  -long-filename-for-testing-terminal-line-wrapping.zip"
```

Despacer 是一款小巧、免费、开源的菜单栏 App，专门解决这个问题。只要它在运行，同样的复制内容粘贴出来就是它本该成为的那一条完整命令：

```
curl --fail --location --retry 3 --connect-timeout 10 --max-time 120 --output premail-demo.zip "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately-long-filename-for-testing-terminal-line-wrapping.zip"
```

- 开箱即支持 Terminal、iTerm2、Ghostty、Warp、kitty、Alacritty、WezTerm、Hyper、Tabby 和 Rio，也支持你自行添加的任何其他 App
- 只处理终端位于最前面时你复制的文本
- 不访问网络，没有分析统计，不收集任何数据
- 需要 macOS 14 Sonoma 或更高版本

## 目录

- [安装](#安装)
- [使用 Despacer](#使用-despacer)
- [设置](#设置)
- [菜单栏菜单](#菜单栏菜单)
- [键盘快捷键](#键盘快捷键)
- [故障排除](#故障排除)
- [工作原理](#工作原理)
- [命令行工具](#命令行工具)
- [卸载](#卸载)
- [构建与贡献](#构建与贡献)
- [支持本项目](#支持本项目)

## 安装

目前需要从源代码构建来安装 Despacer，大约只需一分钟。

1. 如果还没有安装 Apple 的命令行工具，请先安装：
   ```sh
   xcode-select --install
   ```
2. 克隆此仓库并构建：
   ```sh
   git clone https://github.com/MattSenter/despacer.git
   cd despacer
   ./build.sh --install
   ```
   这会构建 `Despacer.app`，将它拷贝到“应用程序”文件夹并打开。
3. 随后会出现设置窗口。在 **系统** 下打开 **登录时打开**，让 Despacer 随时待命。

就这么简单。像平常一样从 Claude Code 或 Codex 复制命令，然后粘贴即可。

## 使用 Despacer

没有任何新东西要学。在终端中选中一条命令，按 Cmd+C，然后粘贴到你要用的地方。等你粘贴时，Despacer 早已把它重新拼接好，通常只需几百分之一秒。

- **从终端复制的内容** 会被检查，需要时会被修复。
- **从其他任何 App 复制的内容** 一律不会被查看。
- **本来就没有断开的文本**，比如短命令或普通的终端输出，会原样保留。

如果某次修复不是你想要的，从菜单栏图标中选取 **撤销上次修复**，即可把复制内容恢复成你复制时的原样。**修复** 下的 **最近的修复** 列表会显示最近十次修复，每一条都有 **拷贝原始文本** 和 **拷贝修复后文本** 按钮。

## 设置

打开设置窗口的方法有：从“应用程序”文件夹（或聚焦、启动台）打开 Despacer，或从菜单栏图标中选取 **设置…**。边栏有七个面板：**修复**、**终端**、**系统**、**权限**、**隐私**、**其他项目**（同一开发者的更多 App）以及 **关于**（版本信息和链接）。

| 设置 | 面板 | 作用 |
|---|---|---|
| **修复从终端复制的内容** | 修复 | 无需退出即可打开或关闭 Despacer。 |
| **匹配会话历史** | 修复 | 在你电脑上的 Claude Code 和 Codex 会话文件中查找准确的原文。默认打开。开关下方会显示 Despacer 是否找到了各个 App 的历史记录。 |
| **修复其他自动换行的文本** | 修复 | 没有精确匹配时，把明显是按终端宽度断开的行重新接起来。默认打开。 |
| **播放声音** | 修复 | 修复好的内容可以粘贴时，播放一段简短的提示音。默认关闭。 |
| **内置** | 终端 | Despacer 认识的终端，默认全部开启。取消勾选你不想让 Despacer 监视的终端。 |
| **由你添加** | 终端 | 你会从中复制命令的其他 App，比如内置终端的代码编辑器。点按 **添加 App…** 并选择它。 |
| **登录时打开** | 系统 | 登录时自动启动 Despacer。它会安静地启动，不会打开此窗口。 |
| **在菜单栏中显示** | 系统 | 显示或移除菜单栏图标。关闭后，Despacer 会在后台隐形运行。从“应用程序”文件夹打开 Despacer 即可回到此窗口。 |
| **退出 Despacer** | 系统 | 真正退出 App。关闭窗口（或按 Cmd+Q）只会关闭窗口，Despacer 会继续运行。 |

**权限** 面板会显示 macOS 是否允许 Despacer 读取你复制的内容（请参阅[故障排除](#故障排除)）。设置会自动存储并立即生效。

## 菜单栏菜单

点按菜单栏中的 Despacer 图标即可快速访问：

- **修复从终端复制的内容**：打开或关闭 Despacer。
- **修复后播放声音**：与 **修复** 中的开关相同。
- **撤销上次修复**：把上一次修复的内容按你复制时的原样放回剪贴板。
- **在菜单栏中显示**：取消勾选即可移除图标。你也可以按住 Cmd 将图标拖出菜单栏。
- **登录时打开**：登录时启动 Despacer。
- **设置…**：打开设置窗口。
- **退出 Despacer**：退出 App。

## 键盘快捷键

当 Despacer 设置窗口位于最前面时：

| 快捷键 | 作用 |
|---|---|
| Cmd+W | 关闭设置窗口。Despacer 会继续运行。 |
| Cmd+Q | 同样只关闭窗口并让 Despacer 继续运行，以免误按 Cmd+Q 把它关掉。要真正退出，请使用 **退出 Despacer**。 |
| Cmd+H | 像其他 App 一样隐藏 Despacer。 |
| Cmd+, | 打开设置。 |

## 故障排除

**复制的内容粘贴出来还是断开的。**
请确认 Despacer 正在运行（从“应用程序”文件夹打开它），并且 **修复从终端复制的内容** 处于打开状态。检查你的终端是否已在 **终端** 下勾选，或用 **添加 App…** 添加它。然后查看 **权限** 面板。

**macOS 询问 Despacer 是否可以从其他 App 粘贴。**
较新版本的 macOS 允许你决定哪些 App 可以读取你复制的内容。请选择 **允许**。如果你选了 **不允许**，请打开“系统设置”>“隐私与安全性”>“从其他 App 粘贴”，将 Despacer 设为“允许”。**权限** 面板会显示当前设置，并提供一个直达该处的按钮。

**有一段复制内容被拼接了，但它本不该被拼接。**
从菜单栏图标中选取 **撤销上次修复**。来自会话历史的精确匹配在换行上绝不会出错，但没有匹配时，换行规则只能靠推测。如果这种情况反复出现，请关闭 **修复其他自动换行的文本**，让 Despacer 只修复它在会话历史中找到的内容。也请附上你复制的文本[提交 issue](https://github.com/MattSenter/despacer/issues)，帮助改进这些规则。

**Despacer 修改了我从普通终端输出中复制的内容。**
Despacer 只会修复带有 Claude Code 和 Codex 所输出的 2 个空格缩进的文本，或者在它们的会话历史中逐字找到的文本。如果你复制的是别的内容却被修改了，请[提交 issue](https://github.com/MattSenter/despacer/issues)。

**我关闭了菜单栏图标，找不到 Despacer 了。**
从“应用程序”文件夹打开 Despacer。设置窗口会出现，你可以在 **系统** 下重新打开图标。

**“登录时打开”总是保持不住。**
macOS 只允许位于固定位置的 App 在登录时打开。请确保 Despacer 位于“应用程序”文件夹中（`./build.sh --install` 会把它放在那里），然后再次打开该设置。

## 工作原理

Claude Code 和 Codex 都自己绘制输出，而且都会在输出前把长行按终端宽度折行：先是一个真正的换行符，再加 2 个空格的缩进。终端看到的始终是一行行独立的文本，所以它复制的也就是这些。终端里没有任何设置能撤销这一点，因为原始的行尾根本没有到达终端。

Despacer 每秒检查剪贴板 20 次（macOS 没有剪贴板通知，而这项检查几乎不消耗资源）。当复制内容来自终端 App 时，它会分两步进行修复：

1. **换行规则，即时生效。** 它会去掉 2 个空格的缩进和行尾的填充空格，然后把所有因折行产生的换行重新接起来。如果下一个单词放不进上一行，这个换行就被视为折行。占满整行宽度的行是在单词中间被拆开的，但仅限于单词长到一行放不下的情况，所以这种行会不加空格直接接上。其他所有换行，以及以 `\` 结尾的行，都会保留。这个版本会立即放到剪贴板上，在你切换窗口之前就已准备好。
2. **精确匹配，稍后完成。** 它会在后台，忽略所有空格和换行，在 Claude Code（`~/.claude/projects`）和 Codex（`~/.codex/sessions`）保存在你电脑上的会话文件中查找复制的文本。它会检查最近一天内活跃的会话，从最新的开始。一旦匹配成功，它就会把原始文本按智能体写下时的原样放到剪贴板上，除非你在此期间又复制了别的内容。

仅靠换行规则就能正确处理大多数命令，但有些换行根本无法区分，例如从一行中间开始的选择。精确匹配能解决这些情况。无论你的选择从哪里开始、到哪里结束，它都有效。

整个 App 不到 1,400 行 Swift 代码，位于 [`App/`](App)，修复引擎约 250 行，位于 [`Sources/DespacerCore/`](Sources/DespacerCore)，并附有测试。

## 命令行工具

同一个修复引擎也是一个命令行过滤器，可用于脚本，或用来修复你已经粘贴到某处的文本：

```sh
swift build -c release
pbpaste | .build/release/despacer | pbcopy
```

传入 `--explain` 可查看它使用了哪种方法，传入 `--no-transcripts` 则只使用换行规则。

## 卸载

1. 从菜单栏图标或设置窗口的 **系统** 面板中选取 **退出 Despacer**。
2. 如果 **登录时打开** 已打开，请先将它关闭，或在“系统设置”>“通用”>“登录项”中移除 Despacer。
3. 将 `/Applications/Despacer.app` 拖到废纸篓。
4. 也可以移除它的设置（可选）：
   ```sh
   defaults delete com.mattsenter.Despacer
   ```

## 构建与贡献

```sh
./build.sh            # builds build/Despacer.app (ad-hoc signed)
./build.sh --install  # also copies it to /Applications and opens it
swift test            # runs the fixing engine's tests
swift Tools/make-icon.swift   # regenerates the app icon in Resources/
python3 scripts/check-localization.py   # checks every language is complete
```

Despacer 提供英语、德语、西班牙语、法语、日语、韩语、巴西葡萄牙语以及简体中文和繁体中文版本。App 新增的显示字符串需要加入 `Localization/en.lproj/Localizable.strings` 和其他所有 `.lproj`，对本 README 或 `PRIVACY.md` 的修改也需要同步到每个译本中。

| 路径 | 内容 |
|---|---|
| `Sources/DespacerCore/` | 修复引擎：换行规则（`Despacer.swift`）和会话历史查找（`TranscriptMatcher.swift`） |
| `Tests/DespacerCoreTests/` | 测试，取材自真实的断行复制内容 |
| `Sources/despacer/` | 命令行工具 |
| `App/main.swift` | App 委托和菜单 |
| `App/ClipboardWatcher.swift` | 监视剪贴板并应用修复 |
| `App/TerminalApps.swift` | 内置终端和你添加的终端 |
| `App/SettingsView.swift` | SwiftUI 设置窗口：边栏和各个面板 |
| `App/OtherProjectsView.swift`, `Resources/other-projects/` | 其他项目面板及其截图 |
| `App/BuiltByCredit.swift`, `App/OutboundLink.swift` | 边栏中的署名和版权信息，以及带标记的外部链接 |
| `App/MenuBarIcon.swift` | 用代码绘制的菜单栏图标 |
| `Localization/<lang>.lproj/` | App 在各语言中的字符串（英语为源语言） |
| `README.<lang>.md`, `PRIVACY.<lang>.md` | 文档译本 |
| `scripts/check-localization.py` | 任何语言缺少字符串或文档时报错 |
| `Tools/make-icon.swift` | 渲染 App 图标 |

欢迎提交 issue 和拉取请求，尤其是换行规则处理错误的断行复制内容。

## 支持本项目

Despacer 现在免费，将来也永远免费。如果它帮你省去了每天的一点小烦恼，欢迎通过 Venmo 给我打赏。

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>通过 Venmo 打赏 @MattSenter</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="打赏 Matt Senter 的 Venmo 二维码">
  </a>
  <br>
  <sub>用手机扫描</sub>
</p>

打赏只是一份谢意，不会解锁任何东西，因为本来就没有什么需要解锁。

## 许可证

[MIT](LICENSE)。开发者：[Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer)。
