#!/bin/zsh
# Builds build/Despacer.app (ad-hoc signed). Pass --install to copy it to
# /Applications and open it. The despacer command line tool and the tests are
# the Swift package: `swift build`, `swift test`.
set -euo pipefail
cd "${0:A:h}"

VERSION="1.0"
BUILD="1"

APP=build/Despacer.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp Info.plist "$APP/Contents/Info.plist"
plutil -replace CFBundleShortVersionString -string "$VERSION" "$APP/Contents/Info.plist"
plutil -replace CFBundleVersion -string "$BUILD" "$APP/Contents/Info.plist"
# The icon: an asset catalog compiled from the Icon Composer .icon (macOS 26 and
# later draw it edge to edge), plus the AppIcon.icns actool renders for older systems.
xcrun actool Resources/AppIcon.icon --compile "$APP/Contents/Resources" --platform macosx \
  --minimum-deployment-target 14.0 --app-icon AppIcon \
  --output-partial-info-plist build/icon-info.plist >/dev/null
plutil -replace CFBundleIconName -string AppIcon "$APP/Contents/Info.plist"
cp Resources/MenuBarIcon.png Resources/MenuBarIcon@2x.png "$APP/Contents/Resources/"
cp Resources/MenuBarIcon*.png "$APP/Contents/Resources/"
cp -R Resources/other-projects "$APP/Contents/Resources/other-projects"
# Translations: every Localization/<lang>.lproj, as-is. Info.plist's
# CFBundleLocalizations lists the same languages.
cp -R Localization/*.lproj "$APP/Contents/Resources/"
# One module: the app and the fixing engine it shares with the command line tool.
swiftc -O -swift-version 5 -target "$(uname -m)-apple-macos14.0" -module-name Despacer \
  -o "$APP/Contents/MacOS/Despacer" App/*.swift Sources/DespacerCore/*.swift
codesign --force --sign - "$APP"
echo "Built $APP"

if [[ "${1:-}" == "--install" ]]; then
  pkill -x Despacer || true
  rm -rf /Applications/Despacer.app
  cp -R "$APP" /Applications/
  open /Applications/Despacer.app
  echo "Installed and launched /Applications/Despacer.app"
fi
