# Comparação: SwitchPhone, DualShock 4 e DualSense

**Pesquisa atualizada em 16/10/2026:** [correção oficial MissionControl 0.16.0, comparação com JoyCon Droid/Companion e mapeamento no navegador](research-2026-10-16.md). O filtro nativo de classes de celulares mudou depois da0.14.2; é uma nova pista concreta, ainda sem validação no console do usuário.

Análise em 14/10/2026 usando código e evidências já disponíveis. Novas coletas suspensas a pedido do usuário. Não há correção física definitiva demonstrada; o APK não foi alterado para disfarçar essa limitação.

## Conclusão

Há diferenças de protocolo: PS4/PS5 usam drivers Sony no MissionControl; o app tenta emular Nintendo. Porém driver ou VID/PID Sony não são requisitos universais para parear: MissionControl também admite vários controles genéricos, inclusive ainda sem mapeamento. Essas diferenças não identificam a causa desta perda de vínculo. A falha registrada acontece antes de abrir HID, portanto não há evidência de que trocar CRC, botões, L+R ou comandos de jogo resolva o pareamento.

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

Uma integração dedicada no MissionControl só é uma alternativa para a etapa posterior de tradução de entradas, se necessária; não está demonstrada como solução da perda pré-HID: o app já tem relatório genérico próprio e funcional no Windows; um driver correspondente poderia reconhecer esse serviço e traduzir seus campos para Switch. Isso exige desenvolvimento/coerência de identificação e validação no console. Não está implementado nem garante resolver uma eventual incompatibilidade de autenticação anterior. Também não exige fingir identidade Sony. Outra arquitetura possível seria uma ponte de rede/homebrew, mas ela muda o transporte solicitado e não foi adotada silenciosamente.

Estado honesto da entrega: PC funcional no escopo relatado; Switch experimental ainda sem conexão demonstrada. Não se recomenda atualizar/apagar configurações do console ou fazer root com base nesses dados. Esta comparação foi documental. A atualização posterior 0.2.6 implementa testes opcionais de vínculo/canal HID, ainda sem sucesso físico confirmado.

## Fontes efetivamente inspecionadas

