local _, MPT = ...

function MPT:HideStates()
    if MPTFrame then MPTFrame:Hide() end   
end

function MPT:ShowStates()
    if MPTFrame then MPTFrame:Show() end   
end
function MPT:Init(preview)
    MPT:HideStates()
    MPT:CreateStates(preview)
    if not preview then MPT:UpdateAllStates() end
    MPT.Frame:Show()
end

function MPT:UpdateAllStates()
    MPT:UpdateMainFrame()
    MPT:UpdateKeyInfo(true)
    MPT:UpdateTimerBar(true, false)
    MPT:UpdateBosses()
    MPT:EnemyForces()
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

        MPT:CreateText(F.TimerBar, "TimerText", MPTSV.TimerText) -- Current Timer
        for i=1, 3 do
            MPT:CreateText(F.TimerBar, "ChestTimer"..i, MPTSV.ChestTimer[i]) -- Chest Timer
        end
        MPT:CreateText(F.TimerBar, "ComparisonTimer", MPTSV.ComparisonTimer) -- Comparison Timer

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
        MPT:CreateText(F.KeyInfo, "KeyLevel", MPTSV.KeyInfo.KeyLevel)
        MPT:CreateText(F.KeyInfo, "DungeonName", MPTSV.KeyInfo.DungeonName)
        MPT:CreateText(F.KeyInfo, "AffixIcons", MPTSV.KeyInfo.AffixIcons)
        F.KeyInfo.Icon = CreateFrame("Button", nil, F.KeyInfo)
        F.KeyInfo.Icon.Texture = F.KeyInfo.Icon:CreateTexture(nil, "ARTWORK")
        MPT:CreateText(F.KeyInfo, "DeathCounter", MPTSV.KeyInfo.DeathCounter)

        -- Boss Bars & Texts
        F.Bosses = {}
        for i=1, 5 do
            F.Bosses[i] = CreateFrame("StatusBar", nil, F, "BackdropTemplate")
            F.Bosses[i]:SetStatusBarColor(0, 0, 0, 0)
            MPT:CreateText(F.Bosses[i], "MPTBossName"..i, MPTSV.BossName)
            MPT:CreateText(F.Bosses[i], "MPTBossTimer"..i, MPTSV.BossTimer)
            MPT:CreateText(F.Bosses[i], "MPTBossSplit"..i, MPTSV.BossSplit)
        end
    
        -- Enemy Forces Bar
        F.ForcesBar = CreateFrame("StatusBar", nil, F, "BackdropTemplate") -- change which boss number this is anchored to in the display
        F.ForcesBar:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            tileSize = 0
        })
        -- Text on Enemy Forces Bar
        MPT:CreateText(F.ForcesBar, "PercentCount", MPTSV.ForcesBar.PercentCount)
        MPT:CreateText(F.ForcesBar, "RealCount", MPTSV.ForcesBar.RealCount)
        -- Border Forces Bar
        F.ForcesBarBorder = CreateFrame("Frame", nil, F.ForcesBar, "BackdropTemplate")
        -- Move Scripts
        F:SetScript("OnDragStart", function(self)
            self:StartMoving()
        end)
        F:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()       
            local xOffset, yOffset = select(4, self:GetPoint())
            MPTSV.Position.XOffset = xOffset
            MPTSV.Position.YOffset = yOffset
        end)

    end  
    
 

    -- Set preview values
    if preview and MPT.Frame then            
        -- Key Info Bar
        MPT:UpdateKeyInfo(true, false, true)

        -- Timer Bar
        MPT:UpdateTimerBar(true, true, true)
        
                  
        local F = MPT.Frame
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
            frame:SetPoint("TOPLEFT", F.TimerBar, "TOPLEFT", MPTSV.Bosses.XOffset, -MPTSV.TimerBar.Height-(i*MPTSV.Spacing)-(i-1)*(MPTSV.Bosses.Height)+MPTSV.Bosses.YOffset)
            frame:SetSize(MPTSV.Bosses.Width, MPTSV.Bosses.Height)
            local BossColor = i <= 3 and MPTSV.BossName.CompletionColor or MPTSV.BossName.Color
            MPT:ApplyTextSettings(F.Bosses[i]["MPTBossName"..i], MPTSV.BossName, name, BossColor)
            local timercolor = (i == 1 and MPTSV.BossTimer.FailColor) or (i == 2 and MPTSV.BossTimer.EqualColor) or (i == 3 and MPTSV.BossTimer.SuccessColor) or MPTSV.BossTimer.Color
            local splitcolor = (i == 1 and MPTSV.BossSplit.FailColor) or (i == 2 and MPTSV.BossSplit.EqualColor) or (i == 3 and MPTSV.BossSplit.SuccessColor) or MPTSV.BossSplit.Color
            local splittext = (i == 2 and "+-0") or (i == 1 and "+"..MPT:FormatTime(math.random(20, 60))) or (i == 3 and "-"..MPT:FormatTime(math.random(20, 60)))
            MPT:ApplyTextSettings(F.Bosses[i]["MPTBossTimer"..i], MPTSV.BossTimer, time, timercolor)
            if splittext then MPT:ApplyTextSettings(F.Bosses[i]["MPTBossSplit"..i], MPTSV.BossSplit, splittext, splitcolor) end
        end

        -- Forces Bar
        F.ForcesBar:SetPoint("TOPLEFT", F.Bosses[5], "TOPLEFT", MPTSV.ForcesBar.XOffset, -MPTSV.Bosses.Height-MPTSV.Spacing+MPTSV.ForcesBar.YOffset) -- just anchoring to 5th Boss in preview
        F.ForcesBar:SetSize(MPTSV.ForcesBar.Width, MPTSV.ForcesBar.Height)
        F.ForcesBar:SetStatusBarTexture(MPTSV.ForcesBar.Texture)
        F.ForcesBar:SetBackdropColor(unpack(MPTSV.ForcesBar.BackgroundColor))
        F.ForcesBarBorder:SetPoint("TOPLEFT", 0, 0)
        F.ForcesBarBorder:SetPoint("BOTTOMRIGHT", 0, 0)
        F.ForcesBarBorder:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = MPTSV.ForcesBar.BorderSize
        })
        F.ForcesBarBorder:SetBackdropBorderColor(unpack(MPTSV.ForcesBar.BorderColor))
        local forcesprog = math.random(1, 99)        
        F.ForcesBar:SetMinMaxValues(0, 100)
        F.ForcesBar:SetValue(forcesprog)
        local forcesColor = 
        (forcesprog < 20 and MPTSV.ForcesBar.Color[1]) or 
        (forcesprog < 40 and MPTSV.ForcesBar.Color[2]) or 
        (forcesprog < 60 and MPTSV.ForcesBar.Color[3]) or 
        (forcesprog < 80 and MPTSV.ForcesBar.Color[4]) or 
        (forcesprog < 100 and MPTSV.ForcesBar.Color[5]) or MPTSV.ForcesBar.CompletionColor
        F.ForcesBar:SetStatusBarColor(unpack(forcesColor))
        MPT:ApplyTextSettings(F.ForcesBar.PercentCount, MPTSV.ForcesBar.PercentCount, forcesprog.."%")
        MPT:ApplyTextSettings(F.ForcesBar.RealCount, MPTSV.ForcesBar.RealCount, forcesprog)


        
        -- Fix Background Size
        MPT:UpdateMainFrame()
        F:Show()
    else
    end
