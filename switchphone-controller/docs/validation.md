# Validação 0.2.8 experimental

- 6.983 asserções JVM aprovadas: 2.574 já existentes, 4.194 de geometria, 194 de reconexão e 21 de tráfego Nintendo opcional. Os testes cobrem três layouts, seis proporções, limites/colisões, associação salva, sessões repetidas, permissões, foco e callbacks tardios. A regressão Nintendo intercala 2.000 pedidos de IMU com 2.000 pacotes de vibração e verifica comandos intactos, avisos agrupados, contadores e rejeição de pacotes inválidos.
- `assembleRelease lintRelease assemblePreview lintPreview`: BUILD SUCCESSFUL. Lint: 0 erros e 1 aviso conhecido de orientação fixa por variante.
- Preview: `com.switchphone.controller.preview`, versionCode 10, versionName 0.2.8-experimental-preview, label Nördhub ProController Preview, minSdk 28/target 35. Assinatura v2 e zipalign aprovados; não depurável.
- SHA-256 APK Preview: `a7da0be8343e44ecf21c607ab53d25dd4061c10ff3f20e40ba9e7174730337b3`. Certificado de teste diferente da assinatura antiga; instalação separada.
- 45 verificações de mapeamento Windows aprovadas. Teste nativo criou um alvo Xbox, leu estado neutro pela API XInput e confirmou que o alvo sumiu após Dispose. Corrigida a inicialização para não manter o pacote de eixos não nulos do estágio inicial do driver; causa conferida no código oficial XusbPdo.
- A Steam detectou Xbox 360 Controller e reservou slot XInput. Teste com o celular durante 180 segundos: 5.892 leituras encaminhadas, 234 mudanças de entrada, botões e magnitude de eixo até 32.768. Não significa aceitação pelo jogo.
- O usuário informou que o ícone de controle passou a aparecer na Steam, mas os analógicos não funcionaram no Dimraeth. Suporte em jogo continua sem aprovação.
- DuckStation no Switch/The King of Fighters ’97: sem comandos no emulador, mas comandos funcionando no HOME, conforme usuário. A 0.2.8 corrige inundação do histórico por avisos alternados de recursos ausentes e evita reiniciar o fluxo periódico a cada resposta ao host. O perfil de jogador/porta do emulador ainda precisa ser conferido; não se declara o jogo corrigido.
- Emulador Android sem aceleração disponível não completou o boot, inclusive na tentativa por software. Não houve captura de tela Android nem teste da UI real. As imagens de layout são prévias vetoriais geradas da geometria, explicitamente identificadas.
- Nenhum driver foi instalado/atualizado; configuração Steam, filtros HidHide e arquivos do jogo não foram alterados. A chave de distribuição original continua ausente. O usuário autorizou desinstalar o APK antigo e substituir a distribuição no GitHub; uma nova chave estável de distribuição foi gerada localmente, sem publicação do material privado. O certificado novo é `6a00bcc9490e4b18de625901486ea39bb6d1fbb3b3147acc2fe4ca1f5200913c`. O APK principal usa o applicationId original, exige a reinstalação autorizada e tem assinatura v3/zipalign verificados.

## Histórico da 0.2.7

- assembleRelease e lintRelease: BUILD SUCCESSFUL, 0 erros e 1 aviso conhecido de orientação paisagem fixa.
- 2.574 asserções JVM aprovadas: ControllerState 28; NintendoProtocol 2.157; PairingFlow 126; InputRouter 106; PairingPulse 8; BondMonitor 39; BondFailure 22; LinkExperiment 61; HidProfile 27.
- Novos contratos verificam igualdade de nome/descrição/provedor/subclasse entre Padrão e Teste 4; mudança efetiva de descritor; identidade Pro Controller mantida para o genérico Switch; identidade original preservada em PC mesmo com preferência Teste 4; descritor genérico ID 1 de 56 bits compatível com o payload ControllerState; descritor Nintendo compatível com o pacote inicial; ausência de recuperação/connect automático no Teste 4; regressão dos perfis anteriores.
- Revisão da integração: HidSession adquire IdentityLease pelo destino, independentemente do protocolo. Registro SDP usa HidProfile; envio/GET_REPORT genérico usa ID 1. Activity e método de envio não disponibilizam Confirmar L+R Nintendo no genérico; relatório informa negociação não aplicável. Callbacks reais continuam sendo requisito de canal e verde. Não houve teste de UI no Android/emulador ou rádio nesta máquina.
- APK release não depurável: versionCode 9, versionName 0.2.7-experimental, minSdk 28, compile/target 35. Assinatura v3 e zipalign verificados; permissões não mudaram.
- Certificado SHA-256 c706c29aba14d93b44452100f90c36584fafc1efb85bde4ff959ed1183b8e74a, igual às versões 0.2.1–0.2.6.
- APK: 123639 bytes; SHA-256 ec4da5355be879b7c045c64eabe47b064773adb902cc4bd510f7b7c37db7cf3c.

