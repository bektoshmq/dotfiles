local wezterm = require 'wezterm'
local mux = wezterm.mux

local act = wezterm.action
local config = wezterm.config_builder()

local MUX_DOMAIN = 'main'
local PROJECT_SCAN_ROOT = [[D:\]]
local PICKER_EVENT = 'workspace-picker'

local function trim(value)
  return (value:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function split_lines(value)
  local lines = {}
  for line in value:gmatch('[^\r\n]+') do
    local item = trim(line)
    if item ~= '' then
      table.insert(lines, item)
    end
  end
  return lines
end

local function basename(path)
  local normalized = path:gsub('\\+$', '')
  local name = normalized:match('([^\\/]+)$')
  if name and name ~= '' then
    return name
  end

  local drive = normalized:match('^([A-Za-z]):\\?$')
  if drive then
    return drive:lower() .. '-root'
  end

  return 'workspace'
end

local function stable_hash(value)
  local hash = 2166136261
  for i = 1, #value do
    hash = (hash ~ value:byte(i)) * 16777619
    hash = hash % 4294967296
  end
  return hash
end

local function normalize_path(value)
  if not value then
    return nil
  end

  local path = value
  if type(value) == 'table' and value.file_path then
    path = value.file_path
  end

  if type(path) ~= 'string' then
    return nil
  end

  path = trim(path):gsub('/', '\\')
  if path == '' then
    return nil
  end

  if path:match('^[A-Za-z]:\\$') then
    return path
  end

  path = path:gsub('\\+$', '')
  return path ~= '' and path or nil
end

local function path_key(path)
  local normalized = normalize_path(path)
  if not normalized then
    return nil
  end
  return normalized:lower()
end

local function run_first_available(commands)
  for _, argv in ipairs(commands) do
    local ok, stdout, _ = wezterm.run_child_process(argv)
    if ok then
      return stdout
    end
  end
  return nil
end

local function discover_zoxide_paths()
  local stdout = run_first_available {
    { 'zoxide.exe', 'query', '--list' },
    { 'zoxide', 'query', '--list' },
  }

  if not stdout then
    return {}
  end

  local paths = {}
  local seen = {}
  for _, line in ipairs(split_lines(stdout)) do
    local path = normalize_path(line)
    if path then
      local key = path:lower()
      if not seen[key] then
        seen[key] = true
        table.insert(paths, path)
      end
    end
  end
  return paths
end

local function discover_fd_paths()
  local stdout = run_first_available {
    {
      'fd.exe',
      '--type',
      'd',
      '--max-depth',
      '2',
      '--color',
      'never',
      '--absolute-path',
      '--exclude',
      '.git',
      '.',
      PROJECT_SCAN_ROOT,
    },
    {
      'fd',
      '--type',
      'd',
      '--max-depth',
      '2',
      '--color',
      'never',
      '--absolute-path',
      '--exclude',
      '.git',
      '.',
      PROJECT_SCAN_ROOT,
    },
  }

  if not stdout then
    return {}
  end

  local paths = {}
  local seen = {}
  for _, line in ipairs(split_lines(stdout)) do
    local path = normalize_path(line)
    if path then
      local key = path:lower()
      if not seen[key] then
        seen[key] = true
        table.insert(paths, path)
      end
    end
  end
  return paths
end

local function workspace_name_for_path(path, workspaces)
  local preferred = basename(path)
  local preferred_key = preferred:lower()
  local existing = workspaces[preferred_key]
  if not existing or (existing.path and path_key(existing.path) == path_key(path)) then
    return preferred
  end

  local suffix = string.format('%04x', stable_hash(path) % 65536)
  local candidate = preferred .. '-' .. suffix
  local counter = 1
  while workspaces[candidate:lower()] and path_key(workspaces[candidate:lower()].path) ~= path_key(path) do
    counter = counter + 1
    candidate = string.format('%s-%04x-%d', preferred, stable_hash(path) % 65536, counter)
  end
  return candidate
end

local function describe_workspace(name, path)
  if path then
    return string.format('[workspace] %s  %s', name, path)
  end
  return string.format('[workspace] %s', name)
end

local function describe_project(path, name)
  return string.format('[project] %s  ->  %s', name, path)
end

local function collect_workspace_state()
  local workspaces = {}

  for _, name in ipairs(mux.get_workspace_names()) do
    workspaces[name:lower()] = {
      name = name,
      path = nil,
    }
  end

  for _, window in ipairs(mux.all_windows()) do
    local workspace = window:get_workspace()
    local entry = workspaces[workspace:lower()]
    if entry and not entry.path then
      local pane = window:active_pane()
      local cwd = pane and normalize_path(pane:get_current_working_dir()) or nil
      if cwd then
        entry.path = cwd
      end
    end
  end

  return workspaces
end

local function build_picker_choices()
  local workspaces = collect_workspace_state()
  local by_path = {}
  local choices = {}

  local workspace_names = {}
  for _, item in pairs(workspaces) do
    table.insert(workspace_names, item.name)
  end
  table.sort(workspace_names, function(left, right)
    return left:lower() < right:lower()
  end)

  for _, name in ipairs(workspace_names) do
    local entry = workspaces[name:lower()]
    if entry.path then
      by_path[path_key(entry.path)] = true
    end

    table.insert(choices, {
      id = wezterm.json_encode {
        kind = 'workspace',
        workspace = entry.name,
      },
      label = describe_workspace(entry.name, entry.path),
    })
  end

  local project_paths = {}
  for _, path in ipairs(discover_zoxide_paths()) do
    table.insert(project_paths, path)
  end
  for _, path in ipairs(discover_fd_paths()) do
    table.insert(project_paths, path)
  end
  table.sort(project_paths, function(left, right)
    return left:lower() < right:lower()
  end)

  local seen_projects = {}
  for _, path in ipairs(project_paths) do
    local key = path:lower()
    if not seen_projects[key] then
      seen_projects[key] = true
      if not by_path[key] then
        local workspace_name = workspace_name_for_path(path, workspaces)
        table.insert(choices, {
          id = wezterm.json_encode {
            kind = 'project',
            workspace = workspace_name,
            cwd = path,
          },
          label = describe_project(path, workspace_name),
        })
      end
    end
  end

  return choices
end

local function prompt_for_workspace()
  return act.PromptInputLine {
    description = 'Enter a workspace name',
    action = wezterm.action_callback(function(window, pane, line)
      if not line or line == '' then
        return
      end

      window:perform_action(
        act.SwitchToWorkspace {
          name = line,
        },
        pane
      )
    end),
  }
end

wezterm.on(PICKER_EVENT, function(window, pane)
  local choices = build_picker_choices()
  if #choices == 0 then
    window:toast_notification('WezTerm', 'No workspaces or project directories found', nil, 3000)
    return
  end

  window:perform_action(
    act.InputSelector {
      title = 'Projects and Workspaces',
      description = 'Enter = open, Esc = cancel, / = fuzzy filter',
      fuzzy = true,
      choices = choices,
      action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
        if not id then
          return
        end

        local decoded = wezterm.json_parse(id)
        if decoded.kind == 'workspace' then
          inner_window:perform_action(
            act.SwitchToWorkspace {
              name = decoded.workspace,
            },
            inner_pane
          )
          return
        end

        inner_window:perform_action(
          act.SwitchToWorkspace {
            name = decoded.workspace,
            spawn = {
              cwd = decoded.cwd,
            },
          },
          inner_pane
        )
      end),
    },
    pane
  )
end)

