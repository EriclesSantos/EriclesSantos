@echo off
setlocal
title SwitchPhone - historico do servico Bluetooth
echo SwitchPhone: consulta numerica do historico interno Bluetooth.
echo Nao precisa executar como administrador.
if not exist "%~dp0Collect-Bluetooth.ps1" goto missing_script
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Collect-Bluetooth.ps1" -ServiceHistory
echo.
pause
exit /b

:missing_script
echo.
echo O script Collect-Bluetooth.ps1 nao foi encontrado ao lado deste iniciador.
echo O Windows pode ter aberto somente o CMD de dentro do ZIP.
echo Feche esta janela. Clique com o botao direito no ZIP e use Extrair tudo.
echo Abra a pasta extraida SwitchPhone-diagnostico-USB e execute Ler-servico-Bluetooth.cmd.
echo.
pause
exit /b 2
