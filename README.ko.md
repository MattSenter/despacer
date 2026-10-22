<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Despacer 앱 아이콘">
</p>

<h1 align="center">Despacer</h1>

<p align="center">
  터미널에서 <b>Claude Code</b>와 <b>Codex</b>의 긴 명령어를 복사해서, 끊김 없이 한 번에 붙여넣으세요.
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <b>한국어</b> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

**Claude Code**와 **Codex**처럼 터미널에서 실행되는 AI 코딩 에이전트는 긴 줄을 스스로 줄바꿈합니다. 긴 명령어의 줄바꿈을 터미널에 맡기지 않고, 실제 줄바꿈과 들여쓰기를 출력에 직접 넣습니다. 그래서 iTerm이나 Terminal에서 명령어를 복사해 붙여넣으면, 여러 조각으로 끊긴 채 붙여넣어져 실행되지 않습니다.

```
  curl --fail --location --retry 3 --connect-timeout 10 --max-time 120
  --output premail-demo.zip
  "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately
  -long-filename-for-testing-terminal-line-wrapping.zip"
```

Despacer는 이 문제를 해결하는 작고 무료인 오픈 소스 메뉴 막대 앱입니다. Despacer가 실행 중이면, 같은 내용을 복사해도 원래 의도한 하나의 명령어로 붙여넣어집니다.

```
curl --fail --location --retry 3 --connect-timeout 10 --max-time 120 --output premail-demo.zip "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately-long-filename-for-testing-terminal-line-wrapping.zip"
```

- Terminal, iTerm2, Ghostty, Warp, kitty, Alacritty, WezTerm, Hyper, Tabby, Rio를 기본으로 지원하며, 직접 추가한 다른 앱에서도 작동합니다
- 터미널이 맨 앞에 있을 때 복사한 텍스트만 건드립니다
- 네트워크 접근, 분석, 데이터 수집이 없습니다
- macOS 14 Sonoma 이상이 필요합니다

## 목차

