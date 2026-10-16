# Nördhub ProController — auxiliar Windows experimental

Este programa lê o gamepad Bluetooth do celular e apresenta um controle Xbox 360 virtual por XInput. O objetivo é atender jogos que aceitam controle Xbox, incluindo jogos Steam e jogos iniciados fora da Steam. O auxiliar fica aberto enquanto você joga e remove o dispositivo virtual quando você encerra ou quando a leitura do celular falha.

**Estado atual:** o Windows deste teste reconheceu o Xbox virtual e a Steam o configurou como Xbox 360. Um teste de três minutos com o APK 0.2.7 recebeu 234 mudanças de entrada reais, incluindo analógicos e botões. O usuário ainda relatou falta de resposta no Dimraeth. Isso é uma versão para investigação, não uma confirmação de funcionamento em qualquer jogo ou computador.

## Requisitos

- Windows 10/11 x64. Windows ARM, Linux, macOS e Windows de 32 bits não foram implementados/validados neste auxiliar.
- Bluetooth no PC e celular Android 9+ com perfil Bluetooth HID Device habilitado pelo fabricante. Nem todo dongle ou Android oferece o mesmo suporte.
- .NET Framework 4.8: [instalação oficial Microsoft](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48).
- Driver ViGEmBus compatível já instalado. O desktop de teste já tinha o driver; este pacote não instala, atualiza nem remove drivers.