Relato adicional recebido: o usuário tentou o destino PC com o Switch e informou que ele não encontrava o telefone. Não há diagnóstico dessa tentativa para confirmar etapa interna. Esse comparador era limitado, pois também restaurava o nome original do rádio. O Teste 4 mantém Pro Controller e campos SDP solicitados, substituindo descritor/relatórios por genéricos; não identifica sozinho a causa da falha nem altera classe real, segurança ou VID/PID. Caches e vínculos anteriores podem afetar observações.

O usuário validou fisicamente a execução e o registro da 0.2.7, mas o Teste 4 falhou antes de BONDED/HID tanto na tentativa com vínculo salvo quanto após removê-lo no celular. Canal, mapeamento e jogos no Switch não foram alcançados. Nenhuma correção definitiva anunciada. Novas coletas USB continuam suspensas. Resultados detalhados 0.2.7 e histórico 0.2.6 abaixo.

## Resultado físico 0.2.7: perfil genérico com vínculo removido no celular

Xiaomi 2511FPC34G/Android 16/API 36, destino Switch, Teste 4. O usuário enviou duas tentativas:

| Tentativa | Eventos observados | Limite da conclusão |
| --- | --- | --- |
| Vínculo salvo | Nome confirmado, HID registrado aos 3 s, host previamente associado pelo perfil=true, vínculo salvo encontrado=true, sem BONDED novo; BONDED→NONE aos 17 s. Sem callback de conexão HID. | Perfil genérico não abriu canal com essa associação anterior. Isoladamente não representava pareamento novo. |
| Após remover o vínculo no celular | Nome confirmado aos 0 s; HID registrado aos 1 s; host previamente associado pelo perfil=false; vínculo salvo encontrado=false; BONDING aos 14 s e NONE aos 20 s, sem BONDED. Sem callback HID (-1), pedidos do host ou envios. Motivo Android 0. | A troca para descritor/relatórios genéricos também não resolveu essa tentativa sem vínculo salvo no Android. Reutilização de associação no telefone não explica sozinha esse caso. |

O app estava em READY até receber a falha; o registro/nome foram limpos depois. Portanto HID=false e nome Pro Controller=false no relatório final são consequências do encerramento. O log confirma registro do perfil e início do vínculo, mas não confirma autenticação completada, leitura SDP pelo console ou canal HID.

Nome Pro Controller, campos SDP solicitados e políticas do Android são comuns aos perfis comparados. A falha com o descritor genérico não exclui problemas nessas partes compartilhadas; também não permite afirmar que o descritor Nintendo estava correto. Nenhum comando de botões foi trocado. Motivo 0 continua sem descrição conhecida, sem autor/motivo nativo da interrupção.

Resultado: as alternativas de retenção após perda, conexão de saída após vínculo estável e troca para perfil genérico não demonstraram compatibilidade com esse Switch. Não há correção definitiva comprovada no APK. Não se atribui defeito exclusivamente ao telefone, ao console ou ao MissionControl, nem se recomenda repetir os mesmos testes, novos coletores, root ou atualização do console com base nesses dados. O próximo avanço técnico exige evidência nova de uma diferença concreta de identidade/serviço/segurança ou da causa nativa; simplesmente alterar tempos, botões ou emitir outro APK não é uma correção fundamentada.

## Histórico: validação 0.2.6 experimental

