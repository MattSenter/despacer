<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Ícone do app Despacer">
</p>

<h1 align="center">Despacer</h1>

<p align="center">
  Copie comandos longos do <b>Claude Code</b> e do <b>Codex</b> no seu terminal, e cole-os inteiros, de uma vez só.
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <b>Português (Brasil)</b> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

Os agentes de programação com IA que rodam no seu terminal, como o **Claude Code** e o **Codex**, quebram as linhas longas por conta própria. Em vez de deixar o terminal quebrar um comando longo, eles inserem nele quebras de linha e recuos de verdade. Então, quando você copia um comando do iTerm ou do Terminal e cola, ele chega em pedaços e não roda:

```
  curl --fail --location --retry 3 --connect-timeout 10 --max-time 120
  --output premail-demo.zip
  "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately
  -long-filename-for-testing-terminal-line-wrapping.zip"
```

O Despacer é um app de barra de menus pequeno, gratuito e de código aberto que resolve isso. Com ele em execução, a mesma cópia é colada como o comando único que deveria ser:

```
curl --fail --location --retry 3 --connect-timeout 10 --max-time 120 --output premail-demo.zip "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately-long-filename-for-testing-terminal-line-wrapping.zip"
```

- Funciona de fábrica com Terminal, iTerm2, Ghostty, Warp, kitty, Alacritty, WezTerm, Hyper, Tabby e Rio, e com qualquer outro app que você adicionar
- Só mexe no texto que você copia enquanto um terminal está na frente
- Sem acesso à rede, sem análises, sem coleta de dados
- Requer macOS 14 Sonoma ou posterior

## Conteúdo

