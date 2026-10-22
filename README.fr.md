<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Icône de l’app Despacer">
</p>

<h1 align="center">Despacer</h1>

<p align="center">
  Copiez les longues commandes de <b>Claude Code</b> et <b>Codex</b> dans votre terminal, et collez-les d’un seul tenant.
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <b>Français</b> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

Les agents de code IA qui tournent dans votre terminal, comme **Claude Code** et **Codex**, coupent eux-mêmes les longues lignes. Au lieu de laisser le terminal faire passer une longue commande à la ligne, ils y insèrent de vrais sauts de ligne et des retraits. Résultat : quand vous copiez une commande depuis iTerm ou Terminal et que vous la collez, elle arrive en morceaux et ne s’exécute pas :

```
  curl --fail --location --retry 3 --connect-timeout 10 --max-time 120
  --output premail-demo.zip
  "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately
  -long-filename-for-testing-terminal-line-wrapping.zip"
```

Despacer est une toute petite app gratuite et open source, logée dans la barre des menus, qui corrige ce problème. Tant qu’elle est ouverte, la même copie se colle sous la forme de la commande unique qu’elle aurait dû être :

```
curl --fail --location --retry 3 --connect-timeout 10 --max-time 120 --output premail-demo.zip "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately-long-filename-for-testing-terminal-line-wrapping.zip"
```

- Fonctionne d’emblée avec Terminal, iTerm2, Ghostty, Warp, kitty, Alacritty, WezTerm, Hyper, Tabby et Rio, ainsi qu’avec toute autre app que vous ajoutez
- Ne touche qu’au texte que vous copiez pendant qu’un terminal est au premier plan
- Aucun accès réseau, aucune statistique d’utilisation, aucune donnée collectée
- Nécessite macOS 14 Sonoma ou version ultérieure

## Sommaire

