<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Despacer 應用程式圖像">
</p>

<h1 align="center">Despacer</h1>

<p align="center">
  在終端機中從 <b>Claude Code</b> 和 <b>Codex</b> 拷貝長指令，貼上時依然完整。
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <b>繁體中文</b>
</p>

---

在終端機中執行的 AI 程式設計代理，例如 **Claude Code** 和 **Codex**，會自行處理長行的換行。它們不讓終端機自動折行，而是直接在長指令中輸出真正的換行字元和縮排。所以當你從 iTerm 或 Terminal 拷貝一道指令再貼上時，它會被拆成好幾段，根本無法執行：

```
  curl --fail --location --retry 3 --connect-timeout 10 --max-time 120
  --output premail-demo.zip
  "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately
  -long-filename-for-testing-terminal-line-wrapping.zip"
```

Despacer 是一款免費、開放原始碼的小巧選單列應用程式，專門解決這個問題。只要它在執行，同樣的拷貝內容貼上後，就是它原本該有的那一道完整指令：

```
curl --fail --location --retry 3 --connect-timeout 10 --max-time 120 --output premail-demo.zip "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately-long-filename-for-testing-terminal-line-wrapping.zip"
```

- 一安裝就支援 Terminal、iTerm2、Ghostty、Warp、kitty、Alacritty、WezTerm、Hyper、Tabby 和 Rio，也支援你自行加入的任何其他應用程式
- 只處理終端機位於最前方時你拷貝的文字
- 不連網、不做分析、不收集任何資料
- 需要 macOS 14 Sonoma 或以上版本

## 目錄

