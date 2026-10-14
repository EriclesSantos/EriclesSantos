# SwitchPhone Controller — download experimental

[Baixar APK Android 0.2.5](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.5-experimental.apk)

[Baixar coletor USB para Windows](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-diagnostico-usb-windows.zip) · [Instruções da coleta](https://github.com/EriclesSantos/EriclesSantos/blob/main/downloads/README.md#coleta-do-erro-do-switch)

[Código-fonte](switchphone-controller-source.zip) · [SHA-256](SHA256SUMS.txt) · [Certificado](SIGNING-CERTIFICATE.sha256) · [Licença MIT](LICENSE.txt)

A 0.2.5 instala como atualização da 0.2.1–0.2.4, com a mesma chave estável. A antiga 0.2.0 debug tem assinatura diferente. Aplicativo experimental fora da Play Store; assinatura própria não garante retirada do aviso Play Protect.

## Correção dos indicadores

Os três pontos ficam verdes fixos quando o canal HID conecta, inclusive enquanto a negociação Nintendo está pendente. Nesse caso a mensagem continua amarela e explícita; o diagnóstico mostra Modo Nintendo negociado separadamente. Sem canal os controles continuam cinzas. Não foi alterado o protocolo, as permissões ou o timeout de negociação de 45 s. Verde confirma transporte HID, sem comprovar entradas em jogo.

O teste 0.2.4 no Xiaomi 2511FPC34G/Android 16 com Windows confirmou SwitchPhone Gamepad no joy.cpl e resposta às entradas no destino PC. No mesmo Windows, o destino Nintendo conectou como Pro Controller: callback HID CONNECTED aos 49 s, sete envios aceitos pelo Android e L+R aos 57 s; zero GET/SET/Interrupt e fase NEGOTIATING. A UI antiga ficava vermelha apesar desse canal real.

O pareamento com Switch Lite continua sem solução física comprovada. HOS 21.1.0|AMS 1.10.1|E/CNX: teste limpo falhou antes do canal HID, BONDING aos 38 s e NONE aos 46 s, motivo Android 0. O módulo enviado e os 59 patches Bluetooth/BTM são idênticos ao MissionControl v0.14.2 oficial. Usuário confirmou MissionControl On no Hekate Toolbox após reiniciar, antes de alterar botões. Aplicação dos patches em memória não foi inspecionada. Não é necessário repetir o envio desses arquivos.

## Coleta do erro do Switch

O cabo está conectado ao PC do usuário; o ambiente na nuvem não acessa essa porta USB. O coletor tenta obter status/hciReason do processo Bluetooth, que o broadcast do app não fornece.

1. No Xiaomi, ative Opções do desenvolvedor (sete toques em Versão do SO/HyperOS, em Sobre o telefone), depois Configurações adicionais → Opções do desenvolvedor → Depuração USB. Transferência de arquivos/MTP confirma o cabo, mas não substitui Depuração USB; pode manter MTP selecionado. Não precisa de Instalar via USB.
2. No Windows, baixe o ZIP do coletor, use Extrair tudo e abra Iniciar-coleta.cmd na pasta extraída. Se faltar o PS1 ao lado, o iniciador explica a extração antes de chamar PowerShell. Não precisa de administrador. Na primeira execução baixa 8 MB de ferramentas oficiais Google, verificadas por SHA-256.
3. Aceite Permitir depuração USB no celular desbloqueado. Deixe o Bluetooth do PC desligado durante a coleta, para ele não reconectar como Pro Controller. Mantenha o do celular ligado.
4. Pressione Enter na janela do coletor. Quando mostrar COLETA INICIADA, no app escolha Switch experimental → Parear e aguarde HID registrado; só então abra Controles → Mudar ordem/modo de segurar no Switch. Aceite Associer sem contatos.
5. Ao terminar (até 90 s), envie o arquivo switchphone-bluetooth-....json gerado e Diagnóstico → Copiar do app. Se o coletor exibir erro, envie essa mensagem. Depois pode desativar Depuração USB e reativar Bluetooth do PC.

O LEIA-ME.txt do ZIP inclui os detalhes e passos para vínculo limpo. O JSON contém só tempo relativo e códigos numéricos, sem MAC, serial, chaves ou log completo. Não é enviado automaticamente à Internet. Sem callback, o relatório informa ausência de eventos; isso não identifica a causa. Não é preciso compartilhar bugreport ou HCI completo.

## Validação e limites

Build/lint aprovados (0 erros, 1 aviso conhecido de paisagem fixa), assinatura/alinhamento e 2.486 asserções JVM. Cinco testes do coletor com PowerShell 7.6.7/Linux e ADB simulado aprovados; download/hash/extração oficiais e rejeição de cache alterado também verificados. Usuário confirmou que o coletor executou no Windows até a checagem USB, ainda sem aparelho ADB autorizado/encontrado. Versão exata do PowerShell, eventos reais Bluetooth e instalação da 0.2.5 no Xiaomi ainda não confirmados.

Android 9+, sem root, Internet, localização, varredura, contatos ou chamadas no APK. Sem telemetria. PC é HID genérico, não XInput. Emulação Pro Controller parcial, sem giroscópio, NFC, rumble do jogo ou pareamento manual por chaves. Jogos, latência, estabilidade e inventário completo de controles ainda não validados. Versões anteriores ficam como histórico.
