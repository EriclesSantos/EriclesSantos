# SwitchPhone Controller — experimental

[Baixar APK Android 0.2.5](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.5-experimental.apk) · [Código-fonte](switchphone-controller-source.zip) · [SHA-256](SHA256SUMS.txt)

[Comparação técnica: SwitchPhone, PS4 e PS5](comparacao-bluetooth.md) — leitura no navegador, sem instalar ferramentas. Novas coletas suspensas a pedido do usuário.

## Estado atual

- Windows: usuário confirmou reconhecimento e resposta às entradas do HID genérico com Xiaomi/Android 16. O destino Nintendo também abriu HID no Windows, sem negociação Nintendo.
- Switch: ainda sem sucesso demonstrado. O vínculo cai antes de abrir HID; motivos recebidos não identificaram a causa. Galaxy teve comportamento semelhante segundo relato, sem modelo/Android/log específicos.
- MissionControl v0.14.2: módulo e 59 patches enviados idênticos aos oficiais; processo On relatado após reinício. Um controle PS4/PS5 conectou e funcionou no console.

O app usa emulação parcial Nintendo; MissionControl usa drivers dedicados para Sony. A API Android empregada não permite definir VID/PID Sony/Nintendo. Trocar nome/layout não reproduz um controle Sony. A comparação completa distingue esses fatos das hipóteses sobre a perda do vínculo. Nenhum novo APK foi publicado nesta análise e não há correção física definitiva comprovada para Switch.

## APK 0.2.5

Mantém a assinatura da 0.2.1–0.2.4 e instala como atualização. Pontos verdes indicam canal HID; negociação Nintendo pendente aparece separadamente. A versão alterou indicação visual, sem mudar o pareamento. Build/lint, assinatura/alinhamento e 2.486 asserções JVM aprovados; teste físico da atualização ainda não confirmado.

Android 9+, sem root/Internet/telemetria no APK. PC é HID genérico, não XInput. Sem IMU/NFC/rumble do jogo/pareamento manual com chaves. Assinatura própria não garante retirada de aviso do Play Protect.

[Certificado](SIGNING-CERTIFICATE.sha256) · [Licença MIT](LICENSE.txt). APKs e ferramentas anteriores permanecem como histórico, sem solicitação de nova coleta.
