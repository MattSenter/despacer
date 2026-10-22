<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Icono de la app Despacer">
</p>

<h1 align="center">Despacer</h1>

<p align="center">
  Copia comandos largos de <b>Claude Code</b> y <b>Codex</b> en tu terminal, y pégalos de una sola pieza.
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <b>Español</b> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

Los agentes de programación con IA que se ejecutan en tu terminal, como **Claude Code** y **Codex**, cortan ellos mismos las líneas largas. En lugar de dejar que el terminal ajuste un comando largo, le insertan saltos de línea y sangrías reales. Así que, cuando copias un comando desde iTerm o Terminal y lo pegas, llega roto en trozos y no se ejecuta:

```
  curl --fail --location --retry 3 --connect-timeout 10 --max-time 120
  --output premail-demo.zip
  "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately
  -long-filename-for-testing-terminal-line-wrapping.zip"
```

Despacer es una pequeña app de la barra de menús, gratuita y de código abierto, que soluciona esto. Con ella en marcha, esa misma copia se pega como el único comando que debía ser:

```
curl --fail --location --retry 3 --connect-timeout 10 --max-time 120 --output premail-demo.zip "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately-long-filename-for-testing-terminal-line-wrapping.zip"
```

- Funciona de serie con Terminal, iTerm2, Ghostty, Warp, kitty, Alacritty, WezTerm, Hyper, Tabby y Rio, y con cualquier otra app que añadas
- Solo toca el texto que copias mientras un terminal está en primer plano
- Sin acceso a la red, sin analíticas, sin recopilar datos
- Requiere macOS 14 Sonoma o posterior

## Contenido

