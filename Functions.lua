local _, MPT = ...
local L = LibStub("AceLocale-3.0"):GetLocale("MPlusTimer") --

local SoundsToMute = {
    [567457] = true,
    [567507] = true,
    [567440] = true,
    [567433] = true,
    [567407] = true,
    [567472] = true,
    [567502] = true,
    [567460] = true,
}

function MPT:MuteJournalSounds()
    local sounds = {}
    for k, _ in pairs(SoundsToMute) do
        sounds[k] = select(2, PlaySoundFile(k))
        if sounds[k] then
            StopSound(sounds[k])
            MuteSoundFile(k)
        end
    end
    C_Timer.After(1, function()
            for k, _ in pairs(SoundsToMute) do
                if sounds[k] then
                    UnmuteSoundFile(k)
                end
            end 
    end)
end

function MPT:PopupIsShown()
    for index = 1, 10 do
        local frame = _G["StaticPopup"..index]
        if frame and frame:IsShown() then
            return true
        end
    end
    return false
end

function MPT:HasAnchorLoop(key, value)
    if key and value and self.AnchorTypes[value] and self.AnchorTypes[key] then
        local current = value
        while current and current ~= "MainFrame" do
            if (self[current] and self[current].AnchoredTo == key) then
                return true
            elseif self[current] and self[current].AnchoredTo == "MainFrame" then
                return false
            else
                current = self[current] and self[current].AnchoredTo
            end
        end
    end
    return false
end

function MPT:SetPoint(frame, Anchor, parent, relativeTo, xOffset, yOffset, keep)
    if not keep then
        frame:ClearAllPoints()
    end
    frame:SetPoint(Anchor, parent, relativeTo, xOffset, yOffset)
end

function MPT:AddMouseoverTooltip(frame, text)
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(text)
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end
function MPT:ApplyTextSettings(frame, settings, text, Color, parent, num)
    parent = parent or frame:GetParent()
    if settings.enabled and parent then
        if type(settings.xOffset) == "table" then
            settings.xOffset = settings.xOffset[num] or 0
        end
        Color = Color or settings.Color
        frame:ClearAllPoints()
        frame:SetPoint(settings.Anchor, parent, settings.RelativeTo, settings.xOffset, settings.yOffset)
        frame:SetFont(self.LSM:Fetch("font", settings.Font), settings.FontSize, settings.Outline)
        frame:SetShadowColor(unpack(settings.ShadowColor))
        frame:SetShadowOffset(unpack(settings.ShadowOffset))
        if Color then
            frame:SetTextColor(unpack(Color))
        end
        if text then
            frame:SetText(text)
        end
        frame:Show()
    else
        frame:Hide()
    end
end

function MPT:CreateText(parent, name, settings, num)    
    parent[name] = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    if settings.xOffset and type(settings.xOffset) == "table" then
        settings.xOffset = settings.xOffset[num] or 0
    end
    parent[name]:SetPoint(settings.Anchor or "CENTER", parent, settings.RelativeTo or "CENTER", settings.xOffset or 0, settings.yOffset or 0)
    parent[name]:SetFont(settings.Font and self.LSM:Fetch("font", settings.Font) or self.LSM:Fetch("font", "Expressway"), settings.FontSize or 13, settings.Outline or "OUTLINE")
    parent[name]:SetShadowColor(unpack(settings.ShadowColor or {0, 0, 0, 1}))
    parent[name]:SetShadowOffset(unpack(settings.ShadowOffset or {0, 0}))
    parent[name]:SetTextColor(unpack(settings.Color or {1, 1, 1, 1}))
    parent[name]:SetText(settings.text or "")
end

function MPT:CreateStatusBar(parent, name, Backdrop, border)
    parent[name] = CreateFrame("StatusBar", nil, parent, "BackdropTemplate")        
    if Backdrop then 
        parent[name]:SetBackdrop({ 
            bgFile = "Interface\\Buttons\\WHITE8x8", 
            tileSize = 0,
        }) 
    end
    if border then 
        parent[name.."Border"] = CreateFrame("Frame", nil, parent[name], "BackdropTemplate")
    end
end

function MPT:AddBGBackground(parent, bgname, bordername, edgeSize, bgColor, bordercolor)
    self:AddBackground(parent, bgname, bgColor)
    self:AddBorder(parent, bordername, edgeSize, bordercolor)
end

function MPT:AddBackground(parent, name, color)
    parent[name] = parent:CreateTexture(nil, "BACKGROUND")
    parent[name]:SetAllPoints(parent)
    parent[name]:SetColorTexture(unpack(color or {0, 0, 0, 0.7}))
end

function MPT:AddBorder(parent, name, edgeSize, color)
    parent[name] = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    self:AddBackDrop(parent[name], edgeSize, color)
end

function MPT:AddBackDrop(parent, edgeSize, color)
    parent:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = edgeSize or 2,
    })
    parent:SetBackdropBorderColor(unpack(color or {1, 1, 1, 1}))
end
        
function MPT:CreateButton(width, height, parent, Background, Border, BGColor, BorderColor, font, fontSize, fontColor, text)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, height)
    if Background then
        self:AddBackground(btn, "BG", BGColor or {0, 0, 0, 0.5})
    end
    if Border then
        btn.Border = btn:CreateTexture(nil, "OVERLAY")
        btn.Border:SetAllPoints()
        btn.Border:SetColorTexture(unpack(BorderColor or {0.2, 0.6, 1, 0.5}))
        btn.Border:Hide()
    end
    if font or text then
        self:CreateText(btn, "Text", {Font = font, FontSize = fontSize, text = text, Color = fontColor})
    end
    return btn
end

