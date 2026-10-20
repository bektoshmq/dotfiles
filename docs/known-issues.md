# Known Issues

## WezTerm + Nushell on Windows scrolls on each keypress

Date: 2026-03-07

Symptoms:
- Typing in Nushell inside WezTerm pushes prior content upward.
- A large empty gap appears above the current prompt.
- This does not reproduce in Windows Terminal.
- The issue still reproduces with bare `nu` and no user config.

Cause:
- Nushell shell integration via `osc133` interacts badly with WezTerm on Windows.
- This appears to be a known upstream combo issue related to prompt repainting.

Fix:
- In [config.nu](/D:/dotfiles/nushell/.config/nushell/config.nu), set:
  ```nu
  $env.config.shell_integration.osc133 = false
  ```

Notes:
- This was not caused by Starship.
- Starship was a separate setup issue.
- `starship prompt` worked, but prompt takeover did not until the active Starship setup was moved directly into `config.nu`.
- Passing `--config` and `--env-config` to Nushell does not relocate Nushell's default config root or autoload directories.
- For this repo, the active Nushell prompt/integration logic currently lives directly in [config.nu](/D:/dotfiles/nushell/.config/nushell/config.nu) to avoid autoload ambiguity.

References:
- [WezTerm shell integration docs](https://wezterm.org/shell-integration.html)
- [Nushell-related report mentioning continued scrolling with typing when osc133 is enabled](https://gitea.starconnect.ch/Public/nushell/commits/commit/4ab2c3238acdc8f4ef1987522b5edb37a78f83e8/crates/nu-cli#L378)
## Nushell + mise on Windows fails in IR mode when loaded from `%APPDATA%`

Date: 2026-03-07

Symptoms:
- Running bare `nu` can fail on startup with:
  ```text
  Can't evaluate block in IR mode
  block is missing compiled representation
  ```
- The traceback points at `%APPDATA%\nushell\vendor\autoload\mise.nu`.
- This can surface in Zed as `Failed to load environment variables`.
- Running Nushell with explicit config flags works:
  ```powershell
  nu --config "D:\dotfiles\nushell\config.nu" --env-config "D:\dotfiles\nushell\env.nu"
  ```

Cause:
- Likely an upstream Nushell IR/runtime issue triggered by the generated `mise` Nushell integration.
- The failure appears path-sensitive on Windows.
- Loading the config through `%APPDATA%\nushell\...` fails, while loading the same config content through `D:\dotfiles\...` works.
- The generated `mise.nu` module itself parses, but the failure appears when interactive startup/hook execution is involved.

Repro:
- Fails:
  ```powershell
  nu --config "C:\Users\bekto\AppData\Roaming\nushell\config.nu" --env-config "C:\Users\bekto\AppData\Roaming\nushell\env.nu"
  ```
- Works:
  ```powershell
  nu --config "D:\dotfiles\nushell\config.nu" --env-config "D:\dotfiles\nushell\env.nu"
  ```

What was ruled out:
- Not a Zed-specific problem. Zed was only surfacing the startup failure.
- Not just a symlink problem. The issue persisted after replacing `%APPDATA%\nushell` with a real copied directory.
- Not a simple syntax error in `mise.nu`. The generated module parses and can be loaded in non-interactive checks.

Current workaround:
- Do not rely on bare `nu` if this matters in a given app/session.
- Launch Nushell with explicit `--config` and `--env-config` paths that point at the repo copy.
- For Zed specifically, do not force Nushell as the builtin terminal shell for now, because Zed's env-loading path is sensitive to this startup failure.

Notes:
- The active `mise` import is in [config.nu](/D:/dotfiles/nushell/.config/nushell/config.nu).
- The generated file comes from [env.nu](/D:/dotfiles/nushell/.config/nushell/env.nu).
- This looks consistent with Nushell IR instability on current releases.

References:
- [Nushell issue #15466](https://github.com/nushell/nushell/issues/15466)


## Ghostty loses Hyprland blur after GTK 4.24 (Omarchy 4.0.5)

Date: 2026-10-19

Status: TEMPORARY workaround in place. Remove it once Omarchy 4.5 is installed.

Symptoms:
- After the 2026-10-19 `omarchy update`, Ghostty is still see-through (`background-opacity = 0.82`) but the wallpaper behind it is sharp, not blurred.
- Electron apps with Hyprland opacity rules (Obsidian, Cursor) still blur normally.
- Changing Hyprland blur settings (`new_optimizations`, `xray`, size/passes, a 0.99 opacity window rule) makes no difference.

Cause:
- That update moved `gtk4` 4.22.4 -> 4.24.1 and `libadwaita` 1.9.3 -> 1.10.0.
- GTK 4.24 registers every window with Hyprland's blur protocol and asks for blur only where a CSS `backdrop-filter` covers it. Without one, GTK apps opt out of blur, and Hyprland 0.56 honors that.
- Not a Hyprland bug, so no Hyprland fix is coming.

Current workaround:
- [ghostty/glass.css](../ghostty/glass.css) adds `window { backdrop-filter: blur(20px); }`, copied from Omarchy's own fix.
- [ghostty/config](../ghostty/config) loads it with `gtk-custom-css = ~/dotfiles/ghostty/glass.css`.
- Don't set Ghostty's `background-blur = true`: Omarchy's PR notes it would create a second blur object on a window GTK already holds one for.

Reminder:
- [omarchy/hooks/post-update.d/glass-workaround-check](../omarchy/hooks/post-update.d/glass-workaround-check) (symlinked into `~/.config/omarchy/hooks/post-update.d/`) sends a desktop notification after each `omarchy update` once `omarchy-hyprland-window-transparency` exists and `ghostty/glass.css` is still here.

Removal (after Omarchy 4.5):
1. Check `omarchy version` reports 4.5 or later and `omarchy hyprland window transparency` exists.
2. Delete `ghostty/glass.css` and the `gtk-custom-css` line plus its comment in `ghostty/config`.
   Also delete the reminder hook and its symlink in `~/.config/omarchy/hooks/post-update.d/` (it goes quiet on its own once `glass.css` is gone).
3. Run `omarchy hyprland window transparency glassy` (or Appearance > Window Transparency > Glassy).
   Note: Glassy also writes its own terminal opacity (0.65) and blur values; re-check `hypr/looknfeel.lua` and Ghostty's `background-opacity` afterwards if you prefer the current look.

References:
- [Omarchy PR #14991: Window Transparency / Glassy (4.5 milestone)](https://github.com/omacom/omarchy/pull/14991)
- [Hyprland issue #16508: no blur behind GTK 4.24.x apps](https://github.com/hyprwm/Hyprland/issues/16508)

## Ghostty won't open from the launcher after systemd 262

Date: 2026-10-19

Symptoms:
- Launching Ghostty from the Omarchy launcher (Alt+Space) does nothing when no Ghostty is already running.
- `journalctl --user -u app-com.mitchellh.ghostty.service` shows:
  ```text
  Main process ... lacks handler for reload signal USR2, refusing service startup.
  Failed with result 'protocol'.
  ```

Cause:
- The desktop entry is `DBusActivatable=true`, so the launcher starts `app-com.mitchellh.ghostty.service`, which is `Type=notify-reload` with `ReloadSignal=SIGUSR2`.
- systemd 262 now refuses to start a `notify-reload` service whose main process has no handler for the reload signal when it reports READY. Ghostty 1.3.1 doesn't install one in time.

Fix (temporary):
- Drop-in [systemd262.conf](../systemd/user/app-com.mitchellh.ghostty.service.d/systemd262.conf), symlinked into `~/.config/systemd/user/app-com.mitchellh.ghostty.service.d/`, sets `Type=notify`.
- Config reload still works because `omarchy restart terminal` sends `killall -SIGUSR2 ghostty` itself and doesn't go through systemd.

Removal:
- Once a Ghostty or systemd update fixes this, delete the drop-in and the symlink, then run `systemctl --user daemon-reload`.
- To check: `systemd-run --user --unit=gt -p Type=notify-reload -p ReloadSignal=SIGUSR2 ghostty --gtk-single-instance=true --initial-window=false --class=com.example.gt`. If it starts, the workaround is no longer needed. Stop it with `systemctl --user stop gt`.
