# Sprint 0 — investigação técnica, atualizada para 0.2.5

Consulta em 2026-10-14. Fontes efetivamente obtidas e lidas por HTTPS:

- MissionControl, https://github.com/ndeadly/MissionControl — `71bbe2d4e97d618775b5a3e2f91bfeaf52d8b75e`: README e implementação de identificação/encaminhamento de controles.
- JoyCon Droid, https://github.com/TeamJCD/JoyConDroid — `e3074f867847ca083d1438f0d7368d41e1fba28a`: README, serviço HID e handlers de relatórios/subcomandos.
- Nintendo Switch Reverse Engineering, https://github.com/dekuNukem/Nintendo_Switch_Reverse_Engineering — `b354f21ae81f7b0d1d060b2b61e66ad0d9bc1756`: notas de Bluetooth, subcomandos e SPI.

A referência oficial pretendida https://developer.android.com/reference/android/bluetooth/BluetoothHidDevice retornou HTTP 403 neste ambiente. As assinaturas usadas foram verificadas por compilação contra SDK 35; não se alega ter lido essa página. Consulta adicional ao driver Linux retornou HTTP 429 e não integra as evidências técnicas lidas.

## Evidências de viabilidade
O README do MissionControl declara permitir JoyConDroid sem root. A função Identify de controller_management.cpp examina VID/PID e nomes oficiais Nintendo e escolhe famílias específicas; um gamepad HID genérico não é automaticamente reconhecido como controle compatível.

O README do JoyCon Droid apresenta ROOT REQUIRED para seu uso geral. O serviço inspecionado usa BluetoothHidDeviceAppSdpSettings/registerApp e delega GET/SET_REPORT a uma camada de controle. Os handlers evidenciam a necessidade de negociação e respostas próprias. O aviso de root e a declaração do MissionControl devem ser avaliados em conjunto, sem inferir compatibilidade universal.

A API HID Device existe desde Android API 28 e depende da implementação do fabricante. O código usa Bluetooth clássico HID; não é BLE HID/GATT. A API pública não permite impor MAC/VID/PID arbitrários nem acessar chaves de enlace privadas. Nome Pro Controller e SDP próprio são pedidos permitidos, mas não provam que a identidade será aceita pelo console.

## Decisão implementada
Dois modos separados: HID genérico para PC, não XInput, e emulação parcial do protocolo Pro Controller para Switch/MissionControl. Três layouts visuais compartilham comandos internos; não representam três emulações de marcas.

O modo Nintendo implementa 3F/21/30, identificação virtual, negociação de modos, botões/eixos, leitura limitada de calibração virtual, LEDs de jogador e contadores. A calibração é gerada para os analógicos de tela. Não contém firmware, EEPROM nem dados extraídos de controle real. NFC, IMU ativo, rumble, modo 31 e pareamento manual por LTK são recusados explicitamente; certos hosts podem exigir esses recursos e falhar. Detalhes em nintendo-protocol.md.

## Licenças
MissionControl contém LICENSE GPL v2 e o arquivo de identificação declara versão 2. Incorporar seu código exigiria avaliar cabeçalhos, atribuição e obrigações de distribuição do código correspondente. Não foi incorporado código.

No checkout do JoyCon Droid não foi encontrada licença explícita na raiz nem no serviço inspecionado. Repositório público não concede automaticamente licença de reutilização. Nenhum trecho, descritor, firmware ou EEPROM foi copiado. Seria necessário obter licença antes de reutilizar código.

Das notas de engenharia reversa foram utilizados fatos de formato de protocolo para uma implementação original, sem copiar exemplos de código. O código próprio está sob MIT. O Gradle Wrapper preserva seus avisos Apache 2.0 separadamente.

## Gate físico e riscos restantes
É necessário testar perfil HID num Android real, pareamento, SDP/identidade, negociação, mapeamento de todos os comandos, analógicos, estabilidade e operação em jogo. O mapeamento 3F em particular permanece experimental; o caminho principal é 0x30. Se houver requisito de identidade/chave inacessível pela API pública sem root, a estratégia pode precisar ser revista.

Não há Android/rádio/console conectado nesta máquina. Não foram validados Galaxy A23 ou outros modelos, versões de HOS/Atmosphère/MissionControl, latência, autonomia ou multiplayer. O APK pode não ser reconhecido pelo Switch. O aceite do MVP exige os testes reais descritos em installation.md, sem depender apenas de pontos verdes na interface ou testes JVM.

## Relato físico e correção 0.2.2

O usuário confirmou instalação e execução no Android, MissionControl ativo e uso de Switch Lite. Relatou diálogo de pareamento repetido e controles estáticos. A captura mostra Associer à Nintendo Switch no Android sobre a tela LAYOUTS. Isso comprova uma tentativa de vínculo, não aceitação em jogo; modelo/versão Android e versões Atmosphère/MissionControl ainda não informados.

