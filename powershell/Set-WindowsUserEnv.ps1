[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$dirs = @(
  "D:\.cache",
  "D:\.state",
  "D:\.local\share",
  "D:\tmp",
  "D:\.cargo",
  "D:\.cargo\bin",
  "D:\.rustup",
  "D:\go",
  "D:\go\pkg\mod",
  "D:\.cache\go-build",
  "D:\.bun",
  "D:\.bun\bin",
  "D:\.cache\bun\install",
  "D:\.cache\bun\transpiler",
  "D:\.cache\python",
  "D:\.cache\python\pip",
  "D:\.cache\python\uv",
  "D:\.cache\python\pyc",
  "D:\.cache\npm",
  "D:\.cache\npm\_cacache"
)

$userEnv = [ordered]@{
  XDG_CONFIG_HOME                 = "D:\dotfiles"
  XDG_CACHE_HOME                  = "D:\.cache"
  XDG_DATA_HOME                   = "D:\.local\share"
  XDG_STATE_HOME                  = "D:\.state"
  BAT_CONFIG_DIR                  = "D:\dotfiles\bat"
  LIBCLANG_PATH                   = "C:\Program Files\LLVM\bin"
  TMP                             = "D:\tmp"
  TEMP                            = "D:\tmp"
  TMPDIR                          = "D:\tmp"
  CARGO_HOME                      = "D:\.cargo"
  RUSTUP_HOME                     = "D:\.rustup"
  GOPATH                          = "D:\go"
  GOMODCACHE                      = "D:\go\pkg\mod"
  GOCACHE                         = "D:\.cache\go-build"
  BUN_INSTALL                     = "D:\.bun"
  BUN_INSTALL_CACHE_DIR           = "D:\.cache\bun\install"
  BUN_RUNTIME_TRANSPILER_CACHE_PATH = "D:\.cache\bun\transpiler"
  PIP_CACHE_DIR                   = "D:\.cache\python\pip"
  UV_CACHE_DIR                    = "D:\.cache\python\uv"
  PYTHONPYCACHEPREFIX             = "D:\.cache\python\pyc"
  NPM_CONFIG_CACHE                = "D:\.cache\npm"
}

$winlibsBin = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages\BrechtSanders.WinLibs.POSIX.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe\mingw64\bin"
$vsLlvmBin = "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Tools\Llvm\x64\bin"
$pathEntries = @(
  (Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Links"),
  "C:\Program Files\LLVM\bin",
  $winlibsBin,
  $vsLlvmBin,
  "D:\clones\Odin",
  "D:\.cargo\bin",
  (Join-Path $env:USERPROFILE ".cargo\bin"),
  "D:\go\bin",
  "D:\.bun\bin"
)

foreach ($dir in $dirs)
{
  if (-not (Test-Path -LiteralPath $dir))
  {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
}

foreach ($pair in $userEnv.GetEnumerator())
{
  [Environment]::SetEnvironmentVariable($pair.Key, $pair.Value, "User")
}

$existingUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
$combined = @()
if ($existingUserPath)
{
  $combined += ($existingUserPath -split ";")
}
$combined += $pathEntries

$seen = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
$deduped = New-Object 'System.Collections.Generic.List[string]'

foreach ($entry in $combined)
{
  $trimmed = $entry.Trim()
  if (-not $trimmed)
  {
    continue
  }
  if ($seen.Add($trimmed))
  {
    $deduped.Add($trimmed)
  }
}

[Environment]::SetEnvironmentVariable("Path", ($deduped -join ";"), "User")

Write-Host "Updated user environment variables and PATH."
Write-Host "Restart terminals and GUI apps to pick up the new environment."
