<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="App-Symbol von Despacer">
</p>

<h1 align="center">Despacer</h1>

<p align="center">
  Lange Befehle aus <b>Claude Code</b> und <b>Codex</b> in deinem Terminal kopieren und in einem Stück einsetzen.
</p>

<p align="center">
  <a href="README.md">English</a> · <b>Deutsch</b> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

KI-Coding-Agenten, die in deinem Terminal laufen, wie **Claude Code** und **Codex**, brechen lange Zeilen selbst um. Statt das Umbrechen eines langen Befehls dem Terminal zu überlassen, schreiben sie echte Zeilenumbrüche und Einrückungen hinein. Wenn du einen Befehl aus iTerm oder Terminal kopierst und einsetzt, kommt er deshalb in Stücken an und läuft nicht:

```
  curl --fail --location --retry 3 --connect-timeout 10 --max-time 120
  --output premail-demo.zip
  "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately
  -long-filename-for-testing-terminal-line-wrapping.zip"
```

Despacer ist eine winzige, kostenlose Open-Source-App für die Menüleiste, die genau das behebt. Solange sie läuft, wird dieselbe Kopie als der eine Befehl eingesetzt, der sie sein sollte:

```
curl --fail --location --retry 3 --connect-timeout 10 --max-time 120 --output premail-demo.zip "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately-long-filename-for-testing-terminal-line-wrapping.zip"
```

- Funktioniert ab Werk mit Terminal, iTerm2, Ghostty, Warp, kitty, Alacritty, WezTerm, Hyper, Tabby und Rio sowie mit jeder anderen App, die du hinzufügst
- Berührt nur Text, den du kopierst, während ein Terminal im Vordergrund ist
- Kein Netzwerkzugriff, keine Analysen, keine Datenerfassung
- Erfordert macOS 14 Sonoma oder neuer

## Inhalt

