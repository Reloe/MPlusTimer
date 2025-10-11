local _, MPT = ...
local LSM = LibStub("LibSharedMedia-3.0")

function MPT:HideStates()
    if self.Frame then self.Frame:Hide() end
end

function MPT:ShowStates()
    if self.Frame then self.Frame:Show() end
end

function MPT:Init(preview)
    
    local mapID = C_ChallengeMode.GetActiveChallengeMapID()
    if mapID then
        self.cmap = mapID
    else
        mapID = self.cmap
    end
    local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
    self.level = level
    self.opened = false
    self.done = false
    self.IsPreview = preview

    self:HideStates()
    self:CreateStates(preview)
    if not preview then self:UpdateAllStates() end
    self:ShowFrame(true)
end

function MPT:UpdateAllStates()
    self:UpdateMainFrame()
    self:UpdateKeyInfo(true)
    self:UpdateTimerBar(true, false)
    self:UpdateBosses(true, 1)
    self:UpdateEnemyForces(true, false)
    self:UpdateMainFrame(true)
end


function MPT:CreateStates(preview)
    if not self.Frame then
        self.Frame = CreateFrame("Frame", nil, UIParent) -- Main Frame
        local F = self.Frame
        -- Background Main Frame
        F.BG = F:CreateTexture(nil, "BACKGROUND")
        -- Background Border Main Frame
        F.BGBorder = CreateFrame("Frame", nil, F, "BackdropTemplate")           

        -- Keystone Info
        self:CreateStatusBar(F, "KeyInfo", false, false)
        self:CreateText(F.KeyInfo, "KeyLevel", self.KeyLevel)
        self:CreateText(F.KeyInfo, "DungeonName", self.DungeonName)
        self:CreateText(F.KeyInfo, "AffixIcons", self.AffixIcons)
        F.KeyInfo.Icon = CreateFrame("Button", nil, F.KeyInfo)
        F.KeyInfo.Icon.Texture = F.KeyInfo.Icon:CreateTexture(nil, "ARTWORK")
        self:CreateText(F.KeyInfo, "DeathCounter", self.DeathCounter)

        -- Timer Bar
        self:CreateStatusBar(F, "TimerBar", true, true)
        self:CreateText(F.TimerBar, "TimerText", self.TimerText) -- Current Timer
        for i=1, 3 do
            self:CreateText(F.TimerBar, "ChestTimer"..i, self["ChestTimer"..i], false, false, i) -- Chest Timer
        end
        self:CreateText(F.TimerBar, "ComparisonTimer", self.ComparisonTimer) -- Comparison Timer
        -- Timer Bar Ticks
        F.TimerBar.Ticks = {}
        for i=1, 2 do
            F.TimerBar.Ticks[i] = F.TimerBar:CreateTexture(nil, "OVERLAY")
            F.TimerBar.Ticks[i]:ClearAllPoints()
            F.TimerBar.Ticks[i]:SetPoint("TOP")
            F.TimerBar.Ticks[i]:SetPoint("BOTTOM")
            F.TimerBar.Ticks[i]:Hide()
        end

        -- Bosses            
        F.Bosses = {}
        for i=1, 5 do -- Boss Bars & Texts
            self:CreateStatusBar(F, "Bosses"..i, false, false)
            F["Bosses"..i]:SetStatusBarColor(0, 0, 0, 0)
            F["Bosses"..i]:Hide()
            self:CreateText(F["Bosses"..i], "BossName"..i, self.BossName)
            self:CreateText(F["Bosses"..i], "BossTimer"..i, self.BossTimer)
            self:CreateText(F["Bosses"..i], "BossSplit"..i, self.BossSplit)
        end

        -- Enemy Forces
        self:CreateStatusBar(F, "ForcesBar", true, true)
        self:CreateText(F.ForcesBar, "PercentCount", self.PercentCount)
        self:CreateText(F.ForcesBar, "Splits", self.ForcesSplits)
        self:CreateText(F.ForcesBar, "RealCount", self.RealCount)
        self:CreateText(F.ForcesBar, "Completion", self.ForcesCompletion)

        -- Move Scripts
        F:SetScript("OnDragStart", function(self)
            self:StartMoving()
        end)
        F:SetScript("OnDragStop", function(Frame)
            Frame:StopMovingOrSizing()       
            local Anchor, _, relativeTo, xOffset, yOffset = Frame:GetPoint()
            xOffset = Round(xOffset)
            yOffset = Round(yOffset)
            self:SetSV({"Position", "xOffset"}, xOffset)
            self:SetSV({"Position", "yOffset"}, yOffset)
            self:SetSV({"Position", "Anchor"}, Anchor)
            self:SetSV({"Position", "relativeTo"}, relativeTo)            
            self:SetPoint(self.Frame, Anchor, UIParent, relativeTo, xOffset, yOffset)
        end)

    end  
    
 

    -- Set preview values
    if preview and self.Frame then
        self:UpdateMainFrame()         
        -- Key Info Bar
        self:UpdateKeyInfo(true, false, true)

        -- Timer Bar
        self:UpdateTimerBar(true, true, true)

        -- Bosses
        self:UpdateBosses(false, false, true)    
        -- Forces Bar
        self:UpdateEnemyForces(true, true)

        -- Fix Background Size
        self:UpdateMainFrame(true)
        self:MoveFrame(true)
    end
