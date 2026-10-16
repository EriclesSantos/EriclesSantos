# Pesquisa: apps existentes, MissionControl e compatibilidade no navegador

Pesquisa conferida em 16/10/2026. Análise de documentação, código e pacotes oficiais, comparada aos resultados físicos enviados pelo usuário. Nenhum rádio, Windows, telefone ou console foi controlado por esta sessão. Não houve novo APK nem novo coletor.

**A pista mais forte para o Switch é uma correção oficial posterior ao MissionControl 0.14.2 instalado: a versão 0.16.0 amplia o filtro de classes Bluetooth para JoyCon Droid sem root, inclusive no patch da família HOS 21.x.** Para o navegador há uma diferença separada de mapeamento do HID genérico. A falha do dongle ainda não tem diagnóstico suficiente para escolher uma causa.

**MissionControl: correção concreta e verificável**

A [release oficial 0.16.0, de 02/10/2026](https://github.com/ndeadly/MissionControl/releases/tag/v0.16.0), inclui no changelog:

> Modified device class check patch to allow JoyconDroid (non-root) to accept a broader range of devices

O [commit de 24/07/2026](https://github.com/ndeadly/MissionControl/commit/8796a58f679adbbafce81c7f8d010468a6c8bf94) introduziu a ampliação. A conferência anterior identificou corretamente os arquivos do usuário como oficiais 0.14.2. A nova pesquisa mostra que essa versão é anterior à correção; módulo ativo e controles físicos funcionando não validam o mesmo filtro aplicado a um smartphone.

O patch `68C915388537833D1AC9F3920708A1A0FF73E35A.ips` aparece no [suporte a HOS 21.0.0](https://github.com/ndeadly/MissionControl/commit/41606c08cfe784ac3eb02f80800a5f92cd3496f5). O [suporte a 21.1.0](https://github.com/ndeadly/MissionControl/commit/141b3aca32581b38f219457614648fc9770cd6cd) não altera os IPS Bluetooth; os pacotes 0.14.0/0.14.1/0.14.2 os mantêm iguais. A versão 0.16.0 altera esse arquivo, embora seu tamanho permaneça 923 bytes. O arquivo novo coincide byte a byte com o commit corretivo de julho.

Na desmontagem ARM64 da região relevante, a extração antiga `lsr w0,w8,#8` passou a `ubfx w0,w8,#8,#5`: a nova isola os cinco bits da classe principal e exclui bits adicionais da comparação. O [framework Android 16](https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/framework/java/android/bluetooth/BluetoothClass.java) define PHONE=0x0200, máscara de classe principal=0x1F00, Limited Discoverability=0x2000 e LE Audio=0x4000. Esses flags podem interferir na extração antiga. Há também alterações em chamadas no patch; não se atribui toda a mudança a uma instrução.

Isso explica tecnicamente como controles físicos podem funcionar enquanto alguns celulares não são aceitos. **A classe real anunciada pelo Xiaomi/Galaxy não foi medida, portanto ainda é uma hipótese para o caso concreto, não a causa comprovada.** A função C++ de MissionControl que renomeia resultados de busca já ignorava bits de serviço; a correção importante é no filtro nativo IPS, uma etapa diferente.

Próxima comparação fundamentada: usar uma instalação oficial compatível de MissionControl 0.16.0, preservando cópia da instalação anterior e seguindo as instruções do projeto. Evitar misturar patches de builds distintos ou instalar o patch experimental antigo de HOS 16.x. O [README 0.16.0](https://github.com/ndeadly/MissionControl/blob/v0.16.0/README.md) declara suporte a todos os firmwares, recomenda Atmosphère atualizado e exige AMS>=1.12.0 especificamente para HOS 23.0.0+. Isso não exige atualizar o HOS 21.1.0 do usuário para 23, mas não comprova fisicamente a combinação exata MC0.16.0/AMS 1.10.1/HOS 21.1.0. A release alerta que houve refatoração e possíveis regressões.

Depois da atualização, a comparação com o mesmo APK deve usar **Switch experimental → Padrão • aguardar Switch**, que mantém o protocolo Nintendo e permite Confirmar L+R após canal real. O Teste 4 usa relatórios genéricos e não comprova mapeamento de jogo, mesmo se o canal passar a abrir. Não é necessário emitir outro APK para avaliar primeiro essa correção do console.

**Comparação com projetos existentes**

| Projeto | O que faz e quais requisitos importam | Relação com o SwitchPhone |
| --- | --- | --- |
| JoyCon Droid | Usa BluetoothHidDevice Android, nome Pro Controller/Joy-Con, subclasse8 e protocolo Nintendo. A documentação apresenta root para os ajustes em Switch sem modificações, mas registra explicitamente a exceção MissionControl sem root. | O caminho sem root tem precedente oficial. Isso não comprova Android16 + este Xiaomi + HOS 21.1.0. |
| JoyCon Droid Companion | Módulo Magisk que modifica a classe real do rádio a cada escrita HCI e pode tornar persistentes vínculos classificados como temporários. | Mostra que o APK e o descritor não controlam todas as propriedades necessárias. O caso específico de vínculo temporário/Security_Block é documentado para Switch2; não prova a falha do Switch Lite. |
| NXBT e joycontrol | Usam Linux/BlueZ, SDP próprio, classe de rádio configurada e sockets L2CAP diretos. A interface web no telefone pode controlar o Bluetooth do servidor Linux. | Esse controle e esses privilégios não equivalem à API pública de um APK Android. Relatos antigos de sucesso não validam HOS 21.1.0/Android16. |

Fontes primárias: [FAQ JoyCon Droid: exceção sem root/MissionControl](https://github.com/TeamJCD/JoyConDroidDocs/blob/47c11d271d44d38c7c6516e2c726cd3a5e02be8c/faq.md#is-there-really-no-way-to-use-a-non-rooted-android), [Companion e distinção Switch1/Switch2](https://github.com/TeamJCD/JoyConDroidCompanion/blob/c4181daf04f31b9d0a5c81351bcf18a874059277/README.md), [hook de classe](https://github.com/TeamJCD/JoyConDroidCompanion/blob/c4181daf04f31b9d0a5c81351bcf18a874059277/src/cod.c#L51), [hook de vínculo](https://github.com/TeamJCD/JoyConDroidCompanion/blob/c4181daf04f31b9d0a5c81351bcf18a874059277/src/bond.c#L75), [NXBT conexão/classe](https://github.com/Brikwerk/nxbt/blob/ec4b800ad6c55de96bb6c7f9f84b5bdc59a4c975/nxbt/controller/server.py#L335), [joycontrol](https://github.com/mart1nro/joycontrol/blob/18a09da1a04306534ff9e1df8a1a69c0192a3244/README.md).

No [JoyCon Droid 1.1.3](https://github.com/TeamJCD/JoyConDroid/blob/1.1.3/app/src/main/java/com/rdapps/gamepad/service/BluetoothControllerService.java#L436), há diferenças configuráveis: SDP Wireless Gamepad/Gamepad/Nintendo, QoS explícito e conexão cerca de 2 s após vínculo em determinados caminhos; SwitchPhone usa outros textos SDP, QoS nulo e os testes de saída esperam 5 s. Provider="Nintendo" é texto, não VID Nintendo. Tais diferenças podem ser comparadas no app, mas nenhuma fonte consultada prova que sejam a correção deste bloqueio antes de HID. Busca ativa não é um requisito demonstrado: JoyCon Droid também usa visibilidade e aguarda o host no fluxo normal.

A [issue103 do JoyCon Droid](https://github.com/TeamJCD/JoyConDroid/issues/103#issuecomment-2949322444) contém relato de funcionamento em Redmi A3 com MissionControl e desconexão em Poco X7 Pro. É um relato útil de variabilidade entre telefones, sem correção comprovada para o modelo do usuário. Não foi localizada confirmação verificável da combinação exata Xiaomi2511FPC34G/Android16/HOS 21.1.0/MC0.14.2.

O [código público Android16](https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/456fc9eea5d50b44b621b3bd3083856800653492/system/btif/src/btif_dm.cc) possui caminhos de vínculo temporário que não preservam chaves, e a camada HID exige autenticação/criptografia nativa. Isso sustenta investigar persistência/segurança; não transforma código0 ou ausência de BONDED do app em prova desse caminho. Não se recomenda root nem o Companion como solução garantida para este Switch Lite.

**Notebook e jogo de navegador**

Usuário relatou pareamento e resposta no teste de controles do Windows com Bluetooth integrado. No jogo de navegador chamado dragonballbudokai3online, somente X respondeu. A URL, navegador e configurador do site ainda não foram recebidos; não se presume que o jogo usa SDL, um emulador específico ou apenas XInput.

O descritor e o payload atuais são coerentes como HID genérico: ID1, 7 bytes, 16 bits de botões (14 usados), quatro eixos assinados e hat. A auditoria não encontrou uma ramificação que envie apenas X. Há, entretanto, diferenças para o layout padrão da Web:

| Aspecto | Perfil atual do SwitchPhone | Gamepad API padrão |
| --- | --- | --- |
| Botões de face | 0–3 | 0–3 |
| Botões10/11 | Home/Capture | L3/R3 |
| Botões12–15 | L3/R3 e sem botões14/15; direcional em hat | Direcional cima/baixo/esquerda/direita |
| Analógicos em Chromium Windows RawInput sem mapper | Usos X/Y/Rx/Ry podem produzir eixos0,1,3,4; hat no eixo9 | Sticks nos eixos0,1,2,3 |

A [especificação W3C](https://github.com/w3c/gamepad/blob/81ad0752c4dd06011722b158314eef68cbc2460d/index.html) e o [MDN](https://github.com/mdn/content/blob/a8b5a77bb154e0c3a124fb4af441d11e4259836e/files/en-us/web/api/gamepad/mapping/index.md) distinguem mapping="standard" de controles sem mapeamento conhecido. No [Chromium Windows](https://github.com/chromium/chromium/blob/6bcbefb7cfb334bf29f1b62ab20aae6b8e58b027/device/gamepad/raw_input_gamepad_device_win.cc#L567), usos HID desconhecidos podem deixar lacunas nos índices dos eixos. O [mapper por dispositivo](https://github.com/chromium/chromium/blob/6bcbefb7cfb334bf29f1b62ab20aae6b8e58b027/device/gamepad/gamepad_standard_mappings_win.cc#L604) pode não reconhecer a identidade do telefone.

Isso pode afetar direcional, analógicos e menus. Os quatro botões de face já usam a ordem esperada, portanto não explica sozinho somente X responder. A próxima análise útil é ler a página indicada pelo usuário e identificar sua configuração de controle. Selecionar layout Xbox no app não implementa XInput. Uma opção futura de relatório para navegador poderia alinhar botões/eixos raw, mas não foi implementada nem garantiria mapping="standard" ou funcionamento neste site.

**Desktop/dongle e acesso local**

O usuário informou que o dongle pareia outros aparelhos, mas falha com SwitchPhone. Isso não identifica a camada: descoberta, vínculo e canal HID são etapas distintas. O diagnóstico do app já existente foi solicitado para essa tentativa; não há necessidade de instalar outro coletor. Um teste isolado deve manter apenas o desktop como host pretendido, sem uma conexão simultânea do notebook, pois o app mantém uma única sessão HID.

Em16/10, apesar da autorização do usuário, as ferramentas expõem somente Linux/workspace em nuvem: não há Windows, rádio Bluetooth ou USB do computador anexados. A autorização permite agir quando houver um canal técnico, mas não cria acesso remoto. Nenhum teste local de jogo/dongle foi anunciado como executado. Não foi alterado driver Windows, biblioteca Android, firmware, MissionControl ou configuração do console.
