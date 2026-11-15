# !HDRShot — HDR screenshot fix for WoW Forever

With `HDROutput` on, screenshots come out washed out. This addon replaces the
global `Screenshot()` with a wrapper that turns `HDROutput` off just before the
capture and turns it back on a few seconds after the last shot finishes.

It covers anything that calls `Screenshot()`: the Print Screen keybind,
macros, and Narcissus photo mode, including the layer captures.

## Install

Copy or link the `!HDRShot` folder into
`C:\Games\World of Warcraft\_forever_\Interface\AddOns\`.

A directory junction lets edits here show up in game after a `/reload`:

```powershell
New-Item -ItemType Junction `
  -Path "C:\Games\World of Warcraft\_forever_\Interface\AddOns\!HDRShot" `
  -Target "C:\repos\personal\hdr-screenshot-fix\!HDRShot"
```

## Check

`/hdrshot` prints the current `HDROutput` value and whether the wrapper is
installed.

## Why the `!` prefix

Narcissus saves its own copy of `Screenshot` when it loads
(`local Screenshot = Screenshot`). The wrapper has to exist before then, and
the `!` prefix makes this addon load before the others.