end

function MPT:UpdateMainFrame(BackgroundOnly)
    local F = self.Frame
    -- Main Frame    
    if BackgroundOnly then    
        local bosscount = #self.BossNames
        local size = self.TimerBar.Height+self.ForcesBar.Height+(self.Bosses.Height*bosscount)+(self.Spacing*(bosscount))+1
        if self.KeyInfo.enabled then size = size+self.KeyInfo.Height+self.Spacing end
        F:SetSize(self.TimerBar.Width, size)
        if self.Background.enabled then
            F.BG:SetAllPoints(F)
            F.BG:SetColorTexture(unpack(self.Background.Color))  
            F.BGBorder:SetFrameLevel(F.KeyInfo:GetFrameLevel()+1)
            F.BGBorder:SetAllPoints(F)
            F.BGBorder:SetBackdrop({
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = self.Background.BorderSize,
            })
            F.BGBorder:SetBackdropBorderColor(unpack(self.Background.BorderColor))
            F.BG:Show()
            F.BGBorder:Show()
        else
            F.BG:Hide()
            F.BGBorder:Hide()
        end
    else        
        local maxSize = self.TimerBar.Height+self.ForcesBar.Height+(self.Bosses.Height*5)+(self.Spacing*5)+1
        if self.KeyInfo.enabled then maxSize = maxSize+self.KeyInfo.Height+self.Spacing end
        F:SetSize(self.TimerBar.Width, maxSize)
        F:SetScale(self.Scale)
        self:SetPoint(F, self.Position.Anchor, UIParent, self.Position.relativeTo, self.Position.xOffset, self.Position.yOffset)
        if self.Background.enabled then
            F.BG:SetAllPoints(F)
            F.BG:SetColorTexture(unpack(self.Background.Color))    
            F.BGBorder:SetFrameLevel(F.KeyInfo:GetFrameLevel()+1)        
            F.BGBorder:SetAllPoints(F)
            F.BGBorder:SetBackdrop({
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = self.Background.BorderSize,
            })
            F.BGBorder:SetBackdropBorderColor(unpack(self.Background.BorderColor))
        else
            F.BG:Hide()
            F.BGBorder:Hide()
        end
    end
end

