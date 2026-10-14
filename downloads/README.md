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

## Próximo teste: vínculo limpo

1. Instale a 0.2.4 e encerre a sessão do app.
2. No celular, Configurações → Bluetooth → Nintendo Switch → Esquecer/Desparear. Remova somente esse vínculo, preservando outros aparelhos e os controles do console.
3. No Switch, Controles → Mudar ordem/modo de segurar. No app, Switch experimental → Parear. Aceite Associer sem marcar contatos/chamadas e aguarde o canal HID do console.
4. Quando Confirmar L+R habilitar, pressione-o. Sem canal não é possível transmitir L+R; Testar toque verifica apenas a tela.
5. Se o vínculo continuar aceito e o canal não abrir, Abrir enlace HID oferece uma tentativa manual após 5 s. Se cair novamente, envie Diagnóstico → Copiar, especialmente motivo Android e origem do vínculo.

## MissionControl/CNX

O usuário informou HOS 21.1.0|AMS 1.10.1|E e CNX. Os arquivos do módulo e boot2 foram encontrados no SD. Isso não confirma execução nem que todos os patches necessários correspondam ao HOS.

Confira atmosphere/exefs_patches/bluetooth_patches e btm_patches com arquivos .ips. O pacote MissionControl também distribui hid_patches. As notas CNX incluem MissionControl e registram ativação por Ultrahand/Hekate Toolbox; o suporte oficial ao HOS 21.1.0 entrou no [MissionControl 0.14.1](https://github.com/ndeadly/MissionControl/releases/tag/v0.14.1). Não copie patches experimentais de firmware diferente.

## Evidência e limites

A tentativa 0.2.3 começou com vínculo já salvo: HID registrado em 1 s; vínculo removido em 7 s; nenhum callback de conexão HID, pedido GET/SET/Interrupt ou envio. Não houve chamada connect do app. Isso não identifica o iniciador/motivo da remoção nem confirma funcionamento em jogo. A 0.2.4 ainda precisa de teste físico com vínculo limpo.

Build/lint (0 erros, aviso conhecido de paisagem fixa), assinatura/alinhamento e 2.486 asserções JVM aprovados. Emulação Pro Controller parcial: sem giroscópio, NFC, rumble do jogo ou pareamento manual com chaves. PC usa HID genérico, não XInput.

Android 9+, sem root, Internet, localização, varredura, contatos ou chamadas no manifesto. Sem telemetria. Versões anteriores permanecem como histórico.
