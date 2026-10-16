<p align="center"><img src="docs/assets/nordhub-procontroller-icon.png" alt="Nördhub ProController" width="150"></p>

# Nördhub ProController

Transforme seu celular Android em um controle de tela para computadores Windows e Nintendo Switch com MissionControl. Escolha entre os layouts **Nintendo, Xbox e PlayStation**, ajuste os comandos ao seu jeito e conecte ao PC por **Bluetooth ou Wi-Fi local**.

**Versão 0.3.0 · experimental · Android 9 ou superior.** Os nomes dos layouts descrevem a aparência dos botões. O app não oferece pareamento direto com consoles físicos Xbox, PS4 ou PS5.

## Downloads

| Download | Conteúdo |
|---|---|
| [Instalar o APK Android 0.3.0](https://github.com/EriclesSantos/EriclesSantos/releases/download/v0.3.0/nordhub-procontroller-0.3.0.apk) | App para celular ou portátil Android. |
| [Baixar o auxiliar Windows x64](https://github.com/EriclesSantos/EriclesSantos/releases/download/v0.3.0/nordhub-procontroller-pc-0.3.0.zip) | Recebe os comandos e cria um controle Xbox virtual para jogos. |
| [Baixar o código-fonte](https://github.com/EriclesSantos/EriclesSantos/releases/download/v0.3.0/nordhub-procontroller-source-0.3.0.zip) | Fontes Android/Windows, testes e documentação. |
| [Conferir SHA-256 dos arquivos](https://github.com/EriclesSantos/EriclesSantos/releases/download/v0.3.0/SHA256SUMS.txt) | Verificação de integridade dos downloads. |

Quem já usa **Nördhub ProController 0.2.8** pode instalar a atualização por cima, preservando os ajustes. Para migrar de **SwitchPhone 0.2.7 ou anterior**, desinstale o app antigo e instale o APK novo, pois a assinatura de distribuição mudou naquela migração.

## Começar a jogar

- **Desktop ou notebook:** siga o [guia para computadores Windows](docs/computadores.md), com programas necessários, links oficiais, Bluetooth, Wi-Fi, Steam e jogos fora da Steam.
- **Portáteis:** consulte o [guia para Switch, portáteis Windows e Android](docs/portateis.md).
- **Ajustes:** veja [perfis, remapeamento, giroscópio, vibração, gatilhos e touchpad](docs/recursos.md).

## Recursos

- Três layouts, multitoque, dois analógicos e contornos luminosos por tema, com os botões básicos do controle.
- Perfis salvos, remapeamento e ajuste separado da sensibilidade e zona morta de cada analógico.
- Curvas linear, precisão e resposta rápida, inversão de eixos e vibração ao tocar.
- Mira por giroscópio, calibração e modo de mira enquanto segura o gatilho.
- Wi-Fi local com código de pareamento, comunicação cifrada e sem servidor na internet.
- Pelo Wi-Fi do PC: gatilhos graduais, retorno de vibração do jogo, touchpad como mouse opcional e movimento DSU para emuladores compatíveis.
- Serviço de conexão independente da tela: sair ou bloquear libera os comandos mantidos; Desconectar encerra a sessão. O Android ou a perda real do transporte também podem encerrá-la.

## Plataformas

| Aparelho que recebe os comandos | Conexão nesta versão | Requisito |
|---|---|---|
| Desktop/notebook Windows 10/11 x64 | Bluetooth ou Wi-Fi local | Auxiliar Nördhub, .NET Framework 4.8 e ViGEmBus compatível. |
| Portátil Windows x64 | Bluetooth ou Wi-Fi local | Mesmos requisitos do computador. |
| Nintendo Switch com Atmosphère | Bluetooth, experimental | MissionControl compatível instalado. |
| Portátil Android como controle | Bluetooth ou Wi-Fi para o PC | Android 9+; HID Device do fabricante para Bluetooth. |
| SteamOS/Linux/macOS | Sem auxiliar publicado | A versão do auxiliar é Windows x64. |
| Xbox, PS4 e PS5 físicos | Sem suporte direto | Selecionar um layout não muda a compatibilidade do console. |

O jogo precisa aceitar o tipo de controle disponibilizado. **Bluetooth e Wi-Fi ainda têm diferenças de recursos**, listadas no [guia de ajustes](docs/recursos.md). Novos recursos Wi-Fi/sensores estão em versão experimental; disponibilidade e desempenho dependem do telefone, da rede e do jogo.

## Interface e layouts

Captura real da interface, fornecida pelo autor, com o controle desconectado:

![Interface do Nördhub ProController](docs/assets/interface-nintendo.png)

### Prévias dos layouts

Prévias geradas da geometria de desenho do app; não são capturas de uma sessão Android conectada.

### Nintendo

![Prévia do layout Nintendo](docs/assets/nordhub-layout-nintendo.png)

### Xbox

![Prévia do layout Xbox](docs/assets/nordhub-layout-xbox.png)

### PlayStation

![Prévia do layout PlayStation](docs/assets/nordhub-layout-playstation.png)

## Tecnologias

**Android:** Java 17, interface nativa com Canvas e multitoque, Bluetooth HID Device, sensores de movimento, vibração e serviço em primeiro plano. **Windows:** C#, .NET Framework 4.8, WinForms, leitura HID e Xbox virtual/XInput por ViGEmClient. **Rede:** UDP local, AES-256-CBC e HMAC-SHA256; DSU opcional no próprio PC para movimento de emuladores. **Build:** Gradle 8.9, Android Gradle Plugin 8.7.3 e Android SDK 35.

ViGEmBus é uma dependência externa descontinuada pelo autor. Leia os [requisitos e links oficiais](docs/computadores.md#programas-necessários) antes de instalar. O auxiliar não instala drivers ou altera o firewall automaticamente.

## Código e licença

[Compilação e verificação](docs/compilar.md) · [Componentes de terceiros](docs/terceiros.md) · [Licença MIT](LICENSE).