function MPT:UpdateKeyInfo(Full, Deaths, preview)
    local F = self.Frame
    if not self.KeyInfo.enabled then
        F.KeyInfo:Hide()
        return
    end
    if Full then
        local mapID = self.cmap
        local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
        local keyLevel = (preview and "+30") or "+"..level
        local DungeonName = (preview and "Halls of Valor") or (mapID and self.maptoID[mapID] and self.maptoID[mapID][2]) or ""
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
                    AffixDisplay = AffixDisplay.."\124T"..select(i, strsplit(" ", icon))..":"..self.KeyInfo.AffixIcons.FontSize..":"..self.KeyInfo.AffixIcons.FontSize..":"..1-i..":0:64:64:6:60:6:60\124t"
                end
            end
        end        
        self:SetPoint(F.KeyInfo, "TOPLEFT", F, "TOPLEFT", self.KeyInfo.xOffset, self.KeyInfo.yOffset)
        F.KeyInfo:SetSize(self.KeyInfo.Width, self.KeyInfo.Height)
        self:ApplyTextSettings(F.KeyInfo.KeyLevel, self.KeyLevel, keyLevel)
        self:ApplyTextSettings(F.KeyInfo.DungeonName, self.DungeonName, DungeonName, false, F.KeyInfo)
        self:ApplyTextSettings(F.KeyInfo.AffixIcons, self.AffixIcons, AffixDisplay, false, F.KeyInfo)
        if self.DeathCounter.enabled then
            local icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"
            F.KeyInfo.Icon:SetSize(self.KeyInfo.Height, self.KeyInfo.Height)
            self:SetPoint(F.KeyInfo.Icon, self.DeathCounter.IconAnchor, F.KeyInfo, self.DeathCounter.IconRelativeTo, self.DeathCounter.IconxOffset, self.DeathCounter.IconyOffset)
            F.KeyInfo.Icon.Texture:SetAllPoints(F.KeyInfo.Icon)     
            F.KeyInfo.Icon.Texture:SetTexture(icon)
            F.KeyInfo.Icon:EnableMouse(true)
            F.KeyInfo.Icon:SetScript("OnEnter", function(Frame)
                local timelost = self:FormatTime(select(2,C_ChallengeMode.GetDeathCount())) or "0:00"
                local text = "Time lost: "..timelost
                GameTooltip:SetOwner(Frame, "ANCHOR_CURSOR")
                GameTooltip:SetText(text)
                GameTooltip:Show()                
            end)
            F.KeyInfo.Icon:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            F.KeyInfo.Icon:Show()
            self:ApplyTextSettings(F.KeyInfo.DeathCounter , self.DeathCounter , deathcount, false, F.KeyInfo.Icon) 
        else
            F.KeyInfo.Icon:Hide()
            F.KeyInfo.DeathCounter:Hide() 
        end
    end
    if Deaths then
        F.KeyInfo.DeathCounter:SetText(C_ChallengeMode.GetDeathCount())
    end
end

