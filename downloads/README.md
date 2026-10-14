# SwitchPhone Controller — experimental

[Baixar APK Android 0.2.6](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.6-experimental.apk) · [Código-fonte](switchphone-controller-source.zip) · [SHA-256](SHA256SUMS.txt)

## Testes novos: vínculo e canal HID

Instala como atualização da 0.2.1–0.2.5 com a mesma assinatura. No app, abra **Início → Switch experimental → Escolher teste de conexão**.

| Opção | Comportamento |
| --- | --- |
| Padrão | Aguarda entrada do Switch e encerra se o vínculo cair, como antes. |
| Teste 1 • vínculo (12s) | Na primeira perda, mantém nome e HID por até 12 s para receber novo vínculo ou canal. Não cria vínculo ou reabre permissões. Só vale com HID ainda registrado/READY e sem canal. |
| Teste 2 • abrir HID (5s) | Com vínculo estável por 5 s e nenhum canal em andamento, verifica o vínculo Android e solicita uma única abertura HID pelo celular. |
| Teste 3 • vínculo + HID | Combina os dois caminhos. |

1. Comece pelo **Teste 1**, toque **Parear** e aceite as confirmações Android.
2. Aguarde **HID registrado** no app. Só então abra **Controles → Mudar ordem/modo de segurar** no Switch. Aceite **Associer** sem contatos, se aparecer.
3. Com pontos verdes, use **Confirmar L+R**. Verde confirma canal HID; negociação Nintendo e resposta no jogo são verificações separadas.
4. Se falhar, use **Diagnóstico → Copiar** antes de começar outro teste. Repita com **Teste 2** e depois **Teste 3**, em tentativas separadas.

O diagnóstico identifica o teste, a janela utilizada e a abertura solicitada. A janela não se prolonga por eventos repetidos e não renova os 120 s de visibilidade. Uma segunda perda ou erro nativo encerra a tentativa. Nenhum coletor adicional é necessário. O modo PC continua com a política padrão.

## Validação e limites

Build/lint, 2.544 asserções JVM, assinatura e alinhamento aprovados. APK não depurável, versionCode 8, 123639 bytes. Testes automatizados cobrem os rastros físicos recebidos e os limites das novas políticas. O usuário executou os três testes da 0.2.6 no Xiaomi/Android 16: nenhum abriu HID. No Teste 1, o vínculo foi confirmado duas vezes e caiu mesmo com o registro mantido. No Teste 2, a abertura pelo celular chegou a CONNECTING e terminou DISCONNECTED. No Teste 3, o vínculo caiu antes do intervalo estável, sem executar a abertura. Os experimentos não corrigiram o pareamento; causa exata ainda desconhecida. A comparação registra tempos e limites da conclusão.

- Windows: usuário confirmou reconhecimento e resposta às entradas do HID genérico com Xiaomi/Android 16. O destino Nintendo também abriu HID no Windows, sem negociação Nintendo.
- Switch: logs anteriores mostram perda de vínculo antes do HID. Galaxy apresentou comportamento semelhante por relato. Os dados não identificaram a causa exata.
- MissionControl v0.14.2: módulo e 59 patches enviados idênticos aos oficiais; processo On relatado após reinício. Um controle PS4/PS5 conectou e funcionou no console.

[Comparação técnica dos controles](comparacao-bluetooth.md), disponível no navegador. MissionControl também aceita controles genéricos: driver/IDs Sony não são requisitos universais de pareamento. Os testes desta versão modificam o gerenciamento da tentativa no app; não alteram autenticação, VID/PID ou política Bluetooth do Android.

Android 9+, sem root/Internet/telemetria. PC é HID genérico, não XInput. Emulação Nintendo parcial, sem IMU/NFC/rumble do jogo/pareamento manual por chaves. Assinatura própria não garante retirada de aviso do Play Protect.

[Certificado](SIGNING-CERTIFICATE.sha256) · [Licença MIT](LICENSE.txt). APKs e ferramentas anteriores permanecem como histórico; novas coletas USB estão suspensas.