**Dependência importante:** ViGEm foi descontinuado pelo autor. Este backend é experimental e foi escolhido para aproveitar o driver já existente no desktop. Não é uma garantia de suporte futuro ou uma recomendação para instalar drivers de sites aleatórios. Consulte o [comunicado oficial](https://docs.nefarius.at/projects/ViGEm/End-of-Life/), a [documentação oficial de instalação](https://docs.nefarius.at/projects/ViGEm/How-to-Install/) e as [releases oficiais do ViGEmBus](https://github.com/nefarius/ViGEmBus/releases) antes de avaliar seu uso em outro PC.

## Instalação e uso

1. Baixe e extraia **todo** o ZIP do auxiliar para uma pasta. Mantenha `Nordhub.ProController.exe` e `ViGEmClient.dll` juntos. Abrir apenas o EXE de dentro do ZIP não é o procedimento suportado.
2. No celular, abra o Nördhub ProController 0.2.8, selecione **PC** e conecte ao Bluetooth do computador. O auxiliar também aceita o perfil antigo SwitchPhone 0.2.7. Use somente um app HID por vez.
3. Mantenha a tela do controle aberta. No Windows, `Win+R → joy.cpl` deve mostrar o gamepad do celular. O nome externo no Bluetooth pode continuar sendo o nome do telefone.
4. Abra `Nordhub.ProController.exe`, selecione o gamepad do celular e clique em **Iniciar controle Xbox**. O nome registrado no Windows pode ser `SwitchPhone Gamepad`, inclusive com a nova identidade visual do APK.
5. Aguarde o status **Controle Xbox ativo**. Toque o celular e compare as duas linhas da janela: **Entrada celular** e **Saída XInput** devem mudar juntas. Se somente a primeira mudar, a conversão não está validada; se ambas mudarem e o jogo não responder, confira o perfil/dispositivo selecionado no jogo.
6. Inicie ou reinicie o jogo depois disso. Alguns jogos enumeram os controles apenas na inicialização.
7. Ao terminar, clique em **Encerrar** ou feche o auxiliar. O processo não é instalado como serviço e não inicia automaticamente com o Windows.

## Jogos Steam

1. Inicie o auxiliar antes de abrir o jogo.
2. Em **Steam → Configurações → Controle**, confira o Xbox 360 detectado e teste suas entradas.
3. Na página do jogo, abra **Propriedades → Controle**. Se o jogo tem suporte nativo a Xbox, teste primeiro o controle nativo, sem aplicar um mapeamento de teclado e mouse por cima. Se usar Steam Input, escolha um modelo de **Gamepad** e confira o mapeamento dos dois analógicos.
4. Se o jogo foi adicionado como atalho externo, confirme que o atalho e seu perfil correspondem ao executável correto. Um perfil carregado para outro jogo não é evidência de compatibilidade do Dimraeth.
5. Feche e reabra o jogo ao trocar perfis ou ao criar o dispositivo virtual. Salve o progresso antes de fechar.

Os nomes das opções podem variar com a versão/idioma da Steam. [Documentação oficial Steam Input para jogadores](https://partner.steamgames.com/doc/features/steam_controller/getting_started_for_players).

## Jogos fora da Steam

1. Conecte o celular ao PC e inicie o auxiliar.
2. Confira o Xbox ativo e os valores de entrada na janela do auxiliar.
3. Abra o jogo pelo seu executável ou launcher e selecione controle/gamepad nas opções do próprio jogo.
4. O jogo precisa aceitar Xbox/XInput. O auxiliar não transforma jogos sem suporte a gamepad em jogos compatíveis e não fornece um mapeamento universal de teclado e mouse.

## Solução de problemas

| Sintoma | O que verificar |
|---|---|
| Bluetooth mostra o nome do celular | Esse nome não determina se o perfil HID de gamepad foi criado. Confira `joy.cpl` e o diagnóstico do APK. |
| Não aparece nenhum gamepad na lista | Selecione destino PC no app, mantenha o controle aberto, confira vínculo e conexão, e use Atualizar lista. |
| Falta `ViGEmClient.dll` | Extraia todo o ZIP. A biblioteca deve ficar ao lado do EXE e seu SHA-256 precisa corresponder ao pacote. |
| Driver não encontrado | O auxiliar depende de ViGEmBus compatível já instalado. Leia os requisitos e o estado de descontinuação antes de decidir instalar um driver. |
| Steam mostra Xbox, mas jogo não responde | Teste entradas na Steam/`joy.cpl`, reinicie o jogo depois da conexão e confira o perfil Gamepad do jogo correto. Detecção não comprova consumo dos comandos. |
| Botões/analógicos não mudam no auxiliar | O problema está antes da entrada do jogo. Confira o teste do controle físico em `joy.cpl` e o diagnóstico do APK. |
| Comandos duplicados | O jogo pode estar lendo o HID original e o Xbox virtual. Não esconda o celular indiscriminadamente: o auxiliar precisa continuar autorizado a lê-lo. HidHide não é configurado automaticamente. |
| App funciona em um PC e não em outro | Bluetooth, drivers, política HID do Android, filtros instalados e suporte do jogo são variáveis de compatibilidade; não existe confirmação de todos os modelos. |

## Limites

- Um celular e um Xbox virtual por processo. Não use vários auxiliares sobre o mesmo telefone.
- Gatilhos do app são digitais: o auxiliar converte solto/pressionado para 0/255. Não cria gradação analógica que não existe no app.
- Capture não tem equivalente próprio no controle Xbox 360 e não é convertido. Home usa o botão Guide quando o consumidor aceita esse botão.
- Vibração do jogo, touchpad, giroscópio e áudio de controle não são encaminhados.
- Nenhum pacote de rede, servidor remoto ou conta é necessário para esta conversão local. O jogo e seu launcher têm requisitos próprios.
- O auxiliar não dá suporte a consoles físicos Xbox, PS4 ou PS5. Remote Play e adaptadores autenticados seriam integrações separadas.
- O EXE de teste não tem assinatura de distribuição Windows. O APK principal 0.2.8 tem uma nova chave de distribuição e exige desinstalar o APK antigo; a variante Preview opcional tem uma assinatura de teste separada.

## Compilação e verificação

Código original em `BridgeCore.cs`, `Program.cs` e `BridgeChecks.cs`. `build.ps1` usa o compilador .NET Framework x64 do Windows.

O cliente nativo veio do NuGet oficial [Nefarius.ViGEm.Client 1.21.256](https://www.nuget.org/packages/Nefarius.ViGEm.Client/1.21.256), conferido contra o hash SHA-512 do catálogo oficial. Somente a DLL x64 necessária foi incluída no pacote compilado. [Código original do cliente](https://github.com/nefarius/ViGEmClient).

SHA-256 esperado da DLL x64: `00303f99e1968d523fbd08a7c691d60d145b7335059ec593947841d124c10875`.

Há 45 verificações de mapeamento (botões, gatilhos, direcional, analógicos, inversão Y, neutro e extremos) e um teste nativo que cria um Xbox, lê-o por XInput com estado neutro e verifica sua remoção ao encerrar. Esses testes não substituem validação de cada jogo.

Consulte `LICENSE.ViGEmClient.txt` para a licença MIT da biblioteca de terceiros. O driver de kernel não faz parte deste ZIP.
