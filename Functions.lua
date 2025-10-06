local _, MPT = ...

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font","Expressway", [[Interface\Addons\MPlusTimer\Expressway.TTF]])

MPT.Spacing = 3

MPT.TimerBar = {
    Width = 330,
    Height = 24,
    XOffset = 0,
    YOffset = 0,
    Texture = LSM:Fetch("statusbar", "Details Flat"),
    Color = {101/255, 152/255, 1, 1},
    BorderSize = 1,
    BackgroundColor = {0, 0, 0, 0.5},
    BorderColor = {0, 0, 0, 1},    
}

MPT.TimerText = {
    enabled = true,
    Anchor = "LEFT",
    RelativeTo = "LEFT",
    XOffset = 2,
    YOffset = 0,
    Font = LSM:Fetch("font", "Expressway"),
    FontSize = 16,
    Outline = "OUTLINE",
    Color = {1, 1, 1, 1},
    ShadowColor = {0, 0, 0, 1},
    ShadowOffset = {0, 0}
}

MPT.ComparisonTimer = {
    enabled = true,
    Anchor = "RIGHT",
    RelativeTo = "LEFT",
    XOffset = 0,
    YOffset = 0,
    Font = LSM:Fetch("font", "Expressway"),
    FontSize = 16,
    Outline = "OUTLINE",
    SuccessColor = {0, 1, 0, 1},
    EqualColor = {1, 0.8, 0, 1},
    FailColor = {1, 0, 0, 1},
    ShadowColor = {0, 0, 0, 1},
    ShadowOffset = {0, 0},
    Justify = "RIGHT",
}

MPT.ChestTimer = {}
for i=1, 3 do
    table.insert(MPT.ChestTimer, 
    {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "RIGHT",
        XOffset = (i-1)*-65,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0},
    })
end

MPT.Ticks = {
    enabled = true,
    Width = 2,  
    Color = {1, 1, 1, 1},
}

MPT.Background = {
    enabled = true,
    Color = {0, 0, 0, 0.57},
    BorderColor = {0, 0, 0, 1},
}

MPT.Position = {
    XOffset = 0,
    YOffset = 0,
}

MPT.KeyInfo = {
    Width = 330,
    Height = 16,
    XOffset = 0,
    YOffset = 0,
    KeyLevel = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "LEFT",
        XOffset = 0,
        YOffset = -2,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}

    },
    DungeonName = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "RIGHT",
        XOffset = 0,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}

    },
    AffixIcons = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "RIGHT",
        XOffset = 0,
        YOffset = -2,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}
    },
    DeathCounter = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "RIGHT",
        XOffset = 0,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}
    },
}


MPT.Bosses = {
    Width = 330,
    Height = 16,
    XOffset = 0,
    YOffset = 0,
}

MPT.BossName = {
    enabled = true,
    Anchor = "LEFT",
    RelativeTo = "LEFT",
    XOffset = 2,
    YOffset = 0,
    Font = LSM:Fetch("font", "Expressway"),
    FontSize = 16,
    Outline = "OUTLINE",
    Color = {1, 1, 1, 1},
    CompletionColor = {0, 1, 0, 1},
    ShadowColor = {0, 0, 0, 1},
    ShadowOffset = {0, 0}
}

MPT.BossTimer = {
    enabled = true,
    Anchor = "RIGHT",
    RelativeTo = "RIGHT",
    XOffset = 0,
    YOffset = 0,
    Font = LSM:Fetch("font", "Expressway"),
    FontSize = 16,
    Outline = "OUTLINE",
    Color = {1, 1, 1, 1},
    ShadowColor = {0, 0, 0, 1},
    ShadowOffset = {0, 0},
    SuccessColor = {0, 1, 0, 1},
    EqualColor = {1, 0.8, 0, 1},
    FailColor = {1, 0, 0, 1},
}

MPT.BossSplit = {
    enabled = true,
    Anchor = "RIGHT",
    RelativeTo = "RIGHT",
    XOffset = -70,
    YOffset = 0,
    Font = LSM:Fetch("font", "Expressway"),
    FontSize = 16,
    Outline = "OUTLINE",
    Color = {1, 1, 1, 1},
    ShadowColor = {0, 0, 0, 1},
    ShadowOffset = {0, 0},
    SuccessColor = {0, 1, 0, 1},
    EqualColor = {1, 0.8, 0, 1},
    FailColor = {1, 0, 0, 1},
}

