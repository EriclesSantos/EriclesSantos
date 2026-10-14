# SwitchPhone Controller — experimental

[Baixar APK Android 0.2.7](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.7-experimental.apk) · [Código-fonte](switchphone-controller-source.zip) · [SHA-256](SHA256SUMS.txt)

## Resultado atual

O Teste 4 da 0.2.7 foi executado pelo usuário com vínculo salvo e após removê-lo no celular: nenhum canal HID abriu. Na tentativa sem vínculo salvo, o app registrou HID aos 1 s, Android iniciou BONDING aos 14 s e retornou NONE aos 20 s, sem BONDED ou callback HID. Motivo 0 continua desconhecido. Os testes 1–3 da 0.2.6 também falharam. **A compatibilidade com esse Switch ainda não foi resolvida.** Não é necessário repetir esses testes ou baixar outro coletor.

O APK permanece idêntico. Windows continua funcional no escopo relatado; o resultado não identifica defeito exclusivamente no telefone ou no console. A comparação abaixo registra as evidências e seus limites.

## Histórico do Teste 4: HID genérico com nome Pro Controller

O destino PC não iniciava pareamento visível com o Switch no relato do usuário. Esse modo também restaura o nome Bluetooth original do telefone, além de trocar o perfil de relatórios, portanto não isolava a causa.

A 0.2.7 adiciona **Teste 4 • HID genérico**: mantém nome de rádio Pro Controller confirmado e os mesmos nome/descrição/provedor/subclasse gamepad solicitados ao SDP, usando o descritor e relatórios genéricos do PC. Não combina retenção de vínculo ou abertura automática dos Testes 1–3. Identidade de rádio real, classe, VID/PID e autenticação continuam sob controle do Android; nome não equivale a identidade Nintendo completa.

1. Instale como atualização: a assinatura é a mesma da 0.2.1–0.2.6.
2. No celular, use **Início → Switch experimental → Escolher teste de conexão → Teste 4 • HID genérico**. Use o destino Switch para este teste.
3. Toque **Parear**, aceite as confirmações Android e aguarde **HID registrado**.
4. Só então abra **Controles → Mudar ordem/modo de segurar** no Switch. Confirme Associer no celular, se aparecer.
5. Observe se o canal conecta/pontos verdes e use **Diagnóstico → Copiar**. O computador não participa e não há coletor externo.

**Confirmar L+R Nintendo fica cinza nesse teste**, inclusive se o canal abrir. A tela identifica o perfil genérico e o diagnóstico informa negociação Nintendo não aplicável. Verde confirma canal HID real, sem garantir mapeamento de botões ou funcionamento em jogo. Mapeamento específico no MissionControl não foi implementado. Caches no host e vínculos anteriores podem limitar a comparação; não é necessário apagar todos os controles do console.

## Validação e resultados anteriores

Build/lint, 2.574 asserções JVM, assinatura e alinhamento aprovados. APK não depurável, versionCode 9, 123639 bytes. Teste físico no Xiaomi/Android 16 e Switch recebido: falhou antes de concluir vínculo/HID, inclusive após remover a associação no celular; nenhuma correção definitiva demonstrada.

- Windows: usuário confirmou reconhecimento e entradas do HID genérico com Xiaomi/Android 16. O perfil Nintendo também abriu HID no Windows, sem negociação Nintendo.
- Switch: Testes 1–3 da 0.2.6 não abriram HID. Teste 1 confirmou vínculo duas vezes, seguido de queda com registro mantido. Teste 2 recebeu CONNECTING→DISCONNECTED após abertura pelo celular. No Teste 3, o vínculo caiu antes do intervalo estável e a abertura não foi executada. Não é necessário repetir esses três testes para a comparação atual.
- MissionControl v0.14.2: módulo e 59 patches enviados idênticos aos oficiais; processo On relatado após reinício. Um controle PS4/PS5 conectou e funcionou no console. Isso não identifica a causa da incompatibilidade do telefone.

[Comparação técnica e evidências](comparacao-bluetooth.md). MissionControl também aceita controles genéricos: driver/IDs Sony não são requisitos universais para parear. Motivo Android 0 e callbacks do app não identificam qual lado encerrou ou se a causa está em autenticação, serviço anunciado ou abertura do canal.

Android 9+, sem root/Internet/telemetria. PC é HID genérico, não XInput. Emulação Nintendo parcial, sem IMU/NFC/rumble do jogo/pareamento manual por chaves. Assinatura própria não garante retirada de aviso do Play Protect.

[Certificado](SIGNING-CERTIFICATE.sha256) · [Licença MIT](LICENSE.txt). Versões e ferramentas anteriores permanecem como histórico; novas coletas USB suspensas.
