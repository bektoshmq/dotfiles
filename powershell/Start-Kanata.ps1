param(
  [string]$KanataExe = "$env:LOCALAPPDATA\kanata\kanata_winIOv2.exe",
  [string]$ConfigPath = (Join-Path $PSScriptRoot "..\kanata\k2-he-laptop.kbd")
)

$resolvedConfig = (Resolve-Path -LiteralPath $ConfigPath).Path

if (-not (Test-Path -LiteralPath $KanataExe)) {
  throw "Kanata executable not found at '$KanataExe'. Pass -KanataExe with the full path to kanata_winIOv2.exe or kanata_wintercept.exe."
}

Start-Process `
  -FilePath $KanataExe `
  -ArgumentList @("--cfg", $resolvedConfig, "--nodelay") `
  -Verb RunAs
