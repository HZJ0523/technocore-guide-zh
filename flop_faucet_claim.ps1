# FLOP Testnet agent-faucet claim, step 2 (password entry wrapper).
# Prompts for the wallet keystore password with the PowerShell masked prompt and
# pipes it to flop_faucet_claim.mjs on stdin. The password stays in this process.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File E:\flop\flop_faucet_claim.ps1 -Nonce <nonce> [-NoPost] [-Keystore <path>]
#     -Nonce     nonce used in the step-1 Technocore message
#     -NoPost    only check the password and sign; do not send the claim
#     -Keystore  keystore path (default: the wallet keystore next to this script)
param(
    [Parameter(Mandatory = $true)][string]$Nonce,
    [switch]$NoPost,
    [string]$Keystore = ''
)

$ErrorActionPreference = 'Stop'
# Windows PowerShell 5.1 has no $PSScriptRoot inside param() defaults, so resolve it here.
if (-not $Keystore) { $Keystore = Join-Path $PSScriptRoot '5ED4bNNKCq6miyYyyeURuNWpirECfuDxt465aAtEY1VwQoZY.json' }
if (-not (Test-Path -LiteralPath $Keystore)) {
    Write-Error "keystore not found: $Keystore" -ErrorAction Continue
    exit 2
}

$secure = Read-Host -Prompt 'keystore password' -AsSecureString
$plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))

$OutputEncoding = New-Object System.Text.UTF8Encoding($false)
$env:NODE_USE_ENV_PROXY = '1'
$nodeArgs = @((Join-Path $PSScriptRoot 'flop_faucet_claim.mjs'), $Nonce, '--keystore', $Keystore)
if ($NoPost) { $nodeArgs += '--no-post' }

$plain | node @nodeArgs
$plain = $null