- assembleRelease e lintRelease: BUILD SUCCESSFUL, 0 erros e 1 aviso conhecido da orientação paisagem fixa.
- 2.544 asserções JVM aprovadas: as 2.486 anteriores e 58 de LinkExperimentTest, com os rastros físicos de vínculo salvo removido aos 7 s e vínculo novo BONDING aos 38 s/NONE aos 46 s.
- Novas regressões: perda isolada versus segunda perda; recuperação por eventos reais; janela de 12 s não renovável, inclusive se voltar a BONDING; bordas temporais; cancelamento/falha; BONDED tardio; intervalo estável de 5 s para vínculo novo e salvo; duplicatas; uma abertura de saída; entrada já observada pelo host; opções inválidas e ausência de registro/estabilidade.
- Testes de política são Java puro; não simulam um aparelho como fisicamente conectado e não executam a Activity ou callbacks Android reais. Inspeção da integração confirmou timer próprio protegido por tentativa, rejeição de eventos após prazo e erros nativos ainda terminais.
- APK release não depurável: versionCode 8, versionName 0.2.6-experimental, minSdk 28, compile/target 35. Assinatura v3 e zipalign aprovados. Nenhuma nova permissão.
- Certificado SHA-256 c706c29aba14d93b44452100f90c36584fafc1efb85bde4ff959ed1183b8e74a, igual às versões 0.2.1–0.2.5.
- APK: 123639 bytes; SHA-256 4ef5de1abd222d86e65f060bf78a9436d8730e329f00cd56e3b553ed89634672.

A versão oferece testes opcionais de retenção do HID por até 12 s após a primeira perda e abertura única do canal após 5 s BONDED estável. Padrão continua passivo; PC não usa esses testes. Nenhum teste cria/remove vínculos ou altera autenticação/VID/PID. Sem canal HID real os controles permanecem bloqueados. O teste pode mostrar se a limpeza imediata do app interfere na tentativa ou se uma abertura pelo celular muda o resultado; não fornece o motivo nativo de autenticação se o Android não o expuser.

Não executados: UI no telefone/emulador, instalação, rádio Bluetooth, Switch/Windows, jogo ou medição física desta versão. Não se declara correção definitiva do pareamento. Não foram solicitadas novas coletas USB, nem executadas/republicadas novas ferramentas de coleta. O usuário valida o APK e, se necessário, envia somente Diagnóstico → Copiar.


## Resultado físico recebido: três testes da 0.2.6

Xiaomi 2511FPC34G, Android 16/API 36, destino Switch e layout Nintendo. Nenhuma das três tentativas abriu o canal HID: zero GET/SET/Interrupt e envios; modo Nintendo nunca negociado. Estado atual HID=false no relatório final resulta da limpeza após erro, não demonstra desregistro antes da falha.

| Teste | Eventos observados | O que permite concluir |
| --- | --- | --- |
| 1: retenção do registro | Registro aos 4 s; BONDING 15 s; BONDED 22 s; NONE 24 s. O app reteve HID/nome; BONDING 25 s; BONDED 27 s; NONE 29 s. Sem callback de conexão HID. | Houve confirmação real do vínculo, duas vezes. A retenção permitiu observar nova tentativa, mas a queda repetiu enquanto o registro estava mantido. Encerrar o perfil na primeira perda não é explicação suficiente desta ocorrência. |
| 2: abertura após 5 s | Vínculo salvo observado e registro em 1 s; connect solicitado aos 6 s; callback CONNECTING/1 aos 6 s e DISCONNECTED/0 aos 7 s. Sem CONNECTED/2. Nenhuma perda de vínculo observada antes do encerramento. | O caminho de saída foi executado e falhou antes do canal ficar disponível. Simples ausência de connect não explica esse caso; não se prova rejeição pelo console, pois o callback não fornece autor/motivo. |
| 3: combinado | Vínculo salvo em 1 s; NONE e novo BONDING em 4 s; NONE em 9 s; nenhum BONDED novo. | Nunca atingiu 5 s de vínculo estável; a parte de abertura HID não foi executada. Não equivale a testar as duas ações completadas em sequência. |

Os experimentos não resolveram o pareamento. Continuam possíveis problemas de autenticação, serviço SDP/HID anunciado ou abertura do enlace, sem código nativo para escolher a causa. BONDED local não garante vínculo utilizável pelos dois lados; callback CONNECTING não confirma canal aberto. Não há evidência de erro de L+R ou formato dos relatórios como causa dessas falhas, pois nenhum relatório foi trocado.

O motivo 0 continua desconhecido. O texto genérico do app para conferir patches não é nova evidência contra MissionControl: módulo e arquivos já foram conferidos. Não se pede repetir estes testes, novos coletores, root ou atualização do console. APK 0.2.6 permanece idêntico; atualização apenas da documentação com a validação física recebida.

## Histórico: validação 0.2.5 experimental

