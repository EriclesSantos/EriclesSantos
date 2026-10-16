param([switch]$Recent,[switch]$ServiceHistory)
# Windows PowerShell 5.1+. Only allowlisted markers and numeric fields leave memory.
# ADB is downloaded from Google, checked, and kept beside this helper.
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

function Convert-BondLine {
    param([string]$Line, [int]$ElapsedSeconds)
    if ($Line.Length -gt 8192 -or $Line -match '[\r\n]') { return }
    $marker = [regex]::Match($Line,'(?i)\bbondStateChangeCallback\b')
    if (-not $marker.Success) { return }
    $body = $Line.Substring($marker.Index + $marker.Length)
    $patterns = @{
        status = '(?i)(?<!\w)status\s*[:=]\s*(?<value>0x[0-9a-f]{1,2}|\d{1,3})(?!\w)'
        state = '(?i)(?<!\w)(?:newState|new_state)\s*[:=]\s*(?<value>0x[0-9a-f]{1,2}|\d{1,3})(?!\w)'
        reason = '(?i)(?<!\w)(?:hciReason|hci_reason)\s*[:=]\s*(?<value>0x[0-9a-f]{1,2}|-1|\d{1,3})(?!\w)'
    }
    $numbers = @{}
    foreach ($key in $patterns.Keys) {
        $fields = [regex]::Matches($body,$patterns[$key])
        if ($fields.Count -ne 1) { return }
        $value = $fields[0].Groups['value'].Value
        if ($value.StartsWith('0x',[StringComparison]::OrdinalIgnoreCase)) { $number = [Convert]::ToInt32($value.Substring(2),16) }
        else { $number = [int]$value }
        if ($number -gt 255) { return }
        $numbers[$key] = $number
    }
    if ($numbers.state -gt 2) { return }
    [pscustomobject][ordered]@{
        elapsed_seconds = $ElapsedSeconds
        status = $numbers.status
        native_bond_state = $numbers.state
        hci_reason = $numbers.reason
    }
}

function Convert-HciCode {
    param([string]$Value)
    # Standard HCI constants, not arbitrary device/log text.
    $codes = @{
        HCI_SUCCESS=0; HCI_ERR_ILLEGAL_COMMAND=1; HCI_ERR_NO_CONNECTION=2; HCI_ERR_HW_FAILURE=3
        HCI_ERR_PAGE_TIMEOUT=4; HCI_ERR_AUTH_FAILURE=5; HCI_ERR_KEY_MISSING=6; HCI_ERR_MEMORY_FULL=7
        HCI_ERR_CONNECTION_TOUT=8; HCI_ERR_MAX_NUM_OF_CONNECTIONS=9; HCI_ERR_MAX_NUM_OF_SCOS=10
        HCI_ERR_CONNECTION_EXISTS=11; HCI_ERR_COMMAND_DISALLOWED=12; HCI_ERR_HOST_REJECT_RESOURCES=13
        HCI_ERR_HOST_REJECT_SECURITY=14; HCI_ERR_HOST_REJECT_DEVICE=15; HCI_ERR_HOST_TIMEOUT=16
        HCI_ERR_ILLEGAL_PARAMETER_FMT=18; HCI_ERR_PEER_USER=19; HCI_ERR_REMOTE_LOW_RESOURCE=20
        HCI_ERR_REMOTE_POWER_OFF=21; HCI_ERR_CONN_CAUSE_LOCAL_HOST=22; HCI_ERR_REPEATED_ATTEMPTS=23
        HCI_ERR_PAIRING_NOT_ALLOWED=24; HCI_ERR_UNSUPPORTED_REM_FEATURE=26; HCI_ERR_UNSPECIFIED=31
        HCI_ERR_LMP_RESPONSE_TIMEOUT=34; HCI_ERR_LMP_ERR_TRANS_COLLISION=35
        HCI_ERR_ENCRY_MODE_NOT_ACCEPTABLE=37; HCI_ERR_UNIT_KEY_USED=38
        HCI_ERR_PAIRING_WITH_UNIT_KEY_NOT_SUPPORTED=41; HCI_ERR_DIFF_TRANSACTION_COLLISION=42
        HCI_ERR_INSUFFCIENT_SECURITY=47; HCI_ERR_ROLE_SWITCH_PENDING=50; HCI_ERR_ROLE_SWITCH_FAILED=53
        HCI_ERR_HOST_BUSY_PAIRING=56; HCI_ERR_UNACCEPT_CONN_INTERVAL=59; HCI_ERR_ADVERTISING_TIMEOUT=60
        HCI_ERR_CONN_FAILED_ESTABLISHMENT=62; HCI_ERR_LIMIT_REACHED=67; HCI_ERR_CANCELLED_BY_LOCAL_HOST=68
        HCI_ERR_UNDEFINED=255
    }
    if ($codes.ContainsKey($Value)) { $code = $codes[$Value] }
    elseif ($Value -match '^0x[0-9a-fA-F]{1,2}$') { $code = [Convert]::ToInt32($Value.Substring(2),16) }
    elseif ($Value -match '^\d{1,3}$') { $code = [int]$Value }
    else { return }
    if ($code -gt 255) { return }
    return $code
}