end

function MPT:UpdateMainFrame(Backgroundonly)
    local F = MPT.Frame
    -- Main Frame    
    if BackgroundOnly and MPT.Background.enabled then    
        -- 5 needs to be changed to # of Bosses    
        F:SetPoint("CENTER", UIParent, "CENTER", MPTSV.TimerBar.Width+MPTSV.Position.XOffset, MPTSV.Position.YOffset-(MPTSV.TimerBar.Height)-(MPTSV.KeyInfo.Height)-(MPTSV.ForcesBar.Height)-((MPTSV.Bosses.Height+MPTSV.Spacing)*5))
        if MPTSV.Background.enabled then
            F.BG:SetAllPoints(F)
            F.BGBorder:SetAllPoints(F)
            F.BG:Show()
            F.BGBorder:Show()
        else
            F.BG:Hide()
            F.BGBorder:Hide()
        end
    else
        local maxSize = MPTSV.TimerBar.Height+MPTSV.KeyInfo.Height+MPTSV.ForcesBar.Height+(MPTSV.Bosses.Height*5)+(MPTSV.Spacing*7)
        F:SetSize(MPTSV.TimerBar.Width, maxSize)
        MPT:UpdateScale()
        F:SetPoint("CENTER", UIParent, "CENTER", MPTSV.Position.XOffset, MPTSV.Position.YOffset)   
        if MPTSV.Background.enabled then
            F.BG:SetAllPoints(F)
            F.BG:SetColorTexture(unpack(MPTSV.Background.Color)) 
            F.BGBorder:SetAllPoints(F)
            F.BGBorder:SetBackdropBorderColor(unpack(MPTSV.Background.BorderColor))
        end
    end
end