MPT.ForcesBar = {
    Width = 330,
    Height = 24,
    XOffset = 0,
    YOffset = 0,
    Texture = LSM:Fetch("statusbar", "Details Flat"),
    Color = {{1, 117/255, 128/255, 1}, {1, 130/255, 72/255, 1}, {1, 197/255, 103/255, 1}, {1, 249/255, 150/255, 1}, {104/255, 205/255, 1, 1}},
    CompletionColor = {205/255, 1, 167/255, 1},
    BorderSize = 1,
    BackgroundColor = {0, 0, 0, 0.5},
    BorderColor = {0, 0, 0, 1},  
    PercentCount = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "LEFT",
        XOffset = 0,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}

    },
    RealCount = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "RIGHT",
        XOffset = 0,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}

    },
}


-- /run MPTAPI:Init()
-- Call MPT:CreateStates(true) to create a preview
-- Call MplutTimer:HideStates() to remove the preview and when leaving the dunugeon
-- Call MPT:CreateStates(false) at the start of M+ or logging into an active M+
-- Call MPT:UpdateStates(Full, TimerBar, Bosses, ForcesBar, KeystoneInfo) to update states on M+ changes


function MPTAPI:Init()
    MPT:HideStates()
    MPT:CreateStates(true)
end

function MPT:HideStates()
    if MPTFrame then MPTFrame:Hide() end   
end

function MPT:ShowStates()
    if MPTFrame then MPTFrame:Show() end   
