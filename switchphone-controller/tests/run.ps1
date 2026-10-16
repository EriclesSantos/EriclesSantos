$ErrorActionPreference='Stop'
$project=Split-Path -Parent $PSScriptRoot
$output=Join-Path ([IO.Path]::GetTempPath()) ('switchphone-tests-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $output | Out-Null
$java=if($env:JAVA_HOME){Join-Path $env:JAVA_HOME 'bin/java.exe'}else{'java.exe'}
$sources=@('controller/ControllerState','controller/InputRouter','controller/PairingPulse','bluetooth/DiagnosticDescriptor','bluetooth/PairingFlow','bluetooth/BondMonitor','bluetooth/BondFailure','bluetooth/LinkExperiment','bluetooth/HidProfile','protocol/NintendoDescriptor','protocol/NintendoProtocol','layouts/ControllerGeometry') | ForEach-Object {Join-Path $project "android-app/app/src/main/java/com/switchphone/$_.java"}
$tests=@(Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*Test.java')
& $java com.sun.tools.javac.Main -encoding UTF-8 -d $output @sources @($tests.FullName)
if($LASTEXITCODE -ne 0){throw 'Test compilation failed'}
foreach($test in $tests){
    & $java -cp $output $test.BaseName
    if($LASTEXITCODE -ne 0){throw "Test failed: $($test.BaseName)"}
}
Write-Output "Compiled test classes: $output"