function MPT:UpdateKeyInfo(Full, Deaths, preview)
    local F = MPT.Frame
    if Full then
        local mapID = C_ChallengeMode.GetActiveChallengeMapID()
        local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
        local keyLevel = (preview and "+30") or "+"..level
        local DungeonName = (preview and "Halls of Valor") or (mapID and MPT.maptoID[mapID] and MPT.maptoID[mapID][2]) or ""
        local AffixDisplay = ""
        local deathcount = (preview and "20") or C_ChallengeMode.GetDeathCount()
        if preview then            
            for i=1, 4 do
                AffixDisplay = AffixDisplay.."\124T"..select(i, strsplit(" ", "236401 1035055 451169 1385910"))..":13:13:"..1-i..":0:64:64:6:60:6:60\124t"
            end 
        else
            local icon = ""
            for _, v in pairs(affixes) do
                if icon == "" then
                    icon = select(3, C_ChallengeMode.GetAffixInfo(v))
                else
                    icon = icon.." "..select(3, C_ChallengeMode.GetAffixInfo(v))
                end
            end
            for i=1, 4 do
                if select(i, strsplit(" ", icon)) then
                    AffixDisplay = AffixDisplay.."\124T"..select(i, strsplit(" ", icon))..":12:12:"..1-i..":0:64:64:6:60:6:60\124t"
                end
            end
        end        
        F.KeyInfo:SetPoint("TOPLEFT", F, "TOPLEFT", MPTSV.KeyInfo.XOffset, MPTSV.KeyInfo.YOffset)
        F.KeyInfo:SetSize(MPTSV.KeyInfo.Width, MPTSV.KeyInfo.Height)
        if MPTSV.KeyInfo.KeyLevel.enabled then MPT:ApplyTextSettings(F.KeyInfo.KeyLevel, MPTSV.KeyInfo.KeyLevel, keyLevel) end
        if MPTSV.KeyInfo.DungeonName.enabled then MPT:ApplyTextSettings(F.KeyInfo.DungeonName, MPTSV.KeyInfo.DungeonName, DungeonName, false, F.KeyInfo.KeyLevel) end        
        if MPTSV.KeyInfo.AffixIcons.enabled then MPT:ApplyTextSettings(F.KeyInfo.AffixIcons, MPTSV.KeyInfo.AffixIcons, AffixDisplay, false, F.KeyInfo.DungeonName) end
        if MPTSV.KeyInfo.DeathCounter.enabled then
            local icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"
            F.KeyInfo.Icon:SetSize(MPTSV.KeyInfo.Height, MPTSV.KeyInfo.Height)
            F.KeyInfo.Icon:SetPoint(MPTSV.KeyInfo.DeathCounter.IconAnchor, F.KeyInfo, MPTSV.KeyInfo.DeathCounter.IconRelativeTo, MPTSV.KeyInfo.DeathCounter.IconXOffset, MPTSV.KeyInfo.DeathCounter.IconYOffset)
            F.KeyInfo.Icon.Texture:SetAllPoints(F.KeyInfo.Icon)     
            F.KeyInfo.Icon.Texture:SetTexture(icon)
            F.KeyInfo.Icon:EnableMouse(true)
            F.KeyInfo.Icon:SetScript("OnEnter", function(self)
                local timelost = MPT:FormatTime(select(2,C_ChallengeMode.GetDeathCount())) or "0:00"
                local text = "Time lost: "..timelost
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                GameTooltip:SetText(text)
                GameTooltip:Show()                
            end)
            F.KeyInfo.Icon:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            MPT:ApplyTextSettings(F.KeyInfo.DeathCounter , MPTSV.KeyInfo.DeathCounter , deathcount, false, F.KeyInfo.Icon) 
        end    
    end
    if Deaths then
        F.KeyInfo.DeathCounter:SetText(C_ChallengeMode.GetDeathCount())
    end
end

