# Store the keystore password for unattended faucet claims.
#
# The password is read with the masked prompt and written DPAPI-encrypted
# (DataProtectionScope CurrentUser) to %USERPROFILE%\.flop\keystore-pass.bin —
# outside this repository, decryptable only by this Windows account on this machine.
# flop_faucet_claim.ps1 picks the file up automatically when it exists; without it
# the script prompts as before.
#
# Revoke: delete the file (Remove-Item $env:USERPROFILE\.flop\keystore-pass.bin).
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File E:\flop\set_keystore_password.ps1 [-Label <text>] [-OutFile <path>]
#   powershell ... -Label 'DID passphrase' -OutFile %USERPROFILE%\.flop\did-passphrase.bin
#     stores the Technocore DID passphrase for technocore.ps1 (unattended say/did/kv)
param(
    [string]$OutFile = '',
    [string]$Label = 'keystore password'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Security

if (-not $OutFile) { $OutFile = Join-Path $env:USERPROFILE '.flop\keystore-pass.bin' }

$secure = Read-Host -Prompt "$Label (will be stored DPAPI-encrypted for your Windows account)" -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
$plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
$secure = $null
try {
    $bytes = [Text.Encoding]::UTF8.GetBytes($plain)
    $blob = [Security.Cryptography.ProtectedData]::Protect($bytes, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
    [Array]::Clear($bytes, 0, $bytes.Length)
}
finally {
    $plain = $null
}

$dir = Split-Path -Parent $OutFile
if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
[IO.File]::WriteAllBytes($OutFile, $blob)
Write-Host "stored $($blob.Length) bytes at $OutFile"
