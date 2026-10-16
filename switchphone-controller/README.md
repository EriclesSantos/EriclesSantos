# Nördhub ProController 0.2.8 — experimental

Controle de tela Android para Nintendo Switch com MissionControl e para computadores por Bluetooth. Novo nome do projeto anteriormente distribuído como SwitchPhone.

## Downloads e instalação

- [APK Android 0.2.8](../downloads/nordhub-procontroller-0.2.8.apk): **Nördhub ProController**, assinado com a nova chave de distribuição. **Desinstale o SwitchPhone anterior antes de instalar esta versão.** A migração não mantém os dados privados e ajustes do app antigo.
- [Auxiliar Windows x64 experimental](../downloads/nordhub-procontroller-pc-0.2.8.zip): conversão local de HID genérico para Xbox/XInput, para investigar compatibilidade com jogos Steam e não Steam.
- [Guia completo de desktop, requisitos e links oficiais](pc-companion/README.md).
- [Código-fonte 0.2.8](../downloads/nordhub-procontroller-source-0.2.8.zip).
- [Ícone Nördhub](docs/assets/nordhub-procontroller-icon.svg).

Extraia todo o ZIP do auxiliar antes de executar. O aplicativo Android exige Android 9+ e suporte HID Device do fabricante. O auxiliar exige Windows 10/11 x64, .NET Framework 4.8 e um driver ViGEmBus compatível já instalado. **ViGEm foi descontinuado**; esse backend é experimental, não instala drivers e não garante suporte futuro. Os links oficiais e os cuidados de compatibilidade estão no guia de desktop.

## O que mudou

- Botões de face de 49 para 68 unidades de desenho, analógicos de raio 48 para 70 e direcional maior, com espaçamento redistribuído.
- Ações de controle reunidas em **Mais** e barra de status recolhida durante a sessão ativa, liberando espaço para o controle.
- Contornos luminosos: ciano/vermelho no Nintendo, verde no Xbox e cores dos símbolos no PlayStation. A luz reforça o toque sem animação contínua.
- Nome **Nördhub ProController** e ícone vetorial do martelo com circuitos dentro da silhueta de controle, em lilás/ciano da marca. O applicationId da versão normal é preservado; as próximas atualizações da 0.2.8 precisam manter a nova chave de distribuição.
- Reconexão ao Switch salvo no modo Padrão prepara HID sem pedir nova visibilidade, reutiliza o vínculo e permite uma única abertura de canal após estabilidade. Não remove vínculos nem altera chaves. **Parear novo** mantém o fluxo de descoberta para outro aparelho.
- Auxiliar Windows para apresentar um Xbox virtual sem depender da Steam em execução. Ainda depende de validação de jogos e do driver indicado.
- Pedidos repetidos de giroscópio/vibração ausentes produzem um aviso por recurso e contadores no resumo, preservando o histórico da conexão. Respostas ao host não reiniciam continuamente o envio periódico dos comandos. Isso não implementa sensores ou vibração do jogo.

## O que está comprovado

| Uso | Estado |
|---|---|
| Switch Lite do usuário com APK antigo + MissionControl 0.16.0 | Primeiro funcionamento confirmado pelo usuário em 16/10/2026. Outros consoles/telefones e reconexão da 0.2.8 ainda precisam de teste. |
| Windows deste desktop, HID genérico da 0.2.7 | Detectado como controlador de jogo; 4 eixos, 16 botões e direcional. Entradas reais recebidas durante o teste. |
| Xbox virtual/XInput pelo auxiliar | Criação, estado neutro, reconhecimento pela Steam e remoção ao encerrar confirmados neste desktop. |
| Dimraeth | O usuário ainda relatou falta de resposta no jogo. A presença do ícone na Steam não confirma compatibilidade concluída. |
| Todos os notebooks/desktops/jogos | Não é uma compatibilidade universal comprovada. Há requisitos de sistema, rádio, drivers e suporte do jogo. |
| Xbox, PS4 e PS5 físicos | Não suportados diretamente. O layout visual não implementa o protocolo/autenticação de um controle aceito pelo console. |