- [설치](#설치)
- [Despacer 사용하기](#despacer-사용하기)
- [설정](#설정)
- [메뉴 막대 메뉴](#메뉴-막대-메뉴)
- [키보드 단축키](#키보드-단축키)
- [문제 해결](#문제-해결)
- [작동 원리](#작동-원리)
- [명령어 라인 도구](#명령어-라인-도구)
- [제거](#제거)
- [빌드 및 기여](#빌드-및-기여)
- [프로젝트 후원하기](#프로젝트-후원하기)

## 설치

현재 Despacer는 소스에서 직접 빌드해 설치합니다. 1분 정도 걸립니다.

1. Apple 명령어 라인 도구가 없다면 설치합니다.
   ```sh
   xcode-select --install
   ```
2. 이 저장소를 복제하고 빌드합니다.
   ```sh
   git clone https://github.com/MattSenter/despacer.git
   cd despacer
   ./build.sh --install
   ```
   `Despacer.app`을 빌드해 응용 프로그램 폴더에 복사한 뒤 실행합니다.
3. 설정 윈도우가 나타납니다. **시스템**에서 **로그인 시 열기**를 켜 두면 Despacer가 항상 준비되어 있습니다.

이제 끝입니다. 평소처럼 Claude Code나 Codex에서 명령어를 복사해 붙여넣으면 됩니다.

## Despacer 사용하기

새로 배울 것은 없습니다. 터미널에서 명령어를 선택하고 Cmd+C를 누른 다음, 원하는 곳에 붙여넣으세요. 붙여넣을 즈음에는 Despacer가 이미 명령어를 다시 하나로 이어 놓았습니다. 보통 100분의 몇 초면 끝납니다.

- **터미널에서 복사한 내용**은 확인한 뒤 필요하면 수정합니다.
- **다른 앱에서 복사한 내용**은 전혀 들여다보지 않습니다.
- **처음부터 끊기지 않은 텍스트**(짧은 명령어나 일반적인 터미널 출력 등)는 그대로 둡니다.

수정 결과가 원하던 것과 다르다면, 메뉴 막대 아이콘에서 **마지막 수정 실행 취소**를 선택하세요. 복사한 내용이 복사했을 때 그대로 돌아옵니다. **수정**의 **최근 수정** 목록에는 최근 10개의 수정 내역이 표시되며, 각 항목에 **원본 복사**와 **수정본 복사** 버튼이 있습니다.

## 설정

설정 윈도우를 열려면 응용 프로그램 폴더(또는 Spotlight나 Launchpad)에서 Despacer를 열거나, 메뉴 막대 아이콘에서 **설정…**을 선택하세요. 사이드바에는 7개의 패널이 있습니다. **수정**, **터미널**, **시스템**, **권한**, **개인정보 보호**, **다른 프로젝트**(같은 개발자의 다른 앱), **정보**(버전 정보와 링크)입니다.

| 설정 | 패널 | 하는 일 |
|---|---|---|
| **터미널 복사 내용 수정** | 수정 | Despacer를 종료하지 않고 켜거나 끕니다. |
| **세션 기록과 대조** | 수정 | 컴퓨터에 있는 Claude Code와 Codex 세션 파일에서 정확한 원본을 찾습니다. 기본적으로 켜져 있습니다. 스위치 아래에 각 앱의 기록을 찾았는지 표시됩니다. |
| **다른 줄바꿈된 텍스트도 복구** | 수정 | 정확히 일치하는 내용이 없을 때, 터미널 너비에서 확실히 끊긴 줄을 다시 잇습니다. 기본적으로 켜져 있습니다. |
| **사운드 재생** | 수정 | 수정된 내용을 붙여넣을 준비가 되면 짧은 사운드를 재생합니다. 기본적으로 꺼져 있습니다. |
| **기본 제공** | 터미널 | Despacer가 기본으로 알고 있는 터미널이며, 모두 기본적으로 켜져 있습니다. Despacer가 지켜보지 않았으면 하는 터미널은 체크를 해제하세요. |
| **직접 추가한 앱** | 터미널 | 터미널이 내장된 코드 편집기처럼, 명령어를 복사해 오는 다른 앱입니다. **앱 추가…**를 클릭해 선택하세요. |
| **로그인 시 열기** | 시스템 | 로그인할 때 Despacer를 자동으로 시작합니다. 이 윈도우를 열지 않고 조용히 시작합니다. |
| **메뉴 막대에서 보기** | 시스템 | 메뉴 막대 아이콘을 표시하거나 없앱니다. 끄면 Despacer는 보이지 않게 실행됩니다. 이 윈도우로 돌아오려면 응용 프로그램 폴더에서 Despacer를 여세요. |
| **Despacer 종료** | 시스템 | 앱을 실제로 종료합니다. 윈도우를 닫거나 Cmd+Q를 눌러도 윈도우만 닫히고 Despacer는 계속 실행됩니다. |

**권한** 패널에는 macOS가 Despacer에게 복사한 내용을 읽도록 허용했는지가 표시됩니다([문제 해결](#문제-해결) 참고). 설정은 자동으로 저장되며 바로 적용됩니다.

## 메뉴 막대 메뉴

메뉴 막대의 Despacer 아이콘을 클릭하면 빠르게 접근할 수 있습니다.

- **터미널 복사 내용 수정**: Despacer를 켜거나 끕니다.
- **수정 시 사운드 재생**: **수정**에 있는 스위치와 같습니다.
- **마지막 수정 실행 취소**: 마지막으로 수정된 내용을 복사했을 때 그대로 클립보드에 되돌립니다.
- **메뉴 막대에서 보기**: 체크를 해제하면 아이콘이 사라집니다. Cmd를 누른 채 아이콘을 메뉴 막대 밖으로 드래그해도 됩니다.
- **로그인 시 열기**: 로그인할 때 Despacer를 시작합니다.
- **설정…**: 설정 윈도우를 엽니다.
- **Despacer 종료**: 앱을 종료합니다.

## 키보드 단축키

Despacer 설정 윈도우가 맨 앞에 있을 때:

| 단축키 | 하는 일 |
|---|---|
| Cmd+W | 설정 윈도우를 닫습니다. Despacer는 계속 실행됩니다. |
| Cmd+Q | 마찬가지로 윈도우만 닫고 Despacer는 계속 실행되므로, 실수로 Cmd+Q를 눌러도 꺼지지 않습니다. 완전히 종료하려면 **Despacer 종료**를 사용하세요. |
| Cmd+H | 다른 앱처럼 Despacer를 가립니다. |
| Cmd+, | 설정을 엽니다. |

## 문제 해결

**복사한 내용이 여전히 끊긴 채 붙여넣어집니다.**
Despacer가 실행 중인지(응용 프로그램 폴더에서 열어 보세요), **터미널 복사 내용 수정**이 켜져 있는지 확인하세요. 사용하는 터미널이 **터미널**에서 체크되어 있는지 확인하고, 없다면 **앱 추가…**로 추가하세요. 그다음 **권한** 패널을 확인하세요.

**macOS가 Despacer에게 다른 앱에서 붙여넣기를 허용할지 물었습니다.**
최신 버전의 macOS에서는 복사한 내용을 읽을 수 있는 앱을 직접 정할 수 있습니다. **허용**을 선택하세요. **허용 안 함**을 선택했다면 시스템 설정 > 개인정보 보호 및 보안 > 다른 앱에서 붙여넣기를 열고 Despacer를 허용으로 설정하세요. **권한** 패널에는 현재 설정이 표시되며, 그곳으로 이동하는 버튼도 있습니다.

**이어 붙이지 말아야 할 내용이 이어 붙여졌습니다.**
메뉴 막대 아이콘에서 **마지막 수정 실행 취소**를 선택하세요. 세션 기록에서 찾은 정확한 일치는 줄바꿈을 틀리는 일이 없지만, 일치하는 내용이 없을 때는 줄바꿈 규칙이 추측할 수밖에 없습니다. 계속 이런 일이 생긴다면 **다른 줄바꿈된 텍스트도 복구**를 끄고, Despacer가 세션 기록에서 찾은 내용만 수정하도록 하세요. 규칙을 개선할 수 있도록 복사한 텍스트를 첨부해 [이슈를 열어 주세요](https://github.com/MattSenter/despacer/issues).

**일반적인 터미널 출력에서 복사한 내용을 Despacer가 바꿨습니다.**
Despacer는 Claude Code와 Codex가 출력하는 2칸 들여쓰기가 있는 텍스트나, 이들의 세션 기록에서 한 글자도 다르지 않게 찾은 텍스트만 복구합니다. 그 밖의 내용을 복사했는데 바뀌었다면 [이슈를 열어 주세요](https://github.com/MattSenter/despacer/issues).

**메뉴 막대 아이콘을 껐더니 Despacer를 찾을 수 없습니다.**
응용 프로그램 폴더에서 Despacer를 여세요. 설정 윈도우가 나타나면 **시스템**에서 아이콘을 다시 켤 수 있습니다.

**로그인 시 열기가 계속 꺼집니다.**
macOS는 고정된 위치에 있는 앱만 로그인 시 열 수 있게 허용합니다. Despacer가 응용 프로그램 폴더에 있는지 확인한 뒤(`./build.sh --install`을 사용하면 그곳에 설치됩니다) 설정을 다시 켜세요.

## 작동 원리

Claude Code와 Codex는 둘 다 출력을 직접 그리며, 둘 다 긴 줄을 터미널 너비에 맞게 줄바꿈한 뒤 출력합니다. 실제 줄바꿈 문자를 넣고, 이어서 2칸 들여쓰기를 넣는 방식입니다. 터미널은 따로 나뉜 줄만 받기 때문에 복사되는 것도 나뉜 줄입니다. 원래의 줄 끝은 터미널에 전혀 전달되지 않으므로, 터미널 설정으로는 이를 되돌릴 수 없습니다.

Despacer는 클립보드를 1초에 20번 확인합니다(macOS에는 클립보드 알림이 없으며, 이 확인에 드는 부담은 거의 없습니다). 터미널 앱에서 복사한 내용이면 두 단계로 수정합니다.

1. **줄바꿈 규칙, 즉시.** 2칸 들여쓰기와 줄 끝의 여백을 없앤 뒤, 줄바꿈 때문에 생긴 모든 줄바꿈을 다시 잇습니다. 다음 단어가 윗줄에 들어가지 않았을 경우, 그 줄바꿈은 자동 줄바꿈으로 간주합니다. 너비를 가득 채운 줄은 단어 중간에서 나뉜 것이지만, 이는 단어가 한 줄에 들어가지 않을 만큼 길 때뿐이므로 공백 없이 잇습니다. 그 밖의 줄바꿈과 `\`로 끝나는 줄은 그대로 둡니다. 이 버전은 바로 클립보드에 들어가므로, 윈도우를 전환하기도 전에 준비됩니다.
2. **정확한 일치, 잠시 후.** 백그라운드에서 모든 공백과 줄바꿈을 무시한 채, Claude Code(`~/.claude/projects`)와 Codex(`~/.codex/sessions`)가 컴퓨터에 보관하는 세션 파일에서 복사한 텍스트를 찾습니다. 최근 하루 동안 활성화된 세션을 최신 순으로 확인합니다. 일치하는 내용을 찾으면 에이전트가 작성한 그대로의 원본 텍스트를 클립보드에 넣습니다. 단, 그사이에 다른 것을 복사했다면 넣지 않습니다.

대부분의 명령어는 줄바꿈 규칙만으로 올바르게 고쳐지지만, 줄 중간에서 시작하는 선택 영역처럼 도저히 구분할 수 없는 줄바꿈도 있습니다. 이런 경우는 정확한 일치로 해결됩니다. 선택 영역이 어디서 시작하고 어디서 끝나든 작동합니다.

앱은 [`App/`](App)에 있는 1,400줄 미만의 Swift 코드이며, 수정 엔진은 [`Sources/DespacerCore/`](Sources/DespacerCore)에 있는 약 250줄의 코드와 테스트로 이루어져 있습니다.

## 명령어 라인 도구

같은 수정 엔진은 명령어 라인 필터로도 사용할 수 있습니다. 스크립트에서 쓰거나, 이미 어딘가에 붙여넣은 텍스트를 고칠 때 유용합니다.

```sh
swift build -c release
pbpaste | .build/release/despacer | pbcopy
```

`--explain`을 붙이면 어떤 방법을 사용했는지 표시되고, `--no-transcripts`를 붙이면 줄바꿈 규칙만 사용합니다.

## 제거

1. 메뉴 막대 아이콘이나 설정 윈도우의 **시스템** 패널에서 **Despacer 종료**를 선택합니다.
2. **로그인 시 열기**를 켜 두었다면 먼저 끄거나, 시스템 설정 > 일반 > 로그인 항목에서 Despacer를 제거합니다.
3. `/Applications/Despacer.app`을 휴지통으로 드래그합니다.
4. 원한다면 설정도 삭제합니다.
   ```sh
   defaults delete com.mattsenter.Despacer
   ```

## 빌드 및 기여

```sh
./build.sh            # builds build/Despacer.app (ad-hoc signed)
./build.sh --install  # also copies it to /Applications and opens it
swift test            # runs the fixing engine's tests
swift Tools/make-icon.swift   # regenerates the app icon in Resources/
python3 scripts/check-localization.py   # checks every language is complete
```

Despacer는 영어, 독일어, 스페인어, 프랑스어, 일본어, 한국어, 브라질 포르투갈어, 중국어 간체 및 번체로 제공됩니다. 앱에 표시되는 새 문자열은 `Localization/en.lproj/Localizable.strings`와 다른 모든 `.lproj`에 추가하고, 이 README나 `PRIVACY.md`를 변경했다면 각 번역에도 반영하세요.

| 경로 | 내용 |
|---|---|
| `Sources/DespacerCore/` | 수정 엔진: 줄바꿈 규칙(`Despacer.swift`)과 세션 기록 조회(`TranscriptMatcher.swift`) |
| `Tests/DespacerCoreTests/` | 실제로 끊긴 복사 내용으로 만든 테스트 |
| `Sources/despacer/` | 명령어 라인 도구 |
| `App/main.swift` | 앱 델리게이트와 메뉴 |
| `App/ClipboardWatcher.swift` | 클립보드를 지켜보고 수정을 적용 |
| `App/TerminalApps.swift` | 기본 제공 터미널과 직접 추가한 앱 |
| `App/SettingsView.swift` | SwiftUI 설정 윈도우: 사이드바와 패널 |
| `App/OtherProjectsView.swift`, `Resources/other-projects/` | 다른 프로젝트 패널과 스크린샷 |
| `App/BuiltByCredit.swift`, `App/OutboundLink.swift` | 사이드바의 크레딧과 저작권 표시, 태그가 붙은 외부 링크 |
| `App/MenuBarIcon.swift` | 코드로 그리는 메뉴 막대 아이콘 |
| `Localization/<lang>.lproj/` | 각 언어의 앱 문자열(영어가 원본) |
| `README.<lang>.md`, `PRIVACY.<lang>.md` | 번역된 문서 |
| `scripts/check-localization.py` | 문자열이나 문서가 빠진 언어가 있으면 실패 |
| `Tools/make-icon.swift` | 앱 아이콘을 렌더링 |

이슈와 풀 리퀘스트를 환영합니다. 특히 줄바꿈 규칙이 잘못 고친 끊긴 복사 내용을 알려 주시면 큰 도움이 됩니다.

## 프로젝트 후원하기

Despacer는 무료이며 앞으로도 계속 무료입니다. 매일 겪던 작은 짜증을 덜어 주었다면 Venmo로 팁을 보내 주세요.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>Venmo로 @MattSenter에게 팁 보내기</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="Matt Senter에게 팁을 보내는 Venmo QR 코드">
  </a>
  <br>
  <sub>휴대폰으로 스캔하세요</sub>
</p>

팁은 감사의 표시입니다. 잠금 해제되는 기능은 없습니다. 애초에 잠긴 기능이 없기 때문입니다.

## 라이선스

[MIT](LICENSE). 개발: [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer).
