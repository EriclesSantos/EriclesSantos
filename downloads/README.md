# SwitchPhone Controller — download experimental

[Baixar APK Android 0.2.2 — release](https://raw.githubusercontent.com/EriclesSantos/EriclesSantos/main/downloads/switchphone-0.2.2-experimental.apk)

[Baixar código-fonte](switchphone-controller-source.zip) · [SHA-256](SHA256SUMS.txt) · [Certificado de distribuição](SIGNING-CERTIFICATE.sha256) · [Licença MIT](LICENSE.txt)

A 0.2.2 mantém a assinatura da 0.2.1: instale como atualização. A antiga 0.2.0 debug exige desinstalar por diferença de assinatura. O app é experimental; assinatura própria não garante remoção de alerta de desenvolvedor desconhecido do Play Protect.

## O que mudou

- Parear abre o controle interativo. Layouts é uma prévia, agora identificada como tal.
- Confirmações de permissões/ativação/visibilidade vêm antes do registro HID e não se repetem automaticamente na mesma tentativa.
- Uma sessão foreground mantém HID durante o diálogo Bluetooth do Android, com cancelamento e prazo visível.
- Após vínculo Android, faz uma tentativa de conexão HID com um único Nintendo Switch conhecido; em múltiplos consoles, escolha Reconectar.
- Com o enlace HID real, botões ficam liberados antes do fim da negociação Nintendo. Confirmar L+R envia 300 ms e libera sem cancelar dedos mantidos.
- Testar toque funciona offline com estado separado, sem enviar entradas Bluetooth ou simular conexão. Diagnóstico → Copiar inclui etapas e modelo/Android sem MAC ou chaves.

## Testar no Switch Lite

1. No console use Controles → Mudar ordem/modo de segurar, com MissionControl/Atmosphère compatíveis e ativos. Procurar controles não adiciona um controle novo.
2. No app escolha o destino Switch experimental e toque Parear. Aceite as confirmações Android.
3. No diálogo Associer à Nintendo Switch ?, toque Associer e deixe contatos/histórico de chamadas desmarcados: não são necessários.
4. Quando o enlace HID existir, toque Confirmar L+R (primeira opção da barra de ações) ou L e R simultaneamente. Pontos verdes significam enlace e modo negociado; confirme funcionamento no console/jogo.
5. Se falhar, use Diagnóstico → Copiar. A tentativa expira em vez de reiniciar os pedidos. Para conferir apenas a tela, use Testar toque.

Recebido relato físico de instalação e tentativa de vínculo na 0.2.1. A 0.2.2 ainda exige novo teste real; não há confirmação de controle funcional em jogo. Emulação Pro Controller parcial: sem giroscópio/NFC/rumble do jogo ou pareamento manual por chaves. PC usa HID genérico, não XInput.

Android 9+, sem root, Internet, localização, varredura, contatos ou acesso a chamadas no manifesto. As permissões normais de foreground service/connectedDevice sustentam apenas a tentativa com prazo ou sessão ativa. Nenhuma telemetria. Versões anteriores permanecem como histórico.
