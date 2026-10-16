[Baixar o pacote de continuação local](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-sessao-local.zip)

# Abrir a continuação no Windows

Este pacote leva o código e um resumo da tarefa. Ele não muda automaticamente a sessão atual nem concede acesso remoto ao computador.

1. Extraia o ZIP inteiro para uma pasta do Windows.
2. Abra a pasta **switchphone-local** em uma sessão local do Codex, no seu Windows. Abrir somente o chat na nuvem continua sem dar acesso ao USB.
3. Conecte o Switch e use **DBI → Run MTP responder** para expor o cartão SD.
4. Cole esta mensagem na sessão local:

> Leia CONTEXTO-PARA-CODEX.md e continue a atualização do MissionControl que autorizei. Verifique o acesso real ao Switch pelo DBI/MTP, confirme a compatibilidade, faça backup dos arquivos atuais, use o pacote oficial e confira a transferência. Não atualize o firmware do console nem instale exefs.nsp como jogo.

O resumo contém as versões, os testes anteriores, as fontes oficiais, o hash do pacote e o que ainda falta validar. A atualização ainda não foi feita. Se você não tiver um Codex com execução local disponível no Windows, baixar este ZIP sozinho não cria essa execução.

O projeto está em **switchphone-controller**. O APK existente e o manifesto MissionControl estão em **referencias**. A chave privada de assinatura não está incluída. Nenhum coletor novo foi acrescentado, nenhum script de atualização automática será executado ao abrir o pacote.

---

# Continuação local: SwitchPhone e atualização do MissionControl

Resumo preparado em 16/10/2026 a pedido do usuário, para continuar uma conversa da nuvem em uma sessão local. Este documento não significa que o chat foi movido automaticamente nem que o console foi atualizado.

**Tarefa atual e autorização do usuário**

O usuário pediu para transferir o trabalho para uma sessão local para realizar a atualização do MissionControl no seu Switch conectado ao computador pelo DBI. A conversa já autorizou a atualização pretendida e o backup dos arquivos atuais; não é necessário repetir uma pergunta genérica de permissão. Primeiro confirme tecnicamente qual aparelho/cartão está acessível e se a combinação escolhida é suportada. Se o ambiente continuar sendo nuvem ou o aparelho não estiver acessível, informe essa limitação sem afirmar que realizou a cópia.

Objetivo imediato: verificar o MissionControl atual, preservar uma cópia restaurável, obter a release oficial 0.16.0, conferir o pacote e atualizar somente os arquivos correspondentes no SD. Não atualizar HOS/Atmosphère silenciosamente nem modificar desbloqueio, jogos, saves, bancos globais de pareamento, módulos não relacionados ou arquivos de outros projetos. O usuário faz o reinício e a validação física que não puderem ser operados pelo ambiente.

**Equipamentos e estado conhecido**

- Celular: Xiaomi 2511FPC34G, Android 16/API36. Um Galaxy também falhou segundo relato, sem modelo/versão informados.
- Console: Switch Lite, HOS 21.1.0, Atmosphère 1.10.1, emuMMC indicada por E, pacote CNX.
- MissionControl 0.14.2: arquivo exefs.nsp enviado anteriormente,166310 bytes, SHA-256 4a21c9d7333d6f7944f88c2067d49c7fb5a7506e0f83fe5898c7d9abb9ce48fa. Os 59 patches Bluetooth/BTM enviados eram byte a byte oficiais da mesma versão. Usuário confirmou MissionControl On após reiniciar, antes de tocar no botão. Reconferir o que estiver instalado agora; esses dados descrevem a evidência anterior.
- Controles PS4/PS5 e genéricos/AliExpress funcionaram no console, segundo o usuário. Não prova aceitação da classe Bluetooth do smartphone.
- App atual: SwitchPhone 0.2.7-experimental, applicationId com.switchphone.controller, versionCode 9, Android 9+, HID clássico genérico para PC ou emulação parcial Nintendo. O layout visual não muda o protocolo.

**Arquivos do projeto e distribuição**

Repositório público autorizado: https://github.com/EriclesSantos/EriclesSantos . Ele contém o perfil GitHub do usuário na raiz; não substituir o README principal. A distribuição está em downloads. O projeto Android completo é fornecido no ZIP de fontes e também na pasta switchphone-controller deste pacote de continuação.

APK atual: https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.7-experimental.apk

Fonte atual: https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-controller-source.zip

Pesquisa completa: https://github.com/EriclesSantos/EriclesSantos/blob/main/downloads/pesquisa-apps-bluetooth.md

