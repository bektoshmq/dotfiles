# Cursor

Only portable editor configuration belongs here. Cursor's `globalStorage`,
`workspaceStorage`, authentication, and machine-specific state remain under
`~/.config/Cursor` and are deliberately not tracked.

Link the configuration on Linux:

```bash
mkdir -p ~/.config/Cursor/User
ln -s ~/dotfiles/cursor/settings.json ~/.config/Cursor/User/settings.json
ln -s ~/dotfiles/cursor/keybindings.json ~/.config/Cursor/User/keybindings.json
~/dotfiles/cursor/install-extensions
```

Restart Cursor after linking the files. Changes made through Cursor's Settings
JSON or Keyboard Shortcuts JSON editors will then be written directly into this
repository.

Cursor theme selection is managed by Omarchy. Applying an Omarchy theme updates
`workbench.colorTheme` in the linked settings file and installs that theme's
preferred extension when needed.

## Reference

- [Neovim → Cursor keybinding comparison](./neovim-keybindings-comparison.html)
