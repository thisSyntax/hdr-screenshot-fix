-- !HDRShot: wrap the global Screenshot() so HDR output is off during capture.
--
-- The "!" folder prefix makes this load before other addons. That matters
-- because Narcissus caches `local Screenshot = Screenshot` at load time
-- (Modules/PhotoMode/PlayerModel.lua, Modules/ScreenshotTool/EmoteList.lua);
-- it must capture our wrapper, not the original.

local origScreenshot = Screenshot

-- Seconds to wait after the last screenshot before re-enabling HDR. Narcissus
-- "save layers" fires shots ~2.5s apart; keeping HDR off across the burst
-- avoids flipping the display mode for every layer.
local RESTORE_DELAY = 4

local restoreHDR = false   -- HDR was on before we turned it off
local restoreTimer

local function Restore()
    restoreTimer = nil
    if restoreHDR then
        restoreHDR = false
        SetCVar("HDROutput", "1")
    end
end

local function ScheduleRestore()
    if restoreTimer then restoreTimer:Cancel() end
    restoreTimer = C_Timer.NewTimer(RESTORE_DELAY, Restore)
end

local f = CreateFrame("Frame")
f:RegisterEvent("SCREENSHOT_SUCCEEDED")
f:RegisterEvent("SCREENSHOT_FAILED")
f:SetScript("OnEvent", function()
    if restoreHDR then ScheduleRestore() end
end)

Screenshot = function(...)
    if restoreTimer then
        restoreTimer:Cancel()
        restoreTimer = nil
    end
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