- assembleRelease e lintRelease: BUILD SUCCESSFUL, 0 erros e 1 aviso conhecido de orientação paisagem fixa.
- APK release não depurável: versionCode 7, versionName 0.2.5-experimental, minSdk 28, compile/target 35. Assinatura v3 e zipalign conferidos.
- Certificado SHA-256 c706c29aba14d93b44452100f90c36584fafc1efb85bde4ff959ed1183b8e74a, igual às versões 0.2.1–0.2.4; instalável como atualização.
- APK: 115447 bytes; SHA-256 93f1860d288736f1804b528c26cc7ccf5ebc057157b85825c03c41d870840ded.
- Permissões mantidas: Bluetooth CONNECT/ADVERTISE, vibração e serviço foreground connectedDevice; sem Internet, contatos, chamadas, localização ou varredura.
- 2.486 asserções JVM aprovadas: ControllerState 28, NintendoProtocol 2.157 (incluindo 5.000 pacotes malformados/aleatórios), PairingFlow 126, InputRouter 106, PairingPulse 8, BondMonitor 39, BondFailure 22.

## Correção visual

O teste Windows com destino Nintendo abriu o canal HID, mas a UI 0.2.4 mantinha pontos vermelhos em NEGOTIATING. A 0.2.5 usa a capacidade de envio pelo canal real para verde fixo/Conectado; não altera fase, protocolo ou timeout. A mensagem de negociação pendente permanece amarela e o diagnóstico explicita Modo Nintendo negociado. Sem canal, controles continuam cinzas; erro/desconexão retira o verde. Acessibilidade descreve Canal HID conectado. Textos de compatibilidade registram o teste genérico Windows recebido.

Não executados neste ambiente: interface em telefone/emulador, rádio, Windows/USB, jogo ou instalação física da 0.2.5. O usuário realiza essas validações. Build/contratos não demonstram correção do pareamento Switch.

## Evidência física recebida: APK 0.2.4

Telefone Xiaomi 2511FPC34G/Android 16 API 36; Switch Lite 21.1.0|AMS 1.10.1|E, CNX.

1. Destino PC: SwitchPhone Gamepad, status OK no joy.cpl, usuário confirmou entradas. Sem versão/build Windows, inventário completo, jogo ou medição de latência.
2. Destino Nintendo no mesmo Windows: Pro Controller; registro aos 1 s, callback HID CONNECTED/2 e enlace aos 49 s; sete envios aceitos pelo Android, L+R aos 57 s. Nenhum GET/SET/Interrupt; NEGOTIATING. Vínculo UNKNOWN é esperado pelo filtro Nintendo Switch quando o host real é PC. Não confirma negociação/consumo Nintendo.
3. Switch, teste limpo: nenhum vínculo salvo, registro aos 1 s, BONDING aos 38 s, NONE aos 46 s, sem BONDED, canal HID ou pedidos do host; motivo Android 0 sem causa detalhada. Também falhou sem connect automático nas 0.2.3/0.2.4. Ordem de preparação controlada não resolveu.

## MissionControl conferido

exefs.nsp recebido: 166310 bytes, SHA-256 4a21c9d7333d6f7944f88c2067d49c7fb5a7506e0f83fe5898c7d9abb9ce48fa, byte a byte oficial v0.14.2. ZIP recebido: 30 bluetooth_patches e 29 btm_patches, todos idênticos ao mesmo pacote oficial, sem ausências/diferenças. Apenas lidos, não executados ou redistribuídos. Usuário confirmou MissionControl On em Background services após reiniciar, antes de alterar botões. Aplicação dos patches em memória não inspecionada.

HOS 21.1.0/AMS 1.10.1 não motivam atualizar o console: o requisito >=1.10.2 da v0.14.2 é específico de HOS 21.2.0+.

## Coletor nativo separado

BondStateMachine do Android 16 registra status/hciReason, mas o broadcast do app não encaminha hciReason. scripts/windows lê por ADB apenas o processo Bluetooth, desde o horário atual, e exporta tempo relativo e três códigos. Não lê chaves, limpa logs ou remove vínculos; não inclui raw log/MAC/serial no JSON. Ausência de eventos não é diagnóstico da causa. Não exige novas permissões no app.

Cinco testes automatizados aprovados com PowerShell 7.6.7/Linux e ADB simulado: evento terminal; descarte de dados privados em stdout/stderr/JSON; erros USB/PID/horário/logcat; prazo sem eventos; limite de 64 eventos; parser rejeita linhas inválidas. Não são teste de driver Windows, PowerShell 5.1 real ou rádio Xiaomi.

