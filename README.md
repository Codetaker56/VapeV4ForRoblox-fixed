# Vape V4 for Roblox (fixed)

Fork of [7GrandDadPGN/VapeV4ForRoblox](https://github.com/7GrandDadPGN/VapeV4ForRoblox) / VapeCompiled (CC0).

Fixes:
- AimAssist no longer snaps the camera 180 (wrapAngle operator precedence bug).
- Profiles save reliably (per-module error handling, autosave survives errors, first-run save, Reset no longer disables saving).

## Usage
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/Codetaker56/VapeV4ForRoblox-fixed/main/loader.lua", true))()
```
Delete your `newvape` folder first if you ran the original, so old cached files are replaced.

Layout: repo root = runtime files the loader downloads. `source/` = uncompiled source tree with the same fixes.
