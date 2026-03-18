# Kanata on Windows

This repo contains a Windows `kanata` config at `kanata/k2-he-laptop.kbd` that mirrors the K2 HE behavior you described:

- `Tab`: tap `Tab`, hold `Left Ctrl`
- `Caps Lock`: `Escape` on base, real `Caps Lock` on the fn layer
- `Left Ctrl`: momentary fn layer
- `\ |`: tap itself, hold `Right Ctrl`
- `Space`: normal `Space`, but becomes `Left Shift` while either Ctrl mod-tap is active
- `Right Ctrl`: right `Windows` / `Meta`

## Install

1. Download a current Windows build of `kanata` from the official releases page.
2. Start with `kanata_winIOv2.exe`.
3. If you need it to work more broadly across applications, switch to `kanata_wintercept.exe` and install the Interception driver from the release zip.

## Run

```powershell
powershell -ExecutionPolicy Bypass -File D:\dotfiles\powershell\Start-Kanata.ps1
```

If `kanata` is not in `%LOCALAPPDATA%\kanata`, pass the executable path explicitly:

```powershell
powershell -ExecutionPolicy Bypass -File D:\dotfiles\powershell\Start-Kanata.ps1 `
  -KanataExe "C:\Tools\kanata\kanata_winIOv2.exe"
```

## Notes

- The two mod-taps use `tap-hold-press 200 200`, not plain `tap-hold`. That keeps Ctrl shortcuts usable without having to wait the full 200 ms before pressing the next key.
- The `Space -> Shift when Ctrl is active` logic is implemented with `fork`, checking whether `lctl` or `rctl` output is currently active.
- If you want stricter "only become Ctrl after 200 ms" behavior, change both mod-taps from `tap-hold-press` to `tap-hold`.
