# Comparação: SwitchPhone, DualShock 4 e DualSense

Análise em 14/10/2026 usando código e evidências já disponíveis. Novas coletas suspensas a pedido do usuário. Não há correção física definitiva demonstrada; o APK não foi alterado para disfarçar essa limitação.

## Conclusão

A diferença principal não é Bluetooth antigo/novo nem layout: PS4/PS5 usam protocolos Sony e drivers próprios no MissionControl; o app se anuncia como Pro Controller e tenta emular Nintendo diretamente. A falha registrada acontece antes de abrir HID, portanto não há evidência de que trocar CRC, botões, L+R ou comandos de jogo resolva o pareamento.

O console aceitou ao menos um dos controles PS4/PS5; o app funcionou com Windows; um Galaxy apresentou comportamento semelhante ao Xiaomi segundo o usuário, ainda sem modelo/Android/log. Isso concentra a investigação na interoperabilidade app/Android→Switch, sem provar qual verificação de identidade, SDP, autenticação ou abertura de enlace falhou.

## Semelhanças e diferenças

| Aspecto | DualShock 4 / DualSense | SwitchPhone atual |
|---|---|---|
| Transporte do caminho comparado | Bluetooth clássico BR/EDR + HID | Bluetooth clássico BR/EDR + HID Device Android |
| Quem controla o rádio e pareamento | Firmware do controle | Sistema Bluetooth do Android/fabricante; app usa API pública |
| Identificação | Sony VID 054c; DS4 PID 05c4/09cc; DS5 PID 0ce6/0df2 | Nome temporário Pro Controller e descritor próprio; API usada não fornece campos VID/PID |
| Classe | Identidade de controle definida pelo firmware | App pede subclasse HID gamepad; isso sozinho não mede/confirma toda a classe de rádio apresentada |
| Tratamento MissionControl | Identifica VID/PID e seleciona driver DualShock4/DualSense | Reconhecimento pelo nome Pro Controller pode selecionar o caminho Switch; isso não transforma a identidade física Android em Nintendo |
| Comandos após conexão | DS4 usa relatórios como 11; DS5 como 31, inicialização/features/CRC próprios; MissionControl traduz para Switch | Emulação parcial Nintendo, relatórios 3f/21/30; IMU/NFC/rumble/manual pairing não implementados |
| Resultado físico recebido | Ao menos um controle conectou e funcionou no Switch | Windows abre HID; Switch remove vínculo antes de callback HID |

IDs e protocolos acima são fatos do código de referência, não leituras de rádio dos controles específicos do usuário. O modelo exato Sony que funcionou não foi discriminado.

## O que o código comprova

A própria release MissionControl v0.14.2/e8d4623c foi consultada. Identify verifica VID/PID Sony para os drivers Sony; nomes oficiais Nintendo, incluindo Pro Controller, têm outro caminho. AttachHandler é chamado no evento HID Opened. Logo o tradutor de botões Sony entra depois da etapa que falta no diagnóstico do app. Isso também significa que a diferença de VID/PID não está demonstrada como causa desta perda anterior ao HID.

BluetoothHidDeviceAppSdpSettings no Android recebe somente nome, descrição, provedor, subclasse e descritor. O app usa esse construtor e registerApp. Não há nele parâmetros para escolher VID/PID Sony/Nintendo, endereço físico ou política completa de autenticação. O nome provider não é um vendor ID. O endereço virtual da resposta Nintendo é um campo de relatório posterior ao HID e não altera o endereço de rádio.

Por isso renomear o app para Wireless Controller/PS4, mudar layout ou trocar apenas os bytes de entrada não reproduz a identidade e o pareamento de um controle Sony. Também não há base para afirmar que Android 16 seja universalmente incapaz: o mesmo registro HID abriu no Windows e outros OEM/versões podem ter comportamento diferente.

## Localização da falha

Sequência: descoberta/identificação → vínculo/autenticação e descoberta de serviços → canal HID → inicialização do protocolo → botões. Parte dessas etapas pode se intercalar conforme o host. Nos testes Switch não foi observado callback de conexão HID; GET/SET/Interrupt e envios são zero. Última tentativa com vínculo salvo: registro em 1 s e remoção aos 7 s, código Android 0. Teste anterior sem vínculo salvo também falhou antes do HID.

Os JSONs não revelaram HCI reason: 1.1.0 recebeu 21 linhas não convertidas; 1.2.0 recebeu 41, com três marcadores de vínculo e nenhum campo de causa. Não se pode extrair a causa de campos que não existem nesses arquivos, nem atribuir a remoção exclusivamente ao console ou ao telefone.

## Caminho de correção

A camada a corrigir é a interoperabilidade antes do canal HID, envolvendo a identidade/serviço anunciado pelo Android e a aceitação pelo Switch. O protocolo parcial Nintendo também precisará de validação depois, mas não foi alcançado nos relatos atuais. Não foi encontrada uma mudança comprovadamente corretiva no código do APK que justifique anunciar outra versão como solução definitiva.

Uma integração dedicada no MissionControl para o HID genérico do SwitchPhone é uma alternativa de engenharia: o app já tem relatório genérico próprio e funcional no Windows; um driver correspondente poderia reconhecer esse serviço e traduzir seus campos para Switch. Isso exige desenvolvimento/coerência de identificação e validação no console. Não está implementado nem garante resolver uma eventual incompatibilidade de autenticação anterior. Também não exige fingir identidade Sony. Outra arquitetura possível seria uma ponte de rede/homebrew, mas ela muda o transporte solicitado e não foi adotada silenciosamente.

Estado honesto da entrega: PC funcional no escopo relatado; Switch experimental ainda sem conexão demonstrada. Não se recomenda atualizar/apagar configurações do console ou fazer root com base nesses dados. Não foram criados novos coletores nem outro APK nesta comparação.

## Fontes efetivamente inspecionadas

- [MissionControl 0.14.2: identificação e seleção de driver](https://github.com/ndeadly/MissionControl/blob/e8d4623c/mc_mitm/source/controllers/controller_management.cpp).
- [MissionControl 0.14.2: handler após HID Opened](https://github.com/ndeadly/MissionControl/blob/e8d4623c/mc_mitm/source/bluetooth_mitm/bluetooth/bluetooth_hid.cpp).
- [IDs DualShock 4](https://github.com/ndeadly/MissionControl/blob/e8d4623c/mc_mitm/source/controllers/dualshock4_controller.hpp) e [DualSense](https://github.com/ndeadly/MissionControl/blob/e8d4623c/mc_mitm/source/controllers/dualsense_controller.hpp). Implementações Sony atuais também consultadas para relatórios/inicialização, sem copiar código GPL para o app.
- [API Android 16 SDP, árvore mantida pelo GrapheneOS](https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/framework/java/android/bluetooth/BluetoothHidDeviceAppSdpSettings.java) e implementação nativa bta_hd_act.cc da mesma árvore. São referência, não decompilação do firmware Xiaomi.
- Código próprio: HidSession, IdentityLease, NintendoDescriptor/Protocol e ControllerState. Análise estática e comparação dos logs recebidos; nenhuma nova validação de rádio foi simulada como sucesso.
