# Nördhub ProController — auxiliar Windows 0.3.0

Recebe o controle Android por Bluetooth ou Wi-Fi local e disponibiliza um Xbox virtual/XInput para jogos Windows. Extraia o ZIP inteiro e mantenha o EXE e `ViGEmClient.dll` juntos.

**Requisitos:** Windows 10/11 x64, .NET Framework 4.8 e ViGEmBus compatível. Bluetooth exige HID Device no Android; Wi-Fi exige a mesma rede local. ViGEmBus foi descontinuado pelo autor e não é instalado automaticamente.

[Tutorial completo, programas necessários e links oficiais](https://github.com/EriclesSantos/EriclesSantos/tree/main/switchphone-controller/docs/computadores.md) · [Recursos e configurações](https://github.com/EriclesSantos/EriclesSantos/tree/main/switchphone-controller/docs/recursos.md) · [Portáteis](https://github.com/EriclesSantos/EriclesSantos/tree/main/switchphone-controller/docs/portateis.md).

No Wi-Fi, use o IP, a porta 26761 e o código exibidos no auxiliar. Touchpad como mouse e movimento DSU iniciam desabilitados e podem ser habilitados na janela. Fechar a janela mantém a bandeja; Encerrar remove o Xbox e Sair fecha o processo.

O auxiliar não oferece suporte direto a consoles físicos Xbox/PS4/PS5. O driver é externo e o EXE não tem assinatura de distribuição Windows. A licença do cliente nativo acompanha o pacote em `LICENSE.ViGEmClient.txt`.