function Convert-NativeFailure {
    param([string]$Line, [int]$ElapsedSeconds)
    if ($Line.Length -gt 8192 -or $Line -match '[\r\n]') { return }
    $failure = [regex]::Match($Line,'(?i)(?:Bonding failed with failure reason|Authentication fail)\s*:\s*(?<code>HCI_[A-Z0-9_]+|0x[0-9a-f]{1,2}|\d{1,3})(?!\w)')
    if (-not $failure.Success) { return }
    $code = Convert-HciCode $failure.Groups['code'].Value
    if ($null -eq $code) { return }
    [pscustomobject][ordered]@{ elapsed_seconds=$ElapsedSeconds; hci_reason=$code }
}

function New-LineProfile {
    return @{ callback_marker=0; status_field=0; state_field=0; hci_reason_field=0; native_failure_marker=0; bond_intent_marker=0; pairing_prompt_marker=0 }
}

function Update-LineProfile {
    param([hashtable]$Profile,[string]$Line)
    $markers = @{
        callback_marker='\bbondStateChangeCallback\b'; status_field='\bstatus\s*[:=]'
        state_field='\b(?:newState|new_state)\s*[:=]'; hci_reason_field='\b(?:hciReason|hci_reason)\s*[:=]'
        native_failure_marker='Bonding failed with failure reason|Authentication fail'
        bond_intent_marker='\bsendIntent\b|\bBOND_STATE_CHANGED\b'
        pairing_prompt_marker='\bSSP_REQUEST\b|\bPIN_REQUEST\b|\bsspRequestCallback\b|\bpinRequestCallback\b'
    }
    foreach ($key in $markers.Keys) { if ($Line -match $markers[$key]) { $Profile[$key]++ } }
}

function Start-AdbProcess {
    param([string]$AdbPath, [string]$Arguments)
    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $AdbPath
    $info.Arguments = $Arguments
    $info.UseShellExecute = $false
    $info.CreateNoWindow = $true
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $info
    try { [void]$process.Start() }
    catch { $process.Dispose(); throw 'E_ADB_START' }
    return $process
}

function Invoke-AdbShort {
    param([string]$AdbPath, [string]$Arguments)
    $process = Start-AdbProcess $AdbPath $Arguments
    try {
        $outputTask = $process.StandardOutput.ReadToEndAsync()
        $errorTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(15000)) { $process.Kill(); throw 'E_ADB_TIMEOUT' }
        $outputText = $outputTask.GetAwaiter().GetResult()
        [void]$errorTask.GetAwaiter().GetResult()
        [pscustomobject]@{ Code = $process.ExitCode; Text = $outputText.Trim() }
    } finally { $process.Dispose() }
}