APK 0.2.7:123639 bytes, SHA-256 ec4da5355be879b7c045c64eabe47b064773adb902cc4bd510f7b7c37db7cf3c. Certificado SHA-256 c706c29aba14d93b44452100f90c36584fafc1efb85bde4ff959ed1183b8e74a, igual às versões 0.2.1–0.2.6. O APK incluído é somente referência, já instalado pelo usuário. Atualizar MissionControl não exige compilar ou reinstalar o app.

A chave de assinatura privada e sua senha não estão neste pacote nem no GitHub. Não criar uma nova chave e anunciar um APK como atualização compatível. Uma futura compilação release precisa da mesma chave por canal privado apropriado; a tarefa imediata não depende dela. Não copiar credenciais da nuvem, tokens GitHub ou históricos privados para o repositório.

**Achado da pesquisa que fundamenta a atualização**

A release oficial MissionControl 0.16.0, de 02/10/2026, inclui no changelog uma ampliação do filtro de classe para JoyConDroid sem root. O commit 8796a58f679adbbafce81c7f8d010468a6c8bf94, de24/07/2026, alterou o filtro nativo. O patch 68C915388537833D1AC9F3920708A1A0FF73E35A.ips da família HOS 21.0/21.1 mudou de verdade, embora permaneça com 923 bytes. A máscara nova isola cinco bits da classe principal, excluindo flags adicionais que o teste anterior podia incluir. A classe real emitida pelo Xiaomi não foi medida: é uma hipótese forte, não uma causa já comprovada.

Release: https://github.com/ndeadly/MissionControl/releases/tag/v0.16.0

Pacote oficial exato: https://github.com/ndeadly/MissionControl/releases/download/v0.16.0/MissionControl-0.16.0-master-71bbe2d4.zip

Pacote: 205210 bytes; SHA-256 35ebcb889e06eae3ad909721332791898cafdefd0785d039aad45b4c4702c7f3. Esse hash foi comparado com o digest do próprio GitHub. O pacote não foi executado nem instalado na sessão anterior e não é redistribuído dentro deste ZIP de continuação.

README da release: https://github.com/ndeadly/MissionControl/blob/v0.16.0/README.md

Ele declara suporte a todos os firmwares, recomenda Atmosphère atualizado e exige explicitamente AMS>=1.12.0 emHOS 23.0.0+. Não exige atualizar HOS 21.1.0 para23; também não confirma fisicamente o trio MC0.16.0/AMS 1.10.1/HOS 21.1.0. Conferir essas condições antes de escrever no SD. A release alerta sobre refatoração e possíveis regressões; por isso o backup anterior importa. Não misturar patches aleatórios nem usar o antigo patch experimental JoyConDroid de HOS16.x.

**Como executar a tarefa no Windows local**

1. Leia as instruções AGENTS.md aplicáveis ao diretório e verifique que o terminal é realmente local no Windows. Identifique o Switch conectado; não basta ter autorização, é necessário acesso técnico real ao dispositivo.
2. No aparelho, DBI → Run MTP responder expõe arquivos do SD. O nome visto anteriormente pelo usuário era Switch → 1: SD Card → atmosphere. MTP pode aparecer só como dispositivo portátil do Explorer, sem letra de unidade; não presumir que existe um caminho como E:\ nem tratar o objeto virtual como diretório comum. Um terminal local pode precisar usar a interface MTP/Shell do Windows. Se esse acesso não estiver disponível, explique a limitação; não simule a transferência.
3. Obtenha o ZIP oficial e confira tamanho/hash acima. Inspecione a lista de arquivos, sem executar conteúdo. Compare a instalação atual e o manifesto do pacote para definir exatamente quais destinos serão escritos.
4. Faça um backup local restaurável dos arquivos MissionControl existentes que serão sobrescritos. Inclua o módulo atmosphere/contents/010000000000bd00, os patches correspondentes presentes nos destinos do pacote e configurações pertinentes. Preserve configurações personalizadas (missioncontrol.ini), controles/saves e arquivos não pertencentes ao pacote. Registre também quais arquivos novos a atualização adicionará para permitir reversão. Não apague diretórios inteiros compartilhados de patches.
5. Copie para a raiz do SD respeitando os caminhos do pacote oficial. exefs.nsp é o módulo do Atmosphère nesse diretório: NÃO usar a instalação de jogos NSP do DBI para ele.
6. Espere a transferência de todos os arquivos terminar. Verifique integridade por hash lendo de volta os destinos escritos para uma área temporária local e comparando-os ao conteúdo extraído; tamanho ou existência sozinhos não comprovam cópia. MTP/Shell pode copiar de forma assíncrona. Não declarar conclusão antes da verificação. Se falhar parcialmente, não orientar reinício com cópia incompleta; use o backup/manifesto para restaurar ou completar e conferir a instalação.
7. Entregue um resumo concreto do que mudou, pasta do backup e resultado da verificação. Peça ao usuário para sair do modo de transferência e reiniciar no Atmosphère, não apenas suspender. Não desligue ou reinicie o console automaticamente sem uma forma local apropriada e clara de fazê-lo.
8. Após iniciar, conferir MissionControl ativo e validar o mesmo APK: destino Switch experimental → Padrão • aguardar Switch. Aguarde HID registrado no celular e então abra Controles → Mudar ordem/modo de segurar no console. Aceitar Associer sem contatos. Se houver canal real, usar Confirmar L+R. Pontos verdes confirmam canal HID, não consumo de botões no jogo. O Teste4 genérico não é a configuração para validar protocolo Nintendo completo.

