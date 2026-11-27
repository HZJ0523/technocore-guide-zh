# One small settled testnet spend with the stored keystore password (DPAPI blob).
# Used to satisfy the faucet's rolloverRequiresSpend gate and to rehearse the
# scored-phase path. Independent miner; never our own.
param(
    [string]$Miner = '5Cm99adrc7guxVoT6YnC7LxUmmVgPamRsw9nVifRA9NUwDmd',
    [string]$Endpoint = 'https://m14.floptest.xyz',
    [string]$Model = 'qwen/qwen3-8b',
    [string]$MaxFlop = '0.005',
    [int]$MaxTokens = 32
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Security
$b = [Security.Cryptography.ProtectedData]::Unprotect([IO.File]::ReadAllBytes("$env:USERPROFILE\.flop\keystore-pass.bin"), $null, 'CurrentUser')
$env:FLOP_PW = [Text.Encoding]::UTF8.GetString($b)
[Array]::Clear($b, 0, $b.Length)

try {
    node E:\flop\cli\node_modules\@flop-labs\cli\dist\cli.js --network testnet --keystore E:\flop\agent-keystore.json --password-env FLOP_PW --json session run --via force --miner $Miner --endpoint $Endpoint --model $Model --max-duration 1200 --max-flop $MaxFlop --max-tokens $MaxTokens --prompt "Reply with exactly: OK"
    exit $LASTEXITCODE
}
finally {
    Remove-Item Env:\FLOP_PW -ErrorAction SilentlyContinue
}
