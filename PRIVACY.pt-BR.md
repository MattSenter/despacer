# Política de Privacidade do Despacer

[English](PRIVACY.md) · [Deutsch](PRIVACY.de.md) · [Español](PRIVACY.es.md) · [Français](PRIVACY.fr.md) · [日本語](PRIVACY.ja.md) · [한국어](PRIVACY.ko.md) · **Português (Brasil)** · [简体中文](PRIVACY.zh-Hans.md) · [繁體中文](PRIVACY.zh-Hant.md)

Última atualização: 22 de outubro de 2026

O Despacer não coleta dados. Nenhum.

- Ele não faz nenhuma conexão de rede.
- Ele não tem conta, análises, relatórios de falhas, publicidade nem rastreamento.
- Ele só lê a área de transferência logo depois que você copia algo enquanto um app de terminal (um dos listados no painel Terminais dos ajustes) está na frente. Cópias de qualquer outro app nunca são lidas.
- Para encontrar o original exato de um comando copiado, ele lê os arquivos de sessão que o Claude Code e o Codex guardam no seu computador (`~/.claude/projects` e `~/.codex/sessions`). Ele só os lê. Nunca os altera, copia ou envia. Você pode desativar isso com **Buscar no histórico de sessões**.
- Ele guarda as suas dez últimas correções na memória para você poder desfazê-las. Elas nunca são gravadas em disco e somem quando o Despacer é encerrado.
- Os ajustes dele (quais recursos estão ativados, quais apps contam como terminais, Mostrar na barra de menus, Abrir ao iniciar sessão) ficam salvos apenas no seu computador.

Se isso mudar algum dia, esta página vai avisar primeiro.

Dúvidas: abra uma issue em https://github.com/MattSenter/despacer/issues.