**Testes físicos já concluídos: não recomeçar a investigação do zero**

- Windows com Xiaomi: usuário confirmou SwitchPhone Gamepad/joy.cpl e resposta às entradas do perfil PC. PerfilNintendo também abriu HID no Windows, mas sem comandosNintendo do host.
- Switch com 0.2.6/Teste1: BONDED aos22s, queda aos24s; app manteve HID, novo BONDED aos27s e nova queda aos29s. Sem canal HID. A limpeza na primeira perda não explica sozinha essa ocorrência.
- Teste2: com vínculo salvo, hid.connect após 5 s gerou callback CONNECTING/1 e DISCONNECTED/0 em seguida, semCONNECTED/2. Falhou antes do canal.
- Teste3: vínculo caiu antes de 5 s estáveis; a abertura automática não foi executada.
- 0.2.7/Teste4: nome Pro Controller com descritor genérico. Com vínculo salvo, ele foi removido aos17s; sem vínculo salvo, registro HID em1s, BONDING em14s e NONE em20s, semBONDED/callback HID/GET/SET/Interrupt/envios. Motivo Android 0 desconhecido. Trocar o descritor também não resolveu.
- Hid=false e nome ProController=false no relatório final são consequências da limpeza após erro, não demonstram que o perfil foi removido antes da falha. Não há prova de defeito exclusivamente no celular/console, de falta de driverSony ou de necessidade de root.

**Outros assuntos que continuam pendentes, depois da atualização**

Usuário acrescentou: notebook com Bluetooth integrado funciona no teste Windows, mas no jogo de navegador dragonballbudokai3online só X respondeu. Desktop com dongle pareia outros aparelhos, porém não conecta o SwitchPhone. Foram solicitados URL exata do jogo e Diagnóstico → Copiar do app numa tentativa no desktop; ainda não recebidos. Não inventar o site, navegador, driver ou modelo de dongle.

Auditoria do perfil PC: payload/descritor correspondem (ID1, 7 bytes), botões de face 0–3 corretos; não foi encontrada uma ramificação que envie apenas X. Há diferença para Gamepad API: Home/Capture em 10/11, L3/R3 em 12/13; padrão Web espera L3/R3 em 10/11 e direcional em12–15. Chromium Windows RawInput sem mapper pode expor eixos0,1,3,4 e hat9 para os usos X/Y/Rx/Ry/hat, enquanto jogos esperam sticks 0–3. Isso pode afetar compatibilidade, mas não explica sozinho só X funcionar. Layout Xbox não significa XInput. Não prometer solução Steam Input para um relato de jogo de navegador.

Há anotações e referências fixadas em docs/research-2026-10-16.md e docs/research-2026-10-16-sources.json do projeto. Para os testesPC, mantenha um único host pretendido conectado para não competir com o notebook enquanto testa o desktop.

**Restrições e estado de validação**

O usuário não quer baixar novos coletores. Use o diagnóstico já existente no app e os meios locais disponíveis; scripts/windows no projeto contêm ferramentas antigas preservadas como histórico, não são uma nova solicitação de coleta. Não pedir novamente modelo Android ou versões já descritas. Só pedir informação nova que realmente falte.

0.2.7 passou assembleRelease/lintRelease (0 erros, 1 aviso conhecido de orientação fixa),2.574 asserções JVM, assinatura e zipalign. Esses checks não substituem validação física. A nuvem não tinha rádio/USB/Windows nem acesso ao console. A atualização MissionControl ainda NÃO foi realizada. Não afirmar que o chat inteiro/histórico original foi importado, que hardware está conectado sem conferir, ou que a correção é definitiva antes do teste.

Para compilar futuramente: JDK 17, SDK Platform 35, Build Tools 35.0.0, Gradle Wrapper 8.9/AGP8.7.3. Projeto Android em switchphone-controller/android-app. No Windows usar gradlew.bat; tests/run.sh contém contratos JVM (Git Bash/WSL ou invocações Java equivalentes). Nenhuma alteração de código é necessária para a atualização imediata.