function MPT:UpdateTimerBar(Start, Completion, preview)
    local F = self.Frame
    self.timer = preview and math.random(900, 2000) or select(2, GetWorldElapsedTime(1))
    self.timelimit = preview and 2280 or self.timelimit or 0
    local chest = (C_ChallengeMode.GetChallengeCompletionInfo().onTime and C_ChallengeMode.GetChallengeCompletionInfo.keystoneUpgradeLevels)
        or (self.timer >= self.timelimit and 0)
        or (self.timer >= self.timelimit*0.8 and 1)
        or (self.timer >= self.timelimit*0.6 and 2)
        or 3
    if Start or preview then
        local time = select(3, C_ChallengeMode.GetCompletionInfo())
        local now = GetTime()
        if time == 0 then
            self.finish = 0
            self.started = true
            if (self.cmap and self.cmap ~= 0) or preview then
                self.timelimit = preview and 2280 or select(3, C_ChallengeMode.GetMapUIInfo(self.cmap))
                local timeremain = self.timelimit-self.timer
                self:SetPoint(F.TimerBar, "TOPLEFT", F.KeyInfo, "TOPLEFT", self.TimerBar.xOffset, -self.KeyInfo.Height+self.TimerBar.yOffset-1)
                F.TimerBar:SetSize(self.TimerBar.Width, self.TimerBar.Height)
                F.TimerBar:SetStatusBarTexture(self.LSM:Fetch("statusbar", self.TimerBar.Texture))
                F.TimerBar:SetStatusBarColor(unpack(self.TimerBar.Color[chest+1]))
                F.TimerBar:SetBackdropColor(unpack(self.TimerBar.BackgroundColor))
                F.TimerBarBorder:ClearAllPoints()
                F.TimerBarBorder:SetPoint("TOPLEFT", 0, 0)
                F.TimerBarBorder:SetPoint("BOTTOMRIGHT", 0, 0)
                F.TimerBarBorder:SetBackdrop({
                    edgeFile = "Interface\\Buttons\\WHITE8x8",
                    edgeSize = self.TimerBar.BorderSize
                })
                F.TimerBarBorder:SetBackdropBorderColor(unpack(self.TimerBar.BorderColor))

                -- Text on Timer Bar
                local percTime = self.timer/self.timelimit
                F.TimerBar:SetMinMaxValues(0, self.timelimit)
                self:DisplayTimerElements(chest)
            end
        end
    end
    if Completion or preview then
        self.started = false
        local now = GetTime()
        local time = select(3, C_ChallengeMode.GetCompletionInfo())

        -- add pb
        local cmap = self.cmap
        local level = self.level
        local before = false
        if cmap and level then
            if not self.BestTime then self.BestTime = {} end
            if not self.BestTime[cmap] then self.BestTime[cmap] = {} end
            if not self.BestTime[cmap][level] then self.BestTime[cmap][level] = {} end

            before = self.BestTime[cmap][level]["finish"]
            if not self.BestTime[cmap][level]["finish"] or time < self.BestTime[cmap][level]["finish"] then
                self.BestTime[cmap][level]["finish"] = time
                self.BestTime[cmap][level]["forces"] = time
                for i, v in ipairs(self.BossTimes) do
                    self.BestTime[cmap][level][i] = v
                end
            end
        end

        self.timer = preview and self.timer or time/1000
        local timeremain = self.timelimit-self.timer
        local diff = before and (self.finish-before)/1000
        local ComparisonTime = preview and math.random(-200, 200) or diff -- math.random(-200, 200)
        local ComparisonColor = ComparisonTime < 0 and self.ComparisonTimer.SuccessColor or ComparisonTime > 0 and self.ComparisonTimer.FailColor or self.ComparisonTimer.EqualColor
        local prefix = ""
        if ComparisonTime then
            if ComparisonTime < 0 then 
                ComparisonTime = ComparisonTime*-1
                prefix = "-"
            elseif ComparisonTime > 0 then
                prefix = "+"
            end
            self:ApplyTextSettings(F.TimerBar.ComparisonTimer, self.ComparisonTimer, string.format("%s%s", prefix, ComparisonTime == 0 and "+-0" or self:FormatTime(ComparisonTime, true)), ComparisonColor)
        end
        if not preview then F.TimerBar:SetStatusBarColor(unpack(self.TimerBar.Color[chest])) end
        self:DisplayTimerElements(chest, true, preview)
    end
    if (not Start) and (not Completion) and ((not self.Last) or self.Last < GetTime()-self.UpdateRate) and (C_ChallengeMode.GetChallengeCompletionInfo().time == 0) and self.started then
        self.last = GetTime()
        if (not self.lasttimer) or self.lasttimer ~= self.timer then
            if not self.cmap then
                local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
                self.cmap = self.cmap or C_ChallengeMode.GetActiveChallengeMapID()
                self.level = level
            end
            self.lasttimer = self.timer
            local timeremain = self.timelimit-self.timer
            F.TimerBar:SetStatusBarColor(unpack(self.TimerBar.Color[chest+1]))
            self:DisplayTimerElements(chest, false, preview)
            return true
        end
    end
