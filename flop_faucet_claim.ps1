# FLOP Testnet agent-faucet claim (password entry wrapper), built on the official CLI.
# @flop-labs/cli 0.9.0 `flop faucet request` sends the signed agent claim described in
# https://flop.network/llms.txt ("Get Testnet FLOP") and checks the faucet status before
# signing. The wallet keystore password is read with the PowerShell masked prompt and passed
# to the CLI in a process environment variable that is removed afterwards.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File E:\flop\flop_faucet_claim.ps1 [-Nonce <n>] [-Keystore <path>] [-Wait] [-WaitMinutes <m>]
#     -Nonce       optional. Repeat a previous claim's nonce to reconcile it instead of paying
#                  again; leave it out for a new claim.
#     -Keystore    keystore path (default: agent-keystore.json next to this script)
#     -Wait        enter the password once, then poll faucet.status (3 s) and submit the moment
#                  it is "open". The open windows last seconds — 11-26 05:58 UTC it closed again
#                  in under a minute. The password stays in this process's environment until the
#                  wait ends (default 30 min), so run it on your own machine and Ctrl-C when done.
#     -WaitMinutes poll cap for -Wait (default 30)
#
# Fallback if the CLI cannot reach the Testnet RPC: flop_faucet_claim.mjs posts the same
# claim directly.
param(
    [string]$Nonce = '',
    [string]$Keystore = '',
    [switch]$Wait,
    [int]$WaitMinutes = 30,
    [string]$PasswordFile = ''
)

$ErrorActionPreference = 'Stop'
# Windows PowerShell 5.1 has no $PSScriptRoot inside param() defaults, so resolve it here.
if (-not $Keystore) { $Keystore = Join-Path $PSScriptRoot 'agent-keystore.json' }
$cli = Join-Path $PSScriptRoot 'cli\node_modules\@flop-labs\cli\dist\cli.js'
if (-not (Test-Path -LiteralPath $Keystore)) {
    Write-Error "keystore not found: $Keystore" -ErrorAction Continue
    exit 2
}
if (-not (Test-Path -LiteralPath $cli)) {
    # The CLI keeps its own dependency tree under cli\; installing it next to the
    # fallback script's @polkadot/keyring 13 breaks both.
    Write-Error "official CLI not found: $cli (run: npm install --prefix $PSScriptRoot\cli @flop-labs/cli@0.9.0)" -ErrorAction Continue
    exit 2
}

# Password source: -PasswordFile > %USERPROFILE%\.flop\keystore-pass.bin (written by
# set_keystore_password.ps1, DPAPI-encrypted for this Windows account) > masked prompt.
if (-not $PasswordFile) {
    $defaultPw = Join-Path $env:USERPROFILE '.flop\keystore-pass.bin'
    if (Test-Path -LiteralPath $defaultPw) { $PasswordFile = $defaultPw }
}
if ($PasswordFile) {
    Add-Type -AssemblyName System.Security
    $blob = [IO.File]::ReadAllBytes($PasswordFile)
    $bytes = [Security.Cryptography.ProtectedData]::Unprotect($blob, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
    try { $env:FLOP_PW = [Text.Encoding]::UTF8.GetString($bytes) }
    finally { [Array]::Clear($bytes, 0, $bytes.Length) }
}
else {
    $secure = Read-Host -Prompt 'keystore password' -AsSecureString
    $env:FLOP_PW = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
    $secure = $null
}

$env:NODE_USE_ENV_PROXY = '1'
$nodeArgs = @($cli, '--network', 'testnet', '--keystore', $Keystore, '--password-env', 'FLOP_PW',
    'faucet', 'request', '5ED4bNNKCq6miyYyyeURuNWpirECfuDxt465aAtEY1VwQoZY', '--json')
if ($Nonce) { $nodeArgs += @('--nonce', $Nonce) }

function Get-FaucetStatus {
    try { (Invoke-RestMethod -UseBasicParsing -TimeoutSec 10 'https://faucet.flop.network/limits').faucet.status }
    catch { '' }
}

try {
    if (-not $Wait) {
        node @nodeArgs
        exit $LASTEXITCODE
    }
    $deadline = (Get-Date).AddMinutes($WaitMinutes)
    while ($true) {
        $status = ''
        while ((Get-Date) -lt $deadline) {
            $status = Get-FaucetStatus
            if ($status -eq 'open') { break }
            Start-Sleep -Seconds 3
        }
        if ($status -ne 'open') {
            Write-Host "faucet still '$status' after $WaitMinutes min; nothing sent"
            exit 3
        }
        # 2>&1 makes the CLI's stderr JSON an error record; with ErrorActionPreference=Stop
        # (set above) PowerShell 5.1 turns that into a terminating NativeCommandError, so
        # relax it for the invocation only.
        $eap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try { $out = & node @nodeArgs 2>&1 | Out-String; $code = $LASTEXITCODE }
        finally { $ErrorActionPreference = $eap }
        Write-Host $out
        # Lost the race (window shut between poll and submit): keep waiting until the deadline.
        if ($out -match 'FAUCET_NOT_OPEN' -and (Get-Date) -lt $deadline) { Start-Sleep -Seconds 2; continue }
        exit $code
    }
}
finally {
    Remove-Item Env:\FLOP_PW -ErrorAction SilentlyContinue
}
