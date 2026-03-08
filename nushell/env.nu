use std 'path add'

# Editor env vars for child processes
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

let config_dir = ($nu.config-path | path dirname)
let zoxide_init = ($config_dir | path join "vendor" "autoload" "zoxide.nu")
let mise_init = ($config_dir | path join "vendor" "autoload" "mise.nu")

if not (which zoxide | is-empty) {
  mkdir ($zoxide_init | path dirname)
  ^zoxide init nushell | save -f $zoxide_init
}

if not (which mise | is-empty) {
  mkdir ($mise_init | path dirname)
  ^mise activate nu | save -f $mise_init
}

if $nu.os-info.name == 'windows' {
  $env.XDG_CONFIG_HOME = 'D:\dotfiles'
  $env.BAT_CONFIG_DIR = 'D:\dotfiles\bat'
  let winlibs_bin = (
    $env.LOCALAPPDATA
    | path join "Microsoft" "WinGet" "Packages" "BrechtSanders.WinLibs.POSIX.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe" "mingw64" "bin"
  )

  let dev_cache = "D:\\.cache"
  let dev_state = "D:\\.state"
  let dev_tmp = "D:\\tmp"
  let go_root = "D:\\go"
  let bun_root = "D:\\.bun"
  let cargo_root = "D:\\.cargo"
  let rustup_root = "D:\\.rustup"
  let python_cache = "D:\\.cache\\python"
  let npm_cache = "D:\\.cache\\npm"

  for dir in [
    $dev_cache
    $dev_state
    $dev_tmp
    $go_root
    $bun_root
    $cargo_root
    $rustup_root
    $python_cache
    $npm_cache
    ($go_root | path join "pkg" "mod")
    ($dev_cache | path join "go-build")
    ($dev_cache | path join "bun" "install")
    ($dev_cache | path join "bun" "transpiler")
    ($python_cache | path join "pip")
    ($python_cache | path join "uv")
    ($python_cache | path join "pyc")
    ($npm_cache | path join "_cacache")
  ] {
    if not ($dir | path exists) {
      mkdir $dir
    }
  }

  # Put mutable caches, state, temp files, and package stores on the Dev Drive.
  $env.XDG_CACHE_HOME = $dev_cache
  $env.XDG_STATE_HOME = $dev_state
  $env.TMP = $dev_tmp
  $env.TEMP = $dev_tmp
  $env.TMPDIR = $dev_tmp

  $env.GOPATH = $go_root
  $env.GOMODCACHE = ($go_root | path join "pkg" "mod")
  $env.GOCACHE = ($dev_cache | path join "go-build")

  $env.BUN_INSTALL = $bun_root
  $env.BUN_INSTALL_CACHE_DIR = ($dev_cache | path join "bun" "install")
  $env.BUN_RUNTIME_TRANSPILER_CACHE_PATH = ($dev_cache | path join "bun" "transpiler")

  $env.CARGO_HOME = $cargo_root
  $env.RUSTUP_HOME = $rustup_root

  $env.PIP_CACHE_DIR = ($python_cache | path join "pip")
  $env.UV_CACHE_DIR = ($python_cache | path join "uv")
  $env.PYTHONPYCACHEPREFIX = ($python_cache | path join "pyc")

  $env.NPM_CONFIG_CACHE = $npm_cache
  $env.npm_config_cache = $npm_cache

  if ($winlibs_bin | path exists) {
    path add $winlibs_bin
  }
  path add ($go_root | path join "bin")
  path add ($bun_root | path join "bin")
  path add ($cargo_root | path join "bin")
}

# Keep current path and XDG setup on Unix-like systems only.
if $nu.os-info.name != 'windows' {
  $env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
  path add ~/.local/bin
  path add ~/go/bin
  path add ~/.cargo/bin
  path add /opt/homebrew/bin
  path add ~/.bun/bin
  path add ~/.orbstack/bin
}