- [Instalación](#instalación)
- [Cómo usar Despacer](#cómo-usar-despacer)
- [Ajustes](#ajustes)
- [El menú de la barra de menús](#el-menú-de-la-barra-de-menús)
- [Atajos de teclado](#atajos-de-teclado)
- [Solución de problemas](#solución-de-problemas)
- [Cómo funciona](#cómo-funciona)
- [La herramienta de línea de comandos](#la-herramienta-de-línea-de-comandos)
- [Desinstalación](#desinstalación)
- [Compilación y contribuciones](#compilación-y-contribuciones)
- [Apoya el proyecto](#apoya-el-proyecto)

## Instalación

Por ahora, Despacer se instala compilándolo desde el código fuente. Se tarda más o menos un minuto.

1. Instala las herramientas de línea de comandos de Apple si no las tienes:
   ```sh
   xcode-select --install
   ```
2. Clona este repositorio y compila:
   ```sh
   git clone https://github.com/MattSenter/despacer.git
   cd despacer
   ./build.sh --install
   ```
   Esto compila `Despacer.app`, lo copia a tu carpeta Aplicaciones y lo abre.
3. Aparece la ventana de ajustes. En **Sistema**, activa **Abrir al iniciar sesión** para que Despacer esté siempre listo.

Y ya está. Copia comandos de Claude Code o Codex como siempre y pégalos.

## Cómo usar Despacer

No hay nada nuevo que aprender. Selecciona un comando en tu terminal, pulsa Cmd+C y pégalo donde lo necesites. Para cuando lo pegas, Despacer ya lo ha vuelto a unir, normalmente en unas pocas centésimas de segundo.

- **Lo que copias desde un terminal** se revisa y se corrige si hace falta.
- **Lo que copias desde cualquier otra app** nunca se mira.
- **El texto que nunca estuvo roto**, como un comando corto o la salida normal del terminal, se queda exactamente como estaba.

Si alguna vez una corrección no es lo que querías, elige **Deshacer la última corrección** en el icono de la barra de menús para recuperar tu copia exactamente como la copiaste. La lista **Correcciones recientes** de **Corrección** muestra las diez últimas correcciones, cada una con los botones **Copiar original** y **Copiar corregido**.

## Ajustes

Abre la ventana de ajustes abriendo Despacer desde tu carpeta Aplicaciones (o desde Spotlight o Launchpad), o eligiendo **Ajustes…** en el icono de la barra de menús. La barra lateral tiene siete paneles: **Corrección**, **Terminales**, **Sistema**, **Permisos**, **Privacidad**, **Otros proyectos** (más apps del mismo desarrollador) y **Acerca de** (información de versión y enlaces).

| Ajuste | Panel | Qué hace |
|---|---|---|
| **Corregir copias del terminal** | Corrección | Activa o desactiva Despacer sin salir de él. |
| **Buscar en el historial de sesiones** | Corrección | Busca el original exacto en los archivos de sesión de Claude Code y Codex de tu equipo. Activado por omisión. Debajo del interruptor, Despacer indica si encontró el historial de cada app. |
| **Reparar otro texto cortado** | Corrección | Cuando no hay una coincidencia exacta, vuelve a unir las líneas que claramente se cortaron al ancho del terminal. Activado por omisión. |
| **Reproducir un sonido** | Corrección | Reproduce un sonido breve cuando una copia corregida está lista para pegar. Desactivado por omisión. |
| **Integradas** | Terminales | Los terminales que Despacer conoce, todos activados por omisión. Desmarca los que no quieras que Despacer vigile. |
| **Añadidas por ti** | Terminales | Cualquier otra app de la que copies comandos, como un editor de código con terminal integrado. Haz clic en **Añadir app…** y elígela. |
| **Abrir al iniciar sesión** | Sistema | Inicia Despacer automáticamente al iniciar sesión. Se inicia en silencio, sin abrir esta ventana. |
| **Mostrar en la barra de menús** | Sistema | Muestra o quita el icono de la barra de menús. Si lo desactivas, Despacer funciona de forma invisible. Abre Despacer desde tu carpeta Aplicaciones para volver a esta ventana. |
| **Salir de Despacer** | Sistema | Sale de la app de verdad. Cerrar la ventana (o pulsar Cmd+Q) solo cierra la ventana y deja Despacer en ejecución. |

El panel **Permisos** muestra si macOS deja que Despacer lea lo que copias (consulta [Solución de problemas](#solución-de-problemas)). Los ajustes se guardan automáticamente y se aplican al instante.

## El menú de la barra de menús

Haz clic en el icono de Despacer de tu barra de menús para acceder rápidamente:

- **Corregir copias del terminal**: activa o desactiva Despacer.
- **Reproducir sonido al corregir**: el mismo interruptor que en **Corrección**.
- **Deshacer la última corrección**: devuelve la última copia corregida al portapapeles exactamente como la copiaste.
- **Mostrar en la barra de menús**: desmárcalo para quitar el icono. También puedes mantener pulsada la tecla Cmd y arrastrar el icono fuera de la barra de menús.
- **Abrir al iniciar sesión**: inicia Despacer al iniciar sesión.
- **Ajustes…**: abre la ventana de ajustes.
- **Salir de Despacer**: sale de la app.

## Atajos de teclado

Mientras la ventana Ajustes de Despacer está en primer plano:

| Atajo | Qué hace |
|---|---|
| Cmd+W | Cierra la ventana de ajustes. Despacer sigue en ejecución. |
| Cmd+Q | También cierra la ventana y deja Despacer en ejecución, para que un Cmd+Q accidental nunca lo apague. Usa **Salir de Despacer** para salir de verdad. |
| Cmd+H | Oculta Despacer como cualquier otra app. |
| Cmd+, | Abre los ajustes. |

## Solución de problemas

**Lo que copio se sigue pegando roto.**
Comprueba que Despacer está en ejecución (ábrelo desde tu carpeta Aplicaciones) y que **Corregir copias del terminal** está activado. Comprueba que tu terminal está marcado en **Terminales**, o añádelo con **Añadir app…**. Después revisa el panel **Permisos**.

**macOS me ha preguntado si Despacer puede pegar desde otras apps.**
Las versiones más recientes de macOS te permiten decidir qué apps pueden leer lo que copias. Elige **Permitir**. Si elegiste **No permitir**, abre Ajustes del Sistema > Privacidad y seguridad > Pegar desde otras apps y cambia Despacer a Permitir. El panel **Permisos** muestra el ajuste actual y tiene un botón que te lleva allí.

**Una copia salió unida cuando no debía.**
Elige **Deshacer la última corrección** en el icono de la barra de menús. La coincidencia exacta con el historial de sesiones nunca se equivoca con los saltos de línea, pero las reglas de corte tienen que adivinar cuando no hay coincidencia. Si te sigue pasando, desactiva **Reparar otro texto cortado** y deja que Despacer corrija solo lo que encuentre en el historial de sesiones. Por favor, [abre una incidencia](https://github.com/MattSenter/despacer/issues) con el texto que copiaste para que las reglas puedan mejorar.

**Despacer cambió algo que copié de la salida normal del terminal.**
Despacer solo repara el texto con la sangría de 2 espacios que imprimen Claude Code y Codex, o el texto que encuentra palabra por palabra en su historial de sesiones. Si copiaste otra cosa y cambió, por favor [abre una incidencia](https://github.com/MattSenter/despacer/issues).

**Desactivé el icono de la barra de menús y no encuentro Despacer.**
Abre Despacer desde tu carpeta Aplicaciones. Aparece la ventana de ajustes y puedes volver a activar el icono en **Sistema**.

**Abrir al iniciar sesión no se queda activado.**
macOS solo permite abrir al iniciar sesión las apps que están en una ubicación estable. Comprueba que Despacer está en tu carpeta Aplicaciones (`./build.sh --install` lo deja ahí) y vuelve a activar el ajuste.

## Cómo funciona

Claude Code y Codex dibujan ellos mismos su salida, y los dos cortan las líneas largas para que quepan en el terminal antes de imprimirlas: un salto de línea real y luego 2 espacios de sangría. El terminal solo ve líneas separadas, así que eso es lo que copia. No hay ningún ajuste del terminal que pueda deshacerlo, porque los finales de línea originales nunca llegan al terminal.

Despacer comprueba el portapapeles 20 veces por segundo (macOS no avisa de los cambios en el portapapeles, y la comprobación no cuesta casi nada). Cuando la copia viene de una app de terminal, la corrige en dos pasos:

1. **Reglas de corte, al instante.** Quita la sangría de 2 espacios y el relleno al final de las líneas, y vuelve a unir cada salto de línea causado por el corte. Un salto cuenta como corte cuando la siguiente palabra no habría cabido en la línea anterior. Una línea que ocupa todo el ancho se partió en medio de una palabra, pero solo cuando la palabra es demasiado larga para una línea, así que se une sin espacio. Cualquier otro salto de línea, y cualquier línea que termine en `\`, se mantiene. Esta versión va al portapapeles enseguida, así que está lista antes de que puedas cambiar de ventana.
2. **Coincidencia exacta, un momento después.** En segundo plano, busca el texto copiado, sin tener en cuenta espacios ni saltos de línea, en los archivos de sesión que Claude Code (`~/.claude/projects`) y Codex (`~/.codex/sessions`) guardan en tu equipo. Revisa las sesiones activas en el último día, de la más reciente a la más antigua. Si encuentra una coincidencia, pone en el portapapeles el texto original, exactamente como lo escribió el agente, salvo que hayas copiado otra cosa entretanto.

Las reglas de corte por sí solas aciertan con la mayoría de los comandos, pero algunos saltos son imposibles de distinguir, por ejemplo una selección que empieza en medio de una línea. La coincidencia exacta resuelve esos casos. Funciona sin importar dónde empiece o termine tu selección.

La app ocupa menos de 1.400 líneas de Swift en [`App/`](App), y el motor de corrección unas 250 líneas en [`Sources/DespacerCore/`](Sources/DespacerCore), con pruebas.

## La herramienta de línea de comandos

El mismo motor de corrección también es un filtro de línea de comandos, para scripts o para corregir texto que ya has pegado en algún sitio:

```sh
swift build -c release
pbpaste | .build/release/despacer | pbcopy
```

Pasa `--explain` para ver qué método usó, o `--no-transcripts` para usar solo las reglas de corte.

## Desinstalación

1. Elige **Salir de Despacer** en el icono de la barra de menús o en el panel **Sistema** de la ventana de ajustes.
2. Si **Abrir al iniciar sesión** estaba activado, desactívalo antes o quita Despacer en Ajustes del Sistema > General > Ítems de inicio.
3. Arrastra `/Applications/Despacer.app` a la Papelera.
4. Si quieres, borra también sus ajustes:
   ```sh
   defaults delete com.mattsenter.Despacer
   ```

## Compilación y contribuciones

```sh
./build.sh            # builds build/Despacer.app (ad-hoc signed)
./build.sh --install  # also copies it to /Applications and opens it
swift test            # runs the fixing engine's tests
swift Tools/make-icon.swift   # regenerates the app icon in Resources/
python3 scripts/check-localization.py   # checks every language is complete
```

Despacer está disponible en inglés, alemán, español, francés, japonés, coreano, portugués de Brasil, y chino simplificado y tradicional. Cada texto nuevo que muestre la app va en `Localization/en.lproj/Localizable.strings` y en todos los demás `.lproj`, y cualquier cambio en este README o en `PRIVACY.md` también va en cada traducción.

| Ruta | Qué contiene |
|---|---|
| `Sources/DespacerCore/` | El motor de corrección: las reglas de corte (`Despacer.swift`) y la búsqueda en el historial de sesiones (`TranscriptMatcher.swift`) |
| `Tests/DespacerCoreTests/` | Pruebas, creadas a partir de copias rotas reales |
| `Sources/despacer/` | La herramienta de línea de comandos |
| `App/main.swift` | Delegado de la app y menús |
| `App/ClipboardWatcher.swift` | Vigila el portapapeles y aplica las correcciones |
| `App/TerminalApps.swift` | Los terminales integrados y los que añades |
| `App/SettingsView.swift` | La ventana de ajustes en SwiftUI: barra lateral y paneles |
| `App/OtherProjectsView.swift`, `Resources/other-projects/` | El panel Otros proyectos y sus capturas de pantalla |
| `App/BuiltByCredit.swift`, `App/OutboundLink.swift` | El crédito y el copyright de la barra lateral, y los enlaces externos etiquetados |
| `App/MenuBarIcon.swift` | El icono de la barra de menús, dibujado en código |
| `Localization/<lang>.lproj/` | Los textos de la app en cada idioma (el inglés es el original) |
| `README.<lang>.md`, `PRIVACY.<lang>.md` | Documentación traducida |
| `scripts/check-localization.py` | Falla si a algún idioma le falta un texto o un documento |
| `Tools/make-icon.swift` | Genera el icono de la app |

Las incidencias y las pull requests son bienvenidas, sobre todo las copias rotas que las reglas de corte no arreglan bien.

## Apoya el proyecto

Despacer es gratis y siempre lo será. Si te ahorra una pequeña molestia diaria, puedes dejarme una propina en Venmo.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>Deja una propina a @MattSenter en Venmo</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="Código QR de Venmo para dejar una propina a Matt Senter">
  </a>
  <br>
  <sub>Escanéalo con tu teléfono</sub>
</p>

Una propina es un agradecimiento. No desbloquea nada, porque no hay nada que desbloquear.

## Licencia

[MIT](LICENSE). Creado por [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer).