- [安裝](#安裝)
- [使用 Despacer](#使用-despacer)
- [設定](#設定)
- [選單列選單](#選單列選單)
- [鍵盤快速鍵](#鍵盤快速鍵)
- [疑難排解](#疑難排解)
- [運作原理](#運作原理)
- [命令列工具](#命令列工具)
- [解除安裝](#解除安裝)
- [建置與貢獻](#建置與貢獻)
- [支持這個專案](#支持這個專案)

## 安裝

目前要安裝 Despacer，需從原始碼建置。整個過程大約一分鐘。

1. 如果你還沒有 Apple 的命令列工具，請先安裝：
   ```sh
   xcode-select --install
   ```
2. 複製這個儲存庫並建置：
   ```sh
   git clone https://github.com/MattSenter/despacer.git
   cd despacer
   ./build.sh --install
   ```
   這會建置 `Despacer.app`，將它拷貝到你的「應用程式」檔案夾並開啟。
3. 「設定」視窗會出現。在 **系統** 面板中打開 **登入時開啟** 開關，讓 Despacer 隨時待命。

就這樣。照平常的方式從 Claude Code 或 Codex 拷貝指令，然後貼上即可。

## 使用 Despacer

沒有新東西要學。在終端機中選取一道指令，按 Cmd+C，然後貼到你要用的地方。等你貼上時，Despacer 早已把它重新接好，通常只需要幾百分之一秒。

- **從終端機拷貝的內容** 會經過檢查，需要時會被修正。
- **從其他任何應用程式拷貝的內容** 一律不會被查看。
- **原本就沒有斷開的文字**，例如短指令或一般的終端機輸出，會保持原樣。

如果某次修正不是你想要的，從選單列圖像選擇 **還原上次修正**，就能把拷貝內容恢復成你拷貝時的原樣。**修正** 中的 **最近的修正** 列表會顯示最近十次修正，每一筆都有 **拷貝原始文字** 和 **拷貝修正後文字** 按鈕。

## 設定

開啟「設定」視窗的方式有：從「應用程式」檔案夾（或 Spotlight、Launchpad）開啟 Despacer，或從選單列圖像選擇 **設定…**。側邊欄有七個面板：**修正**、**終端機**、**系統**、**權限**、**隱私**、**其他專案**（同一位開發者的更多應用程式）和 **關於**（版本資訊與連結）。

| 設定 | 面板 | 功能 |
|---|---|---|
| **修正從終端機拷貝的內容** | 修正 | 不必結束 Despacer 就能開啟或關閉它。 |
| **比對工作階段記錄** | 修正 | 在你電腦上的 Claude Code 和 Codex 工作階段檔案中找出完全相符的原文。預設為開啟。開關下方會顯示 Despacer 是否找到各個應用程式的記錄。 |
| **修正其他自動換行的文字** | 修正 | 找不到完全相符的內容時，把明顯是因終端機寬度而斷開的行重新接起來。預設為開啟。 |
| **播放聲音** | 修正 | 修正好的內容可以貼上時，播放一段簡短的提示音。預設為關閉。 |
| **內建** | 終端機 | Despacer 認得的終端機，預設全部開啟。取消勾選你不想讓 Despacer 監看的終端機。 |
| **由你加入** | 終端機 | 你會從中拷貝指令的其他應用程式，例如內建終端機的程式碼編輯器。按一下 **加入應用程式…** 並選擇它。 |
| **登入時開啟** | 系統 | 登入時自動啟動 Despacer。它會安靜地啟動，不會開啟這個視窗。 |
| **在選單列中顯示** | 系統 | 顯示或移除選單列圖像。關閉後，Despacer 會在背景默默執行。從「應用程式」檔案夾開啟 Despacer 即可回到這個視窗。 |
| **結束 Despacer** | 系統 | 真正結束應用程式。關閉視窗（或按 Cmd+Q）只會關閉視窗，Despacer 仍會繼續執行。 |

**權限** 面板會顯示 macOS 是否允許 Despacer 讀取你拷貝的內容（請參閱 [疑難排解](#疑難排解)）。設定會自動儲存，並立即生效。

## 選單列選單

按一下選單列中的 Despacer 圖像，即可快速使用：

- **修正從終端機拷貝的內容**：開啟或關閉 Despacer。
- **修正後播放聲音**：與 **修正** 中的開關相同。
- **還原上次修正**：把上一次修正的內容依你拷貝時的原樣放回剪貼板。
- **在選單列中顯示**：取消勾選即可移除圖像。你也可以按住 Cmd 鍵，把圖像拖出選單列。
- **登入時開啟**：登入時啟動 Despacer。
- **設定…**：開啟「設定」視窗。
- **結束 Despacer**：結束應用程式。

## 鍵盤快速鍵

當 Despacer 的「設定」視窗在最前方時：

| 快速鍵 | 功能 |
|---|---|
| Cmd+W | 關閉「設定」視窗。Despacer 仍會繼續執行。 |
| Cmd+Q | 同樣會關閉視窗並讓 Despacer 繼續執行，所以不小心按到 Cmd+Q 也不會把它關掉。要真正結束，請使用 **結束 Despacer**。 |
| Cmd+H | 和其他應用程式一樣隱藏 Despacer。 |
| Cmd+, | 開啟「設定」。 |

## 疑難排解

**拷貝的內容貼上後還是斷開的。**
請確認 Despacer 正在執行（從「應用程式」檔案夾開啟它），而且 **修正從終端機拷貝的內容** 已開啟。檢查你的終端機是否已在 **終端機** 中勾選，或用 **加入應用程式…** 加入它。然後查看 **權限** 面板。

**macOS 詢問 Despacer 是否可以從其他 App 貼上。**
較新版本的 macOS 讓你決定哪些應用程式可以讀取你拷貝的內容。請選擇 **允許**。如果你選了 **不允許**，請打開「系統設定」>「隱私權與安全性」>「從其他 App 貼上」，將 Despacer 設為「允許」。**權限** 面板會顯示目前的設定，並提供一個直接前往該處的按鈕。

**有一段拷貝內容被接起來了，但它不該被接起來。**
從選單列圖像選擇 **還原上次修正**。來自工作階段記錄的完全相符結果在換行上絕不會出錯，但找不到相符內容時，換行規則只能用猜的。如果這種情況一再發生，請關閉 **修正其他自動換行的文字**，讓 Despacer 只修正它在工作階段記錄中找到的內容。也請附上你拷貝的文字 [開一個 issue](https://github.com/MattSenter/despacer/issues)，幫助改進這些規則。

**Despacer 修改了我從一般終端機輸出中拷貝的內容。**
Despacer 只會修正帶有 Claude Code 和 Codex 所輸出的 2 個空格縮排的文字，或在它們的工作階段記錄中逐字找到的文字。如果你拷貝的是別的內容卻被修改了，請 [開一個 issue](https://github.com/MattSenter/despacer/issues)。

**我關閉了選單列圖像，結果找不到 Despacer。**
從「應用程式」檔案夾開啟 Despacer。「設定」視窗會出現，你可以在 **系統** 中重新開啟圖像。

**「登入時開啟」一直無法保持開啟。**
macOS 只允許放在固定位置的應用程式在登入時開啟。請確認 Despacer 位於「應用程式」檔案夾（`./build.sh --install` 會把它放在那裡），然後再次開啟這項設定。

## 運作原理

Claude Code 和 Codex 都會自行繪製輸出，而且都會在輸出前把長行依終端機寬度折行：先是一個真正的換行字元，再加上 2 個空格的縮排。終端機看到的永遠是一行行獨立的文字，所以它拷貝的也就是這些。終端機中沒有任何設定能還原這一點，因為原本的行尾根本沒有傳到終端機。

Despacer 每秒檢查剪貼板 20 次（macOS 沒有剪貼板通知，而這項檢查幾乎不耗資源）。當拷貝內容來自終端機應用程式時，它會分兩個步驟進行修正：

1. **換行規則，立即生效。** 它會移除 2 個空格的縮排和行尾的填充空格，然後把所有因折行而產生的換行重新接起來。如果下一個單字放不進上一行，這個換行就會被視為折行。填滿整行寬度的行是在單字中間被拆開的，但僅限於單字長到一行放不下的情況，所以這種行會不加空格直接接上。其他所有換行，以及以 `\` 結尾的行，都會保留。這個版本會立刻放到剪貼板上，在你切換視窗之前就已準備好。
2. **完全相符，稍後完成。** 它會在背景中，忽略所有空格和換行，在 Claude Code（`~/.claude/projects`）和 Codex（`~/.codex/sessions`）保存在你電腦上的工作階段檔案中搜尋拷貝的文字。它會檢查最近一天內有活動的工作階段，從最新的開始。一旦找到相符內容，它就會把原始文字依代理寫下時的原樣放到剪貼板上，除非你在這段期間又拷貝了別的內容。

光靠換行規則就能正確處理大部分指令，但有些換行根本無從分辨，例如從一行中間開始的選取範圍。完全相符能解決這些情況。不論你的選取範圍從哪裡開始、到哪裡結束，它都有效。

整個應用程式的 Swift 程式碼不到 1,400 行，都在 [`App/`](App) 中，修正引擎約 250 行，位於 [`Sources/DespacerCore/`](Sources/DespacerCore)，並附有測試。

## 命令列工具

同一個修正引擎也是一個命令列過濾器，可用於腳本，或用來修正你已經貼到某處的文字：

```sh
swift build -c release
pbpaste | .build/release/despacer | pbcopy
```

傳入 `--explain` 可查看它使用了哪種方法，傳入 `--no-transcripts` 則只使用換行規則。

## 解除安裝

1. 從選單列圖像或「設定」視窗的 **系統** 面板選擇 **結束 Despacer**。
2. 如果 **登入時開啟** 是開啟的，請先將它關閉，或到「系統設定」>「一般」>「登入項目」中移除 Despacer。
3. 將 `/Applications/Despacer.app` 拖到垃圾桶。
4. 你也可以選擇移除它的設定：
   ```sh
   defaults delete com.mattsenter.Despacer
   ```

## 建置與貢獻

```sh
./build.sh            # builds build/Despacer.app (ad-hoc signed)
./build.sh --install  # also copies it to /Applications and opens it
swift test            # runs the fixing engine's tests
swift Tools/make-icon.swift   # regenerates the app icon in Resources/
python3 scripts/check-localization.py   # checks every language is complete
```

Despacer 提供英文、德文、西班牙文、法文、日文、韓文、巴西葡萄牙文，以及簡體中文和繁體中文版本。應用程式新增的顯示字串需要加入 `Localization/en.lproj/Localizable.strings` 和其他所有 `.lproj`，對這份 README 或 `PRIVACY.md` 的修改也需要同步到每個翻譯版本中。

| 路徑 | 內容 |
|---|---|
| `Sources/DespacerCore/` | 修正引擎：換行規則（`Despacer.swift`）和工作階段記錄搜尋（`TranscriptMatcher.swift`） |
| `Tests/DespacerCoreTests/` | 測試，取材自真實的斷行拷貝內容 |
| `Sources/despacer/` | 命令列工具 |
| `App/main.swift` | 應用程式委派和選單 |
| `App/ClipboardWatcher.swift` | 監看剪貼板並套用修正 |
| `App/TerminalApps.swift` | 內建的終端機和你加入的終端機 |
| `App/SettingsView.swift` | SwiftUI「設定」視窗：側邊欄和各個面板 |
| `App/OtherProjectsView.swift`, `Resources/other-projects/` | 其他專案面板及其截圖 |
| `App/BuiltByCredit.swift`, `App/OutboundLink.swift` | 側邊欄中的署名和版權資訊，以及加上標記的外部連結 |
| `App/MenuBarIcon.swift` | 以程式碼繪製的選單列圖像 |
| `Localization/<lang>.lproj/` | 應用程式在各語言中的字串（英文為來源語言） |
| `README.<lang>.md`, `PRIVACY.<lang>.md` | 翻譯文件 |
| `scripts/check-localization.py` | 任何語言缺少字串或文件時回報失敗 |
| `Tools/make-icon.swift` | 繪製應用程式圖像 |

歡迎提出 issue 和 pull request，特別是換行規則處理錯誤的斷行拷貝內容。

## 支持這個專案

Despacer 是免費的，而且永遠免費。如果它幫你省去了每天的一點小麻煩，歡迎透過 Venmo 給我小費。

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>透過 Venmo 給 @MattSenter 小費</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="給 Matt Senter 小費的 Venmo QR 碼">
  </a>
  <br>
  <sub>用手機掃描</sub>
</p>

小費只是一份心意，不會解鎖任何功能，因為本來就沒有東西需要解鎖。

## 授權條款

[MIT](LICENSE)。開發者：[Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer)。
