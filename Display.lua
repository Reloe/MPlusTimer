local _, MPT = ...

function MPT:HideStates()
    if MPT.Frame then MPT.Frame:Hide() end   
end

function MPT:ShowStates()
    if MPT.Frame then MPT.Frame:Show() end   
end

function MPT:Init(preview)
    
    local mapID = C_ChallengeMode.GetActiveChallengeMapID()
    if mapID then
        MPT.cmap = mapID
    else
        mapID = MPT.cmap
    end
    local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
    MPT.level = level
    MPT.opened = false
    MPT.done = false
    MPT.IsPreview = preview

    MPT:HideStates()
    MPT:CreateStates(preview)
    if not preview then MPT:UpdateAllStates() end
    MPT.Frame:Show()
end

function MPT:UpdateAllStates()
    MPT:UpdateMainFrame()
    MPT:UpdateKeyInfo(true)
    MPT:UpdateTimerBar(true, false)
    MPT:UpdateBosses(true, 1)
    MPT:UpdateEnemyForces(true, false)
    MPT:UpdateMainFrame(true)
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
        F.KeyInfo.Icon = CreateFrame("Button", nil, F.KeyInfo)
        F.KeyInfo.Icon.Texture = F.KeyInfo.Icon:CreateTexture(nil, "ARTWORK")
        MPT:CreateText(F.KeyInfo, "DeathCounter", MPT.KeyInfo.DeathCounter)

        -- Boss Bars & Texts
        F.Bosses = {}
        for i=1, 5 do
            F.Bosses[i] = CreateFrame("StatusBar", nil, F, "BackdropTemplate")
            F.Bosses[i]:SetStatusBarColor(0, 0, 0, 0)
            F.Bosses[i]:Hide()
            MPT:CreateText(F.Bosses[i], "BossName"..i, MPT.BossName)
            MPT:CreateText(F.Bosses[i], "BossTimer"..i, MPT.BossTimer)
            MPT:CreateText(F.Bosses[i], "BossSplit"..i, MPT.BossSplit)
        end
    
        -- Enemy Forces Bar
        F.ForcesBar = CreateFrame("StatusBar", nil, F, "BackdropTemplate") -- change which boss number this is anchored to in the display
        F.ForcesBar:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            tileSize = 0
        })
        -- Text on Enemy Forces Bar
        MPT:CreateText(F.ForcesBar, "PercentCount", MPT.ForcesBar.PercentCount)
        MPT:CreateText(F.ForcesBar, "Splits", MPT.ForcesBar.Splits)
        MPT:CreateText(F.ForcesBar, "RealCount", MPT.ForcesBar.RealCount)
        -- Border Forces Bar
        F.ForcesBarBorder = CreateFrame("Frame", nil, F.ForcesBar, "BackdropTemplate")
        -- Move Scripts
        F:SetScript("OnDragStart", function(self)
            self:StartMoving()
        end)
        F:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()       
            local Anchor, _, relativeTo, xOffset, yOffset = self:GetPoint()
            xOffset = Round(xOffset)
            yOffset = Round(yOffset)
            MPT.Position.xOffset = xOffset
            MPT.Position.yOffset = yOffset
            MPT.Position.Anchor = Anchor
            MPT.Position.relativeTo = relativeTo
            MPTSV.Profiles[MPT.ActiveProfile].Position.xOffset = xOffset
            MPTSV.Profiles[MPT.ActiveProfile].Position.yOffset = yOffset
            MPTSV.Profiles[MPT.ActiveProfile].Position.Anchor = Anchor
            MPTSV.Profiles[MPT.ActiveProfile].Position.relativeTo = relativeTo
            MPT.Frame:SetPoint(Anchor, UIParent, relativeTo, xOffset, yOffset)
        end)

    end  
    
 

    -- Set preview values
    if preview and MPT.Frame then   
        MPT:UpdateMainFrame()         
        -- Key Info Bar
        MPT:UpdateKeyInfo(true, false, true)

        -- Timer Bar
        MPT:UpdateTimerBar(true, true, true)
        
        -- Bosses
        MPT:UpdateBosses(false, false, true)    
        -- Forces Bar
        MPT:UpdateEnemyForces(true, true)
        
        -- Fix Background Size
        MPT:UpdateMainFrame(true)
    end
