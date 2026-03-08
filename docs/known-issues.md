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