O PC recebe HID genérico no Bluetooth; escolher o desenho Xbox não transforma o telefone em um controle XInput. A conversão para XInput acontece no auxiliar Windows. O nome Bluetooth do celular pode continuar aparecendo externamente enquanto existe um gamepad HID válido.

## Primeiro teste da nova versão

1. Encerre a conexão do app antigo, desinstale o SwitchPhone e instale o APK Nördhub ProController. Esta reinstalação é necessária pela troca da chave, autorizada pelo usuário; não tente instalar por cima do APK antigo.
2. Se instalou a Preview separada durante o teste, encerre-a também. No app principal novo, selecione **Switch experimental / Padrão** ou **PC**. Use somente um host e um app HID por vez.
3. A reinstalação cria novos dados privados/identidade virtual. O primeiro pareamento da versão nova não comprova a migração da instalação antiga. Avalie a reconexão repetindo a sessão dentro da mesma instalação 0.2.8.
4. No Switch, mantenha MissionControl ativo e use Controles → Mudar ordem/modo de segurar para o primeiro pareamento. Em sessões seguintes, teste **Conectar/Reconectar** usando o vínculo salvo.
5. No PC, primeiro confira entradas em `joy.cpl`, depois no auxiliar, na Steam se aplicável e no jogo. Consulte o guia de desktop para os passos detalhados.

## Compilar e verificar 0.2.8

