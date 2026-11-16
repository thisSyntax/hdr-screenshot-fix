-- !HDRShot: wrap the global Screenshot() so HDR output is off during capture.
--
-- The "!" folder prefix makes this load before other addons. That matters
-- because Narcissus caches `local Screenshot = Screenshot` at load time
-- (Modules/PhotoMode/PlayerModel.lua, Modules/ScreenshotTool/EmoteList.lua);
-- it must capture our wrapper, not the original.
--
-- HDR is restored as soon as each capture finishes. Multi-shot captures such
-- as Narcissus layers still work: every Screenshot() call goes through the
-- wrapper and turns HDR off again for its own shot.

local origScreenshot = Screenshot

local restoreHDR = false   -- HDR was on before we turned it off

local f = CreateFrame("Frame")
f:RegisterEvent("SCREENSHOT_SUCCEEDED")
f:RegisterEvent("SCREENSHOT_FAILED")
f:SetScript("OnEvent", function()
    if restoreHDR then
        restoreHDR = false
        SetCVar("HDROutput", "1")
    end
end)

Screenshot = function(...)
    if GetCVar("HDROutput") ~= "0" then
        restoreHDR = true
        SetCVar("HDROutput", "0")
    end
    return origScreenshot(...)
end

SLASH_HDRSHOT1 = "/hdrshot"
SlashCmdList.HDRSHOT = function()
    print(("|cff66ccffHDRShot|r: HDROutput=%s, wrapper %s, restore pending=%s"):format(
        tostring(GetCVar("HDROutput")),
        Screenshot ~= origScreenshot and "active" or "MISSING",
        tostring(restoreHDR)))
end