end

function MPT:UpdateMainFrame(BackgroundOnly)
    local F = MPT.Frame
    -- Main Frame    
    if BackgroundOnly and MPT.Background.enabled then    
        local bosscount = #MPT.BossNames
        F:SetSize(MPT.TimerBar.Width, MPT.TimerBar.Height+MPT.KeyInfo.Height+MPT.ForcesBar.Height+(MPT.Bosses.Height*bosscount)+(MPT.Spacing*(bosscount+1))+1)
        if MPT.Background.enabled then
            F.BG:SetAllPoints(F)
            F.BGBorder:SetFrameLevel(F.KeyInfo:GetFrameLevel()+1)
            F.BGBorder:SetAllPoints(F)
            F.BG:Show()
            F.BGBorder:Show()
        else
            F.BG:Hide()
            F.BGBorder:Hide()
        end
    else
        local maxSize = MPT.TimerBar.Height+MPT.KeyInfo.Height+MPT.ForcesBar.Height+(MPT.Bosses.Height*5)+(MPT.Spacing*6)+1
        F:SetSize(MPT.TimerBar.Width, maxSize)
        F:SetScale(MPT.Scale)
        F:SetPoint(MPT.Position.Anchor, UIParent, MPT.Position.relativeTo, MPT.Position.xOffset, MPT.Position.yOffset)   
        if MPT.Background.enabled then
            F.BG:SetAllPoints(F)
            F.BG:SetColorTexture(unpack(MPT.Background.Color)) 
            F.BGBorder:SetAllPoints(F)
            F.BGBorder:SetBackdropBorderColor(unpack(MPT.Background.BorderColor))
        end
    end
end

function MPT:UpdateKeyInfo(Full, Deaths, preview)
    local F = MPT.Frame
    if Full then
        local mapID = MPT.cmap
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
                    AffixDisplay = AffixDisplay.."\124T"..select(i, strsplit(" ", icon))..":"..MPT.KeyInfo.AffixIcons.FontSize..":"..MPT.KeyInfo.AffixIcons.FontSize..":"..1-i..":0:64:64:6:60:6:60\124t"
                end
            end
        end        
        F.KeyInfo:SetPoint("TOPLEFT", F, "TOPLEFT", MPT.KeyInfo.xOffset, MPT.KeyInfo.yOffset)
        F.KeyInfo:SetSize(MPT.KeyInfo.Width, MPT.KeyInfo.Height)
        if MPT.KeyInfo.KeyLevel.enabled then MPT:ApplyTextSettings(F.KeyInfo.KeyLevel, MPT.KeyInfo.KeyLevel, keyLevel) end
        if MPT.KeyInfo.DungeonName.enabled then MPT:ApplyTextSettings(F.KeyInfo.DungeonName, MPT.KeyInfo.DungeonName, DungeonName, false, F.KeyInfo.KeyLevel) end        
        if MPT.KeyInfo.AffixIcons.enabled then MPT:ApplyTextSettings(F.KeyInfo.AffixIcons, MPT.KeyInfo.AffixIcons, AffixDisplay, false, F.KeyInfo.DungeonName) end
        if MPT.KeyInfo.DeathCounter.enabled then
            local icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"
            F.KeyInfo.Icon:SetSize(MPT.KeyInfo.Height, MPT.KeyInfo.Height)
            F.KeyInfo.Icon:SetPoint(MPT.KeyInfo.DeathCounter.IconAnchor, F.KeyInfo, MPT.KeyInfo.DeathCounter.IconRelativeTo, MPT.KeyInfo.DeathCounter.IconxOffset, MPT.KeyInfo.DeathCounter.IconyOffset)
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
            MPT:ApplyTextSettings(F.KeyInfo.DeathCounter , MPT.KeyInfo.DeathCounter , deathcount, false, F.KeyInfo.Icon) 
        end    
    end
    if Deaths then
        F.KeyInfo.DeathCounter:SetText(C_ChallengeMode.GetDeathCount())
    end
