# Despacer 隐私政策

[English](PRIVACY.md) · [Deutsch](PRIVACY.de.md) · [Español](PRIVACY.es.md) · [Français](PRIVACY.fr.md) · [日本語](PRIVACY.ja.md) · [한국어](PRIVACY.ko.md) · [Português (Brasil)](PRIVACY.pt-BR.md) · **简体中文** · [繁體中文](PRIVACY.zh-Hant.md)

最后更新：2026 年 10 月 22 日

Despacer 不收集任何数据，一点也不。

- 它不建立任何网络连接。
- 它没有账户、分析统计、崩溃报告、广告或跟踪。
- 它只在终端 App（列在其“终端”设置中的 App）位于最前面、你刚复制了内容时才读取剪贴板。从其他任何 App 复制的内容一律不会被读取。
- 为了找到所复制命令的准确原文，它会读取 Claude Code 和 Codex 保存在你电脑上的会话文件（`~/.claude/projects` 和 `~/.codex/sessions`）。它只读取这些文件，从不修改、拷贝或上传它们。你可以通过 **匹配会话历史** 关闭此功能。
- 它会把最近十次修复保存在内存中，方便你撤销。这些内容从不写入磁盘，Despacer 退出后即消失。
- 它的设置（哪些功能已打开、哪些 App 算作终端、在菜单栏中显示、登录时打开）仅存储在你的电脑上。

如果情况有变，本页面会第一时间说明。

如有疑问：请在 https://github.com/MattSenter/despacer/issues 提交 issue。
