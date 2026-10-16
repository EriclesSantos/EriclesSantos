# Arquitetura 0.2.8

## Alterações da 0.2.8

`ControllerGeometry` centraliza os alvos de desenho/toque em Java puro. Seus 18 botões e dois analógicos são verificados quanto a limites, colisões e prioridade de toque em seis proporções de tela. `ControllerView` usa a mesma geometria para desenhar e processar o direcional. Os contornos são estáticos, com reforço ao pressionar, sem loop permanente.

A tela de controle mantém uma barra compacta com Conectar e Mais. As ações secundárias ficam no menu e a linha de status é recolhida quando o protocolo está ativo. Ícone e marca vêm da adaptação vetorial do símbolo Nördhub, com recursos legacy e adaptive; os dados de transporte mantêm o namespace para permitir atualização futura com a chave original.

`PairingFlow.identityResult(success, needsVisibility)` distingue novo pareamento e reconexão. A Activity consulta somente vínculos já conhecidos após permissão/ativação; no modo Switch Padrão, um único console salvo permite pular a visibilidade. O prazo de tentativa continua finito. `BondMonitor` conserva o intervalo estável e o limite de uma chamada `connect`, e callbacks nativos continuam necessários para liberar entradas. Reconectar funciona também quando não existe sessão atual. Parear novo força o fluxo anterior de descoberta. Testes opcionais 1–4 mantêm seus comportamentos anteriores.

O auxiliar em `pc-companion` é um processo Windows separado. Ele lê o HID por WinMM, normaliza X/Y/R/U para os sticks XInput, converte os gatilhos digitais e cria um alvo Xbox pelo driver ViGEm existente. Não altera HID Hide, não instala driver e não muda arquivos de jogos ou da Steam. Sua criação/remoção é associada à conexão do auxiliar, e falhas de leitura encerram o alvo. O cliente nativo tem origem e hash fixados. ViGEm está descontinuado; esse backend é experimental.

## Base de transporte da 0.2.7

Um módulo Android Java, minSdk 28, compile/target 35, sem bibliotecas de runtime, Internet ou busca ativa de aparelhos.

- MainActivity: navegação, permissões e resultados Android, janela em primeiro plano, binder do serviço, prazo visível e diagnóstico copiável.
- bluetooth/PairingFlow: máquina de estados Java pura. Cada pedido é emitido uma vez, somente na etapa esperada e com a Activity retomada e com foco. Callbacks duplicados/tardios após cancelamento/falha não reabrem o fluxo.
- bluetooth/HidForegroundService: eleva a importância do processo para manter o perfil durante o diálogo Bluetooth remoto. Há notificação/ação Encerrar, prazo de pareamento e START_NOT_STICKY. Não procura dispositivos. O serviço começa depois das confirmações, quando permissões já existem, e termina ao encerrar/falhar/expirar. Se a conexão completar com a UI em segundo plano, há cinco segundos para retornar antes de fechar a sessão. Não exige solicitação de notificações para a notificação obrigatória do serviço.
- bluetooth/BondFailure: descrição de metadados opcionais Android de remoção. A chave interna de extra é lida como string por Intent.getIntExtra; não chama APIs ocultas. Ausência/códigos desconhecidos permanecem explícitos e REMOVED também é tratado como fallback genérico. Android 16+ pode emitir KEY_MISSING protegido; recebê-lo apenas acrescenta observação, sem ler chaves ou alterar a política de conexão.
- bluetooth/BondMonitor: vínculo separado do canal HID; registra snapshots e callbacks reais. Perda é terminal no modo padrão. resumeAfterLoss só é chamado com janela opt-in ainda válida e evento real BONDING/BONDED. Abertura de saída requer vínculo estável por 5 s.
- bluetooth/LinkExperiment: política Java pura, capturada no início de cada tentativa. Teste 1 permite uma janela não renovável de 12 s após a primeira perda, somente com HID registrado/READY e sem canal. Teste 2 permite uma abertura automática de saída após vínculo estável; Teste 3 combina ambos. Cancelamento/falha são terminais. Não chama createBond/removeBond nem APIs ocultas; não simula conexão.
- bluetooth/HidSession: proxy HID, callbacks reais, registro, reconexão, timeouts e protocolo. Enlace confirmado libera comandos e determina pontos verdes. Fase NEGOTIATING também permite entradas para evitar bloquear L+R; sua mensagem permanece explícita e em amarelo até o modo Nintendo ser negociado. A cor não muda o protocolo ou os timeouts.
- bluetooth/IdentityLease: muda o nome uma vez por aquisição e mantém recuperação persistente; adquirir de novo não restaura/renomeia durante a tentativa.
- controller/InputRouter: estados separados de toque local e transporte. Nem relatórios periódicos leem o estado do teste local.
- controller/PairingPulse: sobrepõe L+R temporariamente ao snapshot, sem mudar os botões mantidos pelos dedos.
- controller/ControllerState, layouts/ControllerView e layouts/ConnectionIndicator: comandos, multitoque/Canvas e sinais visuais sem loop de renderização permanente.
- protocol/NintendoProtocol/Descriptor: comandos Nintendo parciais e SPI virtual; DiagnosticDescriptor fornece modo PC genérico.
- settings/Preferences e haptics/Haptics: ajustes e vibração local.

