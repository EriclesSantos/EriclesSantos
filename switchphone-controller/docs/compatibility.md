# Compatibilidade — 0.2.8

Atualização em 16/10/2026: após copiar e conferir MissionControl 0.16.0 no SD, o usuário confirmou que o SwitchPhone passou a funcionar no Switch. Relatou então controles pequenos e dificuldade de reconectar sem esquecer o vínculo. A 0.2.8 altera o layout e oferece reconexão explícita ao vínculo salvo; esses dois comportamentos ainda precisam de validação no telefone.

No desktop desta sessão, o app 0.2.7/PC estava ACTIVE e o Windows identificou um gamepad HID válido. O auxiliar novo criou Xbox virtual disponível ao XInput e reconhecido pela Steam. Entradas reais do telefone foram lidas durante o teste. O usuário ainda relatou falta de movimento no Dimraeth; esse jogo permanece pendente. Consulte o README e `pc-companion/README.md` para requisitos, alcance e limites. Xbox/PS4/PS5 físicos não são suportados diretamente.

## Histórico da 0.2.7

Resultados físicos relatados pelo usuário com APK 0.2.4 em 2026-10-14. A 0.2.5 ainda precisa de instalação/teste físico.

| Componente | Evidência e limite |
|---|---|
| Xiaomi 2511FPC34G, Android 16/API 36, destino PC e Windows | SwitchPhone Gamepad, status OK no joy.cpl; usuário confirmou entradas. Windows/build e inventário completo de botões não informados; jogos e XInput não validados |
| Mesmo telefone/Windows, destino Switch experimental | Pro Controller; callback Android CONNECTED, canal HID aberto, sete envios aceitos pelo Android, L+R enviado. Nenhum GET/SET/Interrupt; NEGOTIATING. Não valida comandos Nintendo ou o Switch |
| Mesmo telefone + Switch Lite 21.1.0/AMS 1.10.1/E, CNX | Tentativas 0.2.2–0.2.4 falharam antes do canal HID. Teste limpo 0.2.4: BONDING aos 38 s, NONE aos 46 s, motivo Android 0; sem BONDED ou callback HID |
| MissionControl desse Switch | Módulo e 59 patches Bluetooth/BTM enviados idênticos ao pacote oficial v0.14.2. Usuário confirmou On no Hekate Toolbox após reiniciar, antes de alterar botões. Aplicação dos patches em memória não inspecionada |
| Outros telefones, Linux/macOS e Switch V1/V2/OLED | Não testados fisicamente |
| IMU/NFC/rumble do jogo/pareamento manual por chaves | Não implementados |
| Multiplayer, jogos, estabilidade, latência/autonomia | Não testados/medidos |

Android 9+ é a API alvo; o perfil HID depende do fabricante. MAC/VID/PID reais são controlados pelo Android. Pro Controller é um nome temporário no destino Nintendo, restaurado ao encerrar. Emulação Nintendo é parcial.

Na 0.2.5, pontos verdes indicam canal HID conectado, inclusive durante NEGOTIATING. Mensagem amarela e diagnóstico informam separadamente negociação Nintendo pendente. ACTIVE exige comando de modo aceito do host; permanece o prazo de negociação de 45 s. Teste local de toque não é teste Bluetooth. Cor verde não confirma consumo das entradas pelo jogo.

No teste Windows com destino Nintendo, vínculo UNKNOWN não contradiz HID CONNECTED: o observador de vínculo desse modo filtra Nintendo Switch, enquanto o host real era o PC. O canal é confirmado pelo callback nativo HID.

Novas coletas USB estão suspensas a pedido do usuário. O sucesso dos dois destinos no Windows não identifica a causa da falha com o console.

[MissionControl v0.14.1](https://github.com/ndeadly/MissionControl/releases/tag/v0.14.1) introduziu suporte HOS 21.1.0. O requisito AMS >=1.10.2 do README v0.14.2 é específico do HOS 21.2.0+, diferente do sistema informado. Hashes e investigação em missioncontrol-reference.json e bluetooth-research.md.

## Comparação adicional informada

Usuário relatou falha semelhante com outro celular Galaxy, sem modelo/Android ou log específicos por enquanto. Confirmou que ao menos um controle PS4/PS5 conectou e funcionou diretamente no Switch com MissionControl. Isso demonstra funcionamento básico do console/MC com um controle compatível e desloca o foco para a interoperabilidade app/Android→Switch. Não comprova que todas as verificações específicas para telefones estão corretas nem distingue sozinho falha do app de política de autenticação do host. Uso anterior de PS4/PS5 no Xiaomi testa o telefone como host, diferente do papel HID Device deste app.

## Direção atual

A pedido do usuário, novas coletas suspensas. Comparação de tecnologia e limites em [controller-comparison.md](controller-comparison.md). Nenhuma correção de pareamento demonstrada foi identificada apenas por essa análise; não foi publicado outro APK especulativo.

Usuário também relatou vários controles paralelos/AliExpress funcionando no Switch. Documentação MissionControl 0.14.2 confirma que controles sem mapeamento podem parear (botões vermelhos). Driver Sony/VID Sony não é requisito universal de vínculo; causa da perda pré-HID do telefone segue indeterminada. Um driver dedicado não está demonstrado como solução da etapa atual.

## Testes físicos posteriores e perfil alternativo

As três variantes 0.2.6 não abriram HID no Xiaomi/Android 16 e Switch. Retenção após primeira perda permitiu observar novo BONDED, seguido de nova queda. Abertura após 5 s com vínculo salvo recebeu CONNECTING→DISCONNECTED; no combinado não houve estabilidade para a abertura. Usuário depois relatou que o Switch não encontrava o telefone no destino PC; sem diagnóstico dessa tentativa, etapa interna desconhecida.

0.2.7/Teste 4 combina nome Pro Controller confirmado com o descritor/relatórios genéricos do PC, mantendo os demais campos SDP solicitados do perfil Nintendo. Testado fisicamente: nenhuma abertura HID nas tentativas com vínculo salvo e após removê-lo no Android. Na tentativa sem vínculo salvo, registro em 1 s, BONDING em 14 s e NONE em 20 s, sem BONDED ou callback HID, motivo 0. Não comprova contorno de verificação de classe/autenticação, reconhecimento dos botões ou mapeamento no MissionControl. L+R Nintendo desabilitado e negociação não aplicável ao genérico. Nome original é preservado no destino PC; Testes 0–3 mantêm protocolo Nintendo.

## Pesquisa oficial em 16/10/2026

[Relatório e fontes](research-2026-10-16.md): MissionControl 0.16.0 amplia o filtro nativo para JoyConDroid semroot, inclusive com mudança do patch da família21.x, posterior à versão 0.14.2 conferida. Isso oferece uma próxima comparação concreta, sem provar causa no telefone. Novo relato PC diferencia notebookWindows funcional no teste de controle, jogo Web com apenas X e desktop/dongle sem conexão SwitchPhone. Diferenças de índices Gamepad API foram identificadas no código Chromium; não houve teste físico local ou mudança do APK.
