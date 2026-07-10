[CmdletBinding()]
param(
  [string]$TargetDir = (Join-Path $env:APPDATA "Sublime Text\Packages\User")
)

$ErrorActionPreference = "Stop"

$SourceDir = $PSScriptRoot

$filesToSync = @(
  "Preferences.sublime-settings",
  "C.sublime-settings",
  "C++.sublime-settings",
  "Rust.sublime-settings",
  "LSP-clangd.sublime-settings",
  "LSP-rust-analyzer.sublime-settings",
  "Clang (C++).sublime-build",
  "Default (Windows).sublime-keymap",
  ".neovintageousrc",
  "ToggleSidebarFocus.py"
)

if (-not (Test-Path -LiteralPath $TargetDir)) {
  throw "Sublime Text User directory not found at '$TargetDir'. Install Sublime Text first."
}

$created = 0
$skipped = 0
$backedUp = 0

foreach ($file in $filesToSync) {
  $sourcePath = Join-Path $SourceDir $file
  $targetPath = Join-Path $TargetDir $file

  if (-not (Test-Path -LiteralPath $sourcePath)) {
    Write-Warning "Source file missing, skipping: $file"
    continue
  }

  if (Test-Path -LiteralPath $targetPath) {
    $item = Get-Item -LiteralPath $targetPath -Force
    if ($item.LinkType -eq "SymbolicLink") {
      $resolvedTarget = if ($item.Target) { (Resolve-Path -LiteralPath $item.Target[0] -ErrorAction SilentlyContinue).Path } else { $item.Target }
      $resolvedSource = (Resolve-Path -LiteralPath $sourcePath).Path
      if ($resolvedTarget -eq $resolvedSource) {
        $skipped++
        continue
      }
    }

    $backupPath = "$targetPath.bak"
    if (Test-Path -LiteralPath $backupPath) {
      Remove-Item -LiteralPath $backupPath -Force
    }
    Move-Item -LiteralPath $targetPath -Destination $backupPath -Force
    $backedUp++
    Write-Host "Backed up existing file: $file -> $file.bak"
  }

  $result = cmd /c mklink "$targetPath" "$sourcePath" 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to create symlink for $file`: $result"
  }
  $created++
  Write-Host "Linked: $file"
}

Write-Host ""
Write-Host "Done. Created: $created, Skipped (already linked): $skipped, Backed up: $backedUp"
if ($backedUp -gt 0) {
  Write-Host "Backups saved with .bak extension in $TargetDir"
}
