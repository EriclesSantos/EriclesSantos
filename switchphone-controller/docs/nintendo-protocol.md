# Modo Pro Controller experimental

Implementação original a partir dos fatos publicados nas notas de engenharia reversa, sem copiar firmware, EEPROM, descritores ou código dos projetos pesquisados.

Fonte técnica: https://github.com/dekuNukem/Nintendo_Switch_Reverse_Engineering, commit `b354f21ae81f7b0d1d060b2b61e66ad0d9bc1756`; arquivos bluetooth_hid_notes.md, bluetooth_hid_subcommands_notes.md e spi_flash_notes.md. Não foram reutilizados os exemplos de código desses documentos. Consulta adicional ao driver Linux por HTTP retornou 429; não é uma fonte lida nesta entrega.

## Relatórios
- `0x3F`: 11 bytes, modo simples de inicialização/alternativo; mapeamento de botões corroborado no driver SDL; validação física ainda pendente.
- `0x21`: 48 bytes, cabeçalho de estado, ACK/NACK, identificador do subcomando e dados.
- `0x30`: 48 bytes, timer, bateria do telefone, botões, dois pares XY compactados em 12 bits e região IMU inativa zerada. Y nativo cresce para cima. Aproximadamente 59 Hz, somente após negociação.
- Saídas `0x01` (subcomandos) e `0x10` (rumble recebido mas não executado). Feature `0x02` devolve a última resposta.

O ID é separado do payload na API Android. Em `0x01`, byte 9 do payload é o subcomando; seus argumentos começam no byte 10. Leituras SPI limitadas a 29 bytes evitam exceder a resposta de 48 bytes.

## Comandos
| Subcomando | Comportamento |
|---|---|
| 00 | Estado do controle |
| 02 | Identidade virtual, tipo Pro Controller, endereço virtual local persistente; não é MAC real do rádio |
| 03 | Aceita modos 30 e 3F; recusa os demais |
| 04 | Contadores de acionamento em unidades de 10 ms, incluindo gatilhos/Home; SL/SR ausentes |
| 08 | Estado virtual de shipment, mantido na sessão |
| 10 | Leitura de memória virtual; áreas não mapeadas retornam FF |
| 11,12 | Gravação/erase protegidos, status de write-protected |
| 30,31 | Guarda e informa LEDs de jogador; mostra comando no diagnóstico |
| 40,48 | Aceita desativação; NACK ao ativar IMU/rumble não implementados |
| 01,38,41,NFC e demais | NACK e explicação no diagnóstico |

O Android cuida do pareamento Bluetooth padrão. Não há extração nem fabricação de chaves LTK. O subcomando de pareamento manual não está implementado. Se o host exigir um comando recusado, a negociação pode falhar.

## Memória e identidade virtuais
Centro dos sticks 2048, deslocamentos máximos de 2047, codificação de calibração esquerda/direita conforme o formato publicado. A memória é gerada por fórmulas para os analógicos de tela. Não é dump de controle real. Coeficientes de escala IMU virtuais não nulos evitam divisão por zero em leitores, mas não representam sensores implementados. Amostras IMU permanecem inativas; pedidos de ativação são recusados.

A versão de firmware informada é virtual (1.0). Endereço virtual local é gerado por instalação; a API pública não permite impor MAC/VID/PID do rádio. MissionControl anuncia suporte sem root ao JoyConDroid, o que é um caminho plausível, não prova de compatibilidade com esta implementação.

## Falhas e confirmações
Sem callbacks, registro/conexão/negociação expiram e bloqueiam controles. Falha de envio tenta um pacote neutro e desconexão; o estado local é zerado. Desde a 0.2.5, pontos verdes correspondem ao canal HID confirmado, inclusive durante NEGOTIATING. A mensagem e o diagnóstico distinguem negociação Nintendo pendente/concluída. Não há confirmação de consumo de cada botão pelo jogo, portanto o aplicativo não consegue detectar isoladamente um mapeamento incorreto no console.

## Entrada durante negociação e confirmação de jogador

A 0.2.2 libera envio quando o enlace HID é confirmado, antes de aguardar modo 0x30, para não impedir o L+R usado na seleção de jogador. Confirmar L+R sobrepõe por 300 ms os bits dos ombros no snapshot. 3F usa bits 0x10/0x20 do primeiro byte; 30 usa R no bit 0x40 do byte direito e L no bit 0x40 do byte esquerdo. O snapshot não altera os dedos mantidos na tela; fim/cancelamento libera só o pulso sintético. A negociação tem prazo de 45 s e não é marcada como concluída apenas por apertar L+R.

Fonte complementar lida para os campos do modo simples: https://raw.githubusercontent.com/libsdl-org/SDL/main/src/joystick/hidapi/SDL_hidapi_switch.c, HandleSimpleControllerState. Licença declarada zlib; nenhum código SDL foi incorporado. Apenas os fatos dos bits corroboram a implementação original.
