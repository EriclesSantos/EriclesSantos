# Nördhub ProController 0.2.8 — experimental

Controle de tela Android para Switch com MissionControl e computadores por Bluetooth. Novo nome do SwitchPhone, com botões e analógicos maiores, mais espaço entre comandos e contornos luminosos nas cores de cada layout.

![Ícone Nördhub ProController](nordhub-procontroller-icon.png)

## Baixar

- **[Baixar o APK Android 0.2.8](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/nordhub-procontroller-0.2.8.apk)**
- **[Baixar o auxiliar Windows x64 experimental](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/nordhub-procontroller-pc-0.2.8.zip)**
- **[Guia de desktop: instalação, Steam, jogos fora da Steam e solução de problemas](../switchphone-controller/pc-companion/README.md)**
- [Código-fonte 0.2.8 em ZIP](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/nordhub-procontroller-source-0.2.8.zip) · [Código navegável](../switchphone-controller/) · [Hashes SHA-256](SHA256SUMS.txt)

O atalho [APK atual](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/nordhub-procontroller.apk) também aponta para esta versão. Os arquivos com número de versão antigo permanecem apenas como histórico.

## Instalar no celular

**Desinstale o SwitchPhone antigo antes de instalar o APK novo.** A chave original não estava disponível no pacote de continuação. Esta versão usa uma nova chave estável de distribuição, com a reinstalação autorizada. Instalar por cima da 0.2.7 pode resultar em conflito de assinatura. Ajustes e dados privados do app anterior não são migrados.

1. Encerre a conexão do app antigo e desinstale-o.
2. Instale o APK 0.2.8 acima. Se instalou a Preview separada, encerre-a também; use apenas um app HID por vez.
3. Autorize Bluetooth/dispositivos próximos e escolha o destino **Switch experimental** ou **PC**. O desenho Nintendo/Xbox/PlayStation não troca o protocolo do destino.

Android 9+ com suporte HID Device do fabricante. O APK é local, sem permissão Internet, conta ou telemetria. O nome externo no Bluetooth do PC pode continuar sendo o nome do celular; isso não determina a existência do gamepad HID.

## Usar em notebook ou desktop

O Bluetooth do app oferece HID genérico. Muitos jogos esperam Xbox/XInput. O auxiliar Windows lê esse HID e cria um Xbox 360 virtual para investigar compatibilidade em jogos Steam e não Steam.

**Requisitos:** Windows 10/11 x64, Bluetooth, .NET Framework 4.8 e ViGEmBus compatível instalado. Extraia todo o ZIP e mantenha EXE e DLL juntos. O pacote não instala drivers e não inicia automaticamente com o Windows.

**ViGEm foi descontinuado pelo autor.** Este backend é experimental, aproveita o driver que já existia no desktop de teste e não oferece garantia de suporte futuro. Fontes oficiais:

- [Microsoft .NET Framework 4.8](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48).
- [ViGEm: descontinuação](https://docs.nefarius.at/projects/ViGEm/End-of-Life/), [instalação](https://docs.nefarius.at/projects/ViGEm/How-to-Install/) e [releases oficiais](https://github.com/nefarius/ViGEmBus/releases).
- [Steam Input: documentação para jogadores](https://partner.steamgames.com/doc/features/steam_controller/getting_started_for_players).

Fluxo de teste: celular no destino PC → gamepad em `Win+R → joy.cpl` → abrir auxiliar → selecionar celular → **Iniciar controle Xbox** → comparar **Entrada celular** com **Saída XInput** ao tocar → iniciar o jogo. Se usar Steam Input, confira o perfil **Gamepad** do jogo correto. O guia completo acima detalha cada etapa.

## Estado real de compatibilidade

| Uso | Resultado e limite |
|---|---|
| Switch Lite do usuário + MissionControl 0.16.0 + APK antigo | Funcionamento inicial confirmado; comandos respondem no HOME. Não comprova todos os Switch/telefones. |
| Reconexão da 0.2.8 | Fluxo para vínculo salvo implementado e testado por software; aguarda teste físico da nova instalação. |
| Windows deste desktop | HID do celular detectado e entradas reais recebidas. Xbox virtual criado e reconhecido pela Steam. |
| Dimraeth no desktop | Sem resposta no jogo, inclusive após reabri-lo. Investigação aberta; o ícone na Steam não comprova funcionamento. |
| DuckStation no Switch / The King of Fighters ’97 | Sem resposta no emulador, embora o HOME responda. Conferir jogador, porta 1 e perfil; [guia e evidências](../switchphone-controller/docs/duckstation-switch.md). |
| Outros notebooks, desktops e jogos | Objetivo de compatibilidade; não há garantia universal. Dependências, Bluetooth e suporte do jogo precisam ser atendidos. |
| Xbox, PS4 e PS5 físicos | Sem suporte direto. Layout visual e XInput do Windows não implementam a autenticação/protocolo desses consoles. Remote Play/adaptadores seriam integrações separadas. |

Não foram modificadas configurações da Steam, filtros HidHide ou arquivos do jogo. O auxiliar é um executável de teste sem assinatura de distribuição Windows; o APK tem assinatura Android verificada.

## Alterações da 0.2.8

- Novo nome **Nördhub ProController** e símbolo Nördhub dentro da silhueta de controle, em lilás/ciano.
- Botões de face maiores, analógicos maiores, direcional ampliado e espaçamento redistribuído. Ações secundárias ficam em **Mais**.
- Contornos luminosos: Nintendo ciano/vermelho, Xbox verde, PlayStation nas cores dos símbolos, com realce ao tocar.
- Reconectar prepara HID com o vínculo salvo, sem pedir nova visibilidade nesse caminho; uma tentativa de abertura após estabilidade. Não remove vínculos ou altera chaves Bluetooth.
- Avisos repetidos de giroscópio/vibração ausentes são agrupados, com contadores no diagnóstico. O envio periódico não reinicia a cada resposta ao host. Isso não acrescenta IMU ou rumble do jogo.
- Auxiliar Windows x64 com comparação entre entrada do celular e estado real lido por XInput.

[Prévia Nintendo](nordhub-layout-nintendo.png) · [Prévia Xbox](nordhub-layout-xbox.png) · [Prévia PlayStation](nordhub-layout-playstation.png). São desenhos da geometria, não capturas Android.

## Verificação e assinatura

6.983 asserções Java e 45 verificações de mapeamento Windows aprovadas. Compilação e lint de release/Preview aprovados, assinatura Android e alinhamento verificados. Teste nativo de criação, estado neutro e remoção do Xbox virtual aprovado. Essas verificações não substituem testes físicos de UI, reconexão e jogos.

Certificado SHA-256 da nova distribuição: `6a00bcc9490e4b18de625901486ea39bb6d1fbb3b3147acc2fe4ca1f5200913c`. [Certificado atual](SIGNING-CERTIFICATE.sha256) · [Certificado histórico 0.2.1–0.2.7](SIGNING-CERTIFICATE-0.2.1-0.2.7.sha256). Nenhuma chave privada ou senha é publicada.

[Validação técnica](../switchphone-controller/docs/validation.md) · [Projeto e compilação](../switchphone-controller/README.md) · [Licença MIT](LICENSE.txt).

## Histórico

[APK anterior 0.2.7](switchphone-0.2.7-experimental.apk) · [Pesquisa anterior de Bluetooth](pesquisa-apps-bluetooth.md) · [Comparação anterior](comparacao-bluetooth.md). Esses documentos registram o estado anterior à atualização do MissionControl e ao primeiro funcionamento confirmado; não são as instruções atuais de instalação.