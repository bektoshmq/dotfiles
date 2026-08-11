# T3 Code and OpenCode Desktop on Omarchy

This document describes the local installation and automatic-update setup for:

- T3 Code
- OpenCode Desktop

Both applications are installed from their official x86-64 AppImage releases. Because this machine does not have the FUSE 2 compatibility library, the AppImages are verified and extracted into user-local directories. No root access is required for normal launches or updates.

## Quick commands

Run an update check now:

```bash
systemctl --user start update-ai-desktops.service
```

Show the most recent update log:

```bash
journalctl --user -u update-ai-desktops.service -n 100 --no-pager
```

Follow the update log live:

```bash
journalctl --user -fu update-ai-desktops.service
```

Show the timer and its next scheduled run:

```bash
systemctl --user list-timers update-ai-desktops.timer
```

Show the installed versions:

```bash
basename "$(readlink -f ~/.local/lib/t3-code-current)"
basename "$(readlink -f ~/.local/lib/opencode-desktop-current)"
```

Launch from a terminal:

```bash
t3-code
opencode-desktop
```

Both applications are also registered in Walker as **T3 Code (Alpha)** and **OpenCode**.

## Installation layout

| Purpose | Path |
|---|---|
| Update script | `~/.local/bin/update-ai-desktops` |
| T3 Code launcher | `~/.local/bin/t3-code` |
| OpenCode launcher | `~/.local/bin/opencode-desktop` |
| T3 active-version link | `~/.local/lib/t3-code-current` |
| OpenCode active-version link | `~/.local/lib/opencode-desktop-current` |
| Extracted application versions | `~/.local/lib/t3-code-*` and `~/.local/lib/opencode-desktop-*` |
| T3 Walker entry | `~/.local/share/applications/t3-code.desktop` |
| OpenCode Walker entry | `~/.local/share/applications/ai.opencode.desktop.desktop` |
| Application icons | `~/.local/share/icons/hicolor/` |
| systemd service | `~/.config/systemd/user/update-ai-desktops.service` |
| systemd timer | `~/.config/systemd/user/update-ai-desktops.timer` |

The launchers always execute the `*-current` symbolic links. An update can therefore install a new version and switch the link without changing the Walker entries.

The `X-AppImage-Version` fields inside the desktop files describe the versions used when those entries were initially created. They are not the authoritative installed-version record. Use the `readlink` commands above instead.

## Automatic-update behavior

The user systemd timer:

- starts five minutes after boot;
- checks approximately once per hour;
- adds up to five minutes of randomized delay;
- checks stable GitHub releases, not prereleases or nightlies;
- downloads nothing when the installed tag is current.

For each new release, the updater:

1. Queries the project's official GitHub release API.
2. Selects the official x86-64 AppImage.
3. requires and verifies GitHub's published SHA-256 digest;
4. extracts the verified AppImage into a versioned directory;
5. installs updated application icons;
6. atomically switches the application's `*-current` link;
7. retains the newest two extracted versions and removes older versions;
8. refreshes the desktop database and restarts Walker;
9. sends a desktop notification.

An already-running application continues using its old files. Quit and reopen it to use the newly activated version.

Official release sources:

- T3 Code: <https://github.com/pingdotgg/t3code/releases>
- OpenCode: <https://github.com/anomalyco/opencode/releases>

## Timer management

Temporarily stop automatic checks:

```bash
systemctl --user stop update-ai-desktops.timer
```

Start them again:

```bash
systemctl --user start update-ai-desktops.timer
```

Disable automatic checks across logins:

```bash
systemctl --user disable --now update-ai-desktops.timer
```

Enable them again:

```bash
systemctl --user enable --now update-ai-desktops.timer
```

Check service and timer status:

```bash
systemctl --user status update-ai-desktops.service update-ai-desktops.timer
```

## Roll back an update

The updater retains the newest two extracted versions. First stop the timer so it does not immediately reactivate the latest release:

```bash
systemctl --user stop update-ai-desktops.timer
```

List the retained versions:

```bash
find ~/.local/lib -maxdepth 1 -type d \
  \( -name 't3-code-*' -o -name 'opencode-desktop-*' \) -print
```

Point the relevant active-version link at the older directory. Replace `VERSION` with the retained version:

```bash
ln -sfn ~/.local/lib/t3-code-VERSION ~/.local/lib/t3-code-current
```

or:

```bash
ln -sfn ~/.local/lib/opencode-desktop-VERSION ~/.local/lib/opencode-desktop-current
```

Launch the application and confirm that the older version works. Leave the timer stopped until the upstream problem is resolved. Starting the timer again will reactivate the latest stable release on its next successful check.

## Troubleshooting

### An application is missing from Walker

Refresh the desktop database and Walker:

```bash
update-desktop-database ~/.local/share/applications
omarchy restart walker
```

Confirm that the desktop entries exist:

```bash
desktop-file-validate \
  ~/.local/share/applications/t3-code.desktop \
  ~/.local/share/applications/ai.opencode.desktop.desktop
```

### An application does not start

Confirm that its active link resolves and `AppRun` is executable:

```bash
readlink -f ~/.local/lib/t3-code-current
test -x ~/.local/lib/t3-code-current/AppRun && echo "T3 runtime OK"

readlink -f ~/.local/lib/opencode-desktop-current
test -x ~/.local/lib/opencode-desktop-current/AppRun && echo "OpenCode runtime OK"
```

Run the launcher from a terminal to see startup errors:

```bash
t3-code
opencode-desktop
```

### An update check fails

Inspect the log:

```bash
journalctl --user -u update-ai-desktops.service -n 100 --no-pager
```

Common causes are loss of network connectivity, GitHub API availability, a missing SHA-256 digest, or an upstream asset-name change. A failed check does not replace the active runtime. The timer tries again at the next scheduled run.

After resolving the problem:

```bash
systemctl --user reset-failed update-ai-desktops.service
systemctl --user start update-ai-desktops.service
```

### Check required updater commands

```bash
command -v curl jq sha256sum flock find sort cut install update-desktop-database
```

## Application data

Application data is stored separately from the extracted runtimes, so installing, updating, rolling back, or pruning runtime versions does not intentionally remove sessions or settings.

Known data locations include:

- T3 Code: `~/.t3/`
- OpenCode: `~/.config/ai.opencode.desktop/`
- OpenCode shared data: `~/.local/share/ai.opencode.desktop/`

Back up those locations separately if the application data is important.

## Removing only the automation

This leaves the currently installed applications usable:

```bash
systemctl --user disable --now update-ai-desktops.timer
rm ~/.config/systemd/user/update-ai-desktops.timer
rm ~/.config/systemd/user/update-ai-desktops.service
rm ~/.local/bin/update-ai-desktops
systemctl --user daemon-reload
```

The application launchers, active-version links, extracted runtimes, desktop entries, icons, settings, and sessions remain in place.

## Notes

- These installations are user-local and are not tracked by Pacman or Yay.
- The original downloaded AppImages in `~/Downloads/` are backup copies; the launchers do not run them.
- In-app update behavior is not relied upon. The systemd updater is the authoritative update mechanism.
- The updater uses a runtime lock, so overlapping checks exit without modifying anything.