function MPT:UpdateTimerBar(Start, Completion, preview)
    local F = MPT.Frame
    MPT.timer = preview and math.random(900, 2000) or select(2, GetWorldElapsedTime(1))
    MPT.timelimit = preview and 2280 or MPT.timelimit
    local chest = (C_ChallengeMode.GetChallengeCompletionInfo().onTime and C_ChallengeMode.GetChallengeCompletionInfo.keystoneUpgradeLevels)
        or (MPT.timer >= MPT.timelimit and 0) 
        or (MPT.timer >= MPT.timelimit*0.8 and 1) 
        or (MPT.timer >= MPT.timelimit*0.6 and 2)
        or 3 
    if Start or preview then
        local time = select(3, C_ChallengeMode.GetCompletionInfo())
        local now = GetTime()
        if time == 0 then
            MPT.finish = 0
            MPT.started = true
            local mapID = C_ChallengeMode.GetActiveChallengeMapID()
            if mapID then
                MPT.mapID = mapID
            else
                mapID = MPT.mapID
            end
            local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
            MPT.cmap = mapID
            MPT.level = level
            if (mapID and mapID ~= 0) or preview then
                MPT.timelimit = preview and 2280 or select(3, C_ChallengeMode.GetMapUIInfo(mapID))    
                local timeremain = MPT.timelimit-MPT.timer
                F.TimerBar:SetPoint("TOPLEFT", F.KeyInfo, "TOPLEFT", MPTSV.TimerBar.XOffset, -MPTSV.KeyInfo.Height-MPTSV.Spacing+MPTSV.TimerBar.YOffset)
                F.TimerBar:SetSize(MPTSV.TimerBar.Width, MPTSV.TimerBar.Height)
                F.TimerBar:SetStatusBarTexture(MPTSV.TimerBar.Texture)
                F.TimerBar:SetStatusBarColor(unpack(MPTSV.TimerBar.ChestColor[chest+1]))
                F.TimerBar:SetBackdropColor(unpack(MPTSV.TimerBar.BackgroundColor))
                F.TimerBarBorder:SetPoint("TOPLEFT", 0, 0)
                F.TimerBarBorder:SetPoint("BOTTOMRIGHT", 0, 0)
                F.TimerBarBorder:SetBackdrop({
                    edgeFile = "Interface\\Buttons\\WHITE8x8",
                    edgeSize = MPTSV.TimerBar.BorderSize
                })
                F.TimerBarBorder:SetBackdropBorderColor(unpack(MPTSV.TimerBar.BorderColor))

                -- Text on Timer Bar
                local percTime = MPT.timer/MPT.timelimit
                F.TimerBar:SetMinMaxValues(0, MPT.timelimit)
                F.TimerBar:SetValue(MPT.timer)
                MPT:ApplyTextSettings(F.TimerBar.TimerText, MPTSV.TimerText, string.format("%s/%s", MPT:FormatTime(MPT.timer), MPT:FormatTime(MPT.timelimit))) 
                for i=1, 3 do
                    local remTime = MPT.timelimit-MPT.timer-((i-1)*MPT.timelimit*0.2)
                    if chest >= i or i == 1 then
                        local color = i == 1 and remTime < 0 and MPTSV.ChestTimer[i].DepleteColor
                        local prefix = ""
                        if remTime < 0 then prefix = "+" remTime = remTime*-1 end
                        MPT:ApplyTextSettings(F.TimerBar["ChestTimer"..i], MPTSV.ChestTimer[i], prefix..MPT:FormatTime(remTime), color)
                    else
                        F.TimerBar["ChestTimer"..i]:Hide()
                    end
                    if i > 1 and MPTSV.Ticks.enabled and chest >= i then 
                        F.TimerBar.Ticks[i-1]:SetColorTexture(unpack(MPTSV.Ticks.Color))
                        F.TimerBar.Ticks[i-1]:SetWidth(MPTSV.Ticks.Width)
                        F.TimerBar.Ticks[i-1]:SetPoint("LEFT", F.TimerBar, "LEFT", (i == 2 and MPTSV.TimerBar.Width*0.8) or (i == 3 and MPTSV.TimerBar.Width*0.6) , 0)
                        F.TimerBar.Ticks[i-1]:Show()
                    elseif i >= 2 then
                        F.TimerBar.Ticks[i-1]:Hide()
                    end
                end
            end
        end
    end
    if Completion or preview then
        MPT.started = false
        local now = GetTime()
        local time = select(3, C_ChallengeMode.GetCompletionInfo())

        -- add pb to SV
        local cmap = MPT.cmap
        local level = MPT.level     
        local before = false   
        if cmap and level then
            if not MPTSV.BestTime then MPTSV.BestTime = {} end
            if not MPTSV.BestTime[cmap] then MPTSV.BestTime[cmap] = {} end
            if not MPTSV.BestTime[cmap][level] then MPTSV.BestTime[cmap][level] = {} end
            
            before = MPTSV.BestTime[cmap][level]["finish"]
            if not MPTSV.BestTime[cmap][level]["finish"] or time < MPTSV.BestTime[cmap][level]["finish"] then
                MPTSV.BestTime[cmap][level]["finish"] = time
            end
        end        
        
        MPT.timer = preview and MPT.timer or time/1000
        local timeremain = MPT.timelimit-MPT.timer   
        local diff = before and (MPT.finish-before)/1000
        local ComparisonTime = preview and math.random(-200, 200) or diff -- math.random(-200, 200)
        local ComparisonColor = ComparisonTime < 0 and MPTSV.ComparisonTimer.SuccessColor or ComparisonTime > 0 and MPTSV.ComparisonTimer.FailColor or MPTSV.ComparisonTimer.EqualColor
        local prefix = ""
        if ComparisonTime then
            if ComparisonTime < 0 then 
                ComparisonTime = ComparisonTime*-1
                prefix = "-"
            end
            MPT:ApplyTextSettings(F.TimerBar.ComparisonTimer, MPTSV.ComparisonTimer, string.format("%s%s", prefix, ComparisonTime == 0 and "+-0" or MPT:FormatTime(ComparisonTime, true)), ComparisonColor)        
        end
        F.TimerBar:SetValue(MPT.timer)
        if not preview then F.TimerBar:SetStatusBarColor(unpack(MPT.TimerBar.ChestColor[chest])) end
        MPT:ApplyTextSettings(F.TimerBar.TimerText, MPTSV.TimerText, string.format("%s/%s", MPT:FormatTime(MPT.timer), MPT:FormatTime(MPT.timelimit))) 
        for i=1, 3 do
            local remTime = MPT.timelimit-MPT.timer-((i-1)*MPT.timelimit*0.2)
            if chest >= i or i == 1 then
                local color = i == 1 and remTime < 0 and MPTSV.ChestTimer[i].DepleteColor
                local prefix = ""
                if remTime < 0 then prefix = "+" remTime = remTime*-1 end
                MPT:ApplyTextSettings(F.TimerBar["ChestTimer"..i], MPTSV.ChestTimer[i], prefix..MPT:FormatTime(remTime), color)
            else
                F.TimerBar["ChestTimer"..i]:Hide()
            end
            if i > 1 and MPTSV.Ticks.enabled and chest >= i then 
                F.TimerBar.Ticks[i-1]:Show()
            elseif i >= 2 then
                F.TimerBar.Ticks[i-1]:Hide()
            end
        end
    end
    if (not Start) and (not Completion) and ((not MPT.Last) or MPT.Last < GetTime()-MPT.UpdateRate) and (C_ChallengeMode.GetChallengeCompletionInfo().time == 0) and MPT.started then
        MPT.last = GetTime()
        if (not MPT.lasttimer) or MPT.lasttimer ~= MPT.timer then
            if not MPT.cmap then
                local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
                MPT.cmap = C_ChallengeMode.GetActiveChallengeMapID()
                MPT.level = level
            end
            MPT.lasttimer = MPT.timer
            local timeremain = MPT.timelimit-MPT.timer                         
            F.TimerBar:SetStatusBarColor(unpack(MPTSV.TimerBar.ChestColor[chest+1]))
            F.TimerBar:SetValue(MPT.timer)
            MPT:ApplyTextSettings(F.TimerBar.TimerText, MPTSV.TimerText, string.format("%s/%s", MPT:FormatTime(MPT.timer), MPT:FormatTime(MPT.timelimit)))
            for i=1, 3 do
                local remTime = MPT.timelimit-MPT.timer-((i-1)*MPT.timelimit*0.2)
                if chest >= i or i == 1 then
                    local color = i == 1 and remTime < 0 and MPTSV.ChestTimer[i].DepleteColor
                    local prefix = ""
                    if remTime < 0 then prefix = "+" remTime = remTime*-1 end
                    MPT:ApplyTextSettings(F.TimerBar["ChestTimer"..i], MPTSV.ChestTimer[i], prefix..MPT:FormatTime(remTime), color)
                elseif F.TimerBar["ChestTimer"..i]:IsShown() then
                    F.TimerBar["ChestTimer"..i]:Hide()
                end
                if i > 1 and MPTSV.Ticks.enabled and chest >= i then                    
                    F.TimerBar.Ticks[i-1]:SetColorTexture(unpack(MPTSV.Ticks.Color))
                    F.TimerBar.Ticks[i-1]:SetWidth(MPTSV.Ticks.Width)
                    F.TimerBar.Ticks[i-1]:SetPoint("LEFT", F.TimerBar, "LEFT", (i == 2 and MPTSV.TimerBar.Width*0.8) or (i == 3 and MPTSV.TimerBar.Width*0.6) , 0)
                    F.TimerBar.Ticks[i-1]:Show()
                elseif i >= 2 then
                    F.TimerBar.Ticks[i-1]:Hide()
                end
            end 
            return true
        end
    end
end

function MPT:UpdateBosses(Full, number, preview)
    local F = MPT.Frame

end

function MPT:EnemyForces(preview)
    local F = MPT.Frame

end