- [Instalação](#instalação)
- [Como usar o Despacer](#como-usar-o-despacer)
- [Ajustes](#ajustes)
- [O menu da barra de menus](#o-menu-da-barra-de-menus)
- [Atalhos de teclado](#atalhos-de-teclado)
- [Solução de problemas](#solução-de-problemas)
- [Como funciona](#como-funciona)
- [A ferramenta de linha de comando](#a-ferramenta-de-linha-de-comando)
- [Desinstalação](#desinstalação)
- [Compilação e contribuições](#compilação-e-contribuições)
- [Apoie o projeto](#apoie-o-projeto)
- [Outros projetos](#outros-projetos)

## Instalação

Por enquanto, o Despacer é instalado compilando o código-fonte. Leva cerca de um minuto.

1. Instale as ferramentas de linha de comando da Apple, se ainda não as tiver:
   ```sh
   xcode-select --install
   ```
2. Clone este repositório e compile:
   ```sh
   git clone https://github.com/MattSenter/despacer.git
   cd despacer
   ./build.sh --install
   ```
   Isso compila o `Despacer.app`, copia o app para a sua pasta Aplicativos e o abre.
3. A janela Ajustes aparece. Em **Sistema**, ative **Abrir ao iniciar sessão** para que o Despacer esteja sempre pronto.

Pronto. Copie comandos do Claude Code ou do Codex como você sempre faz, e cole.

## Como usar o Despacer

Não há nada novo para aprender. Selecione um comando no seu terminal, pressione Cmd+C e cole onde precisar. Quando você cola, o Despacer já juntou tudo de novo, normalmente em poucos centésimos de segundo.

- **Cópias de um terminal** são verificadas e corrigidas, se for preciso.
- **Cópias de qualquer outro app** nunca são examinadas.
- **Texto que nunca foi quebrado**, como um comando curto ou a saída comum do terminal, fica exatamente como estava.

Se alguma correção não sair como você queria, escolha **Desfazer Última Correção** no ícone da barra de menus para devolver a sua cópia exatamente como você copiou. A lista **Correções recentes**, em **Correção**, mostra as dez últimas correções, cada uma com os botões **Copiar original** e **Copiar corrigido**.

## Ajustes

Abra a janela Ajustes abrindo o Despacer pela pasta Aplicativos (ou pelo Spotlight, ou pelo Launchpad), ou escolhendo **Ajustes…** no ícone da barra de menus. A barra lateral tem sete painéis: **Correção**, **Terminais**, **Sistema**, **Permissões**, **Privacidade**, **Outros projetos** (mais apps do mesmo desenvolvedor) e **Sobre** (informações da versão e links).

| Ajuste | Painel | O que faz |
|---|---|---|
| **Corrigir cópias do terminal** | Correção | Liga ou desliga o Despacer sem encerrá-lo. |
| **Buscar no histórico de sessões** | Correção | Procura o original exato nos arquivos de sessão do Claude Code e do Codex no seu computador. Ativado por padrão. Abaixo da chave, o Despacer mostra se encontrou o histórico de cada app. |
| **Reparar outros textos quebrados** | Correção | Quando não há correspondência exata, junta de novo as linhas que foram claramente quebradas na largura do terminal. Ativado por padrão. |
| **Tocar um som** | Correção | Toca um som curto quando uma cópia corrigida está pronta para colar. Desativado por padrão. |
| **Integrados** | Terminais | Os terminais que o Despacer conhece, todos ativados por padrão. Desmarque os que você não quer que o Despacer observe. |
| **Adicionados por você** | Terminais | Qualquer outro app de onde você copia comandos, como um editor de código com terminal integrado. Clique em **Adicionar App…** e escolha o app. |
| **Abrir ao iniciar sessão** | Sistema | Abre o Despacer automaticamente quando você inicia sessão. Ele abre discretamente, sem mostrar esta janela. |
| **Mostrar na barra de menus** | Sistema | Mostra ou remove o ícone da barra de menus. Desativado, o Despacer funciona de forma invisível. Abra o Despacer pela pasta Aplicativos para voltar a esta janela. |
| **Encerrar Despacer** | Sistema | Encerra o app de verdade. Fechar a janela (ou pressionar Cmd+Q) só fecha a janela e mantém o Despacer em execução. |

O painel **Permissões** mostra se o macOS deixa o Despacer ler o que você copia (veja [Solução de problemas](#solução-de-problemas)). Os ajustes são salvos automaticamente e entram em vigor na hora.

## O menu da barra de menus

Clique no ícone do Despacer na sua barra de menus para acesso rápido:

- **Corrigir Cópias do Terminal**: liga ou desliga o Despacer.
- **Tocar Som ao Corrigir**: a mesma chave que em **Correção**.
- **Desfazer Última Correção**: devolve a última cópia corrigida à área de transferência exatamente como você copiou.
- **Mostrar na Barra de Menus**: desmarque para remover o ícone. Você também pode manter Cmd pressionado e arrastar o ícone para fora da barra de menus.
- **Abrir ao Iniciar Sessão**: abre o Despacer quando você inicia sessão.
- **Ajustes…**: abre a janela Ajustes.
- **Encerrar Despacer**: encerra o app.

## Atalhos de teclado

Enquanto a janela Ajustes do Despacer estiver na frente:

| Atalho | O que faz |
|---|---|
| Cmd+W | Fecha a janela Ajustes. O Despacer continua em execução. |
| Cmd+Q | Também fecha a janela e mantém o Despacer em execução, para que um Cmd+Q acidental nunca o desligue. Use **Encerrar Despacer** para encerrar de verdade. |
| Cmd+H | Oculta o Despacer como qualquer outro app. |
| Cmd+, | Abre os Ajustes. |

## Solução de problemas

**O que eu copio continua sendo colado quebrado.**
Verifique se o Despacer está em execução (abra-o pela pasta Aplicativos) e se **Corrigir cópias do terminal** está ativado. Confira se o seu terminal está marcado em **Terminais**, ou adicione-o com **Adicionar App…**. Depois, veja o painel **Permissões**.

**O macOS perguntou se o Despacer pode colar de outros apps.**
As versões mais recentes do macOS deixam você decidir quais apps podem ler o que você copia. Escolha **Permitir**. Se você escolheu **Não Permitir**, abra Ajustes do Sistema > Privacidade e Segurança > Colar de Outros Apps e mude o Despacer para Permitir. O painel **Permissões** mostra o ajuste atual e tem um botão que leva você até lá.

**Uma cópia saiu juntada quando não deveria.**
Escolha **Desfazer Última Correção** no ícone da barra de menus. A correspondência exata com o histórico de sessões nunca erra nas quebras de linha, mas as regras de quebra precisam adivinhar quando não há correspondência. Se isso continuar acontecendo, desative **Reparar outros textos quebrados** e deixe o Despacer corrigir só o que ele encontra no histórico de sessões. Por favor, [abra uma issue](https://github.com/MattSenter/despacer/issues) com o texto que você copiou, para que as regras possam melhorar.

**O Despacer mudou algo que copiei da saída comum do terminal.**
O Despacer só repara texto com o recuo de 2 espaços que o Claude Code e o Codex imprimem, ou texto que ele encontra palavra por palavra no histórico de sessões deles. Se você copiou outra coisa e ela mudou, por favor [abra uma issue](https://github.com/MattSenter/despacer/issues).

**Desativei o ícone da barra de menus e não encontro o Despacer.**
Abra o Despacer pela pasta Aplicativos. A janela Ajustes aparece, e você pode reativar o ícone em **Sistema**.

**Abrir ao iniciar sessão não fica ativado.**
O macOS só permite abrir ao iniciar sessão apps que estejam em um local estável. Verifique se o Despacer está na sua pasta Aplicativos (o `./build.sh --install` o coloca lá) e ative o ajuste de novo.

## Como funciona

O Claude Code e o Codex desenham a própria saída, e os dois quebram as linhas longas para caber no terminal antes de imprimi-las: uma quebra de linha de verdade e depois 2 espaços de recuo. O terminal só enxerga linhas separadas, então é isso que ele copia. Nenhum ajuste do terminal consegue desfazer isso, porque os finais de linha originais nunca chegam ao terminal.

O Despacer verifica a área de transferência 20 vezes por segundo (o macOS não avisa quando a área de transferência muda, e a verificação quase não custa nada). Quando a cópia veio de um app de terminal, ele a corrige em duas etapas:

1. **Regras de quebra, na hora.** Ele remove o recuo de 2 espaços e o preenchimento no fim das linhas, e junta de novo cada quebra de linha causada pela quebra automática. Uma quebra conta como automática quando a palavra seguinte não teria cabido na linha de cima. Uma linha que ocupa toda a largura foi partida no meio de uma palavra, mas só quando a palavra é longa demais para uma linha, então ela é juntada sem espaço. Todas as outras quebras de linha, e qualquer linha que termine em `\`, ficam. Essa versão vai para a área de transferência na hora, então fica pronta antes que você consiga trocar de janela.
2. **Correspondência exata, um instante depois.** Em segundo plano, ele procura o texto copiado, ignorando todos os espaços e quebras de linha, nos arquivos de sessão que o Claude Code (`~/.claude/projects`) e o Codex (`~/.codex/sessions`) guardam no seu computador. Ele verifica as sessões ativas no último dia, das mais recentes para as mais antigas. Se encontrar uma correspondência, coloca na área de transferência o texto original, exatamente como o agente o escreveu, a menos que você tenha copiado outra coisa nesse meio-tempo.

Só as regras de quebra já acertam a maioria dos comandos, mas algumas quebras são impossíveis de distinguir, por exemplo uma seleção que começa no meio de uma linha. A correspondência exata resolve esses casos. Ela funciona não importa onde a sua seleção comece ou termine.

O app tem menos de 1.400 linhas de Swift em [`App/`](App), e o mecanismo de correção tem cerca de 250 linhas em [`Sources/DespacerCore/`](Sources/DespacerCore), com testes.

## A ferramenta de linha de comando

O mesmo mecanismo de correção também é um filtro de linha de comando, para scripts ou para corrigir texto que você já colou em algum lugar:

```sh
swift build -c release
pbpaste | .build/release/despacer | pbcopy
```

Passe `--explain` para ver qual método foi usado, ou `--no-transcripts` para usar só as regras de quebra.

## Desinstalação

1. Escolha **Encerrar Despacer** no ícone da barra de menus ou no painel **Sistema** da janela Ajustes.
2. Se **Abrir ao iniciar sessão** estava ativado, desative-o antes, ou remova o Despacer em Ajustes do Sistema > Geral > Itens de Início.
3. Arraste `/Applications/Despacer.app` para o Lixo.
4. Se quiser, remova os ajustes dele:
   ```sh
   defaults delete com.mattsenter.Despacer
   ```

## Compilação e contribuições

```sh
./build.sh            # builds build/Despacer.app (ad-hoc signed)
./build.sh --install  # also copies it to /Applications and opens it
swift test            # runs the fixing engine's tests
swift Tools/make-icon.swift   # regenerates the app icon in Resources/
python3 scripts/check-localization.py   # checks every language is complete
```

O Despacer está disponível em inglês, alemão, espanhol, francês, japonês, coreano, português do Brasil e chinês simplificado e tradicional. Todo texto novo que o app mostra vai em `Localization/en.lproj/Localizable.strings` e em todos os outros `.lproj`, e qualquer mudança neste README ou no `PRIVACY.md` também vai em cada tradução.

| Caminho | O que tem lá |
|---|---|
| `Sources/DespacerCore/` | O mecanismo de correção: as regras de quebra (`Despacer.swift`) e a busca no histórico de sessões (`TranscriptMatcher.swift`) |
| `Tests/DespacerCoreTests/` | Testes, criados a partir de cópias quebradas reais |
| `Sources/despacer/` | A ferramenta de linha de comando |
| `App/main.swift` | Delegate do app e menus |
| `App/ClipboardWatcher.swift` | Observa a área de transferência e aplica as correções |
| `App/TerminalApps.swift` | Os terminais integrados e os que você adiciona |
| `App/SettingsView.swift` | A janela Ajustes em SwiftUI: barra lateral e painéis |
| `App/OtherProjectsView.swift`, `Resources/other-projects/` | O painel Outros projetos e as capturas de tela dele |
| `App/BuiltByCredit.swift`, `App/OutboundLink.swift` | O crédito e o copyright da barra lateral, e os links externos com marcação |
| `App/MenuBarIcon.swift` | O ícone da barra de menus, desenhado em código |
| `Localization/<lang>.lproj/` | Os textos do app em cada idioma (o inglês é o original) |
| `README.<lang>.md`, `PRIVACY.<lang>.md` | Documentação traduzida |
| `scripts/check-localization.py` | Falha se faltar um texto ou documento em algum idioma |
| `Tools/make-icon.swift` | Gera o ícone do app |

Issues e pull requests são bem-vindos, principalmente cópias quebradas que as regras de quebra não corrigem direito.

## Apoie o projeto

O Despacer é gratuito e sempre será. Se ele poupa você de uma pequena irritação diária, você pode me dar uma gorjeta pelo Venmo.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>Dê uma gorjeta para @MattSenter no Venmo</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="QR code do Venmo para dar uma gorjeta a Matt Senter">
  </a>
  <br>
  <sub>Escaneie com o seu celular</sub>
</p>

A gorjeta é um agradecimento. Ela não desbloqueia nada, porque não há nada para desbloquear.

## Outros projetos

O Despacer é um dos vários produtos que [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects), da [Senternet](https://www.senter.net/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects), projeta, desenvolve e lança de ponta a ponta. Aqui está o resto da linha.

- **[CommandH](https://github.com/MattSenter/commandh)**: Um Cmd+H que funciona até no último app, para você enfim ver a sua área de trabalho.
- **[Weatherling](https://www.weatherling.app/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Chuva, neve e folhas de outono na área de trabalho do Mac. Efeitos de clima, não um app de previsão.
- **[Burly](https://www.burly.click/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Cada link, no perfil de navegador certo.
- **[Comoji](https://www.comoji.io/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Autocompletar de :emoji: no estilo Slack, em todo o seu Mac.
- **[Orgabot](https://www.orga.bot/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Orquestrar o trabalho, não apenas os agentes.
- **[Premail](https://www.premail.pro/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Sua caixa de entrada, defendida.
- **[Highwire](https://www.highwire.news/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Enxergar além das manchetes.
- **[StockCar](https://www.stockcar.app/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Um podcast da sua carteira, não do mercado.
- **[Fix Siri](https://www.fixsiri.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Hey Siri, do better. Um registro com fontes das falhas da Siri e das promessas da Apple.
- **[BeeReady](https://www.beeready.buzz/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Habilidades que salvam vidas, um jogo de cada vez.
- **[SeedMatrix](https://www.seedmatrix.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer&utm_content=other-projects)**: Cada variedade, cada ensaio, uma comparação clara.

## Licença

[MIT](LICENSE). Criado por [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=despacer).
