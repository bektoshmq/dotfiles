# Neovim

This is the source-of-truth Neovim configuration for this dotfiles repo. It
layers personal LazyVim settings on top of Omarchy's Neovim integration.

Omarchy-specific behavior kept here includes:

- desktop-wide theme selection and live theme reloads;
- transparent highlight handling;
- local Wayland plus remote OSC 52 clipboard support;
- Omarchy's stock theme plugins and disabled news notifications.

`lua/plugins/theme.lua` intentionally points at Omarchy's current theme. Keep
personal editor behavior in the other config and plugin files instead of
hard-coding a colorscheme.

The active config is expected to be:

```text
~/.config/nvim -> ~/dotfiles/nvim
```

After cloning onto a new system, preserve any existing Neovim config before
creating that link. Run `:Lazy sync` after activation if the plugin data cache
has not already been populated.

Avoid `omarchy-nvim-refresh` unless you intend to replace and then recreate the
repo link; the refresh command backs up the active path and installs Omarchy's
stock config.