- [Installation](#installation)
- [Utiliser Despacer](#utiliser-despacer)
- [Réglages](#réglages)
- [Le menu de la barre des menus](#le-menu-de-la-barre-des-menus)
- [Raccourcis clavier](#raccourcis-clavier)
- [Dépannage](#dépannage)
- [Fonctionnement](#fonctionnement)
- [Outil en ligne de commande](#outil-en-ligne-de-commande)
- [Désinstallation](#désinstallation)
- [Compilation et contribution](#compilation-et-contribution)
- [Soutenir le projet](#soutenir-le-projet)
- [Autres projets](#autres-projets)

## Installation

Pour l’instant, Despacer s’installe en le compilant à partir du code source. Cela prend environ une minute.

1. Installez les outils en ligne de commande d’Apple si vous ne les avez pas déjà :
   ```sh
   xcode-select --install
   ```
2. Clonez ce dépôt et compilez :
   ```sh
   git clone https://github.com/MattSenter/despacer.git
   cd despacer
   ./build.sh --install
   ```
   Cette commande compile `Despacer.app`, la copie dans votre dossier Applications et l’ouvre.
3. La fenêtre Réglages apparaît. Dans **Système**, activez **Ouvrir avec la session** pour que Despacer soit toujours prêt.

C’est tout. Copiez vos commandes depuis Claude Code ou Codex comme d’habitude, puis collez-les.

## Utiliser Despacer

Rien de nouveau à apprendre. Sélectionnez une commande dans votre terminal, appuyez sur Cmd+C et collez-la là où elle doit aller. Au moment où vous collez, Despacer l’a déjà reconstituée, généralement en quelques centièmes de seconde.

- **Les copies faites depuis un terminal** sont vérifiées et corrigées si nécessaire.
- **Les copies faites depuis toute autre app** ne sont jamais examinées.
- **Le texte qui n’a jamais été coupé**, comme une commande courte ou une sortie de terminal ordinaire, reste exactement tel quel.

Si une correction ne vous convient pas, choisissez **Annuler la dernière correction** dans l’icône de la barre des menus pour retrouver votre copie exactement telle que vous l’avez faite. La liste **Corrections récentes**, dans **Correction**, affiche les dix dernières corrections, chacune avec les boutons **Copier l’original** et **Copier la version corrigée**.

## Réglages

Pour ouvrir la fenêtre Réglages, ouvrez Despacer depuis votre dossier Applications (ou depuis Spotlight ou Launchpad), ou choisissez **Réglages…** dans l’icône de la barre des menus. La barre latérale contient sept sections : **Correction**, **Terminaux**, **Système**, **Autorisations**, **Confidentialité**, **Autres projets** (d’autres apps du même développeur) et **À propos** (infos de version et liens).

| Réglage | Section | Rôle |
|---|---|---|
| **Corriger les copies du terminal** | Correction | Active ou désactive Despacer sans le quitter. |
| **Comparer à l’historique des sessions** | Correction | Recherche l’original exact dans les fichiers de session de Claude Code et Codex sur votre ordinateur. Activé par défaut. Sous l’interrupteur, Despacer indique s’il a trouvé l’historique de chaque app. |
| **Réparer les autres textes coupés** | Correction | En l’absence de correspondance exacte, recolle les lignes clairement coupées à la largeur du terminal. Activé par défaut. |
| **Émettre un son** | Correction | Émet un son bref quand une copie corrigée est prête à être collée. Désactivé par défaut. |
| **Intégrées** | Terminaux | Les terminaux que Despacer connaît, tous activés par défaut. Décochez ceux que Despacer ne doit pas surveiller. |
| **Ajoutées par vous** | Terminaux | Toute autre app depuis laquelle vous copiez des commandes, comme un éditeur de code avec un terminal intégré. Cliquez sur **Ajouter une app…** et choisissez-la. |
| **Ouvrir avec la session** | Système | Lance Despacer automatiquement à l’ouverture de votre session. Il démarre discrètement, sans ouvrir cette fenêtre. |
| **Afficher dans la barre des menus** | Système | Affiche ou retire l’icône de la barre des menus. Une fois désactivé, Despacer fonctionne de façon invisible. Ouvrez Despacer depuis votre dossier Applications pour revenir à cette fenêtre. |
| **Quitter Despacer** | Système | Quitte vraiment l’app. Fermer la fenêtre (ou appuyer sur Cmd+Q) ferme seulement la fenêtre et laisse Despacer ouvert. |

La section **Autorisations** indique si macOS permet à Despacer de lire vos copies (voir [Dépannage](#dépannage)). Les réglages sont enregistrés automatiquement et s’appliquent immédiatement.

## Le menu de la barre des menus

Cliquez sur l’icône de Despacer dans votre barre des menus pour un accès rapide :

- **Corriger les copies du terminal** : active ou désactive Despacer.
- **Émettre un son après correction** : le même interrupteur que dans **Correction**.
- **Annuler la dernière correction** : remet la dernière copie corrigée dans le presse-papiers, exactement telle que vous l’avez copiée.
- **Afficher dans la barre des menus** : décochez pour retirer l’icône. Vous pouvez aussi maintenir Cmd et faire glisser l’icône hors de la barre des menus.
- **Ouvrir avec la session** : lance Despacer à l’ouverture de votre session.
- **Réglages…** : ouvre la fenêtre Réglages.
- **Quitter Despacer** : quitte l’app.

## Raccourcis clavier

Quand la fenêtre Réglages de Despacer est au premier plan :

| Raccourci | Rôle |
|---|---|
| Cmd+W | Ferme la fenêtre Réglages. Despacer reste ouvert. |
| Cmd+Q | Ferme aussi la fenêtre et laisse Despacer ouvert, pour qu’un Cmd+Q accidentel ne le désactive jamais. Utilisez **Quitter Despacer** pour le quitter vraiment. |
| Cmd+H | Masque Despacer comme n’importe quelle autre app. |
| Cmd+, | Ouvre les Réglages. |

## Dépannage

**Ma copie arrive toujours en morceaux quand je la colle.**
Vérifiez que Despacer est ouvert (ouvrez-le depuis votre dossier Applications) et que **Corriger les copies du terminal** est activé. Vérifiez que votre terminal est coché dans **Terminaux**, ou ajoutez-le avec **Ajouter une app…**. Consultez ensuite la section **Autorisations**.

**macOS m’a demandé si Despacer peut coller depuis d’autres apps.**
Les versions récentes de macOS vous laissent choisir quelles apps peuvent lire ce que vous copiez. Choisissez **Autoriser**. Si vous avez choisi **Ne pas autoriser**, ouvrez Réglages Système > Confidentialité et sécurité > Coller depuis d’autres apps et réglez Despacer sur Autoriser. La section **Autorisations** affiche le réglage actuel et propose un bouton qui vous y mène.

**Une copie a été recollée alors qu’elle n’aurait pas dû l’être.**
Choisissez **Annuler la dernière correction** dans l’icône de la barre des menus. La correspondance exacte trouvée dans l’historique des sessions ne se trompe jamais sur les sauts de ligne, mais les règles de retour à la ligne doivent deviner quand il n’y a pas de correspondance. Si cela se reproduit, désactivez **Réparer les autres textes coupés** pour que Despacer ne corrige que ce qu’il trouve dans l’historique des sessions. Merci d’[ouvrir un ticket](https://github.com/MattSenter/despacer/issues) avec le texte que vous avez copié, pour que les règles puissent s’améliorer.

**Despacer a modifié un texte copié depuis une sortie de terminal ordinaire.**
Despacer ne répare que le texte portant le retrait de 2 espaces qu’affichent Claude Code et Codex, ou le texte qu’il retrouve mot pour mot dans leur historique de sessions. Si vous avez copié autre chose et que le texte a changé, merci d’[ouvrir un ticket](https://github.com/MattSenter/despacer/issues).

**J’ai désactivé l’icône de la barre des menus et je ne trouve plus Despacer.**
Ouvrez Despacer depuis votre dossier Applications. La fenêtre Réglages apparaît, et vous pouvez réactiver l’icône dans **Système**.

**Ouvrir avec la session ne reste pas activé.**
macOS n’autorise l’ouverture avec la session que pour les apps situées à un emplacement stable. Vérifiez que Despacer se trouve dans votre dossier Applications (`./build.sh --install` l’y place), puis réactivez le réglage.

## Fonctionnement

Claude Code et Codex dessinent tous deux eux-mêmes leur affichage, et tous deux coupent les longues lignes à la largeur du terminal avant de les afficher : un vrai saut de ligne, puis un retrait de 2 espaces. Le terminal ne voit jamais que des lignes séparées, et c’est donc ce qu’il copie. Aucun réglage du terminal ne peut l’annuler, car les fins de ligne d’origine n’atteignent jamais le terminal.

Despacer vérifie le presse-papiers 20 fois par seconde (macOS ne signale pas les changements du presse-papiers, et la vérification ne coûte presque rien). Quand la copie provient d’une app de terminal, il la corrige en deux étapes :

1. **Règles de retour à la ligne, immédiatement.** Il supprime le retrait de 2 espaces et le remplissage en fin de ligne, puis recolle chaque saut de ligne causé par le retour à la ligne. Un saut compte comme un retour à la ligne quand le mot suivant n’aurait pas tenu sur la ligne du dessus. Une ligne qui occupe toute la largeur a été coupée au milieu d’un mot, mais seulement quand le mot est trop long pour une ligne : elle est donc recollée sans espace. Tous les autres sauts de ligne, et toute ligne se terminant par `\`, sont conservés. Cette version est placée aussitôt dans le presse-papiers, elle est donc prête avant que vous ayez pu changer de fenêtre.
2. **Correspondance exacte, un instant plus tard.** En arrière-plan, il recherche le texte copié, sans tenir compte des espaces ni des sauts de ligne, dans les fichiers de session que Claude Code (`~/.claude/projects`) et Codex (`~/.codex/sessions`) conservent sur votre ordinateur. Il examine les sessions actives au cours de la dernière journée, les plus récentes d’abord. En cas de correspondance, il place dans le presse-papiers le texte d’origine, exactement tel que l’agent l’a écrit, sauf si vous avez copié autre chose entre-temps.

Les règles de retour à la ligne suffisent pour la plupart des commandes, mais certains sauts sont impossibles à distinguer, par exemple quand une sélection commence au milieu d’une ligne. La correspondance exacte tranche ces cas. Elle fonctionne quel que soit l’endroit où votre sélection commence ou se termine.

L’app tient en moins de 1 400 lignes de Swift dans [`App/`](App), et le moteur de correction en environ 250 lignes dans [`Sources/DespacerCore/`](Sources/DespacerCore), avec des tests.

## Outil en ligne de commande

Le même moteur de correction existe aussi sous forme de filtre en ligne de commande, pour les scripts ou pour corriger un texte que vous avez déjà collé quelque part :

```sh
swift build -c release
pbpaste | .build/release/despacer | pbcopy
```

Passez `--explain` pour voir quelle méthode a été utilisée, ou `--no-transcripts` pour n’utiliser que les règles de retour à la ligne.

## Désinstallation

1. Choisissez **Quitter Despacer** dans l’icône de la barre des menus ou dans la section **Système** de la fenêtre Réglages.
2. Si **Ouvrir avec la session** était activé, désactivez-le d’abord, ou retirez Despacer dans Réglages Système > Général > Ouverture.
3. Faites glisser `/Applications/Despacer.app` dans la Corbeille.
4. Si vous le souhaitez, supprimez ses réglages :
   ```sh
   defaults delete com.mattsenter.Despacer
   ```

## Compilation et contribution

```sh
./build.sh            # builds build/Despacer.app (ad-hoc signed)
./build.sh --install  # also copies it to /Applications and opens it
swift test            # runs the fixing engine's tests
swift Tools/make-icon.swift   # regenerates the app icon in Resources/
python3 scripts/check-localization.py   # checks every language is complete
```

Despacer est disponible en anglais, allemand, espagnol, français, japonais, coréen, portugais du Brésil, et chinois simplifié et traditionnel. Toute nouvelle chaîne affichée par l’app va dans `Localization/en.lproj/Localizable.strings` et dans chaque autre `.lproj`, et toute modification de ce README ou de `PRIVACY.md` doit aussi être reportée dans chaque traduction.

| Chemin | Contenu |
|---|---|
| `Sources/DespacerCore/` | Le moteur de correction : les règles de retour à la ligne (`Despacer.swift`) et la recherche dans l’historique des sessions (`TranscriptMatcher.swift`) |
| `Tests/DespacerCoreTests/` | Les tests, construits à partir de vraies copies coupées |
| `Sources/despacer/` | L’outil en ligne de commande |
| `App/main.swift` | Le délégué de l’app et les menus |
| `App/ClipboardWatcher.swift` | Surveille le presse-papiers et applique les corrections |
| `App/TerminalApps.swift` | Les terminaux intégrés et ceux que vous ajoutez |
| `App/SettingsView.swift` | La fenêtre Réglages en SwiftUI : barre latérale et sections |
| `App/OtherProjectsView.swift`, `Resources/other-projects/` | La section Autres projets et ses captures d’écran |
| `App/BuiltByCredit.swift`, `App/OutboundLink.swift` | La mention du créateur et le copyright de la barre latérale, et les liens sortants balisés |
| `App/MenuBarIcon.swift` | L’icône de la barre des menus, dessinée en code |
| `Localization/<lang>.lproj/` | Les chaînes de l’app dans chaque langue (l’anglais est la source) |
| `README.<lang>.md`, `PRIVACY.<lang>.md` | La documentation traduite |
| `scripts/check-localization.py` | Échoue s’il manque une chaîne ou un document dans une langue |
| `Tools/make-icon.swift` | Génère l’icône de l’app |

Les tickets et les pull requests sont les bienvenus, surtout les copies coupées que les règles de retour à la ligne corrigent mal.

## Soutenir le projet

Despacer est gratuit et le restera. S’il vous épargne une petite contrariété quotidienne, vous pouvez me laisser un pourboire sur Venmo.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>Laisser un pourboire à @MattSenter sur Venmo</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="Code QR Venmo pour laisser un pourboire à Matt Senter">
  </a>
  <br>
  <sub>Scannez-le avec votre téléphone</sub>
</p>

Un pourboire est un simple merci. Il ne débloque rien, car il n’y a rien à débloquer.

## Autres projets

Despacer fait partie des produits que [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects), de [Senternet](https://www.senter.net/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects), conçoit, développe et publie de bout en bout. Voici le reste de la gamme.

- **[CommandH](https://github.com/MattSenter/commandh)** : Un Cmd+H qui fonctionne aussi sur la dernière app, pour enfin voir votre bureau.
- **[Weatherling](https://www.weatherling.app/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Pluie, neige et feuilles d’automne sur le bureau de votre Mac. Des effets météo, pas une app météo.
- **[Burly](https://www.burly.click/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Chaque lien, dans le bon profil de navigateur.
- **[Comoji](https://www.comoji.io/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Autocomplétion d’:emoji: façon Slack, partout sur votre Mac.
- **[Orgabot](https://www.orga.bot/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Orchestrer le travail, pas seulement les agents.
- **[Premail](https://www.premail.pro/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Votre boîte de réception, défendue.
- **[Highwire](https://www.highwire.news/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Voir au-delà des titres.
- **[StockCar](https://www.stockcar.app/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Un podcast de votre portefeuille, pas du marché.
- **[Fix Siri](https://www.fixsiri.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Hey Siri, do better. Un registre sourcé des ratés de Siri et des promesses d’Apple.
- **[BeeReady](https://www.beeready.buzz/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Des gestes qui sauvent, un match à la fois.
- **[SeedMatrix](https://www.seedmatrix.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)** : Chaque variété, chaque essai, une comparaison claire.

## Licence

[MIT](LICENSE). Créé par [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer).
