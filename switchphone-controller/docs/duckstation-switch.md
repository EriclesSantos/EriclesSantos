# DuckStation no Nintendo Switch: comandos no HOME, sem comandos no jogo

Relato de 16/10/2026: SwitchPhone 0.2.7, Xiaomi/Android 16, Nintendo negociado, canal ativo, vínculo BONDED, sem perda observada. Botões e analógicos não responderam em The King of Fighters ’97 no DuckStation; o usuário confirmou que os mesmos comandos funcionam no menu HOME do Switch. Não foi confirmada a versão exata do port instalado nem seu perfil de entrada.

Esse resultado demonstra entrada básica no console. Não demonstra que a porta emulada de PlayStation esteja vinculada ao jogador do celular. A hipótese principal passa a ser jogador/porta/mapeamento do emulador, ainda dependente da configuração instalada para confirmação.

## Teste de configuração

1. Salve o progresso e encerre o DuckStation.
2. No HOME do Switch, abra **Controles → Mudar ordem/modo de segurar**. Confirme primeiro o celular com L+R e confira a ordem exibida. Não é necessário esquecer o vínculo Bluetooth para trocar a ordem.
3. Abra o DuckStation e suas configurações de controle. Na **porta 1**, selecione um controle digital para este teste e refaça o mapeamento com o celular: direcional, quatro botões de face, Start, Select e ombros. Os nomes de menus variam entre ports.
4. Se houver mapeamento automático, escolha a origem correspondente ao jogador do celular. No código do port RSDuck consultado, `P0` corresponde ao primeiro jogador/handheld, `P1` ao segundo. Essa nomenclatura da origem não equivale à porta de PlayStation emulada: a porta 1 pode ser mapeada para outra origem.
5. Confira eventual perfil específico do jogo, que pode substituir o perfil global. Teste primeiro o direcional digital; a presença de analógicos no celular não garante que o controle PS1 escolhido os exponha ao jogo.
6. Se o menu HOME responde e o emulador não identifica o toque ao remapear, registre a versão do port e a configuração de entrada para verificar sua fonte de controle. Não substitua arquivos do emulador ou configurações gerais sem backup.

O auxiliar Windows não participa desse caminho. Alterar o desenho do app para PlayStation também não configura as portas do DuckStation: o destino Bluetooth continua sendo Switch.

## Avisos de giroscópio e vibração

O log antigo ficou preenchido por duas mensagens alternadas. A deduplicação anterior comparava apenas o último texto e, por isso, não agrupava essas repetições. A 0.2.8 emite um aviso por recurso em cada sessão e mantém contadores separados no diagnóstico.

O fluxo periódico Nintendo 0x30 agora permanece agendado sem reiniciar a cada subcomando aceito. Desconexão, erro e troca para modo simples cancelam esse fluxo. Pacotes de vibração com tamanho inválido são rejeitados; os válidos são consumidos sem inventar resposta ou produzir vibração inexistente. Pedidos de ativação de IMU/vibração ausentes continuam explicitamente recusados no protocolo. Não há suporte novo a giroscópio, acelerômetro ou rumble do jogo.

A regressão reproduz 2.000 pares alternados de pedidos IMU/pacotes de vibração e verifica preservação de botões, direcional, analógicos e modo 0x30, apenas dois avisos, contadores e validação de pacotes. É um teste de protocolo, não uma execução do DuckStation.

## Fontes primárias

- [Entrada do port RSDuck: jogadores, botões, eixos e mapeamento](https://github.com/RSDuck/duckstation/blob/switch-port/src/util/switch_input_source.cpp). Esse caminho usa `padUpdate`, `padGetButtons` e `padGetStickPos`; não depende da leitura de giroscópio para emitir esses comandos.
- [Documentação do mesmo port: associação de botões](https://github.com/RSDuck/duckstation#bindings-for-qt-frontend). A interface exata depende da compilação instalada.
- [Pesquisa original do protocolo Nintendo: subcomandos 0x40/0x48](https://github.com/dekuNukem/Nintendo_Switch_Reverse_Engineering/blob/master/bluetooth_hid_subcommands_notes.md).

## Configuração instalada conferida por DBI

O executável instalado informa `pre-release 1`. O catálogo identifica o jogo japonês como **SLPM-86084**. A base de dados da revisão `4cf634524abbfb9edcb0a1f3748f508fbffa56d8` lista esse jogo com `DigitalController`, sem vibração. No arquivo global havia configuração antiga `Controller1` junto de `Pad1`, que tinha vínculos apenas para `P0`, e nenhum perfil próprio desse jogo.

Foi criado `switch/duckstation/gamesettings/SLPM-86084.ini`: porta 1 digital; botões e direcional vindos de P0 ou P1 como alternativas para um jogador; analógico esquerdo também mapeado às direções digitais. As demais opções do jogo não foram alteradas. Esse perfil não organiza duas pessoas na mesma partida: P0 e P1 comandam o mesmo jogador nesse teste. Para dois jogadores, remapeie cada porta separadamente.

Depois, a pedido do usuário para ampliar os controles em outros emuladores, o perfil global recebeu `Type = AnalogController` explícito em Pad1, Pad2/P1 separado e abertura do menu de pausa por Minus+Plus em ambos os jogadores. O perfil digital do KOF continua prevalecendo apenas nesse jogo. As configurações globais antigas foram preservadas em backup local; arquivos privados do usuário não são distribuídos no código.

Cada arquivo gravado foi lido de volta e comparado por SHA-256. Isso comprova a gravação, sem substituir o teste de comandos no emulador. A confirmação física após o ajuste ainda está pendente.

Fontes da revisão consultada: [catálogo do KOF ’97](https://github.com/RSDuck/duckstation/blob/4cf634524abbfb9edcb0a1f3748f508fbffa56d8/data/resources/gamedb.yaml#L83642), [entrada Switch](https://github.com/RSDuck/duckstation/blob/4cf634524abbfb9edcb0a1f3748f508fbffa56d8/src/util/switch_input_source.cpp), [leitura de múltiplos vínculos INI](https://github.com/RSDuck/duckstation/blob/4cf634524abbfb9edcb0a1f3748f508fbffa56d8/src/util/ini_settings_interface.cpp).

Para os demais emuladores e jogos nativos, veja [controles no Switch](switch-controls.md).