O código fechava HID/restaurava o nome ao abrir visibilidade e recriava a sessão no retorno. Também bloqueava entradas antes de concluir negociação e a página LAYOUTS era só prévia. A correção separa confirmações prévias do registro, abre a tela interativa e permite entradas após enlace para L+R.

Foi lida a documentação oficial embutida em android-stubs-src.jar do SDK Platform 35, BluetoothHidDevice.registerApp: registro é necessário e o app é desregistrado automaticamente ao deixar de estar foreground. A sessão agora usa foreground service connectedDevice durante pareamento/uso, sem requisição extra de acesso a contatos/chamadas/notificações/varredura e com encerramento finito. As confirmações Android são emitidas uma vez por tentativa; nome Pro Controller é observado antes da visibilidade.

Fonte complementar SDL (licença zlib) consultada em seu driver hidapi Switch para confirmar bits 3F de L/R. Não foi copiado código. Correções e contratos passam em JVM/build; a 0.2.2 ainda exige novo teste no aparelho/console do usuário.

## Investigação do relato físico 0.2.2
O telefone Xiaomi 2511FPC34G/Android 16 confirmou registro HID. O log mostra vínculo aceito aos 10 s, connect de saída iniciado pelo app no mesmo segundo, remoção aos 11 s e novos eventos de vínculo antes do timeout aos 25 s. Não contém confirmação de canal HID nem motivo/autor da remoção; não prova falha no mapeamento L+R ou em subcomandos Nintendo.

O serviço JoyCon Droid inspecionado adia a abertura de saída com comentário sobre evitar disputar o HID inbound do Switch. Trata-se de indício de um risco de concorrência, não prova da causa neste telefone. A 0.2.3 implementa política própria: nenhuma abertura automática após vínculo; fallback somente por ação explícita, após 5 s com vínculo aceito; perda de vínculo termina a tentativa. Não foi copiado código.

O README MissionControl explica que patches bluetooth relaxam checagens de classe e patches btm evitam fechamento imediato por SetTsi em alguns controles. Portanto módulo ativo sozinho não comprova que todos os patches correspondentes ao HOS foram instalados/carregados. Usuário confirmou HOS 21.1.0|AMS 1.10.1|E; versão MissionControl ainda pendente. Não se recomenda apagar o banco global de vínculos como primeiro teste.