end

function MPT:UpdateTimerBar(Start, Completion, preview)
    local F = MPT.Frame
    MPT.timer = preview and math.random(900, 2000) or select(2, GetWorldElapsedTime(1))
    MPT.timelimit = preview and 2280 or MPT.timelimit or 0
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
            if (MPT.cmap and MPT.cmap ~= 0) or preview then
                MPT.timelimit = preview and 2280 or select(3, C_ChallengeMode.GetMapUIInfo(MPT.cmap))    
                local timeremain = MPT.timelimit-MPT.timer
                F.TimerBar:SetPoint("TOPLEFT", F.KeyInfo, "TOPLEFT", MPT.TimerBar.xOffset, -MPT.KeyInfo.Height+MPT.TimerBar.yOffset-1)
                F.TimerBar:SetSize(MPT.TimerBar.Width, MPT.TimerBar.Height)
                F.TimerBar:SetStatusBarTexture(MPT.TimerBar.Texture)
                F.TimerBar:SetStatusBarColor(unpack(MPT.TimerBar.ChestColor[chest+1]))
                F.TimerBar:SetBackdropColor(unpack(MPT.TimerBar.BackgroundColor))
                F.TimerBarBorder:SetPoint("TOPLEFT", 0, 0)
                F.TimerBarBorder:SetPoint("BOTTOMRIGHT", 0, 0)
                F.TimerBarBorder:SetBackdrop({
                    edgeFile = "Interface\\Buttons\\WHITE8x8",
                    edgeSize = MPT.TimerBar.BorderSize
                })
                F.TimerBarBorder:SetBackdropBorderColor(unpack(MPT.TimerBar.BorderColor))

                -- Text on Timer Bar
                local percTime = MPT.timer/MPT.timelimit
                F.TimerBar:SetMinMaxValues(0, MPT.timelimit)
                MPT:DisplayTimerElements(chest)
            end
        end
    end
    if Completion or preview then
        MPT.started = false
        local now = GetTime()
        local time = select(3, C_ChallengeMode.GetCompletionInfo())

        -- add pb
        local cmap = MPT.cmap
        local level = MPT.level     
        local before = false   
        if cmap and level then
            if not MPT.BestTime then MPT.BestTime = {} end
            if not MPT.BestTime[cmap] then MPT.BestTime[cmap] = {} end
            if not MPT.BestTime[cmap][level] then MPT.BestTime[cmap][level] = {} end
            
            before = MPT.BestTime[cmap][level]["finish"]
            if not MPT.BestTime[cmap][level]["finish"] or time < MPT.BestTime[cmap][level]["finish"] then
                MPT.BestTime[cmap][level]["finish"] = time                
                MPT.BestTime[cmap][level]["forces"] = time
                for i, v in ipairs(MPT.BossTimes) do
                    MPT.BestTime[cmap][level][i] = v
                end
            end
        end        
        
        MPT.timer = preview and MPT.timer or time/1000
        local timeremain = MPT.timelimit-MPT.timer   
        local diff = before and (MPT.finish-before)/1000
        local ComparisonTime = preview and math.random(-200, 200) or diff -- math.random(-200, 200)
        local ComparisonColor = ComparisonTime < 0 and MPT.ComparisonTimer.SuccessColor or ComparisonTime > 0 and MPT.ComparisonTimer.FailColor or MPT.ComparisonTimer.EqualColor
        local prefix = ""
        if ComparisonTime then
            if ComparisonTime < 0 then 
                ComparisonTime = ComparisonTime*-1
                prefix = "-"
            elseif ComparisonTime > 0 then
                prefix = "+"
            end
            MPT:ApplyTextSettings(F.TimerBar.ComparisonTimer, MPT.ComparisonTimer, string.format("%s%s", prefix, ComparisonTime == 0 and "+-0" or MPT:FormatTime(ComparisonTime, true)), ComparisonColor)        
        end
        if not preview then F.TimerBar:SetStatusBarColor(unpack(MPT.TimerBar.ChestColor[chest])) end
        MPT:DisplayTimerElements(chest)
    end
    if (not Start) and (not Completion) and ((not MPT.Last) or MPT.Last < GetTime()-MPT.UpdateRate) and (C_ChallengeMode.GetChallengeCompletionInfo().time == 0) and MPT.started then
        MPT.last = GetTime()
        if (not MPT.lasttimer) or MPT.lasttimer ~= MPT.timer then
            if not MPT.cmap then
                local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
                MPT.cmap = MPT.cmap or C_ChallengeMode.GetActiveChallengeMapID()
                MPT.level = level
            end
            MPT.lasttimer = MPT.timer
            local timeremain = MPT.timelimit-MPT.timer                         
            F.TimerBar:SetStatusBarColor(unpack(MPT.TimerBar.ChestColor[chest+1]))                        
            MPT:DisplayTimerElements(chest)
            return true
        end
    end