function MPT:CreateLabel(parent, Anchor, RelativeFrame, RelativeTo, xOffset, yOffset, text)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint(Anchor, RelativeFrame, RelativeTo, xOffset, yOffset)
    label:SetText(text)
    label:SetFont(self.LSM:Fetch("font", "Expressway"), 13, "OUTLINE")
    label:SetTextColor(1, 1, 1, 1)
    return label
end

function MPT:CreateEditBox(parent, Anchor, RelativeFrame, RelativeTo, xOffset, yOffset, width, height)
    local editBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    editBox:SetSize(width, height)
    editBox:SetPoint(Anchor, RelativeFrame, RelativeTo, xOffset, yOffset)
    editBox:SetAutoFocus(false)
    return editBox
end

function MPT:CreateBossFrame(i)
    local F = self.Frame
    if F["Bosses"..i] then
        return F["Bosses"..i]
    end
    self:CreateStatusBar(F, "Bosses"..i, false, false)
    F["Bosses"..i]:SetStatusBarColor(0, 0, 0, 0)
    F["Bosses"..i]:Hide()
    self:CreateText(F["Bosses"..i], "BossName"..i, self.BossName)
    self:CreateText(F["Bosses"..i], "BossTimer"..i, self.BossTimer)
    self:CreateText(F["Bosses"..i], "BossSplit"..i, self.BossSplit)
    return F["Bosses"..i]
end

function MPT:FormatTime(time, round)
    if time then
        local timeMin = math.floor(time / 60)
        local timeSec = round and Round(time - (timeMin*60)) or math.floor(time - (timeMin*60))
        local timeHour = 0

        if timeMin >= 60 then
            timeHour = math.floor(time / 3600)
            timeMin = timeMin - (timeHour * 60)
        end
        if timeHour > 0 and timeHour < 10 then
            timeHour = ("0%d"):format(timeHour)
        end
        if timeMin < 10 and timeMin > 0 then
            timeMin = ("0%d"):format(timeMin)
        end
        if timeSec < 10 and timeSec > 0 then
            timeSec = ("0%d"):format(timeSec)
        elseif timeSec == 0 then
            timeSec = ("00")
        end        
        if timeHour ~= 0 then
            return ("%s:%s:%s"):format(timeHour, timeMin, timeSec)
        else
            return ("%s:%s"):format(timeMin, timeSec)
        end
    end
end

function MPT:StrToTime(str)
    if type(str) ~= "string" then return str end
    local hour, min, sec = str:match("^(%d+):(%d+):(%d+)$")
    if hour and min and sec then
        return tonumber(hour) * 3600 + tonumber(min) * 60 + tonumber(sec)
    end
    min, sec = str:match("^(%d+):(%d+)$")
    if min and sec then
        return tonumber(min) * 60 + tonumber(sec)
    end
    return false
end

function MPT:GetClassColor(class)
    local color = RAID_CLASS_COLORS[class] or {r=1, g=1, b=1, a=1}
    return color
end

function MPT:GetDateFormat(date)
    if not date or #date == 0 then -- manually added runs do not have a date
        return ""
    end
    if self.PBInfo.Format == 1 then
        return string.format("(%02d/%02d/%02d) (%02d:%02d)", date[1], date[2], date[3]%100, date[4], date[5])
    else
        return string.format("(%02d/%02d/%02d) (%02d:%02d)", date[2], date[1], date[3]%100, date[4], date[5])
    end
end

function MPT:MoveFrame(Unlock)
    if Unlock then        
        if not self.Frame then self:Init(true) end
        self:ShowFrame(true)
        self.Frame:SetMovable(true)
        self.Frame:EnableMouse(true)
        self.Movable = true
        self.Frame:RegisterForDrag("LeftButton")
        self.Frame:SetClampedToScreen(true)
    elseif self.Frame then
        self.Frame:SetMovable(false)
        self.Movable = false
        self.Frame:EnableMouse(false)
    end
end

function MPT:ShowFrame(Show)
    if Show then
        if self.Frame then 
            self.Frame:Show()
        end
    elseif self.Frame then
        self.Frame:Hide()
        self.IsPreview = false
    end
end

function MPT:UpdateScale()
    if self.Frame then
        self.Frame:SetScale(self.Scale)
    end
end

function MPT:UpdateDisplay()
    if self.IsPreview then
        self:Init(true)
    elseif C_ChallengeMode.IsChallengeModeActive() then
        self:Init(false)
    end
end

function MPT:Utf8Sub(str, startChar, endChar)
    if not str then return str end
    local startIndex, endIndex = 1, #str
    local currentIndex, currentChar = 1, 0

    while currentIndex <= #str do
        currentChar = currentChar + 1

        if currentChar == startChar then
            startIndex = currentIndex
        end
        if endChar and currentChar > endChar then
            endIndex = currentIndex - 1
            break
        end
        
        local c = string.byte(str, currentIndex)
        if c < 0x80 then
            currentIndex = currentIndex + 1
        elseif c < 0xE0 then
            currentIndex = currentIndex + 2
        elseif c < 0xF0 then
            currentIndex = currentIndex + 3
        else
            currentIndex = currentIndex + 4
        end
    end

    return string.sub(str, startIndex, endIndex)
end

function MPT:Profiling(key, start)
    if not MPTSV.debug then return end
    key = key or "default"
    if start then
        self.ProfilingTimes = self.ProfilingTimes or {}
        self.ProfilingTimes[key] = debugprofilestop()
    elseif self.ProfilingTimes and self.ProfilingTimes[key] then
        local duration = debugprofilestop() - self.ProfilingTimes[key]
        local color = duration > 1 and "|cFFFF0000" or "|cFFFFFFFF"
        print(L["MPT Profiling Output"]:format(color, key, duration))
        self.ProfilingTimes[key] = nil
    end
end
