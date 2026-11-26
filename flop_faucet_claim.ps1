# FLOP Testnet agent-faucet claim (password entry wrapper), built on the official CLI.
# @flop-labs/cli 0.9.0 `flop faucet request` sends the signed agent claim described in
# https://flop.network/llms.txt ("Get Testnet FLOP") and checks the faucet status before
# signing. The wallet keystore password is read with the PowerShell masked prompt and passed
# to the CLI in a process environment variable that is removed afterwards.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File E:\flop\flop_faucet_claim.ps1 [-Nonce <n>] [-Keystore <path>]
#     -Nonce     optional. Repeat a previous claim's nonce to reconcile it instead of paying
#                again; leave it out for a new claim.
#     -Keystore  keystore path (default: agent-keystore.json next to this script)
#
# Fallback if the CLI cannot reach the Testnet RPC: flop_faucet_claim.mjs posts the same
# claim directly.
param(
    [string]$Nonce = '',
    [string]$Keystore = ''
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

$secure = Read-Host -Prompt 'keystore password' -AsSecureString
$env:FLOP_PW = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
$secure = $null

$env:NODE_USE_ENV_PROXY = '1'
$nodeArgs = @($cli, '--network', 'testnet', '--keystore', $Keystore, '--password-env', 'FLOP_PW',
    'faucet', 'request', '5ED4bNNKCq6miyYyyeURuNWpirECfuDxt465aAtEY1VwQoZY', '--json')
if ($Nonce) { $nodeArgs += @('--nonce', $Nonce) }

try {
    node @nodeArgs
}
finally {
    Remove-Item Env:\FLOP_PW -ErrorAction SilentlyContinue
}
