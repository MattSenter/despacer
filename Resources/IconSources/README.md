# Despacer icon artwork

Approved magic paste brush concept, generated with the built-in imagegen tool.

- `AppIcon.png`: transparent master for the navy, mint clipboard-and-brush app icon.
- `TrayIcon.png`: transparent monochrome magic brush and sparkle master (no clipboard).

Run `swift Tools/make-icon.swift` from the project root to package the ICNS,
1024px app PNG, documentation image, and 18px/36px tray representations.
The app marks the tray image as a template so macOS supplies its tint.

Final extraction prompts used the approved concept board as their reference:

- App: isolate the approved colored app icon, preserve its composition, colors,
  lighting and proportions, remove board and labels, and use a transparent
  square canvas with approximately ten percent margin.
- Tray: remove only the clipboard from the original tray artwork. Preserve the
  original broad, flat paintbrush, handle hole, ferrule separators and sparkle;
  solid black on transparency. Edited using the built-in imagegen tool.