Platform-Tools Windows 37.0.1 obtido de dl.google.com; tamanho/SHA-1 conferidos contra manifesto oficial HTTPS; SHA-256 fixado no coletor e três binários executáveis. Não redistribuídos no ZIP. PowerShell Linux v7.6.7 obtido da release oficial com SHA-256 conferido contra hashes.sha256 oficial. TLS/checksums não desativados.

Chave/senha de assinatura fora do repositório e ZIP. Build atual: /workspace/toolchains/build-switchphone.sh assembleRelease lintRelease; assinatura por scripts/sign-release.sh com caminhos privados. Fontes em bluetooth-research.md.

Conferência adicional com PowerShell real no Linux: download HTTPS do pacote Google, hash do ZIP, extração e hashes dos três binários aprovados. Cache com DLL alterada foi recusado antes de qualquer execução. Nenhum executável Windows foi executado aqui.

Suporte posterior: usuário abriu CMD dentro do ZIP, sem PS1 disponível. Iniciador ganhou verificação de arquivo e instrução Extrair tudo; revisão de sintaxe manual, sem execução Windows neste ambiente. Após extrair, o coletor executou no Windows até o preflight USB e informou não autorizado/encontrado. Usuário confirmou MTP/transferência de arquivos, que não equivale a Depuração USB/ADB; orientado ativar Depuração USB e aceitar o computador. Coleta física ainda não recebida. APK permanece idêntico.

## Coletor USB 1.1.0 após captura vazia

Usuário enviou JSON v1 válido, duration_seconds=90, outcome=no_events, events=[]. O fluxo passou por get-state=device, consulta do processo Bluetooth e horário Android, sem erro do coletor; a autorização ADB funcionou nessa execução. Não há código de falha Bluetooth no arquivo. Usuário confirmou tentativa real durante a janela e aparecimento de Associer no celular.

Revisão encontrou erro no filtro do coletor: Utils.TAG_PREFIX_BLUETOOTH="Bluetooth" e BondStateMachine.TAG usa esse prefixo no código Android 16 consultado, enquanto o coletor selecionava só BondStateMachine. Não comprova qual tag a Xiaomi emite, mas a referência lida estava incorretamente coberta.

Regressão nova modela filtro de tags do logcat: falhou antes da correção (no_events) e passou após incluir BluetoothBondStateMachine:I e BondStateMachine:I, preservando PID/processo e descarte do conteúdo bruto. Seis testes aprovados com PowerShell 7.6.7/Linux e ADB simulado; APK não alterado, nenhum novo teste Android necessário. JSON inclui collector_version=1.1.0, lines_read e unmatched_lines; são contagens, sem texto das linhas. Execução dessa correção no Xiaomi ainda pendente.

Fonte adicional lida: https://github.com/GrapheneOS/platform_packages_modules_Bluetooth/blob/16/android/app/src/com/android/bluetooth/Utils.java , junto ao BondStateMachine da mesma árvore. Foram usados fatos do nome de tag para código original.

## Coletor 1.2.0: 21 linhas sem callbacks reconhecidos

JSON 1.1.0 recebido: duration_seconds=90, no_events, lines_read=21, unmatched_lines=21, events=[]. Isso confirma preflight ADB e recepção de linhas, mas não revela seu conteúdo ou a causa da falha. Não prova que todas eram callbacks de pareamento; headers/outros logs também entram na contagem.

Diagnóstico da mesma tentativa: APK 0.2.4, registro HID aos 1 s, host previamente associado pelo perfil=true, vínculo salvo encontrado=true, callback BONDED=false. Aos 7 s BONDED→NONE (12→10), motivo Android 0, sem callback HID, canal ou pedidos/envios. A versão 0.2.5 altera indicador, não esse fluxo. Não há evidência que atribua a falha exclusivamente ao celular ou ao console.

1.2.0 acrescenta leitura do buffer recente de 15 minutos, sem repetir pareamento: Ler-ultima-tentativa.cmd. Usa o horário Android e logcat -d -v epoch; filtra explicitamente eventos fora da janela, exporta apenas idade relativa, preserva as últimas 64 entradas de cada tipo e indica truncamento. Buffer rotacionado ou processo reiniciado pode impedir recuperação. Como endereços são omitidos, eventos de outros pares dentro da janela não são atribuídos ao Switch automaticamente.

Parser reconhece campos únicos conhecidos com prefixos, separadores :/=, caixa e decimal/hex; não exige endereço nem exporta texto. Procura também avisos nativos de falha do bt_btif_dm, com códigos HCI conhecidos convertidos a número, em lista separada dos callbacks. Contagens de marcadores são enums fixos/inteiros. Nada inventa campos ausentes ou marca conexão.