end
function MPT:CreateStates(preview)

    if not MPT.Frame then
        MPT.Frame = CreateFrame("Frame", nil, UIParent) -- Main Frame
        local F = MPT.Frame
        -- Background Main Frame
        F.BG = F:CreateTexture(nil, "BACKGROUND")
        -- Background Border Main Frame
        F.BGBorder = CreateFrame("Frame", nil, F, "BackdropTemplate")   
        F.BGBorder:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
                })

        -- Timer Bar
        F.TimerBar = CreateFrame("StatusBar", nil, F, "BackdropTemplate")    

        -- Background Timer Bar
        F.TimerBar:SetBackdrop({ 
            bgFile = "Interface\\Buttons\\WHITE8x8", 
            tileSize = 0, 
        })    

        -- Border Timer Bar
        F.TimerBarBorder = CreateFrame("Frame", nil, F.TimerBar, "BackdropTemplate")

        MPT:CreateText(F.TimerBar, "TimerText", MPT.TimerText) -- Current Timer
        for i=1, 3 do
            MPT:CreateText(F.TimerBar, "ChestTimer"..i, MPT.ChestTimer[i]) -- Chest Timer
        end
        MPT:CreateText(F.TimerBar, "ComparisonTimer", MPT.ComparisonTimer) -- Comparison Timer

        -- Ticks on Timer Bar
        F.TimerBar.Ticks = {}
        for i=1, 2 do
            F.TimerBar.Ticks[i] = F.TimerBar:CreateTexture(nil, "OVERLAY")
            F.TimerBar.Ticks[i]:ClearAllPoints()
            F.TimerBar.Ticks[i]:SetPoint("TOP")
            F.TimerBar.Ticks[i]:SetPoint("BOTTOM")
            F.TimerBar.Ticks[i]:Hide()
        end
        
        -- Keystone Info
        F.KeyInfo = CreateFrame("StatusBar", nil, F, "BackdropTemplate")
        MPT:CreateText(F.KeyInfo, "KeyLevel", MPT.KeyInfo.KeyLevel)
        MPT:CreateText(F.KeyInfo, "DungeonName", MPT.KeyInfo.DungeonName)
        MPT:CreateText(F.KeyInfo, "AffixIcons", MPT.KeyInfo.AffixIcons)
        MPT:CreateText(F.KeyInfo, "DeathCounter", MPT.KeyInfo.DeathCounter)

        -- Boss Bars & Texts
        F.Bosses = {}
        for i=1, 5 do
            F.Bosses[i] = CreateFrame("StatusBar", nil, F, "BackdropTemplate")
            F.Bosses[i]:SetStatusBarColor(0, 0, 0, 0)
            MPT:CreateText(F.Bosses[i], "MPTBossName"..i, MPT.BossName)
            MPT:CreateText(F.Bosses[i], "MPTBossTimer"..i, MPT.BossTimer)
            MPT:CreateText(F.Bosses[i], "MPTBossSplit"..i, MPT.BossSplit)
        end
    
        -- Enemy Forces Bar
        F.ForcesBar = CreateFrame("StatusBar", nil, F, "BackdropTemplate") -- change which boss number this is anchored to in the display
        F.ForcesBar:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            tileSize = 0
        })
        MPT:CreateText(F.ForcesBar, "PercentCount", MPT.ForcesBar.PercentCount)
        MPT:CreateText(F.ForcesBar, "RealCount", MPT.ForcesBar.RealCount)
        -- Border Forces Bar
        F.ForcesBarBorder = CreateFrame("Frame", nil, F.ForcesBar, "BackdropTemplate")
        -- Create Text on Enemy Forces Bar
    end  
    
 

    -- Set preview values
    if preview and MPT.Frame then    
        -- Main Frame
        local F = MPT.Frame
        local maxSize = MPT.TimerBar.Height+MPT.KeyInfo.Height+MPT.ForcesBar.Height+(MPT.Bosses.Height*5)+(MPT.Spacing*7)
        F:SetSize(MPT.TimerBar.Width, maxSize)
        F:SetPoint("CENTER", UIParent, "CENTER", MPT.Position.XOffset, MPT.Position.YOffset)   
        if MPT.Background.enabled then
            F.BG:SetAllPoints(F)
            F.BG:SetColorTexture(unpack(MPT.Background.Color)) 
            F.BGBorder:SetAllPoints(F)
            F.BGBorder:SetBackdropBorderColor(unpack(MPT.Background.BorderColor))
        end
        
        -- Key Info Bar
        F.KeyInfo:SetPoint("TOPLEFT", F, "TOPLEFT", MPT.KeyInfo.XOffset, MPT.KeyInfo.YOffset)
        F.KeyInfo:SetSize(MPT.KeyInfo.Width, MPT.KeyInfo.Height)
        if MPT.KeyInfo.KeyLevel then MPT:ApplyTextSettings(F.KeyInfo.KeyLevel, MPT.KeyInfo.KeyLevel, "+30") end
        if MPT.KeyInfo.DungeonName then MPT:ApplyTextSettings(F.KeyInfo.DungeonName, MPT.KeyInfo.DungeonName, "Halls of Valor", false, F.KeyInfo.KeyLevel) end
        if MPT.KeyInfo.AffixIcons then 
            local affixdisplay = ""
            for i=1, 4 do
                affixdisplay = affixdisplay.."\124T"..select(i, strsplit(" ", "236401 1035055 451169 1385910"))..":13:13:"..1-i..":0:64:64:6:60:6:60\124t"
            end 
            MPT:ApplyTextSettings(F.KeyInfo.AffixIcons, MPT.KeyInfo.AffixIcons, affixdisplay, false, F.KeyInfo.DungeonName) 
        end
        if MPT.KeyInfo.DeathCounter then MPT:ApplyTextSettings(F.KeyInfo.DeathCounter , MPT.KeyInfo.DeathCounter , "20".."|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:"..(MPT.KeyInfo.DeathCounter.FontSize/1.5).."|t") end

        -- Timer Bar
        F.TimerBar:SetPoint("TOPLEFT", F.KeyInfo, "TOPLEFT", MPT.TimerBar.XOffset, -MPT.KeyInfo.Height-MPT.Spacing+MPT.TimerBar.YOffset)
        F.TimerBar:SetSize(MPT.TimerBar.Width, MPT.TimerBar.Height)
        F.TimerBar:SetStatusBarTexture(MPT.TimerBar.Texture)
        F.TimerBar:SetStatusBarColor(unpack(MPT.TimerBar.Color))
        F.TimerBar:SetBackdropColor(unpack(MPT.TimerBar.BackgroundColor))
        F.TimerBarBorder:SetPoint("TOPLEFT", 0, 0)
        F.TimerBarBorder:SetPoint("BOTTOMRIGHT", 0, 0)
        F.TimerBarBorder:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = MPT.TimerBar.BorderSize
        })
        F.TimerBarBorder:SetBackdropBorderColor(unpack(MPT.TimerBar.BorderColor))

        -- Text on Timer Bar
        local curTime = math.random(900, 2000)
        local maxTime = 2280
        local percTime = curTime/maxTime
        F.TimerBar:SetMinMaxValues(0, maxTime)
        F.TimerBar:SetValue(curTime)
        MPT:ApplyTextSettings(F.TimerBar.TimerText, MPT.TimerText, string.format("%s/%s", MPT:FormatTime(curTime), MPT:FormatTime(maxTime))) 
        local ComparisonTime = math.random(-200, 200)
        local prefix = (ComparisonTime < 0 and "-") or (ComparisonTime > 0 and "+") or ""
        local ComparisonColor = ComparisonTime < 0 and MPT.ComparisonTimer.SuccessColor or ComparisonTime > 0 and MPT.ComparisonTimer.FailColor or MPT.ComparisonTimer.EqualColor
        ComparisonTime = ComparisonTime < 0 and ComparisonTime*-1 or ComparisonTime           
        MPT:ApplyTextSettings(F.TimerBar.ComparisonTimer, MPT.ComparisonTimer, string.format("%s%s", prefix, ComparisonTime == 0 and "+-0" or MPT:FormatTime(ComparisonTime, true)), ComparisonColor)        
        local chest = percTime <= 0.6 and 3 or percTime <= 0.8 and 2 or 1
        for i=1, 3 do
            local remTime = maxTime-curTime-((i-1)*maxTime*0.2)
            if chest >= i then
                MPT:ApplyTextSettings(F.TimerBar["ChestTimer"..i], MPT.ChestTimer[i], MPT:FormatTime(remTime))
            else
                F.TimerBar["ChestTimer"..i]:Hide()
            end
            if i > 1 then 
                if MPT.Ticks.enabled and chest >= i then                    
                    F.TimerBar.Ticks[i-1]:SetColorTexture(unpack(MPT.Ticks.Color))
                    F.TimerBar.Ticks[i-1]:SetWidth(MPT.Ticks.Width)
                    F.TimerBar.Ticks[i-1]:SetPoint("LEFT", F.TimerBar, "LEFT", (i == 2 and MPT.TimerBar.Width*0.8) or (i == 3 and MPT.TimerBar.Width*0.6) , 0)
                    F.TimerBar.Ticks[i-1]:Show()
                else
                    F.TimerBar.Ticks[i-1]:Hide()
                end
            end
        end
                  

        
        -- Bosses
        local killtime = 0
        MPT:MuteJournalSounds()
        for i=1, 5 do
            EJ_SelectInstance(721)
            local name = EJ_GetEncounterInfoByIndex(i, 721)
            name = MPT:Utf8Sub(name, 20) or "Boss "..i
            killtime = killtime+math.random(240, 420)
            local time = MPT:FormatTime(killtime, true)
            local frame = F.Bosses[i]
            frame:SetPoint("TOPLEFT", F.TimerBar, "TOPLEFT", MPT.Bosses.XOffset, -MPT.TimerBar.Height-(i*MPT.Spacing)-(i-1)*(MPT.Bosses.Height)+MPT.Bosses.YOffset)
            frame:SetSize(MPT.Bosses.Width, MPT.Bosses.Height)
            local BossColor = i <= 3 and MPT.BossName.CompletionColor or MPT.BossName.Color
            MPT:ApplyTextSettings(F.Bosses[i]["MPTBossName"..i], MPT.BossName, name, BossColor)
            local timercolor = (i == 1 and MPT.BossTimer.FailColor) or (i == 2 and MPT.BossTimer.EqualColor) or (i == 3 and MPT.BossTimer.SuccessColor) or MPT.BossTimer.Color
            local splitcolor = (i == 1 and MPT.BossSplit.FailColor) or (i == 2 and MPT.BossSplit.EqualColor) or (i == 3 and MPT.BossSplit.SuccessColor) or MPT.BossSplit.Color
            local splittext = (i == 2 and "+-0") or (i == 1 and "+"..MPT:FormatTime(math.random(20, 60))) or (i == 3 and "-"..MPT:FormatTime(math.random(20, 60)))
            MPT:ApplyTextSettings(F.Bosses[i]["MPTBossTimer"..i], MPT.BossTimer, time, timercolor)
            if splittext then MPT:ApplyTextSettings(F.Bosses[i]["MPTBossSplit"..i], MPT.BossSplit, splittext, splitcolor) end
        end

        -- Forces Bar
        F.ForcesBar:SetPoint("TOPLEFT", F.Bosses[5], "TOPLEFT", MPT.ForcesBar.XOffset, -MPT.Bosses.Height-MPT.Spacing+MPT.ForcesBar.YOffset) -- just anchoring to 5th Boss in preview
        F.ForcesBar:SetSize(MPT.ForcesBar.Width, MPT.ForcesBar.Height)
        F.ForcesBar:SetStatusBarTexture(MPT.ForcesBar.Texture)
        F.ForcesBar:SetBackdropColor(unpack(MPT.ForcesBar.BackgroundColor))
        F.ForcesBarBorder:SetPoint("TOPLEFT", 0, 0)
        F.ForcesBarBorder:SetPoint("BOTTOMRIGHT", 0, 0)
        F.ForcesBarBorder:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = MPT.ForcesBar.BorderSize
        })
        F.ForcesBarBorder:SetBackdropBorderColor(unpack(MPT.ForcesBar.BorderColor))
        local forcesprog = math.random(1, 99)        
        F.ForcesBar:SetMinMaxValues(0, 100)
        F.ForcesBar:SetValue(forcesprog)
        local forcesColor = 
        (forcesprog < 20 and MPT.ForcesBar.Color[1]) or 
        (forcesprog < 40 and MPT.ForcesBar.Color[2]) or 
        (forcesprog < 60 and MPT.ForcesBar.Color[3]) or 
        (forcesprog < 80 and MPT.ForcesBar.Color[4]) or 
        (forcesprog < 100 and MPT.ForcesBar.Color[5]) or MPT.ForcesBar.CompletionColor
        F.ForcesBar:SetStatusBarColor(unpack(forcesColor))
        MPT:ApplyTextSettings(F.ForcesBar.PercentCount, MPT.ForcesBar.PercentCount, forcesprog.."%")
        MPT:ApplyTextSettings(F.ForcesBar.RealCount, MPT.ForcesBar.RealCount, forcesprog)


        
        -- Fix Background Size
        F:SetPoint("CENTER", UIParent, "CENTER", MPT.TimerBar.Width+MPT.Position.XOffset, MPT.Position.YOffset-(MPT.TimerBar.Height)-(MPT.KeyInfo.Height)-(MPT.ForcesBar.Height)-((MPT.Bosses.Height+MPT.Spacing)*5))
        if MPT.Background.enabled then
            F.BG:SetAllPoints(F)
            F.BGBorder:SetAllPoints(F)
            F.BG:Show()
            F.BGBorder:Show()
        else
            F.BG:Hide()
            F.BGBorder:Hide()
        end
        F:Show()
    else
        MPT:UpdateStates()
    end
end

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

function MPT:ApplyTextSettings(frame, settings, text, Color, parent)
    parent = parent or frame:GetParent()
    if settings.enabled and parent then
        Color = Color or settings.Color
        frame:SetPoint(settings.Anchor, parent, settings.RelativeTo, settings.XOffset, settings.YOffset)
        frame:SetFont(settings.Font, settings.FontSize, settings.Outline)
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

function MPT:CreateText(parent, name, settings)    
    parent[name] = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    parent[name]:SetPoint(settings.Anchor, parent, settings.RelativeTo, settings.XOffset, settings.YOffset)
    parent[name]:SetFont(settings.Font, settings.FontSize, settings.Outline)
    parent[name]:SetShadowColor(unpack(settings.ShadowColor))
    parent[name]:SetShadowOffset(unpack(settings.ShadowOffset))
    if settings.Justify then
        parent[name]:SetJustifyH(settings.Justify)
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
        end        
        if timeHour ~= 0 then
            return ("%s:%s:%s"):format(timeHour, timeMin, timeSec)
        else
            return ("%s:%s"):format(timeMin, timeSec)
        end
    end
end

function MPT:UpdateStates(Full, TimerBar, Bosses, ForcesBar, KeystoneInfo)

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