end

function MPT:DisplayTimerElements(chest, completion, preview)
    local F = self.Frame
    local displayed = 0
    F.TimerBar:SetValue(self.timer)
    self:ApplyTextSettings(F.TimerBar.TimerText, self.TimerText, string.format("%s/%s", self:FormatTime(self.timer), self:FormatTime(self.timelimit)))
    for i=3, 1, -1 do
        local remTime = self.timelimit-self.timer-((i-1)*self.timelimit*0.2)
        if self.TimerBar.ChestTimerDisplay ~= 3 and self["ChestTimer"..i].enabled and (((chest >= i or (i == 1 and remTime < 0)) and (self.TimerBar.ChestTimerDisplay == 2 or displayed == 0)) or (self.TimerBar.ChestTimerDisplay == 1 and completion and chest+1 >= i and displayed < 2 and not preview)) then
            displayed = displayed +1
            local color = i == 1 and remTime < 0 and self.ChestTimer.BehindColor
            local prefix = ""
            if remTime < 0 then prefix = "+" remTime = remTime*-1 end
            self:ApplyTextSettings(F.TimerBar["ChestTimer"..i], self["ChestTimer"..i], prefix..self:FormatTime(remTime), color, false, i)
        else
            F.TimerBar["ChestTimer"..i]:Hide()
        end
        if i > 1 and self.Ticks.enabled and chest >= i then
            F.TimerBar.Ticks[i-1]:SetColorTexture(unpack(self.Ticks.Color))
            F.TimerBar.Ticks[i-1]:SetWidth(self.Ticks.Width)
            F.TimerBar.Ticks[i-1]:SetHeight(self.TimerBar.Height)
            self:SetPoint(F.TimerBar.Ticks[i-1], "LEFT", F.TimerBar, "LEFT", (i == 2 and self.TimerBar.Width*0.8) or (i == 3 and self.TimerBar.Width*0.6) , 0)
            F.TimerBar.Ticks[i-1]:Show()
        elseif i >= 2 then
            F.TimerBar.Ticks[i-1]:Hide()
        end
    end
end

