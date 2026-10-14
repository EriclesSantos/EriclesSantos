# SwitchPhone Controller — download experimental

[Baixar APK Android 0.2.3 — release](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.3-experimental.apk)

[Baixar código-fonte](switchphone-controller-source.zip) · [SHA-256](SHA256SUMS.txt) · [Certificado](SIGNING-CERTIFICATE.sha256) · [Licença MIT](LICENSE.txt)

A 0.2.3 mantém a assinatura da 0.2.1/0.2.2: instale como atualização. A antiga 0.2.0 debug exige desinstalar por diferença de assinatura. Aplicativo experimental distribuído fora da Play Store; assinatura própria não garante retirada de aviso do Play Protect.

## O que mudou

- Retirada a conexão HID automática imediatamente após aceitar o vínculo Android, para evitar possível disputa com a abertura do canal pelo Switch. Vínculo e conexão HID são etapas diferentes.
- Falha/remoção do vínculo do host encerra a tentativa, sem reiniciá-la por novos eventos do sistema. Erro permanece visível ao sair e voltar ao app.
- Abrir enlace HID oferece uma única tentativa manual com vínculo aceito há 5 s. Usa apenas um vínculo já aceito; não procura aparelhos nem apaga pareamentos.
- Diagnóstico preserva registro/canal HID alguma vez observados e confirmação do nome antes da limpeza; inclui callbacks de conexão e contagens de pedidos GET/SET/Interrupt e envios, sem payloads, MAC ou chaves.
- Mantidos: controle interativo ao Parear, serviço foreground com prazo, botões cinza sem canal, Confirmar L+R com enlace real e Testar toque isolado/offline.

## Testar no Switch Lite

1. No console, abra Controles → Mudar ordem/modo de segurar com MissionControl/Atmosphère compatíveis e ativos. Procurar controles não adiciona controle novo.
2. No app escolha Switch experimental e toque Parear. Aceite visibilidade/permite Bluetooth quando solicitado.
3. Em Associer à Nintendo Switch ?, toque Associer sem marcar contatos/histórico de chamadas. Aguarde o canal HID do console.
4. Quando Confirmar L+R habilitar, pressione-o. Sem canal não há como enviar L+R por Bluetooth; Testar toque verifica somente a tela.
5. Se o vínculo continuar aceito e o canal não abrir, Abrir enlace HID permite uma tentativa manual após 5 s. Se o vínculo for removido, copie o diagnóstico antes de nova tentativa.
6. Pontos verdes indicam enlace e modo negociado; ainda é necessário validar entradas no console/jogo.

## Relato físico e compatibilidade

Teste 0.2.2: Xiaomi 2511FPC34G/Android 16 (API 36), Switch Lite 21.1.0|AMS 1.10.1|E e MissionControl declarado ativo. Houve registro HID e vínculo Android, mas o vínculo caiu antes de confirmar canal HID. Não funcionou como controle nesse teste. Causa da remoção não foi comprovada; versão MissionControl instalada ainda pendente.

O suporte ao HOS 21.1.0 entrou no [MissionControl 0.14.1](https://github.com/ndeadly/MissionControl/releases/tag/v0.14.1). Para conferir o sistema, consulte Configurações do console → Console → Versão atual, sem iniciar atualização. A versão MissionControl pode ser conferida pelo ZIP/pacote instalado; a presença da pasta do módulo não informa sua versão nem prova carregamento dos patches.

A 0.2.3 passou em compilação, lint (0 erros, aviso de paisagem fixa), assinatura/alinhamento e 2.448 asserções JVM. Ainda não foi testada fisicamente. Emulação Pro Controller parcial: sem giroscópio, NFC, rumble do jogo ou pareamento manual com chaves. PC usa HID genérico, não XInput. Não há confirmação de funcionamento em jogo.

Android 9+, sem root, Internet, localização, varredura, contatos ou chamadas no manifesto. Sem telemetria. Versões anteriores permanecem como histórico.
