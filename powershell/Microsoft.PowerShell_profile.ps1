# Keep the real profile thin and track the actual PowerShell setup in dotfiles.
$mise = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\mise.exe'
if (Test-Path -LiteralPath $mise) {
  (& $mise env -s pwsh) | Out-String | Invoke-Expression
  (& $mise activate pwsh) | Out-String | Invoke-Expression
}
