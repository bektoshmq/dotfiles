# Nushell behavior
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.history.max_size = 3000
$env.config.shell_integration.osc133 = false

# Prompt
$env.PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""

if (which starship | is-empty) {
  print --stderr "yo, you don't have starship installed"
} else {
  $env.STARSHIP_SHELL = "nu"
  $env.PROMPT_MULTILINE_INDICATOR = (^starship prompt --continuation)
  $env.PROMPT_INDICATOR = ""
  $env.PROMPT_COMMAND = {||
    let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS }
    ^starship prompt --cmd-duration $cmd_duration $"--status=($env.LAST_EXIT_CODE)" --terminal-width (term size).columns | str trim -r -c "\n"
  }
}

# Zoxide
source vendor/autoload/zoxide.nu

# Mise
use vendor/autoload/mise.nu

# Aliases
alias cat = bat

export def --wrapped la [...rest: string] {
  ^eza --icons -a ...$rest
}

export def --wrapped ll [...rest: string] {
  ^eza --long --group --icons ...$rest
}

export def --wrapped lla [...rest: string] {
  ^eza --long --group --icons -a ...$rest
}

# FZF
def __fzf_file_candidates [] {
  if not (which fd | is-empty) {
    ^fd --type f --hidden --follow --strip-cwd-prefix --exclude .git .
    | lines
    | where {|line| $line != "" }
  } else {
    ls **/*
    | where type == file
    | get name
    | each {|path| $path | path relative-to $env.PWD }
  }
}

def __fzf_quote_path [path: string] {
  if ($path | str contains "'") {
    let escaped = ($path | str replace --all '\\' '\\\\' | str replace --all '"' '\\"')
    [ '"' $escaped '"' ] | str join ""
  } else {
    [ "'" $path "'" ] | str join ""
  }
}

def --env __fzf_insert_file [] {
  if (which fzf | is-empty) {
    return
  }

  let selected = (
    __fzf_file_candidates
    | str join (char nl)
    | ^fzf --prompt "Files> " --height 40% --layout reverse
    | str trim
  )

  if $selected != "" {
    commandline edit --insert (__fzf_quote_path $selected)
  }
}

# Keybindings
$env.config.keybindings ++= [
  {
    name: "clear_commandline"
    modifier: "control"
    keycode: "char_u"
    mode: "vi_insert"
    event: {
      edit: "CutFromStart"
    }
  }
  {
    name: "fzf_file_picker"
    modifier: "control"
    keycode: "char_f"
    mode: "vi_insert"
    event: {
      send: executehostcommand
      cmd: "__fzf_insert_file"
    }
  }
  {
    name: "menu_down_ctrl_j"
    modifier: "control"
    keycode: "char_j"
    mode: "vi_insert"
    event: {
      until: [
        { send: menudown }
        { send: down }
      ]
    }
  }
  {
    name: "menu_up_ctrl_k"
    modifier: "control"
    keycode: "char_k"
    mode: "vi_insert"
    event: {
      until: [
        { send: menuup }
        { send: up }
      ]
    }
  }
]

# Theme
source themes/rose_pine.nu

# Completions
source completions/git.nu
source completions/zellij.nu
