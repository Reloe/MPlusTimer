local _, MPT = ...

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font","Expressway", [[Interface\Addons\MPlusTimer\Expressway.TTF]])
MPT.TimerBar = {
    Width = 330,
    Height = 24,
    XOffset = 0,
    YOffset = 0,
    Texture = LSM:Fetch("statusbar", "Details Flat"),
    Color = {0.4, 0.6, 1, 1},
    BorderSize = 1,
    Inset = 1,
    BackgroundColor = {0, 0, 0, 0.52},
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
    enabled = true,
    Height = 20,
}

MPT.Bosses = {
    Width = 330,
    Height = 16,
    Spacing = 3,
    XOffset = 0,
    YOffset = -24,
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
    ShadowColor = {0, 0, 0, 1},
    ShadowOffset = {0, 0}
}

MPT.EnemyForces = {
    enabled = true,
    Height = 24
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

        -- Create Ticks on Timer Bar
        F.TimerBar.Ticks = {}
        for i=1, 2 do
            F.TimerBar.Ticks[i] = F.TimerBar:CreateTexture(nil, "OVERLAY")
            F.TimerBar.Ticks[i]:ClearAllPoints()
            F.TimerBar.Ticks[i]:SetPoint("TOP")
            F.TimerBar.Ticks[i]:SetPoint("BOTTOM")
            F.TimerBar.Ticks[i]:Hide()
        end
        
        -- Create Keystone Info

        -- Create Boss Bars & Texts
        F.Bosses = {}
        for i=1, 5 do
            F.Bosses[i] = CreateFrame("StatusBar", nil, F, "BackdropTemplate")
            F.Bosses[i]:SetStatusBarColor(0, 0, 0, 0)
            MPT:CreateText(F.Bosses[i], "MPTBossName"..i, MPT.BossName)
        end
    
        -- Create Enemy Forces Bar

        -- Create Text on Enemy Forces Bar
    end  
    
 

    -- Set preview values
    if preview and MPT.Frame then    
        local F = MPT.Frame
        local maxSize = MPT.TimerBar.Height+MPT.KeyInfo.Height+MPT.EnemyForces.Height+(MPT.Bosses.Height*5)
        F:SetSize(MPT.TimerBar.Width, maxSize)
        F:SetPoint("CENTER", UIParent, "CENTER", MPT.Position.XOffset, MPT.Position.YOffset)    
        F.BG:SetAllPoints(F)
        F.BG:SetColorTexture(unpack(MPT.Background.Color)) 
        F.BGBorder:SetAllPoints(F)
        F.BGBorder:SetBackdropBorderColor(unpack(MPT.Background.BorderColor))
        F.TimerBar:SetPoint("TOPLEFT", F, "TOPLEFT", MPT.TimerBar.XOffset, MPT.TimerBar.YOffset)
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

        for i=1, 5 do  
            local frame = F.Bosses[i]
            frame:SetPoint("TOPLEFT", F.TimerBar, "TOPLEFT", MPT.Bosses.XOffset, MPT.Bosses.YOffset-(i*MPT.Bosses.Spacing)-(i-1)*(MPT.Bosses.Height))
            frame:SetSize(MPT.Bosses.Width, MPT.Bosses.Height)
            MPT:ApplyTextSettings(F.Bosses[i]["MPTBossName"..i], MPT.BossName, "Boss "..i)
        end
        
        
        F:SetPoint("CENTER", UIParent, "CENTER", MPT.TimerBar.Width+MPT.Position.XOffset, MPT.Position.YOffset-(MPT.TimerBar.Height)-(MPT.KeyInfo.Height)-(MPT.EnemyForces.Height)-((MPT.Bosses.Height+MPT.Bosses.Spacing)*5))
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


function MPT:ApplyTextSettings(frame, settings, text, Color)
    if settings.enabled then
        local Color = settings.Color or Color
        frame:SetPoint(settings.Anchor, frame:GetParent(), settings.RelativeTo, settings.XOffset, settings.YOffset)
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