function MPT:UpdateBosses(Start, count, preview)
    local F = self.Frame
    if preview then
        local killtime = 0
        self:MuteJournalSounds()
        self.BossNames = {}
        for i=1, 5 do
            EJ_SelectInstance(721)
            local name = EJ_GetEncounterInfoByIndex(i, 721)
            name = self:Utf8Sub(name, 20) or "Boss "..i
            killtime = killtime+math.random(240, 420)
            local time = self:FormatTime(killtime, true)
            local frame = F["Bosses"..i]
            self.BossNames[i] = name
            self:SetPoint(frame, "TOPLEFT", F.TimerBar, "TOPLEFT", self.Bosses.xOffset, -self.TimerBar.Height-(i*self.Spacing)-(i-1)*(self.Bosses.Height)+self.Bosses.yOffset)
            frame:SetSize(self.Bosses.Width, self.Bosses.Height)
            local BossColor = i <= 3 and self.BossName.CompletionColor or self.BossName.Color
            self:ApplyTextSettings(frame["BossName"..i], self.BossName, name, BossColor)
            local timercolor = (i == 1 and self.BossTimer.FailColor) or (i == 2 and self.BossTimer.EqualColor) or (i == 3 and self.BossTimer.SuccessColor) or self.BossTimer.Color
            local splitcolor = (i == 1 and self.BossSplit.FailColor) or (i == 2 and self.BossSplit.EqualColor) or (i == 3 and self.BossSplit.SuccessColor) or self.BossSplit.Color
            local splittext = (i == 2 and "+-0") or (i == 1 and "+"..self:FormatTime(math.random(20, 60))) or (i == 3 and "-"..self:FormatTime(math.random(20, 60)))
            self:ApplyTextSettings(frame["BossTimer"..i], self.BossTimer, time, timercolor)
            frame:Show()
            if splittext then self:ApplyTextSettings(frame["BossSplit"..i], self.BossSplit, splittext, splitcolor) end
        end
    elseif Start then
        self.BossTimes = {}
        self.BossNames = {}

        local max = select(3, C_Scenario.GetStepInfo())
        if C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).isWeightedProgress then max = max-1 end -- if last criteria is enemy forces
        self:MuteJournalSounds()
        local mapID = C_Map.GetBestMapForUnit("player")
        local instanceID = (mapID and EJ_GetInstanceForMap(mapID)) or 0
        if instanceID == 0 or instanceID == nil then
            if self.cmap and self.maptoID[self.cmap] then
                instanceID = self.maptoID[self.cmap][1]
            end
        end
        if instanceID and instanceID ~= 0 then
            if not C_AddOns.IsAddOnLoaded("Blizzard_EncounterJournal") then C_AddOns.LoadAddOn("Blizzard_EncounterJournal") end        
            for i=1, 20 do
                local name = EJ_GetEncounterInfoByIndex(i, instanceID)
                if name and name ~= "nil" then
                    self.BossNames[i] = name
                elseif i < select(3, C_Scenario.GetStepInfo()) and not self.opened then
                    EncounterJournal_OpenJournal(23, instanceID) 
                    EJ_SelectInstance(instanceID)
                    self.opened = true
                    HideUIPanel(EncounterJournal)
                    local name = EJ_GetEncounterInfoByIndex(i, instanceID)
                    if name then
                        self.BossNames[i] = name
                    end
                else
                    break
                end
            end
        end
        if count <= 6 then -- check again in 2 seconds a few times to make sure data is correct
            C_Timer.After(2, function()
                    self:UpdateBosses(true, count+1)
            end)
        end 
        if max > 0 then
            if C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).isWeightedProgress then max = max-1 end
            local cmap = self.cmap
            local level = self.level
            local pb = self.BossSplit.enabled and self.BestTime and self.BestTime[cmap] and (self.BestTime[cmap][level] or (self.LowerKey and self.BestTime[cmap][level-1]))
            for i=1, max do
                local num = (cmap == 370 and i+4) or (cmap == 392 and i+5) or (cmap == 227 and i+2) or (cmap == 234 and i+6) or (cmap == 464 and i+4) or i
                local name = self.BossNames[num]
                local criteria = C_ScenarioInfo.GetCriteriaInfo(i)
                for j = 1, #(self.BossNames) do
                    if self.BossNames[j] and string.find(criteria.description, self.BossNames[j]) then
                        name = self.BossNames[j]
                        break
                    end
                end
                if cmap == 227 and num == 3 then name = "Opera Hall" end
                name = self:Utf8Sub(name, self.BossName.MaxLength)
                if name and name ~= "" then      
                    local completed = criteria.completed
                    local defeated = criteria.elapsed
                    local frame = F["Bosses"..i]
                    self:SetPoint(frame, "TOPLEFT", F.TimerBar, "TOPLEFT", self.Bosses.xOffset, -self.TimerBar.Height-(i*self.Spacing)-(i-1)*(self.Bosses.Height)+self.Bosses.yOffset)
                    frame:SetSize(self.Bosses.Width, self.Bosses.Height)
                    local BossColor = completed and self.BossName.CompletionColor or self.BossName.Color
                    self:ApplyTextSettings(frame["BossName"..i], self.BossName, name, BossColor)
                    if not completed then
                        frame["BossTimer"..i]:SetText("")
                        frame["BossSplit"..i]:SetText("")
                    end
                    if completed and defeated and defeated ~= 0 then
                        local timercolor = self.BossTimer.Color
                        local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                        if pb and pb[i] then
                            timercolor = (pb[i] == time and self.BossTimer.EqualColor) or (pb > time and self.BossTimer.SuccessColor) or self.BossTimer.FailColor
                        end
                        self:ApplyTextSettings(frame["BossTimer"..i], self.BossTimer, self:FormatTime(time), timercolor)
                    end
                    if completed and defeated and defeated ~= 0 and pb and pb[i] then
                        local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                        local splitcolor = (pb[i] == time and self.BossSplit.EqualColor) or (pb[i] > time and self.BossSplit.SuccessColor) or self.BossSplit.FailColor
                        local prefix = (pb[i] == time and "+-0") or (pb[i] > time and "-") or "+"
                        local diff = time-pb[i]
                        if diff < 0 then diff = diff*-1 end
                        self:ApplyTextSettings(frame["BossSplit"..i], self.BossSplit, prefix..self:FormatTime(diff), splitcolor)
                    end
                    frame:Show()
                end                
            end
        end        
    else
        local max = select(3, C_Scenario.GetStepInfo())
        if C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).isWeightedProgress then max = max-1 end
        local pb = self.BossSplit.enabled and self.BestTime and self.BestTime[cmap] and (self.BestTime[cmap][level] or (self.LowerKey and self.BestTime[cmap][level-1]))
        for i=1, max do
            local criteria = C_ScenarioInfo.GetCriteriaInfo(i)
            if criteria.completed then
                local defeated = criteria.elapsed
                local frame = F.Bosses[i]                    
                frame["BossName"..i]:SetTextColor(self.BossName.CompletionColor)                
                if defeated and defeated ~= 0 then                        
                    local timercolor = self.BossTimer.Color
                    local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                    if pb and pb[i] then
                        timercolor = (pb[i] == time and self.BossTimer.EqualColor) or (pb[i] > time and self.BossTimer.SuccessColor) or self.BossTimer.FailColor
                    end
                    self:ApplyTextSettings(frame["BossTimer"..i], self.BossTimer, self:FormatTime(time), timercolor)
                end
                if completed and defeated and defeated ~= 0 and pb and pb[i]then
                    local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                    local splitcolor = (pb[i] == time and self.BossSplit.EqualColor) or (pb[i] > time and self.BossSplit.SuccessColor) or self.BossSplit.FailColor
                    local prefix = (pb[i] == time and "+-0") or (pb[i] > time and "-") or "+"
                    local diff = time-pb[i]
                    if diff < 0 then diff = diff*-1 end
                    self:ApplyTextSettings(frame["BossSplit"..i], self.BossSplit, prefix..self:FormatTime(diff), splitcolor)
                end
            end
        end
        return true
    end