end

function MPT:DisplayTimerElements(chest)
    local F = MPT.Frame
    local displayed = false
    F.TimerBar:SetValue(MPT.timer)
    MPT:ApplyTextSettings(F.TimerBar.TimerText, MPT.TimerText, string.format("%s/%s", MPT:FormatTime(MPT.timer), MPT:FormatTime(MPT.timelimit)))
    for i=3, 1, -1 do
        local remTime = MPT.timelimit-MPT.timer-((i-1)*MPT.timelimit*0.2)
        if MPT.TimerBar.ChestTimerDisplay ~= 3 and (chest >= i or (i == 1 and remTime < 0)) and (MPT.TimerBar.ChestTimerDisplay == 2 or not displayed) then
            displayed = true
            local color = i == 1 and remTime < 0 and MPT.ChestTimer[i].DepleteColor
            local prefix = ""
            if remTime < 0 then prefix = "+" remTime = remTime*-1 end
            MPT:ApplyTextSettings(F.TimerBar["ChestTimer"..i], MPT.ChestTimer[i], prefix..MPT:FormatTime(remTime), color)
        else
            F.TimerBar["ChestTimer"..i]:Hide()
        end
        if i > 1 and MPT.Ticks.enabled and chest >= i then                    
            F.TimerBar.Ticks[i-1]:SetColorTexture(unpack(MPT.Ticks.Color))
            F.TimerBar.Ticks[i-1]:SetWidth(MPT.Ticks.Width)
            F.TimerBar.Ticks[i-1]:SetPoint("LEFT", F.TimerBar, "LEFT", (i == 2 and MPT.TimerBar.Width*0.8) or (i == 3 and MPT.TimerBar.Width*0.6) , 0)
            F.TimerBar.Ticks[i-1]:Show()
    elseif i >= 2 then
            F.TimerBar.Ticks[i-1]:Hide()
        end
    end
end

