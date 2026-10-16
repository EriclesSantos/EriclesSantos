# Roadmap

- Sprint 0: pesquisa, licenças, riscos e plano físico documentados.
- Sprint 1: API HID, diagnóstico e emulação parcial Nintendo implementados. Validação física e eventuais comandos adicionais ainda pendentes.
- Sprint 2: controles completos, analógicos, multitoque e vibração local implementados; validação física pendente.
- Sprint 3: três layouts e preferências implementados; revisão no telefone pendente.
- Sprint 4: callbacks, timeouts e limpeza implementados; consumo, latência e desempenho ainda não medidos.
- Sprint 5: build e CI preparados. Release assinada de produção e publicação aguardam testes físicos.

IMU, NFC, rumble do jogo, acessibilidade avançada e multiplayer não estão prontos. Não há garantia de compatibilidade universal sem root. Esta versão não atende aos critérios físicos de aceite do MVP antes dos testes reais.

Correção 0.2.2 após primeiro relato: preflight único, serviço foreground com prazo, contagem regressiva, diagnóstico copiável, teste local isolado, abertura da tela interativa e confirmação L+R antes da negociação completa. Recebido indício físico de tentativa de vínculo, mas funcionalidade em jogo continua pendente.

Correção 0.2.3 após log Xiaomi/Android 16: registro HID confirmado fisicamente, mas vínculo cai antes do canal de controle. Removida abertura automática imediatamente após vínculo, acrescentado monitor terminal de perda e marcos/callbacks no diagnóstico. Compilar e passar contratos não confirma reconhecimento em jogo; novo teste físico segue pendente.

0.2.4: diagnóstico distingue vínculo antigo de callback recebido, registra motivo opcional Android e KEY_MISSING no Android 16+, sem novas permissões ou alteração do protocolo Nintendo. Novo relato 0.2.3 falhou antes do HID mesmo sem connect; conexão física permanece sem solução comprovada. Próximo teste parte de vínculo limpo e verifica patches do console.

Resultado físico 0.2.4: modo PC reconhecido e entradas respondendo em joy.cpl, conforme relato e captura do usuário. Teste em jogo, latência/estabilidade e inventário completo de botões ainda pendentes. Teste Nintendo limpo continua falhando antes do canal HID; investigação passa a identificar a versão/arquivos MissionControl e diferenças de conexão Nintendo.

0.2.5: indicador passa a confirmar canal HID, com negociação pendente explícita. Destino Nintendo abriu canal no Windows, sem negociação Nintendo. Módulo MissionControl v0.14.2 e 59 patches recebidos conferidos; processo On relatado após reinício. Coletor USB preparado para status/hciReason. APKs experimentais assinados/publicados desde 0.2.1; aceite Nintendo/produção e execução real Windows/USB do coletor continuam pendentes.