end

function MPT:UpdateEnemyForces(Start, preview)
    local F = self.Frame
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
        local bosscount = preview and 5 or #self.BossNames
        self:SetPoint(F.ForcesBar, "TOPLEFT", F["Bosses"..bosscount], "TOPLEFT", self.ForcesBar.xOffset, -self.Bosses.Height-self.Spacing+self.ForcesBar.yOffset)
        F.ForcesBar:SetSize(self.ForcesBar.Width, self.ForcesBar.Height)
        F.ForcesBar:SetStatusBarTexture(self.LSM:Fetch("statusbar", self.ForcesBar.Texture))
        F.ForcesBar:SetBackdropColor(unpack(self.ForcesBar.BackgroundColor))
        F.ForcesBarBorder:ClearAllPoints()
        F.ForcesBarBorder:SetPoint("TOPLEFT", 0, 0)
        F.ForcesBarBorder:SetPoint("BOTTOMRIGHT", 0, 0)
        F.ForcesBarBorder:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = self.ForcesBar.BorderSize
        })
        F.ForcesBarBorder:SetBackdropBorderColor(unpack(self.ForcesBar.BorderColor))
        F.ForcesBar:SetMinMaxValues(0, total)
        F.ForcesBar:SetValue(current)
        local forcesColor =
        (percent < 20 and self.ForcesBar.Color[1]) or
        (percent < 40 and self.ForcesBar.Color[2]) or
        (percent < 60 and self.ForcesBar.Color[3]) or
        (percent < 80 and self.ForcesBar.Color[4]) or
        (percent < 100 and self.ForcesBar.Color[5]) or self.ForcesBar.CompletionColor
        F.ForcesBar:SetStatusBarColor(unpack(forcesColor))
        local remaining = self.RealCount.remaining and total-current or current
        local remainingText = self.RealCount.total and string.format("%s/%s", remaining, total) or remaining
        percent = self.PercentCount.remaining and 100-percent or percent
        self:ApplyTextSettings(F.ForcesBar.PercentCount, self.PercentCount, string.format("%.2f%%", percent))
        self:ApplyTextSettings(F.ForcesBar.RealCount, self.RealCount, remainingText)
        F.ForcesBar:Show()
        if preview then            
            local diff = math.random(-200, 200)
            local color = (diff == 0 and self.ForcesSplits.EqualColor) or (diff < 0 and self.ForcesSplits.SuccessColor) or self.ForcesSplits.FailColor
            local prefix = (diff == 0 and "+-0") or (diff < 0 and "-") or "+"
            if diff < 0 then diff = diff * -1 end
            self:ApplyTextSettings(F.ForcesBar.Splits, self.ForcesSplits, prefix..self:FormatTime(diff), color)
            self:ApplyTextSettings(F.ForcesBar.Completion, self.ForcesCompletion, self:FormatTime(math.random(900, 2000)), self.ForcesCompletion.Color)
        end
    else
        F.ForcesBar:SetValue(current)
        local forcesColor =
        (percent < 20 and self.ForcesBar.Color[1]) or
        (percent < 40 and self.ForcesBar.Color[2]) or
        (percent < 60 and self.ForcesBar.Color[3]) or
        (percent < 80 and self.ForcesBar.Color[4]) or
        (percent < 100 and self.ForcesBar.Color[5]) or self.ForcesBar.CompletionColor
        F.ForcesBar:SetStatusBarColor(unpack(forcesColor))
        if percent >= 100 and not self.done then
            local max = select(3, C_Scenario.GetStepInfo())
            local defeat = C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).elapsed or 0
            local cur = select(2, GetWorldElapsedTime(1)) - defeat
            local cmap = self.cmap
            local level = self.level
            local pb = self.BestTime and self.BestTime[cmap] and (self.BestTime[cmap][level] or (self.LowerKey and self.BestTime[cmap][level-1]))
            if pb and pb["forces"] then
                local diff = cur - pb["forces"]
                local color = (diff == 0 and self.ForcesSplits.EqualColor) or (diff < 0 and self.ForcesSplits.SuccessColor) or self.ForcesSplits.FailColor
                local prefix = (diff == 0 and "+-0") or (diff < 0 and "-") or "+"
                if diff < 0 then diff = diff * -1 end
                self:ApplyTextSettings(F.ForcesBar.Splits, self.ForcesSplits, prefix..self:FormatTime(diff), color)
            end
            self.done = true
        end        
        local remaining = self.RealCount.remaining and total-current or current
        local remainingText = self.RealCount.total and string.format("%s/%s", remaining, total) or remaining
        percent = self.PercentCount.remaining and 100-percent or percent
        self:ApplyTextSettings(F.ForcesBar.PercentCount, self.PercentCount, string.format("%.2f%%", percent))
        self:ApplyTextSettings(F.ForcesBar.RealCount, self.RealCount, remainingText)
        local completionText = criteria.completed and criteria.elapsed or ""
        self:ApplyTextSettings(F.ForcesBar.Completion, self.ForcesCompletion, self:FormatTime(completionText), self.ForcesCompletion.Color)
    end
end