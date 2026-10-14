# SwitchPhone Controller — download experimental

[Baixar APK Android 0.2.5](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.5-experimental.apk)

[Baixar coletor USB 1.3.0 para Windows](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-diagnostico-usb-windows-1.3.0.zip) · [Instruções da coleta](https://github.com/EriclesSantos/EriclesSantos/blob/main/downloads/README.md#coleta-do-erro-do-switch)

[Código-fonte](switchphone-controller-source.zip) · [SHA-256](SHA256SUMS.txt) · [Certificado](SIGNING-CERTIFICATE.sha256) · [Licença MIT](LICENSE.txt)

A 0.2.5 instala como atualização da 0.2.1–0.2.4, com a mesma chave estável. A antiga 0.2.0 debug tem assinatura diferente. Aplicativo experimental fora da Play Store; assinatura própria não garante retirada do aviso Play Protect.

## Correção dos indicadores

Os três pontos ficam verdes fixos quando o canal HID conecta, inclusive enquanto a negociação Nintendo está pendente. Nesse caso a mensagem continua amarela e explícita; o diagnóstico mostra Modo Nintendo negociado separadamente. Sem canal os controles continuam cinzas. Não foi alterado o protocolo, as permissões ou o timeout de negociação de 45 s. Verde confirma transporte HID, sem comprovar entradas em jogo.

O teste 0.2.4 no Xiaomi 2511FPC34G/Android 16 com Windows confirmou SwitchPhone Gamepad no joy.cpl e resposta às entradas no destino PC. No mesmo Windows, o destino Nintendo conectou como Pro Controller: callback HID CONNECTED aos 49 s, sete envios aceitos pelo Android e L+R aos 57 s; zero GET/SET/Interrupt e fase NEGOTIATING. A UI antiga ficava vermelha apesar desse canal real.

O pareamento com Switch Lite continua sem solução física comprovada. HOS 21.1.0|AMS 1.10.1|E/CNX: teste limpo falhou antes do canal HID, BONDING aos 38 s e NONE aos 46 s, motivo Android 0. O módulo enviado e os 59 patches Bluetooth/BTM são idênticos ao MissionControl v0.14.2 oficial. Usuário confirmou MissionControl On no Hekate Toolbox após reiniciar, antes de alterar botões. Aplicação dos patches em memória não foi inspecionada. Não é necessário repetir o envio desses arquivos.

## Coleta do erro do Switch

O cabo está conectado ao PC do usuário; o ambiente na nuvem não acessa essa porta USB. O coletor tenta obter status/hciReason do processo Bluetooth, que o broadcast do app não fornece.

1. No Xiaomi, ative Opções do desenvolvedor (sete toques em Versão do SO/HyperOS, em Sobre o telefone), depois Configurações adicionais → Opções do desenvolvedor → Depuração USB. Transferência de arquivos/MTP confirma o cabo, mas não substitui Depuração USB; pode manter MTP selecionado. Não precisa de Instalar via USB.
2. No Windows, baixe o ZIP do coletor, use Extrair tudo e abra Iniciar-coleta.cmd na pasta extraída. Se faltar o PS1 ao lado, o iniciador explica a extração antes de chamar PowerShell. Não precisa de administrador. Na primeira execução baixa 8 MB de ferramentas oficiais Google, verificadas por SHA-256.
3. Aceite Permitir depuração USB no celular desbloqueado. Deixe o Bluetooth do PC desligado durante a coleta, para ele não reconectar como Pro Controller. Mantenha o do celular ligado.
4. Pressione Enter na janela do coletor. Quando mostrar COLETA INICIADA, no app escolha Switch experimental → Parear e aguarde HID registrado; só então abra Controles → Mudar ordem/modo de segurar no Switch. Aceite Associer sem contatos.
5. Ao terminar (até 90 s), envie o arquivo switchphone-bluetooth-....json gerado e Diagnóstico → Copiar do app. Se o coletor exibir erro, envie essa mensagem. Depois pode desativar Depuração USB e reativar Bluetooth do PC.

O LEIA-ME.txt do ZIP inclui os detalhes e passos para vínculo limpo. O JSON contém só tempo relativo e códigos numéricos, sem MAC, serial, chaves ou log completo. Não é enviado automaticamente à Internet. Sem callback, o relatório informa ausência de eventos; isso não identifica a causa. Não é preciso compartilhar bugreport ou HCI completo.

## Validação e limites

Build/lint aprovados (0 erros, 1 aviso conhecido de paisagem fixa), assinatura/alinhamento e 2.486 asserções JVM. Cinco testes do coletor com PowerShell 7.6.7/Linux e ADB simulado aprovados; download/hash/extração oficiais e rejeição de cache alterado também verificados. Usuário confirmou que o coletor executou no Windows até a checagem USB, ainda sem aparelho ADB autorizado/encontrado. Versão exata do PowerShell, eventos reais Bluetooth e instalação da 0.2.5 no Xiaomi ainda não confirmados.

Android 9+, sem root, Internet, localização, varredura, contatos ou chamadas no APK. Sem telemetria. PC é HID genérico, não XInput. Emulação Pro Controller parcial, sem giroscópio, NFC, rumble do jogo ou pareamento manual por chaves. Jogos, latência, estabilidade e inventário completo de controles ainda não validados. Versões anteriores ficam como histórico.

## Coletor 1.1.0 — correção de captura vazia

JSON recebido do usuário: 90 segundos, no_events, events vazio. ADB/USB passou na checagem, mas nenhum motivo Bluetooth foi capturado. Usuário confirmou tentativa real e pedido Associer durante a janela. Foi encontrado um erro no filtro: o código Android 16 usa BluetoothBondStateMachine, enquanto a versão anterior selecionava apenas BondStateMachine. O novo coletor aceita ambos os nomes e continua limitado ao processo Bluetooth.

Seis testes aprovados, incluindo regressão que falhou antes e passou após a correção. O JSON identifica collector_version=1.1.0 e inclui contagens de linhas recebidas/não reconhecidas, sem conteúdo bruto. Isso não corrige nem explica por si só o pareamento Switch. O APK 0.2.5 permanece idêntico.

Baixe o coletor 1.1.0, extraia tudo e confira a versão na janela. Após COLETA INICIADA, tente efetivamente Parear no app e Mudar ordem/modo de segurar no Switch durante os 90 s. Envie o novo JSON e o diagnóstico do app da mesma tentativa. Executar somente o coletor não provoca pareamento.

## Coletor 1.2.0 — consultar o histórico recente

Novo arquivo 1.1.0 recebido: 90 s, 21 linhas, todas não reconhecidas; nenhum código de falha. Diagnóstico da mesma tentativa no APK 0.2.4: vínculo salvo removido aos 7 s, sem canal HID, motivo Android 0. Isso não identifica se Android ou console causou a interrupção.

Primeiro abra **Ler-ultima-tentativa.cmd**, na pasta extraída do novo coletor. Ele lê somente os últimos 15 minutos ainda conservados no processo Bluetooth; não inicia pareamento e não exige repetir agora. Envie o JSON gerado. Buffer rotacionado ou processo reiniciado pode impedir recuperar o episódio. Tempos negativos indicam segundos antes da leitura. Registros de outros pares dentro da janela não são automaticamente atribuídos ao Switch.

A 1.2.0 aceita variações de prefixo/separador/caixa/decimal/hex em campos conhecidos, procura avisos nativos de falha HCI e exporta somente números e contagens de marcadores fixos. Não exporta linhas, MAC, chaves, serial ou nomes. Callbacks e avisos nativos são listas separadas; nenhum campo ausente é inventado. Oito testes com PowerShell/Linux e ADB simulado aprovados, incluindo recuperação com idade correta, limites de janela, variações e privacidade. Execução real 1.2.0 ainda pendente. O APK permanece idêntico.

Iniciar-coleta.cmd continua disponível para uma nova janela de 90 s caso não haja histórico útil. A investigação ainda não sustenta culpar exclusivamente o celular ou o console.

## Coletor 1.3.0 — histórico nativo do serviço

O JSON 1.2.0 recebido continha 41 linhas, três marcadores de vínculo e nenhum código de falha. O usuário informou comportamento semelhante num Galaxy, sem modelo/Android/log detalhados; isso reduz a hipótese exclusiva do Xiaomi, mas não comprova culpa do console, pois o app também é comum aos testes. PS4/PS5 no Xiaomi testa o celular como host; o teste de um desses controles diretamente no Switch foi solicitado e ainda não foi informado.

Abra **Ler-servico-Bluetooth.cmd** da pasta extraída do coletor 1.3.0, com USB autorizado e Bluetooth do celular ligado. Não precisa iniciar outro pareamento. Envie o JSON gerado.

Esse modo consulta dumpsys bluetooth_manager em memória e filtra somente o histórico nativo shim::btm, onde o código Android registra status/estado/motivo dos vínculos independentemente do logcat. Exporta só valores conhecidos, idade relativa e operações fixas. Não salva ou envia o dump completo, PINs, passkeys, endereços, nomes, chaves ou datas. Não compartilhe um dumpsys bruto. Janela de uma hora; dados podem incluir outros pares e não são automaticamente atribuídos ao Switch. O fabricante pode omitir a seção; ausência ou código zero não inventam uma causa.

Dez testes com PowerShell/Linux e ADB simulado aprovados; limite de registros futuros subsegundo conferido após ajuste. Leitura dessa fonte no Windows/Xiaomi ainda pendente. Não houve alteração ou rebuild do APK. O teste com PS4/PS5 no Switch continua sendo a comparação prática para verificar aceitação de um controle compatível pelo MissionControl.

### Resultado da comparação com controle compatível

Usuário confirmou que ao menos um controle PS4/PS5 conectou e funcionou no Switch via MissionControl. Assim, há confirmação básica console/MC com controle compatível. App funciona no Windows e falha no Switch em Xiaomi e, conforme relato sem log detalhado, Galaxy. O foco fica na interoperabilidade app/Android→Switch; esse conjunto não permite atribuir a causa a um defeito geral do console nem comprova uma linha específica do app como responsável. Modelo/Android do Galaxy ainda pendentes.