- [MissionControl 0.14.2: identificação e seleção de driver](https://github.com/ndeadly/MissionControl/blob/e8d4623c/mc_mitm/source/controllers/controller_management.cpp).
- [MissionControl 0.14.2: handler após HID Opened](https://github.com/ndeadly/MissionControl/blob/e8d4623c/mc_mitm/source/bluetooth_mitm/bluetooth/bluetooth_hid.cpp).
- [IDs DualShock 4](https://github.com/ndeadly/MissionControl/blob/e8d4623c/mc_mitm/source/controllers/dualshock4_controller.hpp) e [DualSense](https://github.com/ndeadly/MissionControl/blob/e8d4623c/mc_mitm/source/controllers/dualsense_controller.hpp). Implementações Sony atuais também consultadas para relatórios/inicialização, sem copiar código GPL para o app.
- [API Android 16 SDP, árvore mantida pelo GrapheneOS](https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/framework/java/android/bluetooth/BluetoothHidDeviceAppSdpSettings.java) e implementação nativa bta_hd_act.cc da mesma árvore. São referência, não decompilação do firmware Xiaomi.
- Código próprio: HidSession, IdentityLease, NintendoDescriptor/Protocol e ControllerState. Análise estática e comparação dos logs recebidos; nenhuma nova validação de rádio foi simulada como sucesso.

## Esclarecimento após o teste com controles paralelos

Usuário confirmou uso de vários controles paralelos, inclusive AliExpress, no Switch. Isso é consistente com o README oficial 0.14.2: seção Other Controllers recomenda modos HID/PC/Android; controles ainda não suportados podem parear e aparecer com botões vermelhos por falta de mapeamento. O código cria UnknownController no caso não identificado; a seleção ocorre depois de HID Opened. Logo não é correto tratar VID/PID Sony ou driver dedicado como requisito para passar pelo pareamento.

A recomendação anterior de um driver próprio foi prematura como correção deste bloqueio. Sem HID aberto, adicionar tradução de botões não resolve por si só a etapa anterior. A versão do app ainda pode ter problemas de emulação posteriores, mas não foram atingidos nos logs.

O bloqueio observado fica no estabelecimento do vínculo/enlace HID. Candidatos são autenticação/segurança, anúncio SDP/HID e verificações de classe/aceitação específicas ao aparelho. O nome Pro Controller não comprova equivalência nesses campos. Não há código HCI nos dados enviados que permita escolher entre esses candidatos; não se declara causa Android 16, classe de telefone ou falta de patch como comprovada. Arquivos de patches conferidos não comprovam aplicação em memória; um controle funcionando não exercita necessariamente todas as verificações exigidas por outro.

Fonte exata: [README MissionControl 0.14.2, Other Controllers](https://github.com/ndeadly/MissionControl/blob/e8d4623c/README.md#other-controllers), parágrafo que começa Controllers that successfully pair but haven't been officially supported yet; e default UnknownController em controller_management.cpp da mesma release. Essa revisão foi documental; veja a atualização experimental posterior abaixo.

## Atualização posterior: testes opcionais 0.2.6

A pedido do usuário, o app passou a permitir manter o registro HID por até 12 s após a primeira perda do vínculo e solicitar uma única abertura de canal após 5 s de vínculo estável. São opções separadas e combináveis no Início → Escolher teste de conexão, sem mudar autenticação ou identidade do rádio. O modo Padrão continua passivo. Isso testa duas decisões do aplicativo antes de concluir que dependem exclusivamente do stack/console. Nenhuma hipótese foi convertida em causa comprovada. Veja as instruções do APK no README.

## Resultado físico recebido: três testes da 0.2.6

Xiaomi 2511FPC34G, Android 16/API 36, destino Switch e layout Nintendo. Nenhuma das três tentativas abriu o canal HID: zero GET/SET/Interrupt e envios; modo Nintendo nunca negociado. Estado atual HID=false no relatório final resulta da limpeza após erro, não demonstra desregistro antes da falha.

| Teste | Eventos observados | O que permite concluir |
| --- | --- | --- |
| 1: retenção do registro | Registro aos 4 s; BONDING 15 s; BONDED 22 s; NONE 24 s. O app reteve HID/nome; BONDING 25 s; BONDED 27 s; NONE 29 s. Sem callback de conexão HID. | Houve confirmação real do vínculo, duas vezes. A retenção permitiu observar nova tentativa, mas a queda repetiu enquanto o registro estava mantido. Encerrar o perfil na primeira perda não é explicação suficiente desta ocorrência. |
| 2: abertura após 5 s | Vínculo salvo observado e registro em 1 s; connect solicitado aos 6 s; callback CONNECTING/1 aos 6 s e DISCONNECTED/0 aos 7 s. Sem CONNECTED/2. Nenhuma perda de vínculo observada antes do encerramento. | O caminho de saída foi executado e falhou antes do canal ficar disponível. Simples ausência de connect não explica esse caso; não se prova rejeição pelo console, pois o callback não fornece autor/motivo. |
| 3: combinado | Vínculo salvo em 1 s; NONE e novo BONDING em 4 s; NONE em 9 s; nenhum BONDED novo. | Nunca atingiu 5 s de vínculo estável; a parte de abertura HID não foi executada. Não equivale a testar as duas ações completadas em sequência. |

Os experimentos não resolveram o pareamento. Continuam possíveis problemas de autenticação, serviço SDP/HID anunciado ou abertura do enlace, sem código nativo para escolher a causa. BONDED local não garante vínculo utilizável pelos dois lados; callback CONNECTING não confirma canal aberto. Não há evidência de erro de L+R ou formato dos relatórios como causa dessas falhas, pois nenhum relatório foi trocado.

O motivo 0 continua desconhecido. O texto genérico do app para conferir patches não é nova evidência contra MissionControl: módulo e arquivos já foram conferidos. Não se pede repetir estes testes, novos coletores, root ou atualização do console. APK 0.2.6 permanece idêntico; atualização apenas da documentação com a validação física recebida.

## Relato posterior: destino PC no Switch e comparação 0.2.7

Usuário informou que o console não encontrava o telefone no destino PC, permanecendo na procura. Não foi recebido diagnóstico dessa tentativa; isso não demonstra a etapa interna de falha. A sugestão de comparar PC com Switch era limitada: PC restaura o nome original do rádio e também muda descritor/relatórios. Logo não isola rejeição do descritor genérico.

Foi adicionado Teste 4 na 0.2.7: destino Switch conserva nome de rádio Pro Controller e os mesmos textos/subclasse solicitados SDP; usa DiagnosticDescriptor e relatórios ID 1 do caminho PC. É uma comparação dos perfis mantendo a identificação nominal, sem mudar política de autenticação/classe de rádio. Não se presume que o nome causou a falha anterior. Cache no console e estado dos vínculos ainda podem afetar o resultado.

O teste é passivo, sem combinar as alternativas 1–3. Conexão fica verde só após canal real; negociação Nintendo é não aplicável e Confirmar L+R fica inativo. Um canal genérico eventualmente aberto não prova controles mapeados no MissionControl. O teste físico posterior falhou com vínculo salvo e sem vínculo salvo no Android; detalhes abaixo.

## Resultado físico 0.2.7: perfil genérico com vínculo removido no celular

Xiaomi 2511FPC34G/Android 16/API 36, destino Switch, Teste 4. O usuário enviou duas tentativas:

| Tentativa | Eventos observados | Limite da conclusão |
| --- | --- | --- |
| Vínculo salvo | Nome confirmado, HID registrado aos 3 s, host previamente associado pelo perfil=true, vínculo salvo encontrado=true, sem BONDED novo; BONDED→NONE aos 17 s. Sem callback de conexão HID. | Perfil genérico não abriu canal com essa associação anterior. Isoladamente não representava pareamento novo. |
| Após remover o vínculo no celular | Nome confirmado aos 0 s; HID registrado aos 1 s; host previamente associado pelo perfil=false; vínculo salvo encontrado=false; BONDING aos 14 s e NONE aos 20 s, sem BONDED. Sem callback HID (-1), pedidos do host ou envios. Motivo Android 0. | A troca para descritor/relatórios genéricos também não resolveu essa tentativa sem vínculo salvo no Android. Reutilização de associação no telefone não explica sozinha esse caso. |

O app estava em READY até receber a falha; o registro/nome foram limpos depois. Portanto HID=false e nome Pro Controller=false no relatório final são consequências do encerramento. O log confirma registro do perfil e início do vínculo, mas não confirma autenticação completada, leitura SDP pelo console ou canal HID.

Nome Pro Controller, campos SDP solicitados e políticas do Android são comuns aos perfis comparados. A falha com o descritor genérico não exclui problemas nessas partes compartilhadas; também não permite afirmar que o descritor Nintendo estava correto. Nenhum comando de botões foi trocado. Motivo 0 continua sem descrição conhecida, sem autor/motivo nativo da interrupção.

Resultado: as alternativas de retenção após perda, conexão de saída após vínculo estável e troca para perfil genérico não demonstraram compatibilidade com esse Switch. Não há correção definitiva comprovada no APK. Não se atribui defeito exclusivamente ao telefone, ao console ou ao MissionControl, nem se recomenda repetir os mesmos testes, novos coletores, root ou atualização do console com base nesses dados. O próximo avanço técnico exige evidência nova de uma diferença concreta de identidade/serviço/segurança ou da causa nativa; simplesmente alterar tempos, botões ou emitir outro APK não é uma correção fundamentada.