JDK 17, Android SDK Platform 35, Build Tools 35.0.0, Gradle 8.9 e AGP 8.7.3.

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
.\tests\run.ps1
cd android-app
.\gradlew.bat assembleRelease lintRelease assemblePreview lintPreview
```

A compilação Gradle da release normal é gerada sem assinatura. O APK publicado foi assinado com uma nova chave de distribuição, após autorização para desinstalar a versão antiga. Atualizações futuras da 0.2.8 precisam manter essa nova chave. A variante Preview opcional tem pacote e assinatura de teste separados. Nenhuma chave privada ou senha acompanha o código-fonte ou o GitHub.

Certificado SHA-256 da nova distribuição: `6a00bcc9490e4b18de625901486ea39bb6d1fbb3b3147acc2fe4ca1f5200913c`. A chave original das versões 0.2.1–0.2.7 era outra; os APKs não são intercambiáveis como atualização sobreposta.

Validação desta alteração: 6.983 asserções JVM; assemble/lint de release e Preview aprovados (0 erros, 1 aviso conhecido de orientação por variante); assinatura e zipalign aprovados; 45 testes de mapeamento Windows e teste real de ciclo de vida XInput. A interface Android no emulador e o funcionamento do novo APK no telefone não foram validados nesta sessão. As prévias de layout são desenhos da geometria, não capturas de tela Android.

## DuckStation no Switch

No relato de The King of Fighters ’97 com a 0.2.7, os comandos funcionaram no HOME do Switch, mas não no emulador. Isso confirma a entrada básica no console e direciona a investigação para jogador/porta/perfil do DuckStation. Os avisos de sensores ausentes, isoladamente, não comprovam a causa. Veja o [guia e as evidências do DuckStation](docs/duckstation-switch.md).

## Consoles físicos e possíveis evoluções

Xbox/PS4/PS5 exigiriam uma integração separada por Remote Play ou um adaptador de hardware realmente compatível, validado por modelo, firmware e jogo. Não há suporte direto a essas plataformas neste código. O XInput do auxiliar é uma interface de entrada do Windows.

- [PS Remote Play e seus requisitos oficiais](https://www.playstation.com/en-us/remote-play/).
- [Xbox Remote Play e seus requisitos oficiais](https://www.xbox.com/en-US/consoles/remote-play/).
- [Xbox: distinção entre hosts Bluetooth e Xbox Wireless](https://news.xbox.com/en-us/2021/09/08/xbox-controller-firmware-update-rolling-out-to-insiders-starting-today/).

## Histórico técnico da 0.2.7

O conteúdo abaixo descreve a versão anterior e preserva os limites e resultados conhecidos à época. Para o estado atual, use as seções acima.

Android nativo em Java, API 28+, offline, sem root, servidor, anúncios ou telemetria. Não há permissão Internet no APK.

**Dois modos Bluetooth clássico:** gamepad HID genérico para PC (não XInput) e emulação parcial de Pro Controller para experimentar com Nintendo Switch/Atmosphère/MissionControl.

No Windows, o usuário confirmou reconhecimento e resposta às entradas no joy.cpl com Xiaomi/Android 16 e app 0.2.4. No Switch Lite, as tentativas 0.2.2–0.2.4 falharam antes do canal HID, incluindo teste limpo com a ordem de preparação controlada. Jogos e compatibilidade Nintendo continuam sem aprovação.

**Validação física atual:** o Teste 4 da 0.2.7 também falhou no Xiaomi/Android 16 e Switch, inclusive após remover o vínculo no celular. Registro HID em 1 s, BONDING em 14 s e NONE em 20 s, sem BONDED ou canal. Causa nativa desconhecida; não há correção definitiva do Switch demonstrada.

**Pesquisa 16/10/2026:** [foi encontrada correção oficial MissionControl 0.16.0 para classes Bluetooth de celulares, além de diferenças do perfil PC para jogos Web](docs/research-2026-10-16.md). A aplicação da correção no console e o jogo/dongle ainda não foram validados.

## Interface e controles
- Layouts Nintendo Switch, Xbox e PlayStation desenhados em Canvas, com prévia e seleção persistente. O layout visual é independente do modo Bluetooth.
- Multitoque, dois analógicos, direcional com diagonais, ombros, gatilhos, Home/Capture, Menu/View e L3/R3.
- Zona morta, sensibilidade e vibração local configuráveis. Não há rumble comandado pelo jogo.
- Botão **Parear** no topo conduz permissões, ativação, confirmação do nome e visibilidade; só depois do retorno ao app registra HID. Não repete solicitações automaticamente na mesma tentativa.
- Três pontos vermelhos pulsantes enquanto aguarda; verdes fixos após confirmação do canal HID, inclusive durante negociação Nintendo pendente; vermelhos fixos em erro, cinzas quando encerrado.
- Parear abre a tela interativa. Controles ficam disponíveis após o enlace HID, inclusive antes da negociação Nintendo, para permitir L+R. Sem enlace ficam cinza e rebaixados. Perda de conexão, cancelamento e saída liberam estados.
- **Confirmar L+R** envia um pulso de 300 ms sem sobrescrever dedos mantidos na tela. **Testar toque** usa um estado separado e nunca envia comandos por Bluetooth.
- Contagem regressiva de até 120 s, mensagens por etapa e diagnóstico copiável com modelo/Android/permissões e eventos de vínculo; sem MAC, nome pessoal do telefone ou chaves.
- Uma sessão em primeiro plano com notificação mantém o HID durante a confirmação Bluetooth do sistema. Não há busca ativa; o app aguarda o Switch/computador. A sessão termina ao cancelar, expirar, falhar ou sair do controle ativo.
- Diagnóstico 0.2.4 distingue vínculo anterior salvo de callback BONDED recebido agora, lê motivo de remoção Android quando disponibilizado e observa KEY_MISSING no Android 16+. Campos ausentes permanecem desconhecidos; código genérico não identifica um culpado. Nenhuma chave é lida e não há novas permissões.
- No modo Padrão, o primeiro pareamento é passivo e a perda do vínculo encerra a tentativa. A 0.2.6 oferece testes opcionais separados de recomposição de vínculo e abertura HID; veja abaixo. Abrir enlace HID continua disponível manualmente após 5 s de vínculo estável.
- Diagnóstico guarda registro/canal HID observados antes da limpeza, callbacks de conexão e contagens GET/SET/Interrupt/envios; sem endereços Bluetooth, dados dos relatórios ou chaves.

## Nintendo experimental
Implementa descritor próprio, relatórios `0x3F`, `0x21`, `0x30`, identificação virtual, negociação de modo, botões/eixos nativos, leitura de calibração virtual SPI, LEDs de jogador e contadores de gatilhos. Transmite `0x30` aproximadamente 59 vezes/s somente conectado e negociado.

Não implementa NFC, giroscópio, rumble, atualização de firmware ou acesso a chaves de pareamento do sistema. Pedidos não suportados recebem NACK/erro explícito e aparecem no diagnóstico. Isso pode impedir a negociação em determinados hosts. MAC/VID/PID reais continuam sob controle do Android. O nome Bluetooth é temporariamente alterado para `Pro Controller`, com recuperação persistida do nome anterior.

**Pontos verdes não comprovam que o jogo reconheceu os botões.** O app não recebe confirmação do consumo de cada entrada. As calibrações e identidade são virtuais para este aplicativo, não dumps de um controle original.

## Compilar e testar
Abra `android-app` no Android Studio com JDK 17 ou 21, SDK Platform 35 e Build Tools 35.0.0. Gradle Wrapper 8.9 e AGP 8.7.3 estão fixados.

```sh
./tests/run.sh
cd android-app
./gradlew assembleDebug lintDebug
```

APK debug: `android-app/app/build/outputs/apk/debug/app-debug.apk`. Não é release de produção. Build requer Internet; jogar não depende dela.

Leia [instalação e testes físicos](docs/installation.md), [protocolo](docs/nintendo-protocol.md), [pesquisa](docs/bluetooth-research.md), [arquitetura](docs/architecture.md), [compatibilidade](docs/compatibility.md), [validação](docs/validation.md) e [roadmap](docs/roadmap.md).

Código original MIT; não foi incorporado código dos projetos pesquisados. O Gradle Wrapper tem seus [avisos de terceiros](docs/third-party-notices.md). O workflow GitHub Actions compila e disponibiliza o APK como artefato; publicação em Releases e assinatura de produção ficam para depois dos testes físicos.

## Distribuição e Play Protect

O APK 0.2.7 de download usa a mesma chave própria da 0.2.1 e build release não depurável e assinatura própria do projeto; a versão 0.2.0 usava Android Debug. A 0.2.1 alterou apenas a distribuição. A 0.2.2 adicionou o serviço foreground; a 0.2.3 remove a reconexão automática imediata após vínculo e melhora o diagnóstico, preservando package ID e assinatura; não altera o app para contornar o Play Protect. App novo distribuído fora da Play Store ainda pode gerar aviso de desenvolvedor desconhecido. Assinatura própria não equivale à revisão/aprovação pelo Google e não garante retirada do alerta.

Para reproduzir o release: execute `./gradlew assembleRelease lintRelease` em android-app e use scripts/sign-release.sh com ANDROID_HOME, SIGNING_KEYSTORE e SIGNING_PASSWORD_FILE apontando para seus arquivos privados. Nunca publique a chave ou sua senha. Preserve uma cópia segura da chave estável para permitir futuras atualizações. Uma chave diferente exige desinstalar o build antigo antes da instalação.

## Teste no Switch Lite

Use **Controles → Mudar ordem/modo de segurar**. No app selecione o destino **Switch experimental**, toque Parear e aceite **Associer** no Android sem marcar acesso aos contatos. Quando o enlace HID existir, pressione **Confirmar L+R**. A tela Layouts é apenas uma prévia; Parear/Selecionar abrem a tela de controle real. Se falhar, use Diagnóstico → Copiar. O log físico da 0.2.2 mostra registro HID, vínculo aos 10 s, conexão de saída automática e remoção do vínculo aos 11 s; não demonstra qual lado removeu o vínculo nem a causa. As tentativas seguintes também falharam antes do canal HID. Se o vínculo permanecer aceito e o canal não abrir, Abrir enlace HID permite uma tentativa manual após 5 s. Se o vínculo cair, envie o diagnóstico e as versões do console.

## Após falha com vínculo já salvo
O log físico 0.2.3 começa com um Switch previamente vinculado e termina em 12 → 10 (BONDED → NONE) aos 7 s, sem callback HID nem pedidos GET/SET/Interrupt. A chamada de saída não ocorreu; portanto retirá-la não resolveu essa ocorrência. Na 0.2.4, a consulta do vínculo salvo não é mais apresentada como confirmação nova. O motivo da remoção só poderá ser conhecido se o fabricante expuser os metadados no próximo teste; ausência ou código 9 não prova a causa.

Encerre o app e esqueça **somente Nintendo Switch** no Bluetooth do celular para testar um vínculo limpo. No console use Mudar ordem/modo de segurar e repita Parear/Associer. Se persistir, confira os patches MissionControl no SD e envie o novo diagnóstico. Não se recomenda apagar o banco global de controles ou atualizar HOS/Atmosphère como primeiro passo.

## Validação física recebida em 2026-10-14
SwitchPhone 0.2.4 no Xiaomi 2511FPC34G/Android 16/API 36: o Windows reconheceu SwitchPhone Gamepad com status OK no joy.cpl e o usuário confirmou resposta às entradas. A captura não identifica versão/build do Windows e não comprova cada botão/eixo individualmente, latência, estabilidade prolongada ou jogo específico.

No Switch Lite 21.1.0|AMS 1.10.1|E, houve teste limpo: BONDING aos 38 s, NONE aos 46 s, sem BONDED, canal HID ou solicitações do host; motivo Android 0 não detalha a causa. O funcionamento genérico no PC não valida o descritor/identidade/negociação Nintendo. O módulo v0.14.2 e os 59 patches enviados foram identificados como oficiais; o usuário confirmou MissionControl On após reiniciar, antes de alterar botões. Aplicação de patches em memória não foi inspecionada.

## Atualização 0.2.5: transporte e negociação

O destino Nintendo também abriu o HID com o Windows como Pro Controller: callback CONNECTED aos 49 s, sete relatórios aceitos pelo Android e L+R aos 57 s; nenhum GET/SET/Interrupt do host. Isso confirma o canal com esse host, sem confirmar protocolo Nintendo ou entrada no console.

A 0.2.5 corrige pontos vermelhos durante esse enlace: agora ficam verdes fixos, o botão mostra Conectado e a mensagem amarela continua informando negociação Nintendo pendente. O diagnóstico distingue modo negociado. Protocolo, permissões e timeout de negociação de 45 s foram mantidos; sem canal os controles ficam cinzas. Instala como atualização da 0.2.1–0.2.4 com a mesma assinatura.

As ferramentas USB anteriores permanecem apenas como histórico. O teste atual usa o diagnóstico dentro do próprio aplicativo.

## Atualização 0.2.7: perfil genérico mantendo o nome Pro Controller

Depois dos três testes da 0.2.6, nenhum canal HID abriu no Switch. O Teste 1 confirmou BONDED duas vezes e a perda repetiu com o registro mantido. O Teste 2 solicitou abertura, recebeu CONNECTING e depois DISCONNECTED. O Teste 3 perdeu o vínculo antes dos 5 s estáveis e não abriu saída. Esses resultados não identificam a causa nativa.

O usuário tentou o destino PC contra o mesmo Switch e relatou que o console não encontrava o celular. Essa comparação era limitada: PC troca tanto o descritor quanto o nome Bluetooth do rádio (restaura o nome original do telefone). Sem diagnóstico dessa tentativa, não é possível dizer em qual etapa interna ela parou, nem atribuir o resultado exclusivamente ao nome.

A 0.2.7 adiciona **Início → Switch experimental → Escolher teste de conexão → Teste 4 • HID genérico**. Mantém nome de rádio confirmado Pro Controller e os mesmos nome/descrição/provedor/subclasse gamepad solicitados ao SDP. Troca o descritor Nintendo pelo genérico já usado no PC e passa a enviar relatórios genéricos ID 0x01. Mantém espera passiva e encerramento na perda, como Padrão; não combina retenção ou abertura automática dos Testes 1–3.

O objetivo é comparar descoberta/vínculo/canal com outro perfil de relatórios mantendo o nome. Não transforma o Android num controle Sony/Nintendo e não altera classe de rádio, VID/PID ou autenticação. Informações em cache no host podem limitar a comparação. A diferença de nome é uma hipótese, não uma causa demonstrada.

1. Instale a atualização e escolha o destino **Switch experimental**, não PC.
2. Selecione **Teste 4 • HID genérico** e toque **Parear**.
3. Autorize visibilidade e aguarde **HID registrado**. Então abra **Controles → Mudar ordem/modo de segurar** no console e confirme Associer no celular, se aparecer.
4. Observe se há pontos verdes/canal HID. Use **Diagnóstico → Copiar** para registrar a tentativa.

Nesse teste, **Confirmar L+R Nintendo permanece cinza**, inclusive se abrir HID. A tela mostra um aviso e o diagnóstico informa que negociação Nintendo não se aplica. O canal genérico não comprova reconhecimento dos botões no console; pode exigir mapeamento compatível no MissionControl, que não foi implementado. Sucesso de descoberta ou canal não será anunciado como controle Nintendo funcional. Nenhuma nova ferramenta de coleta é solicitada.

## Histórico 0.2.6: testar vínculo e canal HID

No **Início → Switch experimental → Escolher teste de conexão**, selecione uma opção antes de Parear. Mudar a opção encerra a sessão anterior; o diagnóstico registra a opção usada naquela tentativa.

| Opção | Alteração de comportamento |
| --- | --- |
| Padrão | Preserva a espera pelo host e encerra se o vínculo cair. |
| Teste 1 • vínculo (12s) | Na primeira perda, mantém nome e registro HID por até 12 s, somente se ainda registrado/READY e sem canal. Aceita novo evento real de vínculo ou canal dentro do prazo, sem criar vínculo ou reabrir permissões. Não prolonga a janela; uma segunda perda encerra. |
| Teste 2 • abrir HID (5s) | Após 5 s de vínculo BONDED estável, se o host ainda não abriu o canal e o transporte está READY, confere novamente o vínculo Android e solicita uma única conexão HID a partir do celular. Não tenta durante BONDING ou após perda. |
| Teste 3 • vínculo + HID | Combina os dois comportamentos acima. |

Comece pelo Teste 1 e, em uma tentativa separada, pelo Teste 2; use o Teste 3 para combinar os caminhos. Aguarde HID registrado no celular antes de abrir **Controles → Mudar ordem/modo de segurar** no console. Autorize Associer sem contatos. Com canal confirmado, pontos verdes e Confirmar L+R ficam disponíveis. Se falhar, basta **Diagnóstico → Copiar** do app, sem outro coletor.

A janela de 12 s não reinicia o limite original de visibilidade. Erro nativo de registro/canal continua encerrando a sessão imediatamente. Controles não são liberados por BONDED ou pela janela de recuperação: exigem callback real HID conectado. O teste não altera autenticação, VID/PID ou política Bluetooth do Android, nem demonstra que a causa é vínculo/canal. Instala como atualização com a assinatura existente. Teste físico dessa versão ainda pendente.

## Histórico de ferramentas — coletas suspensas

A pedido do usuário, o fluxo atual usa somente evidências já coletadas e a [comparação dos controles](docs/controller-comparison.md). As ferramentas abaixo permanecem como histórico.

## Coletor USB 1.2.0

Ler-ultima-tentativa.cmd tenta recuperar códigos dos últimos 15 minutos ainda no buffer, sem iniciar pareamento. O modo ao vivo continua em Iniciar-coleta.cmd. JSON separa callbacks completos de avisos nativos e inclui contagens de marcadores fixos, sem texto bruto. A coleta 1.1.0 recebeu 21 linhas, mas não reconheceu callbacks; o diagnóstico do app confirmou perda do vínculo salvo aos 7 s, antes do HID. A causa ainda não foi atribuída ao telefone ou console. Oito testes do coletor com ADB simulado aprovados, execução real da correção pendente. APK 0.2.5 não alterado.

## Coletor 1.3.0: histórico do serviço

Ler-servico-Bluetooth.cmd consulta o histórico nativo BTM de dumpsys bluetooth_manager sem novo pareamento. Esse histórico é separado dos logs Java que retornaram 41 linhas sem códigos. O dump bruto fica somente em memória; saem apenas códigos conhecidos/idade/operações fixas da seção shim::btm. Sem dados disponíveis, a causa continua desconhecida. Dez testes com ADB simulado aprovados; fonte real Xiaomi ainda pendente. Nenhuma mudança no APK.