Sequência: permissões → Bluetooth ligado → nome observado → diálogo de visibilidade → Activity retomada/com foco → serviço foreground → registro HID → aguardar host (até 120 s) → negociação Nintendo (até 45 s). Confirmar L+R funciona quando o enlace já existe, inclusive em 3F antes da negociação completa.

Diálogos anteriores ao registro não derrubam um perfil ainda inexistente. Durante vínculo remoto, o serviço preserva a importância do processo e a Activity não encerra a tentativa ao ser coberta. A sessão segue vinculada ao ciclo de vida da Activity e é cancelada se ela for destruída; não é restaurada automaticamente após morte do processo. Eventos protegidos de vínculo são filtrados pelo dispositivo escolhido ou pelo nome exato Nintendo Switch, sem ler/publicar endereços. Eventos de outros aparelhos são ignorados e nunca simulam confirmação de entrada em jogo. O erro terminal continua visível ao sair/voltar ao app.

No modo Padrão, após vínculo, a UI continua aguardando a conexão HID iniciada pelo host, com prazo de visibilidade original. BOND_BONDED não chama connect, não completa PairingFlow e não habilita L+R. BOND_NONE após BONDING/BONDED encerra a sessão, sem reabrir prompts. Em vínculo estável, o usuário pode usar Abrir enlace HID (Reconectar no PC); a chamada confere novamente BOND_BONDED e READY no transporte. Mais de um console conhecido exige escolha manual. Callbacks duplicados não reiniciam timeouts.

O diagnóstico distingue estado atual de marcos da tentativa. Antes de fechar o proxy preserva se houve registro/canal, último callback Android e contagem de solicitações do host/envios aceitos pelo Android. Não guarda payloads nem mede se o console/jogo consumiu entradas. A confirmação anterior do nome é preservada mesmo após a restauração.

Consulta getBondedDevices e o estado anterior trazido por broadcast usam seedExisting, sem simular um callback BONDED novo. O diagnóstico separa snapshot do vínculo salvo, callback efetivamente recebido, código opcional de perda e sinal de chave ausente. Estes campos não habilitam botões, não iniciam conexões, não removem vínculos e não recuperam sessões terminais. Metadados opcionais não são pré-requisito de funcionamento.

## Integração dos testes opcionais 0.2.6

MainActivity mantém o prazo original de visibilidade e um timer independente de 12 s para a janela de recuperação, protegido pelo número da tentativa. Duplicatas não renovam o prazo. BONDING dentro da janela não o reinicia; BONDED ou canal HID real encerram a janela. Nova perda encerra, pois o orçamento já foi usado. Se expirar, eventos de vínculo são rejeitados antes de qualquer alteração de estado. Falha/cancelamento remove ambos os timers e fecha o perfil/restaura o nome. Erros nativos continuam terminais.

O tick de espera pode solicitar HID de saída somente no modo opt-in, enquanto WAIT_HOST, transporte READY e BondMonitor estável. requestLink confere BOND_BONDED no dispositivo antes de consumir a única solicitação. BondMonitor compartilha a trava com o botão manual. CONNECTING recebido do host retira o tick, evitando competir com uma entrada já observada. Uma entrada ainda não notificada pode correr com a saída: o teste não elimina essa possibilidade do stack. Timeout nativo de abertura é 15 s. Reconexão automática não é repetida.

Não são alterados descritor Nintendo, respostas de protocolo, critérios de verde ou disponibilidade de L+R. PCs usam sempre a política padrão. A preferência selecionada não substitui o modo registrado no diagnóstico de uma tentativa anterior.

## Perfil separado da identificação — 0.2.7

HidProfile captura nome/descrição/provedor/subclasse/descritor e distingue switchIdentity de nintendoProtocol. MainActivity confirma Pro Controller para qualquer destino Switch antes da visibilidade; HidSession volta a adquirir essa mesma identificação mesmo quando o protocolo selecionado é genérico. Somente PC restaura o nome original antes de registrar. O Teste 4 é a única variante Switch que usa DiagnosticDescriptor e pacotes ID 1 do ControllerState. Os textos SDP e subclasse são iguais aos do perfil Nintendo; a classe real do rádio não é lida/alterada.

NEGOTIATING e seu timeout de 45 s só existem com protocolo Nintendo. Genérico usa ACTIVE para transporte habilitado, com mensagem explícita de mapeamento não confirmado; o relatório da Activity trata negociação Nintendo como não aplicável e não infere Nintendo a partir de ACTIVE. Confirmar L+R é desabilitado e o próprio método rejeita chamadas no genérico. GET_REPORT ID 1 responde ao relatório genérico, outros IDs/outputs sem suporte continuam explícitos; nenhuma resposta Nintendo é fabricada. O Teste 4 não habilita retenção do vínculo ou connect automático. Preferências antigas e os caminhos PC/Padrão/Testes 1–3 são preservados.
