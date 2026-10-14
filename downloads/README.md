# SwitchPhone Controller — download experimental

[Baixar APK Android 0.2.4 — release](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.4-experimental.apk)

[Baixar código-fonte](switchphone-controller-source.zip) · [SHA-256](SHA256SUMS.txt) · [Certificado](SIGNING-CERTIFICATE.sha256) · [Licença MIT](LICENSE.txt)

A 0.2.4 mantém a assinatura da 0.2.1/0.2.2/0.2.3: instale como atualização. A antiga 0.2.0 debug exige desinstalar por diferença de assinatura. Aplicativo experimental fora da Play Store; assinatura própria não garante retirada de aviso do Play Protect.

## O que mudou

- Corrigida a identificação do vínculo: um Nintendo Switch já salvo no celular não é mais apresentado como callback BONDED recebido nesta tentativa.
- Diagnóstico inclui o motivo de remoção disponibilizado pelo Android, quando presente. Ausência/códigos desconhecidos são explícitos; o código 9 é também genérico e não prova quem removeu o vínculo.
- No Android 16+, pode observar o sinal KEY_MISSING do sistema para ajudar a identificar falhas de chave. Não lê chaves, não chama APIs ocultas, não usa root ou novas permissões. Ausência desse sinal não descarta falha de autenticação.
- Mantém a política da 0.2.3: nenhuma conexão de saída automática após vínculo; uma tentativa manual com vínculo estável há 5 s; perda do vínculo encerra; L+R exige canal HID real; teste de toque local permanece isolado.

Esta versão melhora o diagnóstico. Ainda não há correção física comprovada para a conexão Xiaomi/Android 16 com Switch Lite.

## Validação física: Windows

Em 2026-10-14, o usuário confirmou que SwitchPhone 0.2.4 no Xiaomi 2511FPC34G/Android 16/API 36 respondeu às entradas no Windows. A captura mostra SwitchPhone Gamepad com status OK em joy.cpl e a página de teste de eixos/botões. A versão/build do Windows não foi informada; jogos, todos os comandos individualmente, latência e operação prolongada não foram inventariados.

O APK permanece o mesmo, com o mesmo SHA-256. Esta atualização registra o resultado e prepara a identificação do módulo MissionControl instalado.

## Próxima conferência no Switch

O teste limpo já foi realizado: nenhum vínculo salvo ao registrar HID; tentativa nova aos 38 s; falha aos 46 s; sem canal HID ou comandos do host, motivo Android 0 sem causa detalhada. A ordem com registro HID antes de abrir Mudar ordem/modo de segurar também foi testada e não resolveu a ocorrência.

O próximo artefato útil é atmosphere/contents/010000000000bd00/exefs.nsp do SD, que aparece como exefs quando o Windows oculta extensões. Copie esse arquivo para o computador para conferir a versão. O código-fonte inclui docs/missioncontrol-identification.md, fingerprints dos módulos oficiais e scripts/identify-missioncontrol.py, que calcula SHA-256 sem executar ou modificar o módulo.

## MissionControl/CNX

O usuário informou HOS 21.1.0|AMS 1.10.1|E e CNX. Arquivos do módulo, boot2 e pastas bluetooth_patches/btm_patches foram relatados presentes no SD. Isso não confirma a versão exata, execução ou correspondência dos arquivos ao HOS.

Confira atmosphere/exefs_patches/bluetooth_patches e btm_patches com arquivos .ips. O pacote MissionControl também distribui hid_patches. As notas CNX incluem MissionControl e registram ativação por Ultrahand/Hekate Toolbox; o suporte oficial ao HOS 21.1.0 entrou no [MissionControl 0.14.1](https://github.com/ndeadly/MissionControl/releases/tag/v0.14.1). Não copie patches experimentais de firmware diferente.

## Evidência e limites

A tentativa 0.2.3 começou com vínculo já salvo: HID registrado em 1 s; vínculo removido em 7 s; nenhum callback de conexão HID, pedido GET/SET/Interrupt ou envio. Não houve chamada connect do app. Isso não identifica o iniciador/motivo da remoção nem confirma funcionamento em jogo. O teste limpo 0.2.4 também falhou antes do canal HID, conforme seção acima. O sucesso genérico no PC não identifica a causa da falha Nintendo.

Build/lint (0 erros, aviso conhecido de paisagem fixa), assinatura/alinhamento e 2.486 asserções JVM aprovados. Emulação Pro Controller parcial: sem giroscópio, NFC, rumble do jogo ou pareamento manual com chaves. PC usa HID genérico, não XInput; houve confirmação manual de reconhecimento e resposta no joy.cpl.

Android 9+, sem root, Internet, localização, varredura, contatos ou chamadas no manifesto. Sem telemetria. Versões anteriores permanecem como histórico.