- [Installation](#installation)
- [Despacer verwenden](#despacer-verwenden)
- [Einstellungen](#einstellungen)
- [Das Menü in der Menüleiste](#das-menü-in-der-menüleiste)
- [Tastaturkurzbefehle](#tastaturkurzbefehle)
- [Fehlerbehebung](#fehlerbehebung)
- [So funktioniert es](#so-funktioniert-es)
- [Das Befehlszeilentool](#das-befehlszeilentool)
- [Deinstallieren](#deinstallieren)
- [Kompilieren und mitwirken](#kompilieren-und-mitwirken)
- [Das Projekt unterstützen](#das-projekt-unterstützen)
- [Weitere Projekte](#weitere-projekte)

## Installation

Despacer wird derzeit installiert, indem du es aus dem Quellcode kompilierst. Das dauert etwa eine Minute.

1. Installiere Apples Befehlszeilentools, falls du sie noch nicht hast:
   ```sh
   xcode-select --install
   ```
2. Klone dieses Repository und kompiliere es:
   ```sh
   git clone https://github.com/MattSenter/despacer.git
   cd despacer
   ./build.sh --install
   ```
   Dadurch wird `Despacer.app` erstellt, in deinen Ordner „Programme“ kopiert und geöffnet.
3. Das Einstellungsfenster erscheint. Schalte unter **System** die Option **Bei der Anmeldung öffnen** ein, damit Despacer immer bereit ist.

Das war's. Kopiere Befehle aus Claude Code oder Codex wie gewohnt und setze sie ein.

## Despacer verwenden

Du musst nichts Neues lernen. Markiere einen Befehl in deinem Terminal, drücke Cmd+C und setze ihn ein, wo immer er hin soll. Bis du einsetzt, hat Despacer ihn schon wieder zusammengefügt, meist innerhalb weniger hundertstel Sekunden.

- **Kopien aus einem Terminal** werden geprüft und bei Bedarf korrigiert.
- **Kopien aus jeder anderen App** werden nie angesehen.
- **Text, der nie umbrochen war**, etwa ein kurzer Befehl oder gewöhnliche Terminalausgabe, bleibt genau so, wie er war.

Falls eine Korrektur einmal nicht das ist, was du wolltest, wähle im Menü des Menüleistensymbols **Letzte Korrektur widerrufen**, um deine Kopie genau so wiederherzustellen, wie du sie kopiert hast. Die Liste **Letzte Korrekturen** unter **Korrektur** zeigt die letzten zehn Korrekturen, jeweils mit den Tasten **Original kopieren** und **Korrigierte Fassung kopieren**.

## Einstellungen

Du öffnest das Einstellungsfenster, indem du Despacer aus deinem Ordner „Programme“ (oder über Spotlight oder das Launchpad) öffnest oder im Menü des Menüleistensymbols **Einstellungen…** wählst. Die Seitenleiste hat sieben Bereiche: **Korrektur**, **Terminals**, **System**, **Berechtigungen**, **Datenschutz**, **Weitere Projekte** (mehr Apps vom selben Entwickler) und **Über** (Versionsinfo und Links).

| Einstellung | Bereich | Was sie bewirkt |
|---|---|---|
| **Terminal-Kopien korrigieren** | Korrektur | Schaltet Despacer ein oder aus, ohne es zu beenden. |
| **Mit Sitzungsverlauf abgleichen** | Korrektur | Sucht das exakte Original in den Sitzungsdateien von Claude Code und Codex auf deinem Computer. Standardmäßig eingeschaltet. Unter dem Schalter zeigt Despacer an, ob es den Verlauf der jeweiligen App gefunden hat. |
| **Anderen umbrochenen Text reparieren** | Korrektur | Fügt Zeilen, die eindeutig an der Breite des Terminals umbrochen wurden, wieder zusammen, wenn es keine exakte Übereinstimmung gibt. Standardmäßig eingeschaltet. |
| **Ton abspielen** | Korrektur | Spielt einen kurzen Ton ab, sobald eine korrigierte Kopie zum Einsetzen bereit ist. Standardmäßig ausgeschaltet. |
| **Integriert** | Terminals | Die Terminals, die Despacer kennt, alle standardmäßig eingeschaltet. Deaktiviere alle, die Despacer nicht beobachten soll. |
| **Von dir hinzugefügt** | Terminals | Jede andere App, aus der du Befehle kopierst, etwa ein Code-Editor mit integriertem Terminal. Klicke auf **App hinzufügen…** und wähle sie aus. |
| **Bei der Anmeldung öffnen** | System | Startet Despacer automatisch, wenn du dich anmeldest. Es startet still, ohne dieses Fenster zu öffnen. |
| **In der Menüleiste anzeigen** | System | Zeigt das Menüleistensymbol an oder entfernt es. Ist die Option aus, läuft Despacer unsichtbar. Öffne Despacer aus deinem Ordner „Programme“, um zu diesem Fenster zurückzukehren. |
| **Despacer beenden** | System | Beendet die App wirklich. Das Schließen des Fensters (oder Cmd+Q) schließt nur das Fenster, Despacer läuft weiter. |

Der Bereich **Berechtigungen** zeigt, ob macOS Despacer erlaubt, deine Kopien zu lesen (siehe [Fehlerbehebung](#fehlerbehebung)). Einstellungen werden automatisch gesichert und gelten sofort.

## Das Menü in der Menüleiste

Klicke auf das Despacer-Symbol in deiner Menüleiste, um schnell darauf zuzugreifen:

- **Terminal-Kopien korrigieren**: Despacer ein- oder ausschalten.
- **Ton nach Korrektur abspielen**: derselbe Schalter wie unter **Korrektur**.
- **Letzte Korrektur widerrufen**: die zuletzt korrigierte Kopie wieder genau so in die Zwischenablage legen, wie du sie kopiert hast.
- **In der Menüleiste anzeigen**: Deaktiviere die Option, um das Symbol zu entfernen. Du kannst auch die Befehlstaste gedrückt halten und das Symbol aus der Menüleiste ziehen.
- **Bei der Anmeldung öffnen**: Despacer starten, wenn du dich anmeldest.
- **Einstellungen…**: das Einstellungsfenster öffnen.
- **Despacer beenden**: die App beenden.

## Tastaturkurzbefehle

Solange das Fenster „Despacer-Einstellungen“ im Vordergrund ist:

| Kurzbefehl | Was er bewirkt |
|---|---|
| Cmd+W | Schließt das Einstellungsfenster. Despacer läuft weiter. |
| Cmd+Q | Schließt ebenfalls das Fenster und lässt Despacer weiterlaufen, damit ein versehentliches Cmd+Q es nie ausschaltet. Mit **Despacer beenden** beendest du es wirklich. |
| Cmd+H | Blendet Despacer aus wie jede andere App. |
| Cmd+, | Öffnet die Einstellungen. |

## Fehlerbehebung

**Meine Kopie kommt beim Einsetzen immer noch zerstückelt an.**
Stelle sicher, dass Despacer läuft (öffne es aus deinem Ordner „Programme“) und dass **Terminal-Kopien korrigieren** eingeschaltet ist. Prüfe, ob dein Terminal unter **Terminals** aktiviert ist, oder füge es mit **App hinzufügen…** hinzu. Sieh dir dann den Bereich **Berechtigungen** an.

**macOS hat gefragt, ob Despacer aus anderen Apps einsetzen darf.**
In neueren Versionen von macOS entscheidest du, welche Apps lesen dürfen, was du kopierst. Wähle **Erlauben**. Wenn du **Nicht erlauben** gewählt hast, öffne „Systemeinstellungen“ > „Datenschutz & Sicherheit“ > „Aus anderen Apps einsetzen“ und stelle Despacer auf „Erlauben“. Der Bereich **Berechtigungen** zeigt die aktuelle Einstellung und hat eine Taste, die dich dorthin bringt.

**Eine Kopie wurde zusammengefügt, obwohl sie das nicht sollte.**
Wähle im Menü des Menüleistensymbols **Letzte Korrektur widerrufen**. Die exakte Übereinstimmung aus dem Sitzungsverlauf irrt sich nie bei Zeilenumbrüchen, aber die Umbruchregeln müssen raten, wenn es keine Übereinstimmung gibt. Wenn es immer wieder passiert, schalte **Anderen umbrochenen Text reparieren** aus und lass Despacer nur korrigieren, was es im Sitzungsverlauf findet. Bitte [erstelle ein Issue](https://github.com/MattSenter/despacer/issues) mit dem kopierten Text, damit die Regeln besser werden können.

**Despacer hat etwas verändert, das ich aus gewöhnlicher Terminalausgabe kopiert habe.**
Despacer repariert nur Text mit der Einrückung von 2 Leerzeichen, die Claude Code und Codex ausgeben, oder Text, den es Wort für Wort in deren Sitzungsverlauf findet. Wenn du etwas anderes kopiert hast und es sich verändert hat, [erstelle bitte ein Issue](https://github.com/MattSenter/despacer/issues).

**Ich habe das Menüleistensymbol ausgeschaltet und finde Despacer nicht mehr.**
Öffne Despacer aus deinem Ordner „Programme“. Das Einstellungsfenster erscheint, und du kannst das Symbol unter **System** wieder einschalten.

**„Bei der Anmeldung öffnen“ bleibt nicht eingeschaltet.**
macOS erlaubt das Öffnen bei der Anmeldung nur für Apps an einem festen Ort. Stelle sicher, dass Despacer in deinem Ordner „Programme“ liegt (`./build.sh --install` legt es dort ab), und schalte die Einstellung dann erneut ein.

## So funktioniert es

Claude Code und Codex zeichnen ihre Ausgabe beide selbst, und beide brechen lange Zeilen passend zur Breite des Terminals um, bevor sie sie ausgeben: ein echter Zeilenumbruch, dann 2 Leerzeichen Einrückung. Das Terminal sieht immer nur einzelne Zeilen, also kopiert es auch genau das. Keine Einstellung im Terminal kann das rückgängig machen, weil die ursprünglichen Zeilenenden das Terminal nie erreichen.

Despacer prüft die Zwischenablage 20-mal pro Sekunde (macOS meldet Änderungen an der Zwischenablage nicht, und die Prüfung kostet so gut wie nichts). Stammt die Kopie aus einer Terminal-App, korrigiert es sie in zwei Schritten:

1. **Umbruchregeln, sofort.** Es entfernt die Einrückung von 2 Leerzeichen und die Auffüllung an den Zeilenenden und fügt dann jeden Zeilenumbruch wieder zusammen, den das Umbrechen verursacht hat. Ein Umbruch gilt als Umbrechen, wenn das nächste Wort nicht mehr in die Zeile darüber gepasst hätte. Eine Zeile, die die ganze Breite füllt, wurde mitten im Wort geteilt, aber nur, wenn das Wort zu lang für eine Zeile ist, also wird sie ohne Leerzeichen angefügt. Jeder andere Zeilenumbruch und jede Zeile, die auf `\` endet, bleibt erhalten. Diese Fassung landet sofort in der Zwischenablage, sie ist also bereit, bevor du das Fenster wechseln kannst.
2. **Exakte Übereinstimmung, einen Moment später.** Im Hintergrund sucht es den kopierten Text, ohne Rücksicht auf Leerzeichen und Zeilenumbrüche, in den Sitzungsdateien, die Claude Code (`~/.claude/projects`) und Codex (`~/.codex/sessions`) auf deinem Computer ablegen. Es prüft die Sitzungen, die am letzten Tag aktiv waren, die neuesten zuerst. Bei einer Übereinstimmung legt es den Originaltext genau so in die Zwischenablage, wie der Agent ihn geschrieben hat, es sei denn, du hast inzwischen etwas anderes kopiert.

Die Umbruchregeln allein bringen die meisten Befehle richtig hin, aber manche Umbrüche lassen sich unmöglich unterscheiden, etwa bei einer Auswahl, die mitten in einer Zeile beginnt. Die exakte Übereinstimmung klärt diese Fälle. Sie funktioniert unabhängig davon, wo deine Auswahl beginnt oder endet.

Die App besteht aus weniger als 1.400 Zeilen Swift in [`App/`](App), und die Korrektur-Engine umfasst etwa 250 Zeilen in [`Sources/DespacerCore/`](Sources/DespacerCore), samt Tests.

## Das Befehlszeilentool

Dieselbe Korrektur-Engine gibt es auch als Befehlszeilenfilter, für Skripte oder um Text zu korrigieren, den du schon irgendwo eingesetzt hast:

```sh
swift build -c release
pbpaste | .build/release/despacer | pbcopy
```

Übergib `--explain`, um zu sehen, welche Methode verwendet wurde, oder `--no-transcripts`, um nur die Umbruchregeln zu verwenden.

## Deinstallieren

1. Wähle **Despacer beenden** über das Menüleistensymbol oder im Bereich **System** des Einstellungsfensters.
2. Falls **Bei der Anmeldung öffnen** eingeschaltet war, schalte es vorher aus oder entferne Despacer unter „Systemeinstellungen“ > „Allgemein“ > „Anmeldeobjekte“.
3. Ziehe `/Applications/Despacer.app` in den Papierkorb.
4. Entferne bei Bedarf seine Einstellungen:
   ```sh
   defaults delete com.mattsenter.Despacer
   ```

## Kompilieren und mitwirken

```sh
./build.sh            # builds build/Despacer.app (ad-hoc signed)
./build.sh --install  # also copies it to /Applications and opens it
swift test            # runs the fixing engine's tests
swift Tools/make-icon.swift   # regenerates the app icon in Resources/
python3 scripts/check-localization.py   # checks every language is complete
```

Despacer gibt es auf Englisch, Deutsch, Spanisch, Französisch, Japanisch, Koreanisch, brasilianischem Portugiesisch sowie vereinfachtem und traditionellem Chinesisch. Ein neuer String, den die App anzeigt, gehört in `Localization/en.lproj/Localizable.strings` und in jedes andere `.lproj`, und eine Änderung an dieser README oder an `PRIVACY.md` gehört auch in jede Übersetzung.

| Pfad | Was dort liegt |
|---|---|
| `Sources/DespacerCore/` | Die Korrektur-Engine: die Umbruchregeln (`Despacer.swift`) und die Suche im Sitzungsverlauf (`TranscriptMatcher.swift`) |
| `Tests/DespacerCoreTests/` | Tests, gebaut aus echten zerstückelten Kopien |
| `Sources/despacer/` | Das Befehlszeilentool |
| `App/main.swift` | App-Delegate und Menüs |
| `App/ClipboardWatcher.swift` | Beobachtet die Zwischenablage und wendet Korrekturen an |
| `App/TerminalApps.swift` | Die integrierten Terminals und die, die du hinzufügst |
| `App/SettingsView.swift` | Das SwiftUI-Einstellungsfenster: Seitenleiste und Bereiche |
| `App/OtherProjectsView.swift`, `Resources/other-projects/` | Der Bereich „Weitere Projekte“ und seine Screenshots |
| `App/BuiltByCredit.swift`, `App/OutboundLink.swift` | Der Hinweis auf den Entwickler und das Copyright in der Seitenleiste sowie die markierten ausgehenden Links |
| `App/MenuBarIcon.swift` | Das Menüleistensymbol, im Code gezeichnet |
| `Localization/<lang>.lproj/` | Die Strings der App in jeder Sprache (Englisch ist die Quelle) |
| `README.<lang>.md`, `PRIVACY.<lang>.md` | Übersetzte Dokumentation |
| `scripts/check-localization.py` | Schlägt fehl, wenn einer Sprache ein String oder ein Dokument fehlt |
| `Tools/make-icon.swift` | Rendert das App-Symbol |

Issues und Pull Requests sind willkommen, vor allem zerstückelte Kopien, die die Umbruchregeln falsch behandeln.

## Das Projekt unterstützen

Despacer ist kostenlos und wird es immer bleiben. Wenn es dir einen kleinen täglichen Ärger erspart, kannst du mir über Venmo ein Trinkgeld geben.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>@MattSenter auf Venmo ein Trinkgeld geben</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="Venmo-QR-Code für ein Trinkgeld an Matt Senter">
  </a>
  <br>
  <sub>Mit dem Handy scannen</sub>
</p>

Ein Trinkgeld ist ein Dankeschön. Es schaltet nichts frei, denn es gibt nichts freizuschalten.

## Weitere Projekte

Despacer ist eines von mehreren Produkten, die [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects) von [Senternet](https://www.senter.net/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects) von Anfang bis Ende entwirft, entwickelt und veröffentlicht. Hier ist der Rest der Reihe.

- **[CommandH](https://github.com/MattSenter/commandh)**: Cmd+H, das auch bei der letzten App funktioniert, damit du endlich deinen Schreibtisch siehst.
- **[Weatherling](https://www.weatherling.app/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Regen, Schnee und Herbstlaub auf deinem Mac-Desktop. Wettereffekte, keine Wetter-App.
- **[Burly](https://www.burly.click/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Jeder Link im richtigen Browserprofil.
- **[Comoji](https://www.comoji.io/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: :emoji:-Autovervollständigung wie in Slack, überall auf deinem Mac.
- **[Orgabot](https://www.orga.bot/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Die Arbeit orchestrieren, nicht nur die Agenten.
- **[Premail](https://www.premail.pro/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Dein Posteingang, verteidigt.
- **[Highwire](https://www.highwire.news/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Hinter die Schlagzeilen sehen.
- **[StockCar](https://www.stockcar.app/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Ein Podcast über dein Depot, nicht über den Markt.
- **[Fix Siri](https://www.fixsiri.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Hey Siri, do better. Ein belegtes Archiv der Siri-Pannen und der Versprechen von Apple.
- **[BeeReady](https://www.beeready.buzz/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Lebensrettende Handgriffe, ein Spiel nach dem anderen.
- **[SeedMatrix](https://www.seedmatrix.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Jede Sorte, jeder Versuch, ein klarer Vergleich.

## Lizenz

[MIT](LICENSE). Entwickelt von [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer).