Oito testes do coletor aprovados em PowerShell 7.6.7/Linux com ADB simulado: regressões existentes, prefixos/hex, falha nativa sem callback Java, snapshot com idade correta e exclusão de linhas velhas/futuras, recusa de campos ambíguos/fora de faixa, privacidade e limites. APK, protocolo e permissões não alterados; sem rebuild Android. A execução 1.2.0 no Windows/Xiaomi ainda depende do usuário.

Referências lidas por HTTPS da mesma árvore GrapheneOS Android 16: system/btif/src/btif_dm.cc (aviso Bonding failed with failure reason e tag bt_btif_dm), system/stack/include/hci_error_code.h (fatos de constantes HCI e nome do motivo) e android/app/jni/com_android_bluetooth_btservice_AdapterService.cpp (encaminhamento callback). Não foi copiada implementação desses projetos.

## Coletor 1.3.0: fonte nativa BTM independente do logcat

JSON 1.2.0 recebido: modo recent_buffer, 41 linhas não reconhecidas, três marcadores de sendIntent/BOND_STATE_CHANGED, zero callback/status/estado/hciReason e zero aviso nativo de falha. Não há código de causa a interpretar. Isso confirma acesso ADB e logs de vínculo, sem comprovar que as 41 linhas eram callbacks omitidos pelo parser. Usuário informou comportamento semelhante com um Galaxy (modelo/Android/log ainda não informados) e uso de controles PS4/PS5 no Xiaomi, que testa o papel de host. Solicitado teste de um desses controles diretamente no Switch via MissionControl; resultado ainda pendente.

Fonte Android 16 inspecionada por Git público, branch 16 GrapheneOS: BTM_LogHistory registra CBACK Bond state changed com bt_status/bond_state/reason em memória; DumpsysBtm imprime sob shim::btm. BluetoothManagerService injeta --print e encaminha dumpsys ao AdapterService; este chama a interface nativa se ligado; dump do stack chama DumpsysBtm. Isso é outra fonte, sem depender dos logs Java ausentes. Pesquisa pública de issues MissionControl não trouxe uma correção comprovada para este par Android 16/Switch; comentários antigos JoyCon Droid não comprovam suporte deste app.

Ler-servico-Bluetooth.cmd usa ADB autorizado e dumpsys bluetooth_manager. O texto permanece só em memória: parser exige a seção nativa shim::btm e campos conhecidos únicos; exporta apenas status/estado/HCI, idade relativa e operações API fixas. PINs, passkeys, endereços, nomes, datas e demais seções são ignorados. Janela de uma hora com relógio local do telefone e últimas 64 entradas de cada tipo. Dados de outros pares não são automaticamente atribuídos ao Switch. Remove bond é observação de API, não prova de solicitante/cause. Sem seção/dados mantém ausência; Permission Denial vira erro explícito. Não ativa Bluetooth, não remove vínculos, não limpa logs e não muda app.

Dez testes do coletor passaram com PowerShell 7.6.7/Linux e ADB simulado. Após ajuste do limite de tempo foi repetido o caso afetado: registro 500 ms futuro também excluído. São testados dados privados antes/dentro/depois da seção, PIN em mensagem ignorada, status desconhecido/ambíguo, recusa de DUMP, idade/limites e regressões anteriores. Nenhuma interface nova ou permissão no APK; não houve rebuild Android. Leitura física do serviço no Xiaomi ainda pendente.

Arquivos consultados: service/src/com/android/server/bluetooth/BluetoothManagerService.java; android/app/src/com/android/bluetooth/btservice/AdapterService.java; system/btif/src/bluetooth.cc; system/stack/btm/btm_main.cc; system/main/shim/dumpsys.h; system/include/hardware/bluetooth.h, no repositório GrapheneOS/platform_packages_modules_Bluetooth branch 16. Foram usados fatos de formato e constantes para parser original, sem copiar implementação.

Adendo à comparação: usuário confirmou que um dos controles PS4/PS5 conectou e funcionou no Switch pelo MissionControl. É confirmação manual do funcionamento básico console/MC para esse controle; não se presume que ambos os modelos tenham sido testados nem que isso valide emulação Android. O foco passa à interoperabilidade do app/Android com o console. Modelo e versão Android do Galaxy foram solicitados e ainda não informados.
