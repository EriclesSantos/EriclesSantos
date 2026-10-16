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

Estado: correções de tráfego/diagnóstico testadas por software; funcionamento no jogo e ajuste do perfil instalado ainda aguardam validação física.
