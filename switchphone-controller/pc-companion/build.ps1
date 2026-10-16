param([Parameter(Mandatory=$true)][string]$ClientDll,[Parameter(Mandatory=$true)][string]$OutputDirectory,[string]$IconFile)
$ErrorActionPreference='Stop'
$compiler=Join-Path $env:WINDIR 'Microsoft.NET/Framework64/v4.0.30319/csc.exe'
if(-not(Test-Path -LiteralPath $compiler)){throw '.NET Framework x64 compiler unavailable'}
$clientHash=(Get-FileHash -LiteralPath $ClientDll -Algorithm SHA256).Hash.ToLowerInvariant()
if($clientHash -ne '00303f99e1968d523fbd08a7c691d60d145b7335059ec593947841d124c10875'){throw 'Unexpected native client checksum'}
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
Copy-Item -LiteralPath $ClientDll -Destination (Join-Path $OutputDirectory 'ViGEmClient.dll') -Force
$core=Join-Path $PSScriptRoot 'BridgeCore.cs'
[string[]]$iconArgs=@()
if($IconFile){$iconArgs+="/win32icon:$IconFile"}
& $compiler /nologo /target:winexe /platform:x64 /optimize+ /reference:System.Windows.Forms.dll /reference:System.Drawing.dll @iconArgs "/out:$(Join-Path $OutputDirectory 'Nordhub.ProController.exe')" $core (Join-Path $PSScriptRoot 'Program.cs')
if($LASTEXITCODE -ne 0){throw 'PC companion compilation failed'}
& $compiler /nologo /target:exe /platform:x64 /optimize+ "/out:$(Join-Path $OutputDirectory 'BridgeChecks.exe')" $core (Join-Path $PSScriptRoot 'BridgeChecks.cs')
if($LASTEXITCODE -ne 0){throw 'PC companion test compilation failed'}
& (Join-Path $OutputDirectory 'BridgeChecks.exe')
if($LASTEXITCODE -ne 0){throw 'PC companion mapping checks failed'}
