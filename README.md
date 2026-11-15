# !HDRShot: HDR screenshot fix for WoW Forever

With `HDROutput` on, screenshots come out washed out. This addon replaces the
global `Screenshot()` with a wrapper that turns `HDROutput` off just before the
capture and turns it back on a few seconds after the last shot finishes.

It covers anything that calls `Screenshot()`: the Print Screen keybind,
macros, and Narcissus photo mode, including its layer captures. HDR is only
turned back on if it was on before the shot.

## Install

Download the zip from CurseForge or the GitHub releases page and extract it
into `World of Warcraft\_forever_\Interface\AddOns\`. You should end up with
an `AddOns\!HDRShot\` folder.

To check it's working, type `/hdrshot`. It prints the current `HDROutput`
value and whether the wrapper is installed.

## Macro alternative (no addon)

If you only want a fix for the screenshots you take yourself, this macro does
the same thing for one shot:

```
/run local f=CreateFrame("Frame")f:RegisterEvent("SCREENSHOT_SUCCEEDED")f:RegisterEvent("SCREENSHOT_FAILED")f:SetScript("OnEvent",function()SetCVar("HDROutput",1)f:UnregisterAllEvents()end)SetCVar("HDROutput",0)Screenshot()
```

The macro has some limits:

- It only covers screenshots taken with the macro. The Print Screen key and
  addons like Narcissus bypass it, so use the addon if you need those.
- It always turns HDR back on afterwards, even if HDR was off before.
- It doesn't hide the UI. Press Alt+Z first if you want a clean shot.

## Why the `!` prefix

Narcissus saves its own copy of `Screenshot` when it loads
(`local Screenshot = Screenshot`). The wrapper has to exist before then, and
the `!` prefix makes this addon load before the others.

## Development

The repo root is the addon folder. To work on it, link the repo into your
AddOns folder so `/reload` picks up your changes:

```powershell
New-Item -ItemType Junction `
  -Path "C:\Games\World of Warcraft\_forever_\Interface\AddOns\!HDRShot" `
  -Target "<path to this repo>"
```

### Releasing

Push a `v*` tag (for example `git tag v0.1.0 && git push origin v0.1.0`).
GitHub Actions runs the [BigWigs packager](https://github.com/BigWigsMods/packager).
The packager builds `!HDRShot.zip`, fills in the version from the tag,
attaches the zip to a GitHub release and uploads it to CurseForge. The
`16001` interface number tells the packager this is a WoW Forever file.

The CurseForge upload needs two things:

- `## X-Curse-Project-ID: <id>` in `!HDRShot.toc`
- a `CF_API_TOKEN` repository secret holding a CurseForge API token

## License

The code is under the [MIT License](LICENSE). The logo uses Blizzard's in-game
camera icon, which the MIT License doesn't cover.