function MPT:UpdateBosses(Start, count, preview)
    local F = MPT.Frame
    if preview then
        local killtime = 0
        MPT:MuteJournalSounds()
        MPT.BossNames = {}
        for i=1, 5 do
            EJ_SelectInstance(721)
            local name = EJ_GetEncounterInfoByIndex(i, 721)
            name = MPT:Utf8Sub(name, 20) or "Boss "..i
            killtime = killtime+math.random(240, 420)
            local time = MPT:FormatTime(killtime, true)
            local frame = F.Bosses[i]
            MPT.BossNames[i] = name
            frame:SetPoint("TOPLEFT", F.TimerBar, "TOPLEFT", MPT.Bosses.xOffset, -MPT.TimerBar.Height-(i*MPT.Spacing)-(i-1)*(MPT.Bosses.Height)+MPT.Bosses.yOffset)
            frame:SetSize(MPT.Bosses.Width, MPT.Bosses.Height)
            local BossColor = i <= 3 and MPT.BossName.CompletionColor or MPT.BossName.Color
            MPT:ApplyTextSettings(F.Bosses[i]["BossName"..i], MPT.BossName, name, BossColor)
            local timercolor = (i == 1 and MPT.BossTimer.FailColor) or (i == 2 and MPT.BossTimer.EqualColor) or (i == 3 and MPT.BossTimer.SuccessColor) or MPT.BossTimer.Color
            local splitcolor = (i == 1 and MPT.BossSplit.FailColor) or (i == 2 and MPT.BossSplit.EqualColor) or (i == 3 and MPT.BossSplit.SuccessColor) or MPT.BossSplit.Color
            local splittext = (i == 2 and "+-0") or (i == 1 and "+"..MPT:FormatTime(math.random(20, 60))) or (i == 3 and "-"..MPT:FormatTime(math.random(20, 60)))
            MPT:ApplyTextSettings(F.Bosses[i]["BossTimer"..i], MPT.BossTimer, time, timercolor)
            frame:Show()
            if splittext then MPT:ApplyTextSettings(F.Bosses[i]["BossSplit"..i], MPT.BossSplit, splittext, splitcolor) end
        end
    elseif Start then
        MPT.BossTimes = {}
        MPT.BossNames = {}

        local max = select(3, C_Scenario.GetStepInfo())
        if C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).isWeightedProgress then max = max-1 end -- if last criteria is enemy forces
        MPT:MuteJournalSounds()
        local mapID = C_Map.GetBestMapForUnit("player")
        local instanceID = (mapID and EJ_GetInstanceForMap(mapID)) or 0
        if instanceID == 0 or instanceID == nil then
            if MPT.cmap and MPT.maptoID[MPT.cmap] then
                instanceID = MPT.maptoID[MPT.cmap][1]
            end
        end
        if instanceID and instanceID ~= 0 then
            if not C_AddOns.IsAddOnLoaded("Blizzard_EncounterJournal") then C_AddOns.LoadAddOn("Blizzard_EncounterJournal") end        
            for i=1, 20 do
                local name = EJ_GetEncounterInfoByIndex(i, instanceID)
                if name and name ~= "nil" then
                    MPT.BossNames[i] = name
                elseif i < select(3, C_Scenario.GetStepInfo()) and not MPT.opened then
                    EncounterJournal_OpenJournal(23, instanceID) 
                    EJ_SelectInstance(instanceID)
                    MPT.opened = true
                    HideUIPanel(EncounterJournal)
                    local name = EJ_GetEncounterInfoByIndex(i, instanceID)
                    if name then
                        MPT.BossNames[i] = name
                    end
                else
                    break
                end
            end
        end
        if count <= 6 then -- check again in 2 seconds a few times to make sure data is correct
            C_Timer.After(2, function()
                    MPT:UpdateBosses(true, count+1)
            end)
        end 
        if max > 0 then
            if C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).isWeightedProgress then max = max-1 end
            local cmap = MPT.cmap
            local level = MPT.level
            local pb = MPT.BossSplit.enabled and MPT.BestTime and MPT.BestTime[cmap] and (MPT.BestTime[cmap][level] or (MPT.LowerKey and MPT.BestTime[cmap][level-1]))
            for i=1, max do 
                local num = (cmap == 370 and i+4) or (cmap == 392 and i+5) or (cmap == 227 and i+2) or (cmap == 234 and i+6) or (cmap == 464 and i+4) or i
                local name = MPT.BossNames[num]
                local criteria = C_ScenarioInfo.GetCriteriaInfo(i)
                for j = 1, #(MPT.BossNames) do
                    if MPT.BossNames[j] and string.find(criteria.description, MPT.BossNames[j]) then
                        name = MPT.BossNames[j]
                        break
                    end
                end
                if cmap == 227 and num == 3 then name = "Opera Hall" end
                name = MPT:Utf8Sub(name, MPT.BossName.MaxLength)
                if name and name ~= "" then      
                    local completed = criteria.completed
                    local defeated = criteria.elapsed
                    local frame = F.Bosses[i]                    
                    frame:SetPoint("TOPLEFT", F.TimerBar, "TOPLEFT", MPT.Bosses.xOffset, -MPT.TimerBar.Height-(i*MPT.Spacing)-(i-1)*(MPT.Bosses.Height)+MPT.Bosses.yOffset)
                    frame:SetSize(MPT.Bosses.Width, MPT.Bosses.Height)
                    local BossColor = completed and MPT.BossName.CompletionColor or MPT.BossName.Color
                    MPT:ApplyTextSettings(frame["BossName"..i], MPT.BossName, name, BossColor)
                    if not completed then
                        frame["BossTimer"..i]:SetText("")
                        frame["BossSplit"..i]:SetText("")
                    end
                    if completed and defeated and defeated ~= 0 and MPT.BossTimer.enabled then                        
                        local timercolor = MPT.BossTimer.Color
                        local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                        if pb and pb[i] then
                            timercolor = (pb[i] == time and MPT.BossTimer.EqualColor) or (pb > time and MPT.BossTimer.SuccessColor) or MPT.BossTimer.FailColor
                        end
                        MPT:ApplyTextSettings(frame["BossTimer"..i], MPT.BossTimer, MPT:FormatTime(time), timercolor)
                    end
                    if completed and defeated and defeated ~= 0 and pb and pb[i] and MPT.BossSplit.enabled then
                        local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                        local splitcolor = (pb[i] == time and MPT.BossSplit.EqualColor) or (pb[i] > time and MPT.BossSplit.SuccessColor) or MPT.BossSplit.FailColor
                        local prefix = (pb[i] == time and "+-0") or (pb[i] > time and "-") or "+"
                        local diff = time-pb[i]
                        if diff < 0 then diff = diff*-1 end
                        MPT:ApplyTextSettings(frame["BossSplit"..i], MPT.BossSplit, prefix..MPT:FormatTime(diff), splitcolor)
                    end
                    frame:Show()
                end                
            end
        end        
    else
        local max = select(3, C_Scenario.GetStepInfo())
        if C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).isWeightedProgress then max = max-1 end
        local pb = MPT.BossSplit.enabled and MPT.BestTime and MPT.BestTime[cmap] and (MPT.BestTime[cmap][level] or (MPT.LowerKey and MPT.BestTime[cmap][level-1]))
        for i=1, max do
            local criteria = C_ScenarioInfo.GetCriteriaInfo(i)
            if criteria.completed then
                local defeated = criteria.elapsed
                local frame = F.Bosses[i]                    
                frame["BossName"..i]:SetTextColor(MPT.BossName.CompletionColor)                
                if defeated and defeated ~= 0 and MPT.BossTimer.enabled then                        
                    local timercolor = MPT.BossTimer.Color
                    local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                    if pb and pb[i] then
                        timercolor = (pb[i] == time and MPT.BossTimer.EqualColor) or (pb[i] > time and MPT.BossTimer.SuccessColor) or MPT.BossTimer.FailColor
                    end
                    MPT:ApplyTextSettings(frame["BossTimer"..i], MPT.BossTimer, MPT:FormatTime(time), timercolor)
                end
                if completed and defeated and defeated ~= 0 and pb and pb[i] and MPT.BossSplit.enabled then
                    local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                    local splitcolor = (pb[i] == time and MPT.BossSplit.EqualColor) or (pb[i] > time and MPT.BossSplit.SuccessColor) or MPT.BossSplit.FailColor
                    local prefix = (pb[i] == time and "+-0") or (pb[i] > time and "-") or "+"
                    local diff = time-pb[i]
                    if diff < 0 then diff = diff*-1 end
                    MPT:ApplyTextSettings(frame["BossSplit"..i], MPT.BossSplit, prefix..MPT:FormatTime(diff), splitcolor)
                end
            end
        end
        return true
    end