Notas de versões oficiais consultadas por HTTPS: [v0.14.0](https://github.com/ndeadly/MissionControl/releases/tag/v0.14.0) adiciona HOS 21.0.0; [v0.14.1](https://github.com/ndeadly/MissionControl/releases/tag/v0.14.1) adiciona HOS 21.1.0; [v0.14.2](https://github.com/ndeadly/MissionControl/releases/tag/v0.14.2) adiciona HOS 21.2.0. Portanto 0.14.1 é a versão que introduziu suporte oficial ao sistema informado. Não se presume versão instalada nem necessidade de atualizar HOS/Atmosphère.

## Investigação física 0.2.3 e metadados 0.2.4
Novo teste: registro confirmado em 1 s, Nintendo Switch já salvo, BONDED → NONE (12 → 10) em 7 s. Nenhuma chamada connect do app, callback HID de conexão ou GET/SET/Interrupt. Isso afasta a chamada imediata como explicação desta ocorrência e não identifica o motivo da perda. A 0.2.3 erroneamente marcava o snapshot do vínculo salvo como confirmação nesta tentativa; corrigido para campos separados em 0.2.4.

O fabricante pode anexar um código opcional de remoção. Foi consultado o código Android 16 mantido pelo GrapheneOS: [BluetoothDevice](https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/framework/java/android/bluetooth/BluetoothDevice.java) e [BondStateMachine](https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/android/app/src/com/android/bluetooth/btservice/BondStateMachine.java). AOSP em android.googlesource.com retornou 403 e não é alegado como página lida. Foram usados fatos de constantes/formato para código original, sem copiar implementação.

O extra android.bluetooth.device.extra.REASON é metadado interno, não garantido pelo SDK público/OEM. O app usa somente Intent.getIntExtra no broadcast protegido; não faz reflexão, chamadas de APIs ocultas, acesso a chaves ou bypass de permissões. Ausência explícita e códigos desconhecidos são preservados. O código 9/REMOVED é usado também como fallback no stack e não deve ser atribuído automaticamente ao usuário ou ao Switch. KEY_MISSING no Android 16+ pode ser recebido com CONNECT, conforme feature flag do fabricante; é apenas observação, sem depender dela para operar ou inferir ausência de problema se não vier.

[Issue MissionControl 743](https://github.com/ndeadly/MissionControl/issues/743) confirma historicamente a relação entre patches de classe Bluetooth e JoyCon Droid sem root. Comentários antigos mencionam compatibilidade de versões JoyCon Droid/Android, não provam impossibilidade nem funcionamento deste aplicativo no Android 16. Patches experimentais antigos para HOS 16.0.x não são adequados ao HOS 21.1.0 e não foram distribuídos.

[CNX 21.1.0-0](https://github.com/CostelaCNX/CNX/releases/tag/21.1.0-0) lista Atmosphère 1.10.1 e MissionControl; [histórico de versões CNX](https://github.com/CostelaCNX/CNX/releases?page=2) registra o módulo desativado por padrão, habilitável por Ultrahand/Hekate Toolbox. Captura do usuário mostra arquivos em atmosphere/contents/010000000000bd00 e foi informado boot2 em flags. Isso verifica presença de arquivos/configuração, não execução/correspondência de patches. Solicitada conferência read-only de bluetooth_patches e btm_patches. Orientado teste de vínculo limpo removendo apenas Nintendo Switch no celular.

## Controle genérico funcional no Windows
Em 2026-10-14, usuário confirmou resposta às entradas do app 0.2.4 no joy.cpl; captura mostra SwitchPhone Gamepad e status OK. Telefone: Xiaomi 2511FPC34G/Android 16/API 36. O teste confirma funcionamento de transporte HID genérico com esse Windows, sem validar jogos, todos os controles ou modo Nintendo.

Novo teste Switch limpo registra HID em 1 s, inicia vínculo aos 38 s e perde aos 46 s (10→11→10), sem canal HID ou dados do host; razão Android 0 não detalha causa. A ordem de preparação foi testada e não solucionou esse caso. Não se infere defeito geral do rádio nem culpa exclusiva do MissionControl; diferenças de SDP, identidade/classe e política de autenticação do host continuam possíveis.

Consultadas tags oficiais v0.14.0/v0.14.1/v0.15.0 do MissionControl. v0.14.1 exige AMS >=1.10.1 no HOS 21.1.0+, compatível com os números informados. Não houve mudança nos arquivos exefs_patches entre v0.14.0 e v0.14.1: a existência das pastas ou comparação apenas desses patches não distingue a versão do módulo. O Makefile incorpora build/version no binário, tornando exefs.nsp o próximo artefato útil para conferência.

## Identificação do módulo enviado
O exefs.nsp enviado pelo usuário corresponde byte a byte ao módulo da release oficial MissionControl v0.14.2: 166310 bytes, SHA-256 4a21c9d7333d6f7944f88c2067d49c7fb5a7506e0f83fe5898c7d9abb9ce48fa. Foi apenas lido/comparado, não executado nem redistribuído. README v0.14.2 exige AMS >=1.10.2 especificamente no HOS 21.2.0+; o usuário informou HOS 21.1.0/AMS 1.10.1. Identificar o módulo não comprova sua execução nem o conteúdo dos patches no console. Referências dos arquivos bluetooth_patches e btm_patches foram preparadas para a próxima conferência.

## Conferência do ZIP de patches enviado

O ZIP btm_patches.zip contém ambas as pastas: bluetooth_patches (30 arquivos IPS) e btm_patches (29 arquivos IPS). Os 59 arquivos correspondem byte a byte aos do pacote oficial MissionControl v0.14.2; não há arquivos esperados ausentes, extras ou com conteúdo diferente nesse conjunto recebido. Não foram extraídos para execução nem redistribuídos.

Junto do exefs.nsp já identificado, isso confirma o conteúdo enviado do módulo e desses dois conjuntos de patches. Não confirma execução do módulo, aplicação de patches em memória ou compatibilidade do pareamento Android 16/Switch.

Próximo dado solicitado: estado MissionControl no Hekate Toolbox → Background services imediatamente após reiniciar no Atmosphère e antes de alterar botões. O código consultado do Hekate Toolbox consulta pmdmntGetProcessId ao abrir a tela, diferente de verificar apenas boot2. Alterar a chave de um módulo requires_reboot pode atualizar o estado visual segundo o flag; por isso a observação deve ser feita em abertura nova após reinício, antes de tocar no botão.

Fonte inspecionada: https://github.com/WerWolv/Hekate-Toolbox/blob/c3a9be6158e18267564c6785948d24d84fa3f683/source/gui/gui_sysmodule.cpp . Foi lida para entender a indicação; não foi copiado código nem executado o aplicativo Switch neste ambiente. Uma indicação Off também pode depender de sucesso de acesso à API do gerenciador, e deve ser interpretada com o contexto da execução.

## Teste Nintendo no Windows e coleta nativa — 0.2.5

Usuário confirmou MissionControl On ao abrir Background services após reiniciar, antes de alterar botões. Módulo e 59 patches recebidos já foram comparados byte a byte com v0.14.2 oficial; aplicação em memória não inspecionada. Não é justificável repetir a instalação sem outra evidência.

Mantendo Xiaomi/Windows, destino Switch experimental conectou como Pro Controller: callback HID CONNECTED aos 49 s, sete relatórios aceitos, L+R aos 57 s, nenhum GET/SET/Interrupt. NEGOTIATING é esperado sem comando Nintendo do host; não comprova funcionamento Nintendo. O verde da 0.2.5 sinaliza canal HID e a mensagem mantém negociação pendente, sem fabricar ACTIVE ou retirar timeout.

BondStateMachine.java Android 16 consultado registra bondStateChangeCallback com status, newState e hciReason. Só status participa do motivo enviado no broadcast; hciReason não chega ao app. Coletor original PowerShell separado usa ADB autorizado, filtro PID de com.android.bluetooth, horário atual/logcat -T e exportação numérica estrita. Não requer root, APIs privadas ou compartilhamento de HCI/bugreport completo. A implementação Xiaomi pode não emitir a linha ou usar outro processo; ausência de evento permanece explícita.

Android Platform-Tools Windows 37.0.1 verificado via manifesto oficial https://dl.google.com/android/repository/repository2-3.xml: 8044989 bytes, SHA-1 e03e78b1d80b396f1c3358e31251cb31740e1110; SHA-256 calculado após verificação 45f4d63113e895ebde0c90f194099a4676b6ac653bd28d54314a9e022bbc1a99. Coletor baixa da origem oficial; não redistribui binários. PowerShell de teste v7.6.7 verificado contra hashes.sha256 da release oficial; testes Linux com ADB simulado não equivalem a teste Windows/USB.

### Correção do filtro logcat no coletor 1.1.0

JSON recebido: 90 s, no_events, lista vazia. ADB autorizado e processo encontrado não equivalem a evento de pareamento capturado. Utils.java Android 16 obtido por HTTPS define TAG_PREFIX_BLUETOOTH="Bluetooth"; BondStateMachine.java usa esse prefixo com class.getSimpleName(). Portanto a tag da referência é BluetoothBondStateMachine; o filtro anterior só BondStateMachine era incompleto. A correção cobre ambas as tags, sem ampliar para logs arbitrários ou exportar conteúdo bruto. Regressão reproduziu a captura vazia antes e recebeu eventos depois, com filtro modelado no ADB simulado. Não prova que esse era o único motivo da ausência na Xiaomi nem revela a causa da falha Switch.

Fonte: https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/android/app/src/com/android/bluetooth/Utils.java .

### Coleta 1.1.0 recebeu 21 linhas, nenhuma convertida

Mesmo teste app 0.2.4: vínculo salvo removido aos 7 s sem canal HID; motivo público 0. O JSON 1.1.0 recebeu 21 linhas não reconhecidas; o conteúdo não foi exportado, logo não há base para atribuir a falha a uma das pontas. 1.2.0 tenta ler registros já existentes, amplia somente o reconhecimento de campos conhecidos e acrescenta contagens de marcadores, sem salvar conteúdo bruto.

Fontes Android 16 consultadas: https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/system/btif/src/btif_dm.cc , https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/system/stack/include/hci_error_code.h , https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/android/app/jni/com_android_bluetooth_btservice_AdapterService.cpp . A camada nativa pode registrar aviso de autenticação antes do callback Java; códigos conhecidos são exportados em native_failures separado, sem fabricar um callback completo. Não se afirma que a Xiaomi necessariamente emita esses avisos.

### Leitura do histórico nativo BTM no coletor 1.3.0

O JSON 1.2.0 retornou 41 linhas, três marcadores de vínculo e nenhum callback/código esperado. Novo caminho foi confirmado no código: BTM_LogHistory registra CBACK Bond state changed com bt_status, bond_state e reason; DumpsysBtm imprime a seção shim::btm; a cadeia dumpsys bluetooth_manager → AdapterService → dump nativo a inclui. O leitor exporta somente campos conhecidos dessa seção, mantendo todo o dump bruto em memória e descartando os demais dados. Não se afirma que o OEM Xiaomi tenha mantido esse histórico disponível.

Fontes adicionais: https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/system/stack/btm/btm_main.cc , https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/system/btif/src/bluetooth.cc , https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/system/include/hardware/bluetooth.h , https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/service/src/com/android/server/bluetooth/BluetoothManagerService.java . Clone raso público usado para resolver caminhos que retornaram 404; fatos de formatos/constantes apenas.