function Get-VerifiedAdb {
    param([string]$Directory)
    $toolRoot = Join-Path $Directory '.switchphone-tools'
    $adb = Join-Path $toolRoot 'platform-tools/adb.exe'
    if (-not (Test-Path -LiteralPath $adb -PathType Leaf)) {
        Write-Host 'Baixando Android Platform-Tools oficial do Google (8 MB)...'
        $temp = Join-Path ([IO.Path]::GetTempPath()) ('switchphone-' + [guid]::NewGuid().ToString('N'))
        [void](New-Item -ItemType Directory -Path $temp)
        try {
            $archive = Join-Path $temp 'platform-tools.zip'
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -UseBasicParsing -Uri 'https://dl.google.com/android/repository/platform-tools_r37.0.1-win.zip' -OutFile $archive
            if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ne '45f4d63113e895ebde0c90f194099a4676b6ac653bd28d54314a9e022bbc1a99') { throw 'E_HASH' }
            if (Test-Path -LiteralPath $toolRoot) { throw 'E_CACHE' }
            Expand-Archive -LiteralPath $archive -DestinationPath $toolRoot
        } finally { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
    $hashes = @{
        'adb.exe' = 'b4a6b455702684652cccf7b46258b29e653538904359a58fd4931cf3ef286b3f'
        'AdbWinApi.dll' = 'c1d653030b4bde65d3e07e4d0b0979e17be56df1436cdd15528630f27808050d'
        'AdbWinUsbApi.dll' = '0710e894d9b40f71a670c13c694079d564c92c1279da382cfe4850983aaebe1b'
    }
    foreach ($file in $hashes.Keys) {
        $path = Join-Path (Join-Path $toolRoot 'platform-tools') $file
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw 'E_HASH' }
        if ((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() -ne $hashes[$file]) { throw 'E_HASH' }
    }
    return $adb
}

function Invoke-BondCapture {
    param([string]$AdbPath, [ValidateRange(1,180)][int]$Seconds = 90)
    $device = Invoke-AdbShort $AdbPath '-d get-state'
    if ($device.Code -ne 0 -or $device.Text -cne 'device') { throw 'E_USB' }
    $bt = Invoke-AdbShort $AdbPath '-d shell pidof com.android.bluetooth'
    if ($bt.Code -ne 0 -or $bt.Text -notmatch '^\d{1,8}$') { throw 'E_BT_PID' }
    $clock = Invoke-AdbShort $AdbPath '-d shell date +%s.%N'
    if ($clock.Code -ne 0 -or $clock.Text -notmatch '^\d{9,12}\.\d{9}$') { throw 'E_CLOCK' }
    # Android 16 prefixes this tag with Utils.TAG_PREFIX_BLUETOOTH ("Bluetooth").
    # Keep the legacy tag too; both remain restricted to the Bluetooth process.
    $arguments = '-d logcat --pid=' + $bt.Text + ' -b main -v raw -T ' + $clock.Text + ' -s BluetoothBondStateMachine:I BondStateMachine:I bt_btif_dm:I *:S'
    $process = Start-AdbProcess $AdbPath $arguments
    $events = New-Object 'System.Collections.Generic.List[object]'
    $nativeFailures = New-Object 'System.Collections.Generic.List[object]'
    $profile = New-LineProfile
    $watch = [Diagnostics.Stopwatch]::StartNew()
    $ended = $false
    $linesRead = 0
    $unmatchedLines = 0
    try {
        # Never write raw stdout/stderr to the terminal, disk or report.
        $errorTask = $process.StandardError.ReadToEndAsync()
        $lineTask = $process.StandardOutput.ReadLineAsync()
        Write-Host 'COLETA INICIADA: tente agora parear o celular com o Switch.'
        Write-Host 'Aguardando ate 90 segundos. Apenas codigos numericos serao salvos.'
        while ($watch.Elapsed.TotalSeconds -lt $Seconds -and $events.Count -lt 64) {
            if (-not $lineTask.IsCompleted) { Start-Sleep -Milliseconds 100; continue }
            $line = $lineTask.GetAwaiter().GetResult()
            if ($null -eq $line) { $ended = $true; break }
            if ($line.Length -gt 0) { $linesRead++ }
            Update-LineProfile $profile $line
            $elapsed = [int][Math]::Floor($watch.Elapsed.TotalSeconds)
            $event = Convert-BondLine $line $elapsed
            $native = Convert-NativeFailure $line $elapsed
            if ($null -ne $native) {
                if ($nativeFailures.Count -ge 64) { $nativeFailures.RemoveAt(0) }
                [void]$nativeFailures.Add($native)
                Write-Host ('Falha nativa: hciReason={0}' -f $native.hci_reason)
            }
            if ($null -ne $event) {
                [void]$events.Add($event)
                Write-Host ('Evento: status={0}, estado nativo={1}, hciReason={2}' -f $event.status,$event.native_bond_state,$event.hci_reason)
                if ($event.native_bond_state -ne 1) { break }
            } elseif ($null -eq $native -and $line.Length -gt 0) { $unmatchedLines++ }
            $lineTask = $process.StandardOutput.ReadLineAsync()
        }
        if ($ended -and $process.WaitForExit(1000) -and $process.ExitCode -ne 0) { throw 'E_LOGCAT' }
    } finally {
        $watch.Stop()
        if (-not $process.HasExited) { $process.Kill(); [void]$process.WaitForExit(1000) }
        $process.Dispose()
    }
    $outcome = 'no_events'
    if ($events.Count -gt 0) { $outcome = 'bond_events' }
    elseif ($nativeFailures.Count -gt 0) { $outcome = 'native_failure' }
    elseif ($ended) { $outcome = 'stream_ended' }
    [pscustomobject][ordered]@{
        format = 'switchphone-bond-codes-v1'
        collector_version = '1.3.0'
        capture_mode = 'live'
        duration_seconds = [int][Math]::Floor($watch.Elapsed.TotalSeconds)
        outcome = $outcome
        lines_read = $linesRead
        unmatched_lines = $unmatchedLines
        marker_counts = $profile
        events = @($events.ToArray())
        native_failures = @($nativeFailures.ToArray())
    }
}

function Invoke-BondSnapshot {
    param([string]$AdbPath)
    $watch = [Diagnostics.Stopwatch]::StartNew()
    $device = Invoke-AdbShort $AdbPath '-d get-state'
    if ($device.Code -ne 0 -or $device.Text -cne 'device') { throw 'E_USB' }
    $bt = Invoke-AdbShort $AdbPath '-d shell pidof com.android.bluetooth'
    if ($bt.Code -ne 0 -or $bt.Text -notmatch '^\d{1,8}$') { throw 'E_BT_PID' }
    $clock = Invoke-AdbShort $AdbPath '-d shell date +%s.%N'
    if ($clock.Code -ne 0 -or $clock.Text -notmatch '^\d{9,12}\.\d{9}$') { throw 'E_CLOCK' }
    $culture = [Globalization.CultureInfo]::InvariantCulture
    $now = [decimal]::Parse($clock.Text,$culture)
    $start = ([long][Math]::Floor($now - 900)).ToString($culture) + '.000'
    Write-Host 'Lendo ultimos 15 minutos ainda disponiveis. Nao precisa parear novamente agora.'
    $argsText = '-d logcat -d --pid=' + $bt.Text + ' -b main -v epoch -T ' + $start + ' -s BluetoothBondStateMachine:I BondStateMachine:I bt_btif_dm:I *:S'
    $dump = Invoke-AdbShort $AdbPath $argsText
    if ($dump.Code -ne 0) { throw 'E_LOGCAT' }
    $events = New-Object 'System.Collections.Generic.List[object]'
    $nativeFailures = New-Object 'System.Collections.Generic.List[object]'
    $profile = New-LineProfile
    $linesRead = 0
    $unmatched = 0
    $outsideWindow = 0
    $truncated = $false
    foreach ($line in [regex]::Split($dump.Text,'\r?\n')) {
        if ($line.Length -eq 0) { continue }
        $linesRead++
        Update-LineProfile $profile $line
        # Epoch is used only for the lookback window/relative age, never exported.
        $stamp = [regex]::Match($line,'^(?<epoch>\d{9,12}\.\d{3,9})\s+')
        if (-not $stamp.Success) { $unmatched++; continue }
        $time = [decimal]::Parse($stamp.Groups['epoch'].Value,$culture)
        if ($time -lt $now - 900 -or $time -gt $now) { $outsideWindow++; continue }
        $age = [int][Math]::Floor($time - $now)
        $event = Convert-BondLine $line $age
        $native = Convert-NativeFailure $line $age
        if ($null -ne $event) {
            if ($events.Count -ge 64) { $events.RemoveAt(0); $truncated=$true }
            [void]$events.Add($event)
        }
        if ($null -ne $native) {
            if ($nativeFailures.Count -ge 64) { $nativeFailures.RemoveAt(0); $truncated=$true }
            [void]$nativeFailures.Add($native)
        }
        if ($null -eq $event -and $null -eq $native) { $unmatched++ }
    }
    $outcome = 'no_events'
    if ($events.Count -gt 0) { $outcome='bond_events' }
    elseif ($nativeFailures.Count -gt 0) { $outcome='native_failure' }
    $watch.Stop()
    [pscustomobject][ordered]@{
        format='switchphone-bond-codes-v1'; collector_version='1.3.0'; capture_mode='recent_buffer'
        duration_seconds=[int][Math]::Floor($watch.Elapsed.TotalSeconds); lookback_seconds=900
        outcome=$outcome; lines_read=$linesRead; unmatched_lines=$unmatched
        outside_window_lines=$outsideWindow; events_truncated=$truncated; marker_counts=$profile
        events=@($events.ToArray()); native_failures=@($nativeFailures.ToArray())
    }
}

function Convert-BtmBondLine {
    param([string]$Line,[int]$ElapsedSeconds)
    if ($Line.Length -gt 8192 -or $Line -match '[\r\n]') { return }
    if ($Line -notmatch '^shim::btm\s+.+\s+CBACK\s+Bond state changed\s*:') { return }
    $fields = @{
        status='\bbt_status\s*:\s*(?<value>[a-zA-Z_]+|0x[0-9a-fA-F]{1,2}|\d{1,3})(?!\w)'
        state='\bbond_state\s*:\s*(?<value>[0-2])(?!\w)'
        reason='\breason\s*:\s*(?<value>HCI_[A-Z0-9_]+|0x[0-9a-fA-F]{1,2}|\d{1,3})(?!\w)'
    }
    $values = @{}
    foreach ($key in $fields.Keys) {
        $matchesFound = [regex]::Matches($Line,$fields[$key],[Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($matchesFound.Count -ne 1) { return }
        $values[$key] = $matchesFound[0].Groups['value'].Value
    }
    $statuses = @('success','fail','not_ready','no_memory','busy','already_done','unsupported','parameter_invalid','unhandled','auth_failure','remote_device_down','auth_rejected','jni_env_error','jni_thread_error','wakelock_error','timeout_error','device_not_found','unexpected_state','socket_error')
    $status = [Array]::IndexOf($statuses,$values.status.ToLowerInvariant())
    if ($status -lt 0) {
        if ($values.status -match '^\d{1,3}$') { $status=[int]$values.status }
        elseif ($values.status -match '^0x[0-9a-fA-F]{1,2}$') { $status=[Convert]::ToInt32($values.status.Substring(2),16) }
        else { return }
    }
    if ($status -gt 255) { return }
    $reason = Convert-HciCode $values.reason
    if ($null -eq $reason) { return }
    [pscustomobject][ordered]@{ elapsed_seconds=$ElapsedSeconds; status=$status; native_bond_state=[int]$values.state; hci_reason=$reason }
}

function Invoke-BluetoothServiceHistory {
    param([string]$AdbPath)
    $watch = [Diagnostics.Stopwatch]::StartNew()
    $device = Invoke-AdbShort $AdbPath '-d get-state'
    if ($device.Code -ne 0 -or $device.Text -cne 'device') { throw 'E_USB' }
    $clock = Invoke-AdbShort $AdbPath '-d shell date +%Y-%m-%d_%H:%M:%S'
    if ($clock.Code -ne 0 -or $clock.Text -notmatch '^\d{4}-\d{2}-\d{2}_\d{2}:\d{2}:\d{2}$') { throw 'E_CLOCK' }
    $culture = [Globalization.CultureInfo]::InvariantCulture
    try { $now = [datetime]::ParseExact($clock.Text,'yyyy-MM-dd_HH:mm:ss',$culture) } catch { throw 'E_CLOCK' }
    Write-Host 'Consultando historico nativo do servico Bluetooth, sem iniciar pareamento...'
    $dump = Invoke-AdbShort $AdbPath '-d shell dumpsys bluetooth_manager'
    if ($dump.Code -ne 0 -or $dump.Text -match 'Permission Denial|Can.t find service') { throw 'E_SERVICE_DUMP' }
    $events = New-Object 'System.Collections.Generic.List[object]'
    $requests = New-Object 'System.Collections.Generic.List[object]'
    $headerSeen=$false; $inBtm=$false; $linesRead=0; $btmLines=0; $unmatched=0; $outside=0; $truncated=$false
    foreach ($line in [regex]::Split($dump.Text,'\r?\n')) {
        if ($line.Length -eq 0) { continue }
        $linesRead++
        if ($line -match '^\s*-{3,}\s+shim::btm\s+-{3,}\s*$') { $headerSeen=$true; $inBtm=$true; continue }
        if ($line -match '^\s*-{3,}\s+.+\s+-{3,}\s*$') { $inBtm=$false; continue }
        if (-not $inBtm -or $line -notmatch '^shim::btm\s+') { continue }
        $btmLines++
        $stamp = [regex]::Match($line,'(?<time>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})\s+')
        if (-not $stamp.Success) { $unmatched++; continue }
        try { $time=[datetime]::ParseExact($stamp.Groups['time'].Value,'yyyy-MM-dd HH:mm:ss.fff',$culture) }
        catch { $unmatched++; continue }
        if ($time -lt $now.AddSeconds(-3600) -or $time -gt $now) { $outside++; continue }
        $age=[int][Math]::Floor(($time-$now).TotalSeconds)
        $event = Convert-BtmBondLine $line $age
        if ($null -ne $event) {
            if ($events.Count -ge 64) { $events.RemoveAt(0); $truncated=$true }
            [void]$events.Add($event)
            continue
        }
        # API request markers are observations, not an attribution to a caller.
        $operation=0
        if ($line -match '\bAPI\s+Create bond\s*:') { $operation=1 }
        elseif ($line -match '\bAPI\s+Cancel bond\s*:') { $operation=2 }
        elseif ($line -match '\bAPI\s+Remove bond\s*:') { $operation=3 }
        if ($operation -gt 0) {
            if ($requests.Count -ge 64) { $requests.RemoveAt(0); $truncated=$true }
            [void]$requests.Add([pscustomobject][ordered]@{ elapsed_seconds=$age; operation=$operation })
        } else { $unmatched++ }
    }
    $outcome='no_events'
    if ($events.Count -gt 0) { $outcome='bond_events' }
    elseif ($requests.Count -gt 0) { $outcome='requests_only' }
    $watch.Stop()
    [pscustomobject][ordered]@{
        format='switchphone-bond-codes-v1'; collector_version='1.3.0'; capture_mode='bluetooth_service_history'
        duration_seconds=[int][Math]::Floor($watch.Elapsed.TotalSeconds); lookback_seconds=3600
        outcome=$outcome; native_history_header_seen=$headerSeen; lines_read=$linesRead
        native_history_lines=$btmLines; unmatched_lines=$unmatched; outside_window_lines=$outside
        events_truncated=$truncated; events=@($events.ToArray()); requests=@($requests.ToArray())
        operation_codes=[ordered]@{ create_bond=1; cancel_bond=2; remove_bond=3 }
        native_failures=@(); marker_counts=@{}
    }
}

function Start-Collector {
    param([string]$Directory,[switch]$Recent,[switch]$ServiceHistory)
    $messages = @{
        E_USB = 'USB nao autorizado/encontrado. Ative Depuracao USB, desbloqueie o celular e aceite a autorizacao. Deixe apenas um celular USB conectado.'
        E_BT_PID = 'Processo Bluetooth nao encontrado. Ative Bluetooth no celular. O fabricante pode usar outro processo.'
        E_CLOCK = 'O Android nao forneceu o horario necessario. Nenhum log antigo foi coletado.'
        E_ADB_TIMEOUT = 'O ADB nao respondeu em 15 segundos. Reconecte o cabo e execute novamente.'
        E_ADB_START = 'Nao foi possivel executar o ADB. Confira o arquivo e as restricoes do Windows.'
        E_HASH = 'A verificacao SHA-256 das ferramentas falhou. Nada desse conjunto sera executado. Baixe e extraia o coletor em uma pasta nova.'
        E_CACHE = 'Cache incompleto. Extraia o coletor em uma pasta nova e execute novamente.'
        E_LOGCAT = 'O Android recusou/encerrou a leitura. Nenhum motivo foi inventado. Envie apenas esta mensagem.'
        E_SERVICE_DUMP = 'O Android nao autorizou/disponibilizou o diagnostico do servico Bluetooth. Nenhum conteudo bruto foi salvo.'
    }
    try {
        Write-Host 'SwitchPhone coletor USB 1.3.0 - codigos e historico do servico'
        $adb = Get-VerifiedAdb $Directory
        Write-Host 'Deixe Bluetooth do PC desligado e o do celular ligado. Conecte o cabo USB.'
        Write-Host 'Ative Depuracao USB nas opcoes do desenvolvedor e aceite a autorizacao no celular.'
        # Start the ordinary ADB USB authorization dialog before waiting for Enter.
        [void](Invoke-AdbShort $adb '-d get-state')
        if ($ServiceHistory) {
            $report = Invoke-BluetoothServiceHistory $adb
        } elseif ($Recent) {
            $report = Invoke-BondSnapshot $adb
        } else {
            [void](Read-Host 'Pressione Enter quando estiver pronto para tentar o Switch')
            $report = Invoke-BondCapture $adb
        }
        $filename = 'switchphone-bluetooth-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,4) + '.json'
        $path = Join-Path $Directory $filename
        $report | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $path -Encoding UTF8
        Write-Host ('Pronto. Envie o arquivo ' + $filename + ' desta pasta, junto do Diagnostico do app.')
        if ($report.events.Count -eq 0 -and $report.native_failures.Count -eq 0) { Write-Host 'Nenhum codigo encontrado. Contagens de marcadores foram salvas; ausencia nao identifica a causa.' }
        return 0
    } catch {
        $code = $_.Exception.Message
        if ($messages.ContainsKey($code)) { Write-Host $messages[$code] }
        else { Write-Host 'Falha local no coletor/download. Confira Internet e permissao de escrita; extraia em uma pasta nova. Nenhum log bruto foi salvo.' }
        return 1
    }
}

if ($MyInvocation.InvocationName -ne '.') { exit (Start-Collector $PSScriptRoot -Recent:$Recent -ServiceHistory:$ServiceHistory) }
