def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if ($var.name | str upcase) == 'PATH' {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" and $var.name in $env {
      hide-env $var.name
    }
  }
}
export-env {
  
  'hide,RUSTUP_TOOLCHAIN,
set,PATH,C:\Users\bekto\AppData\Local\Microsoft\WinGet\Packages\BrechtSanders.WinLibs.POSIX.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe\mingw64\bin;D:\.bun\bin;D:\go\bin;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\PowerShell\7\;C:\Program Files\WezTerm;C:\Program Files\Git\cmd;C:\Program Files\nu\bin\;C:\Program Files\Neovim\bin;C:\Program Files\starship\bin\;C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\;C:\Users\bekto\AppData\Local\Microsoft\WindowsApps;C:\Users\bekto\AppData\Local\Voidstar\FilePilot;C:\Users\bekto\AppData\Local\PowerToys\DSCModules\;C:\Users\bekto\AppData\Local\Programs\Zed\bin;C:\Users\bekto\AppData\Local\Microsoft\WinGet\Links;
hide,MISE_SHELL,
hide,__MISE_DIFF,
hide,__MISE_DIFF,' | parse vars | update-env
  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"C:\\Users\\bekto\\AppData\\Local\\Microsoft\\WinGet\\Links\\mise.exe"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"C:\\Users\\bekto\\AppData\\Local\\Microsoft\\WinGet\\Links\\mise.exe" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"C:\\Users\\bekto\\AppData\\Local\\Microsoft\\WinGet\\Links\\mise.exe" $command ...$rest
  }
}

def --env mise_hook [] {
  ^"C:\\Users\\bekto\\AppData\\Local\\Microsoft\\WinGet\\Links\\mise.exe" hook-env -s nu
    | parse vars
    | update-env
}

