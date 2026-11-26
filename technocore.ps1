# Run technocore_agent.py with the DID passphrase supplied from the DPAPI blob written by
#   set_keystore_password.ps1 -Label 'DID passphrase' -OutFile %USERPROFILE%\.flop\did-passphrase.bin
# The starter prompts with getpass; here the passphrase goes to the child's stdin instead
# (getpass falls back to reading stdin when it is not a console).
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File E:\flop\technocore.ps1 <same args as technocore_agent.py>
#   e.g.  ... -File E:\flop\technocore.ps1 did
#         ... -File E:\flop\technocore.ps1 say technocore "text"
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$AgentArgs
)

$ErrorActionPreference = 'Stop'
if (-not $AgentArgs) {
    Write-Host 'usage: technocore.ps1 <technocore_agent.py args>  (e.g. did | say <room> <text> | read <room>)'
    exit 2
}
$pw = Join-Path $env:USERPROFILE '.flop\did-passphrase.bin'
if (-not (Test-Path -LiteralPath $pw)) {
    Write-Error "no stored DID passphrase: run set_keystore_password.ps1 -Label 'DID passphrase' -OutFile $pw" -ErrorAction Continue
    exit 2
}
Add-Type -AssemblyName System.Security
$blob = [IO.File]::ReadAllBytes($pw)
$bytes = [Security.Cryptography.ProtectedData]::Unprotect($blob, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
$plain = [Text.Encoding]::UTF8.GetString($bytes)
[Array]::Clear($bytes, 0, $bytes.Length)

$python = Join-Path $PSScriptRoot 'technocore-did-starter\.venv\Scripts\python.exe'
$script = Join-Path $PSScriptRoot 'technocore-did-starter\technocore_agent.py'
if (-not (Test-Path -LiteralPath $python) -or -not (Test-Path -LiteralPath $script)) {
    Write-Error "technocore-did-starter venv or script missing under $PSScriptRoot" -ErrorAction Continue
    exit 2
}

# Windows getpass reads the console directly, so stdin piping does not work; the starter
# reads this environment variable instead (local addition in load_identity).
# It also resolves identity.pem relative to the working directory, so run from its dir.
$env:TECHNOCORE_PASSPHRASE = $plain
Push-Location (Split-Path -Parent $script)
try { & $python $script @AgentArgs; $code = $LASTEXITCODE }
finally { Pop-Location; Remove-Item Env:\TECHNOCORE_PASSPHRASE -ErrorAction SilentlyContinue; $plain = $null }
exit $code