end

function MPT:UpdateEnemyForces(Start, preview)
    local F = MPT.Frame
    local steps = preview and 5 or select(3, C_Scenario.GetStepInfo())
    if not steps or steps <= 0 then
        return
    end
    local criteria = preview and {} or C_ScenarioInfo.GetCriteriaInfo(steps)
    local total = preview and 100 or criteria.totalQuantity
    local current = preview and math.random(20, 90) or criteria.quantityString:gsub("%%", "")
    current = tonumber(current)
    local percent = 0
    if current then
        percent = current / total * 100
        percent = math.floor(percent*100)/100
    end
    if Start or preview then
        local bosscount = preview and 5 or #MPT.BossNames
        F.ForcesBar:SetPoint("TOPLEFT", F.Bosses[bosscount], "TOPLEFT", MPT.ForcesBar.xOffset, -MPT.Bosses.Height-MPT.Spacing+MPT.ForcesBar.yOffset) 
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
        F.ForcesBar:SetMinMaxValues(0, total)
        F.ForcesBar:SetValue(current)
        local forcesColor =
        (percent < 20 and MPT.ForcesBar.Color[1]) or
        (percent < 40 and MPT.ForcesBar.Color[2]) or
        (percent < 60 and MPT.ForcesBar.Color[3]) or
        (percent < 80 and MPT.ForcesBar.Color[4]) or
        (percent < 100 and MPT.ForcesBar.Color[5]) or MPT.ForcesBar.CompletionColor
        F.ForcesBar:SetStatusBarColor(unpack(forcesColor))
        if MPT.ForcesBar.PercentCount.enabled then MPT:ApplyTextSettings(F.ForcesBar.PercentCount, MPT.ForcesBar.PercentCount, string.format("%.2f%%", percent)) end
        if MPT.ForcesBar.RealCount.enabled then MPT:ApplyTextSettings(F.ForcesBar.RealCount, MPT.ForcesBar.RealCount, total-current) end
        F.ForcesBar:Show()
    else
        F.ForcesBar:SetValue(current)
        local forcesColor =
        (percent < 20 and MPT.ForcesBar.Color[1]) or
        (percent < 40 and MPT.ForcesBar.Color[2]) or
        (percent < 60 and MPT.ForcesBar.Color[3]) or
        (percent < 80 and MPT.ForcesBar.Color[4]) or
        (percent < 100 and MPT.ForcesBar.Color[5]) or MPT.ForcesBar.CompletionColor
        F.ForcesBar:SetStatusBarColor(unpack(forcesColor))
        if percent >= 100 and not MPT.done then
            local max = select(3, C_Scenario.GetStepInfo())
            local defeat = C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).elapsed or 0
            local cur = select(2, GetWorldElapsedTime(1)) - defeat
            local cmap = MPT.cmap
            local level = MPT.level
            local pb = MPT.ForcesBar.Splits.enabled and MPT.BestTime and MPT.BestTime[cmap] and (MPT.BestTime[cmap][level] or (MPT.LowerKey and MPT.BestTime[cmap][level-1]))
            if pb and pb["forces"] then                
                local diff = cur - pb["forces"]
                local color = (diff == 0 and MPT.ForcesBar.Splits.EqualColor) or (diff < 0 and MPT.ForcesBar.Splits.SuccessColor) or MPT.ForcesBar.Splits.FailColor
                local prefix = (diff == 0 and "+-0") or (diff < 0 and "-") or "+"
                if diff < 0 then diff = diff * -1 end
                MPT:ApplyTextSettings(F.ForcesBar.Splits, MPT.ForcesBar.Splits, prefix..MPT:FormatTime(diff), color)
            end
            MPT.done = true
        end
        if MPT.ForcesBar.PercentCount.enabled then MPT:ApplyTextSettings(F.ForcesBar.PercentCount, MPT.ForcesBar.PercentCount, string.format("%.2f%%", percent)) end
        if MPT.ForcesBar.RealCount.enabled then MPT:ApplyTextSettings(F.ForcesBar.RealCount, MPT.ForcesBar.RealCount, total-current) end
    end
end