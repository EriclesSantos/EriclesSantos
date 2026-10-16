# Controles externos nos emuladores e jogos do Switch

Conferência e ajustes por DBI/MTP em 16/10/2026, com backup local das configurações. Os caminhos abaixo são relativos à raiz do SD. Arquivos escritos foram relidos e comparados por SHA-256. Testes de resposta após os ajustes ainda precisam ser realizados no console.

## O que foi ajustado

| Aplicativo | Estado e ajuste |
|---|---|
| DuckStation pre-release 1 | `switch/duckstation/settings.ini`: porta 1 explicitada como DualShock/AnalogController, mapeada a P0; porta 2 mapeada a P1. Direcionais e analógicos separados por jogador. Minus+Plus abre a pausa em ambos. O modo digital pode usar os analógicos como direcional. |
| KOF ’97 japonês no DuckStation | `switch/duckstation/gamesettings/SLPM-86084.ini`: controle digital na porta 1, botões e direcional/analógico esquerdo aceitos de P0 ou P1 para teste de um jogador. Esse jogo é listado com suporte digital na base do próprio emulador. |
| RetroArch | `retroarch/retroarch.cfg`: `all_users_control_menu = "true"`. Detecção automática, driver Switch e oito posições de jogador já estavam habilitados e foram preservados. Os remapeamentos de cores/jogos não foram substituídos. |
| PPSSPP | `switch/ppsspp/config/ppsspp/PSP/SYSTEM/controls.ini`: preservados os 21 comandos originais e adicionadas alternativas para os dispositivos genéricos 10 a 17, as primeiras oito posições de gamepad. O PSP emulado continua sendo um jogador; os controles alternativos não criam partidas locais multiplayer. |
| melonDS | Configuração conferida, preservada. O port consulta `CONTROLLER_P1_AUTO` no caminho de entrada. Use o controle externo como jogador 1 do Switch. Não foi inventada uma opção INI para trocar isso. |
| MissionControl / jogos nativos | MissionControl 0.16.0 já instalado e primeiro funcionamento confirmado. Nenhuma nova modificação de módulo, firmware, vínculos ou arquivos de jogos foi feita nesta etapa. |

Esses ajustes ampliam o uso de dispositivos já reconhecidos pelo sistema. Eles não acrescentam protocolos de novos modelos de controle ao MissionControl e não tornam um acessório incompatível automaticamente compatível.

## Como usar um controle diferente

1. Pareie o acessório conforme o procedimento do MissionControl para o modelo. No app Nördhub, escolha destino **Switch experimental / Padrão**. O desenho visual do controle não altera o protocolo Bluetooth.
2. No Switch, abra **Controles → Mudar ordem/modo de segurar** e confirme com L+R na ordem desejada. Para jogar sozinho, coloque primeiro o celular/controle que quer usar; confira a ordem exibida.
3. Abra o emulador ou jogo depois da organização. O modelo físico já chega aos aplicativos pela interface de controle do Switch.
4. No RetroArch, confira também **Entrada → Controles da porta 1 → Índice do dispositivo** se o jogador estiver em outra posição. Remapeamentos de um core ou jogo podem prevalecer sobre o perfil geral.
5. No DuckStation, confira se há configuração específica do jogo. No KOF ’97, o perfil instalado é digital e considera P0/P1 alternativas do primeiro jogador. Em outros títulos, o perfil geral separa as duas portas.
6. No PPSSPP, as alternativas adicionadas mantêm os mesmos códigos de botão já usados pelo aparelho. Uma versão/backend com numeração diferente ainda exige remapeamento. Isso não é um teste físico de oito dispositivos.
7. No melonDS e em jogos que usam somente a primeira posição, organize o controle externo como jogador 1. Reinicie o aplicativo se ele enumerar controles apenas ao abrir.

## Jogos nativos

A entrada é global via sistema/MissionControl; não existe um arquivo de configuração universal que faça qualquer jogo aceitar qualquer tipo de controle. Um título pode exigir Joy-Con separado, movimento, acessório específico ou um modo de jogo próprio. O app ainda não fornece IMU, NFC ou vibração do jogo. Não há confirmação de todos os títulos ou de todos os modelos de acessórios.

Use **Mudar ordem/modo de segurar** para atribuir os jogadores e o menu do próprio jogo quando ele oferecer seleção de controle. Compatibilidade do modelo no MissionControl e suporte a Pro Controller no título continuam sendo requisitos.

## Restaurar

Os backups completos e o relatório SHA-256 ficaram nos arquivos locais entregues ao proprietário, fora do GitHub, porque configurações de emuladores podem conter dados privados. Para desfazer, com os aplicativos encerrados, restaure somente os arquivos alterados a partir desse backup. Para remover o ajuste específico do KOF, remova apenas `switch/duckstation/gamesettings/SLPM-86084.ini`, que não existia antes. Não restaure pastas de ROMs, BIOS, saves ou firmware.

## Fontes primárias

- [MissionControl: modelos e uso](https://github.com/ndeadly/MissionControl).
- [DuckStation Switch: jogadores e vínculos](https://github.com/RSDuck/duckstation/blob/4cf634524abbfb9edcb0a1f3748f508fbffa56d8/src/util/switch_input_source.cpp).
- [RetroArch: driver Switch](https://github.com/libretro/RetroArch/blob/master/input/drivers_joypad/switch_joypad.c) e [autoconfiguração](https://docs.libretro.com/guides/controller-autoconfiguration/).
- [PPSSPP: posições de gamepad](https://github.com/hrydgard/ppsspp/blob/v1.17.1/Common/Input/InputState.h) e [leitura das alternativas de mapeamento](https://github.com/hrydgard/ppsspp/blob/v1.17.1/Core/KeyMap.cpp).
- [melonDS Switch: entrada do jogador 1](https://github.com/RSDuck/melonDS/blob/switch/src/switch/main.cpp).
