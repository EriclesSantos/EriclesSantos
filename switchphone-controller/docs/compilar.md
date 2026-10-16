# Compilar o projeto

## Android

Use JDK 17, Android SDK Platform 35, Build Tools 35.0.0 e Gradle 8.9. O Gradle Wrapper está em `android-app` e usa Android Gradle Plugin 8.7.3. Configure `ANDROID_HOME` para o SDK ou crie um `android-app/local.properties` local com `sdk.dir`.

```powershell
.\tests\run.ps1
cd android-app
.\gradlew.bat assembleRelease lintRelease
```

Em Linux/macOS, execute `sh tests/run.sh` e, na pasta `android-app`, `bash gradlew assembleRelease lintRelease`. A compilação produz `app/build/outputs/apk/release/app-release-unsigned.apk`; esse arquivo precisa de assinatura para distribuição.

O script `scripts/sign-release.ps1` recebe caminho do keystore, arquivo de senha, SDK e APK de saída. Keystore e senha ficam fora do repositório. Uma atualização sobreposta exige o mesmo applicationId e a mesma assinatura da versão instalada.

## Auxiliar Windows

Requer compilador .NET Framework x64 no Windows e a DLL x64 de [Nefarius.ViGEm.Client 1.21.256](https://www.nuget.org/packages/Nefarius.ViGEm.Client/1.21.256). O script verifica o SHA-256 da DLL antes de compilar.

```powershell
.\pc-companion\fetch-client.ps1 -OutputDirectory C:\dependencias
.\pc-companion\build.ps1 -ClientDll C:\dependencias\ViGEmClient64.dll -OutputDirectory C:\build\nordhub
.\tests\check-wifi.ps1 -ClientDll C:\dependencias\ViGEmClient64.dll -OutputDirectory C:\build\verificacao
```

Os testes de mapeamento e rede usam alvo Xbox simulado; a parte UDP exige acesso a 127.0.0.1. A interoperabilidade verifica pacotes e comandos Java/C# nos dois sentidos. Esses testes não substituem a verificação física do telefone, rádio e jogo.

SHA-256 da DLL x64 esperada: `00303f99e1968d523fbd08a7c691d60d145b7335059ec593947841d124c10875`.

O CI verifica fontes e compilação. Os downloads para usuários ficam na release, com o APK assinado e seus hashes. Não há assinatura de produção nem instalação de driver automática no CI.