wezterm.on('update-right-status', function(window, _)
  local workspace = window:active_workspace()
  window:set_right_status(wezterm.format {
    { Text = 'mux:' .. MUX_DOMAIN .. '  ws:' .. workspace .. ' ' },
  })
end)

config.default_prog = { 'nu.exe' }
config.default_cwd = [[D:\]]
config.default_domain = MUX_DOMAIN
config.unix_domains = {
  {
    name = MUX_DOMAIN,
  },
}
config.default_gui_startup_args = { 'connect', MUX_DOMAIN }

config.window_decorations = 'RESIZE'
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.window_close_confirmation = 'NeverPrompt'
config.automatically_reload_config = true

config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Medium' })
config.font_size = 18
config.font_rules = {
  {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold' }),
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font('JetBrainsMono Nerd Font', {
      weight = 'Bold',
      style = 'Italic',
    }),
  },
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font('JetBrainsMono Nerd Font', {
      weight = 'Medium',
      style = 'Italic',
    }),
  },
}

config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.animation_fps = 1
config.hide_mouse_cursor_when_typing = true

config.color_scheme = 'rose-pine'
config.colors = {
  background = '#000000',
}

config.window_background_opacity = 1.0

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = 'P',
    mods = 'CTRL|ALT',
    action = act.ActivateCommandPalette,
  },
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = act.SendKey { key = 'a', mods = 'CTRL' },
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Rename current tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  {
    key = '-',
    mods = 'ALT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '\\',
    mods = 'ALT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '\\',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'x',
    mods = 'ALT',
    action = act.CloseCurrentPane { confirm = false },
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = act.CloseCurrentPane { confirm = false },
  },
  {
    key = 'z',
    mods = 'ALT',
    action = act.TogglePaneZoomState,
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  {
    key = '[',
    mods = 'ALT',
    action = act.ActivateCopyMode,
  },
  {
    key = '[',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'H',
    mods = 'LEADER|SHIFT',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'J',
    mods = 'LEADER|SHIFT',
    action = act.AdjustPaneSize { 'Down', 3 },
  },
  {
    key = 'K',
    mods = 'LEADER|SHIFT',
    action = act.AdjustPaneSize { 'Up', 3 },
  },
  {
    key = 'L',
    mods = 'LEADER|SHIFT',
    action = act.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'c',
    mods = 'ALT',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'h',
    mods = 'ALT',
    action = act.ActivateTabRelative(-1),
  },
  {
    key = 'l',
    mods = 'ALT',
    action = act.ActivateTabRelative(1),
  },
  {
    key = 'd',
    mods = 'ALT',
    action = act.DetachDomain 'CurrentPaneDomain',
  },
  {
    key = 's',
    mods = 'ALT',
    action = act.EmitEvent(PICKER_EVENT),
  },
  {
    key = 'o',
    mods = 'ALT',
    action = prompt_for_workspace(),
  },
  {
    key = 'H',
    mods = 'ALT|SHIFT',
    action = act.SwitchWorkspaceRelative(-1),
  },
  {
    key = 'L',
    mods = 'ALT|SHIFT',
    action = act.SwitchWorkspaceRelative(1),
  },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end

return config


