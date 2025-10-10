local _, MPT = ...

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

function MPT:SetPoint(frame, Anchor, parent, relativeTo, xOffset, yOffset)
    frame:ClearAllPoints()
    frame:SetPoint(Anchor, parent, relativeTo, xOffset, yOffset)
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
        frame:SetFont(MPT.LSM:Fetch("font", settings.Font), settings.FontSize, settings.Outline)
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
    if type(settings.xOffset) == "table" then
        settings.xOffset = settings.xOffset[num] or 0
    end
    parent[name]:SetPoint(settings.Anchor, parent, settings.RelativeTo, settings.xOffset, settings.yOffset)
    parent[name]:SetFont(MPT.LSM:Fetch("font", settings.Font), settings.FontSize, settings.Outline)
    parent[name]:SetShadowColor(unpack(settings.ShadowColor))
    parent[name]:SetShadowOffset(unpack(settings.ShadowOffset))
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

function MPT:MoveFrame(Unlock)
    if Unlock then        
        if not MPT.Frame then MPT:Init(true) end
        MPT:ShowFrame(true)
        MPT.Frame:SetMovable(true)
        MPT.Frame:EnableMouse(true)
        MPT.Movable = true
        MPT.Frame:RegisterForDrag("LeftButton")
        MPT.Frame:SetClampedToScreen(true)
    elseif MPT.Frame then        
        MPT.Frame:SetMovable(false)
        MPT.Movable = false
        MPT.Frame:EnableMouse(false)
    end
end

function MPT:ShowFrame(Show)
    if Show then
        if MPT.Frame then 
            MPT.Frame:Show()
        end
    elseif MPT.Frame then
        MPT.Frame:Hide()
        MPT.IsPreview = false
    end
end

function MPT:UpdateScale()
    if MPT.Frame then
        MPT.Frame:SetScale(MPT.Scale)
    end
end

function MPT:Utf8Sub(str, startChar, endChar)
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

        -- move by UTF-8 codepoint length
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
