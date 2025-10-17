local _, MPT = ...
local LSM = LibStub("LibSharedMedia-3.0")

function MPT:HideBossFrames()
    local F = self.Frame
    for i=1, 20 do
        local frame = F["Bosses"..i]
        if frame then
            frame:Hide()
            frame["BossName"..i]:SetText("")
            frame["BossTimer"..i]:SetText("")
            frame["BossSplit"..i]:SetText("")
        end
    end
end

function MPT:Init(preview)
    self:SetKeyInfo(true)
    self.opened = false
    self.done = false
    self.IsPreview = preview   
    self.PreviousMaxBossFrame = 0 
    self:CreateStates(preview)
end

function MPT:SetKeyInfo(init)
    if init or (not self.cmap) or (not self.level) or (not self.affixes) or self.level == 0 or self.affixes == {} then
        self.cmap = C_ChallengeMode.GetActiveChallengeMapID()
        self.level, self.affixes = C_ChallengeMode.GetActiveKeystoneInfo()
    end
end

function MPT:UpdateAllStates(preview)
    self:UpdateMainFrame()        
    self:UpdateBosses(true, (not preview) and 1, preview)       
    self:UpdateKeyInfo(true, false, preview)
    self:UpdateTimerBar(true, false, preview)
    self:UpdateEnemyForces(true, preview)
    self:UpdatePBInfo(preview)
    self:UpdateMainFrame(true)
    self:MoveFrame(preview)
    self:ShowFrame(true)
end

function MPT:CreateStates(preview)
    if self.Frame then self.Frame:Hide() end
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
            self:CreateBossFrame(i)
        end

        -- Enemy Forces
        self:CreateStatusBar(F, "ForcesBar", true, true)
        self:CreateText(F.ForcesBar, "PercentCount", self.PercentCount)
        self:CreateText(F.ForcesBar, "Splits", self.ForcesSplits)
        self:CreateText(F.ForcesBar, "RealCount", self.RealCount)
        self:CreateText(F.ForcesBar, "Completion", self.ForcesCompletion)

        self:CreateStatusBar(F.ForcesBar, "CurrentPullBar", false, false)

        -- PB Info
        self:CreateText(F.ForcesBar, "PBInfo", self.PBInfo)
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
   self:UpdateAllStates(preview)
end


function MPT:UpdateMainFrame(BackgroundOnly)
    local F = self.Frame
    -- Main Frame     
    if BackgroundOnly then    
        local spacing = self.Spacing*(self.MaxBossFrame-1)
        if self.KeyInfo.AnchoredTo ~= "MainFrame" then spacing = spacing+self.Spacing end
        if self.TimerBar.AnchoredTo ~= "MainFrame" then spacing = spacing+self.Spacing end
        if self.ForcesBar.AnchoredTo ~= "MainFrame" then spacing = spacing+self.Spacing end
        if self.Bosses.AnchoredTo ~= "MainFrame" then spacing = spacing+self.Spacing end
        local size = self.TimerBar.Height+self.ForcesBar.Height+self.KeyInfo.Height+(self.Bosses.Height*self.MaxBossFrame)+spacing
        F:SetSize(self.TimerBar.Width, size)
        F:SetFrameStrata(self.FrameStrata)
        if self.Background.enabled then
            local w, h = F:GetWidth(), F:GetHeight()
            F.BG:SetSize(w+(self.Background.WidthOffset), h+(self.Background.HeightOffset))
            self:SetPoint(F.BG, "TOPLEFT", F, "TOPLEFT", self.Background.xOffset, self.Background.yOffset)
            F.BG:SetColorTexture(unpack(self.Background.Color))  
            F.BGBorder:SetFrameLevel(F.KeyInfo:GetFrameLevel()+1)
            F.BGBorder:SetAllPoints(F.BG)
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
        local maxSize = self.TimerBar.Height+self.ForcesBar.Height+self.KeyInfo.Height+(self.Bosses.Height*5)+(self.Spacing*7)
        F:SetSize(self.TimerBar.Width, maxSize)
        F:SetScale(self.Scale)
        F:SetFrameStrata(self.FrameStrata)
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
    if Full then
        local AffixDisplay = ""
        local deathcount = (preview and "20") or C_ChallengeMode.GetDeathCount()
        if preview then            
            for i=1, 4 do
                AffixDisplay = AffixDisplay.."\124T"..select(i, strsplit(" ", "236401 1035055 451169 1385910"))..":"..self.AffixIcons.FontSize..":"..self.AffixIcons.FontSize..":"..1-i..":0:64:64:6:60:6:60\124t"
            end 
        else
            local icon = ""
            for _, v in pairs(self.affixes) do
                if icon == "" then
                    icon = select(3, C_ChallengeMode.GetAffixInfo(v))
                else
                    icon = icon.." "..select(3, C_ChallengeMode.GetAffixInfo(v))
                end
            end
            for i=1, 4 do
                if select(i, strsplit(" ", icon)) then
                    AffixDisplay = AffixDisplay.."\124T"..select(i, strsplit(" ", icon))..":"..self.AffixIcons.FontSize..":"..self.AffixIcons.FontSize..":"..1-i..":0:64:64:6:60:6:60\124t"
                end
            end
        end        
        local parent = (self.KeyInfo.AnchoredTo == "MainFrame" and F) or (self.KeyInfo.AnchoredTo == "Bosses" and F["Bosses"..self.MaxBossFrame]) or F[self.KeyInfo.AnchoredTo]
        local spacing = parent == F and 0 or self.Spacing
        self:SetPoint(F.KeyInfo, self.KeyInfo.Anchor, parent, self.KeyInfo.RelativeTo, self.KeyInfo.xOffset, -spacing+self.KeyInfo.yOffset)
        F.KeyInfo:SetSize(self.KeyInfo.Width, self.KeyInfo.Height)
        self:ApplyTextSettings(F.KeyInfo.KeyLevel, self.KeyLevel, preview and "+30" or "+"..self.level)
        self:ApplyTextSettings(F.KeyInfo.DungeonName, self.DungeonName, preview and "Halls of Valor" or self:GetDungeonName(self.cmap), false, F.KeyInfo)
        self:ApplyTextSettings(F.KeyInfo.AffixIcons, self.AffixIcons, AffixDisplay, false, F.KeyInfo)
        if self.DeathCounter.enabled then
            self:ApplyTextSettings(F.KeyInfo.DeathCounter , self.DeathCounter, deathcount, false, F.KeyInfo) 
        else
            F.KeyInfo.DeathCounter:Hide() 
        end
        if self.DeathCounter.Iconenabled then
            local icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"
            self:SetPoint(F.KeyInfo.Icon, self.DeathCounter.IconAnchor, F.KeyInfo, self.DeathCounter.IconRelativeTo, self.DeathCounter.IconxOffset, self.DeathCounter.IconyOffset)
            F.KeyInfo.Icon:SetSize(self.KeyInfo.Height, self.KeyInfo.Height)
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
        else
            F.KeyInfo.Icon:Hide()
        end
    end
    if Deaths then
        F.KeyInfo.DeathCounter:SetText(C_ChallengeMode.GetDeathCount())
    end
end

function MPT:UpdateTimerBar(Start, Completion, preview)
    local F = self.Frame
    local time = C_ChallengeMode.GetChallengeCompletionInfo().time
    local now = GetTime()
    self.timer = preview and math.random(900, 2000) or select(2, GetWorldElapsedTime(1))
    self.timelimit = preview and 2280 or self.timelimit or 0
    local chest = (C_ChallengeMode.GetChallengeCompletionInfo().onTime and C_ChallengeMode.GetChallengeCompletionInfo().keystoneUpgradeLevels)
        or (self.timer >= self.timelimit and 0)
        or (self.timer >= self.timelimit*0.8 and 1)
        or (self.timer >= self.timelimit*0.6 and 2)
        or 3
    if Start or preview then
        if time == 0 then
            self.started = true
            if (self.cmap and self.cmap ~= 0) or preview then
                self.timelimit = preview and 2280 or select(3, C_ChallengeMode.GetMapUIInfo(self.cmap))
                local timeremain = self.timelimit-self.timer
                local parent = (self.TimerBar.AnchoredTo == "MainFrame" and F) or (self.TimerBar.AnchoredTo == "Bosses" and F["Bosses"..self.MaxBossFrame]) or F[self.TimerBar.AnchoredTo]
                local spacing = parent == F and 0 or self.Spacing
                self:SetPoint(F.TimerBar, self.TimerBar.Anchor, parent, self.TimerBar.RelativeTo, self.TimerBar.xOffset, -spacing+self.TimerBar.yOffset)
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
        -- add pb
        local before = false
        local date = C_DateAndTime.GetCurrentCalendarTime()
        if (self.cmap and self.level) and not preview then
            before = self:UpdatePB(time, self.forcesTime, self.cmap, self.level, date, self.BossTimes, self.BossNames)
        end
        self.timer = preview and self.timer or time/1000
        local diff = before and (time-before)/1000        
        if not preview then F.TimerBar:SetStatusBarColor(unpack(self.TimerBar.Color[chest+1])) end
        self:DisplayTimerElements(chest, true, preview, diff)
    end
    if (not Start) and (not Completion) and ((not self.Last) or self.Last < now-self.UpdateRate) and (time == 0) and self.started then
        self.last = now
        if (not self.lasttimer) or self.lasttimer ~= self.timer then
            self:SetKeyInfo()
            self.lasttimer = self.timer
            local timeremain = self.timelimit-self.timer
            F.TimerBar:SetStatusBarColor(unpack(self.TimerBar.Color[chest+1]))
            self:DisplayTimerElements(chest, false, preview)
            return true
        end
    end
end
    
function MPT:DisplayTimerElements(chest, completion, preview, diff)
    local F = self.Frame
    local displayed = 0
    F.TimerBar:SetValue(self.timer)
    local timertext = self:FormatTime(math.floor(self.timer))
    if completion and self.TimerText.Decimals > 0 then
        local timeMS  = self.timer and select(2, strsplit(".", (self.timer)))
        timeMS = timeMS and (".%s"):format(string.sub(timeMS, 1, self.TimerText.Decimals))
        timertext = timeMS and ("%s%s"):format(timertext, timeMS) or timertext
    end
    local upgrades = completion and C_ChallengeMode.GetChallengeCompletionInfo().keystoneUpgradeLevels or 0
    local timercolor = (completion and (C_ChallengeMode.GetChallengeCompletionInfo().onTime and self.TimerText.SuccessColor or self.TimerText.FailColor)) or self.TimerText.Color
    self:ApplyTextSettings(F.TimerBar.TimerText, self.TimerText, string.format("%s/%s", timertext, self:FormatTime(self.timelimit)))
    if diff or preview then
        local ComparisonTime = preview and math.random(-200, 200) or diff or 0 -- math.random(-200, 200)
        local ComparisonColor = (ComparisonTime < 0 and self.ComparisonTimer.SuccessColor) or (ComparisonTime > 0 and self.ComparisonTimer.FailColor) or self.ComparisonTimer.EqualColor
        local prefix = ""
        if ComparisonTime < 0 then 
            ComparisonTime = ComparisonTime*-1
            prefix = "-"
        elseif ComparisonTime > 0 then
            prefix = "+"
        end
        self:ApplyTextSettings(F.TimerBar.ComparisonTimer, self.ComparisonTimer, string.format("%s%s", prefix, ComparisonTime == 0 and "+-0" or self:FormatTime(ComparisonTime, true)), ComparisonColor)
    else
        F.TimerBar.ComparisonTimer:Hide()
    end
    for i=3, 1, -1 do
        local remTime = self.timelimit-self.timer-((i-1)*self.timelimit*0.2)
        if self.TimerBar.ChestTimerDisplay ~= 3 and self["ChestTimer"..i].enabled and (((chest >= i or (i == 1 and remTime < 0)) and (self.TimerBar.ChestTimerDisplay == 2 or displayed == 0)) or (self.TimerBar.ChestTimerDisplay == 1 and completion and chest+1 >= i and displayed < 2 and chest ~= 3 and not preview)) then
            displayed = displayed +1
            local color = i == 1 and remTime < 0 and self["ChestTimer"..i].BehindColor
            local prefix = ""
            if remTime < 0 then prefix = "+" remTime = remTime*-1 end
            if completion then
                color = upgrades < i and self["ChestTimer"..i].BehindColor or self["ChestTimer"..i].AheadColor
                prefix = upgrades < i and "+" or "-"
            end
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
        self.MaxBossFrame = 5
        self:HideBossFrames()
        for i=1, 5 do
            EJ_SelectInstance(721)
            local name = EJ_GetEncounterInfoByIndex(i, 721)
            name = self:Utf8Sub(name, 1, 20) or "Boss "..i
            killtime = killtime+math.random(240, 420)
            local time = self:FormatTime(killtime, true)
            local frame = self:CreateBossFrame(i)
            self.BossNames[i] = name
            local parent = self.Bosses.AnchoredTo == "MainFrame" and F or F[self.Bosses.AnchoredTo]
            local spacing = parent == F and i == 1 and 0 or self.Spacing -- only use spacing if not anchored to main frame or not first boss
            self:SetPoint(frame, self.Bosses.Anchor, parent, self.Bosses.RelativeTo, self.Bosses.xOffset, -(i*spacing)-(i-1)*(self.Bosses.Height)+self.Bosses.yOffset)
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
    elseif Start and not self.IsPreview then
        self:SetKeyInfo()
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
        self:HideBossFrames()
        self.MaxBossFrame = 0
        if max > 0 then
            if C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).isWeightedProgress then max = max-1 end
            local pb = self.BossSplit.enabled and self:GetPB(self.cmap, self.level, self.seasonID, self.LowerKey)
            local pb2 = self.BossTimer.enabled and self:GetPB(self.cmap, self.level, self.seasonID, self.LowerKey)
            for i=1, max do
                local num = (self.cmap == 370 and i+4) or (self.cmap == 392 and i+5) or (self.cmap == 227 and i+2) or (self.cmap == 234 and i+6) or (self.cmap == 464 and i+4) or i
                local name = self.BossNames[num]
                local criteria = C_ScenarioInfo.GetCriteriaInfo(i)
                for j = 1, #(self.BossNames) do
                    if self.BossNames[j] and string.find(criteria.description, self.BossNames[j]) then
                        name = self.BossNames[j]
                        break
                    end
                end
                if self.cmap == 227 and num == 3 then name = "Opera Hall" end       
                if name and name ~= "" then   
                    name = self:Utf8Sub(name, 1, self.BossName.MaxLength)     
                    self.MaxBossFrame = i       
                    local completed = criteria.completed
                    local defeated = criteria.elapsed
                    local frame = self:CreateBossFrame(i)
                    local parent = self.Bosses.AnchoredTo == "MainFrame" and F or F[self.Bosses.AnchoredTo]
                    local spacing = parent == F and 0 or self.Spacing
                    self:SetPoint(frame, self.Bosses.Anchor, parent, self.Bosses.RelativeTo, self.Bosses.xOffset, -(i*spacing)-(i-1)*(self.Bosses.Height)+self.Bosses.yOffset)
                    frame:SetSize(self.Bosses.Width, self.Bosses.Height)
                    local BossColor = completed and self.BossName.CompletionColor or self.BossName.Color
                    self:ApplyTextSettings(frame["BossName"..i], self.BossName, name, BossColor)
                    if not completed then
                        frame["BossTimer"..i]:SetText("")
                        frame["BossSplit"..i]:SetText("")
                    end
                    if pb2 and pb2[i] then
                        local time = completed and select(2, GetWorldElapsedTime(1))-defeated or pb2[i]
                        local timercolor = completed and ((pb2[i] == time and self.BossTimer.EqualColor) or (pb2[i] > time and self.BossTimer.SuccessColor) or self.BossTimer.FailColor) or self.BossTimer.Color
                        self:ApplyTextSettings(frame["BossTimer"..i], self.BossTimer, self:FormatTime(time), timercolor)
                    end
                    if completed and defeated and pb and pb[i] then
                        local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                        local splitcolor = (pb[i] == time and self.BossSplit.EqualColor) or (pb[i] > time and self.BossSplit.SuccessColor) or self.BossSplit.FailColor
                        local prefix = (pb[i] == time and "+-0") or (pb[i] > time and "-") or "+"
                        local diff = time-pb[i]
                        if diff < 0 then diff = diff*-1 end
                        self:ApplyTextSettings(frame["BossSplit"..i], self.BossSplit, prefix..self:FormatTime(diff), splitcolor)
                    else
                        frame["BossSplit"..i]:SetText("")
                    end
                    frame:Show()
                end                
            end
            if self.MaxBossFrame > self.PreviousMaxBossFrame then -- re-anchor other elements if they are anchored to Bosses
                if self.KeyInfo.AnchoredTo == "Bosses" then self:UpdateKeyInfo(true, true) end
                if self.TimerBar.AnchoredTo == "Bosses" then self:UpdateTimerBar(true) end
                if self.ForcesBar.AnchoredTo == "Bosses" then self:UpdateEnemyForces(true) end
            end
            self.PreviousMaxBossFrame = self.MaxBossFrame
            if self.MaxBossFrame == 0 then 
                local frame = F["Bosses"..1] -- if somehow we don't have any boss frame, we force show one to prevent errors
                frame:Show()
                self.MaxBossFrame = 1 
            end
        end        
    elseif not self.IsPreview then
        self.BossTimes = self.BossTimes or {}
        local max = select(3, C_Scenario.GetStepInfo())
        if C_ScenarioInfo.GetCriteriaInfo(max) and C_ScenarioInfo.GetCriteriaInfo(max).isWeightedProgress then max = max-1 end
        local pb = self.BossSplit.enabled and self:GetPB(self.cmap, self.level, self.seasonID, self.LowerKey)
        for i=1, max do
            local criteria = C_ScenarioInfo.GetCriteriaInfo(i)
            if criteria.completed then
                local frame = self:CreateBossFrame(i)
                local defeated = criteria.elapsed
                frame["BossName"..i]:SetTextColor(unpack(self.BossName.CompletionColor))          
                local timercolor = self.BossTimer.Color
                local time = self.BossTimes[i] or select(2, GetWorldElapsedTime(1))-defeated
                self.BossTimes[i] = time
                if pb and pb[i] then
                    timercolor = (pb[i] == time and self.BossTimer.EqualColor) or (pb[i] > time and self.BossTimer.SuccessColor) or self.BossTimer.FailColor
                end
                self:ApplyTextSettings(frame["BossTimer"..i], self.BossTimer, self:FormatTime(time), timercolor)
                if defeated and pb and pb[i] then
                    local time = select(2, GetWorldElapsedTime(1))-defeated or 0
                    local splitcolor = (pb[i] == time and self.BossSplit.EqualColor) or (pb[i] > time and self.BossSplit.SuccessColor) or self.BossSplit.FailColor
                    local prefix = (pb[i] == time and "+-0") or (pb[i] > time and "-") or "+"
                    local diff = time-pb[i]
                    if diff < 0 then diff = diff*-1 end
                    self:ApplyTextSettings(frame["BossSplit"..i], self.BossSplit, prefix..self:FormatTime(diff), splitcolor)
                end
            end
        end
    end
end

function MPT:UpdateEnemyForces(Start, preview, completion)
    local F = self.Frame
    local steps = preview and 5 or select(3, C_Scenario.GetStepInfo())
    if not steps or steps <= 0 then
        return
    end
    local criteria = preview and {} or C_ScenarioInfo.GetCriteriaInfo(steps)
    local total = preview and 550 or criteria.totalQuantity
    self.totalcount = total
    local current = preview and math.random(100, 450) or criteria.quantityString:gsub("%%", "")
    current = tonumber(current)
    local percent = 0
    if current then
        percent = current / total * 100
    end
    if Start or preview then
        local parent = (self.ForcesBar.AnchoredTo == "MainFrame" and F) or (self.ForcesBar.AnchoredTo == "Bosses" and F["Bosses"..self.MaxBossFrame]) or F[self.ForcesBar.AnchoredTo]
        local spacing = parent == F and 0 or self.Spacing
        self:SetPoint(F.ForcesBar, self.ForcesBar.Anchor, parent, self.ForcesBar.RelativeTo, self.ForcesBar.xOffset, -spacing+self.ForcesBar.yOffset)
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
        local completed = percent >= 100
        local remaining = self.RealCount.remaining and total-current or current
        local remainingText = self.RealCount.total and string.format("%s/%s", remaining, total) or remaining
        local percentText = self.PercentCount.remaining and 100-percent or percent
        local currentPull = preview and math.random(50, 120) or 0 -- edit this to whatever new API blizzard hopefully comes up with
        local currentPullPercent = preview and (currentPull/total)*100 or 0 -- edit this to whatever new API blizzard hopefully comes up with
        if not completed then -- protection because I anticipate blizzard's current pull API might still return data if we're already at 100%
            local prefix = self.RealCount.remaining and "-" or "+"
            remainingText = self.RealCount.pullcount and currentPull and currentPull > 0 and string.format("%s (%s%s)", remainingText, prefix, currentPull) or remainingText
            local percentprefix = self.PercentCount.remaining and "-" or "+"
            percentText = self.PercentCount.pullcount and currentPullPercent and currentPullPercent > 0 and string.format("%.2f%% (%s%.2f%%)", percentText, percentprefix, currentPullPercent) or string.format("%.2f%%", percentText)
        end
        self:ApplyTextSettings(F.ForcesBar.PercentCount, self.PercentCount, percentText)
        self:ApplyTextSettings(F.ForcesBar.RealCount, self.RealCount, remainingText)
        F.ForcesBar:Show()
        if self.CurrentPullBar.enabled and currentPull and currentPull > 0 and currentPullPercent and currentPullPercent > 0 and current < total then
            local xOffset = (F.ForcesBar:GetValue()/total)*F.ForcesBar:GetWidth()        
            F.ForcesBar.CurrentPullBar:SetSize(self.ForcesBar.Width-xOffset, self.ForcesBar.Height)
            F.ForcesBar.CurrentPullBar:ClearAllPoints()    
            self:SetPoint(F.ForcesBar.CurrentPullBar, "LEFT", F.ForcesBar, "LEFT", xOffset, 0)
            F.ForcesBar.CurrentPullBar:SetStatusBarTexture(self.LSM:Fetch("statusbar", self.CurrentPullBar.Texture))
            F.ForcesBar.CurrentPullBar:SetMinMaxValues(0, total-current) -- set max to remaining forces
            F.ForcesBar.CurrentPullBar:SetValue(currentPull)
            F.ForcesBar.CurrentPullBar:SetStatusBarColor(unpack(self.CurrentPullBar.Color))
            F.ForcesBar.CurrentPullBar:SetFrameLevel(F.ForcesBar:GetFrameLevel())
            F.ForcesBar.CurrentPullBar:Show()
        else
            F.ForcesBar.CurrentPullBar:Hide()
        end
        if preview then            
            local diff = math.random(-200, 200)
            local color = (diff == 0 and self.ForcesSplits.EqualColor) or (diff < 0 and self.ForcesSplits.SuccessColor) or self.ForcesSplits.FailColor
            local prefix = (diff == 0 and "+-0") or (diff < 0 and "-") or "+"
            if diff < 0 then diff = diff * -1 end
            self:ApplyTextSettings(F.ForcesBar.Splits, self.ForcesSplits, prefix..self:FormatTime(diff), color)
            self:ApplyTextSettings(F.ForcesBar.Completion, self.ForcesCompletion, self:FormatTime(math.random(900, 2000)), self.ForcesCompletion.Color)
        else
            F.ForcesBar.Splits:Hide()
            F.ForcesBar.Completion:Hide()
        end
    else
        percent = completion and 100 or percent
        count = completion and total or count
        local forcesColor =
        (percent < 20 and self.ForcesBar.Color[1]) or
        (percent < 40 and self.ForcesBar.Color[2]) or
        (percent < 60 and self.ForcesBar.Color[3]) or
        (percent < 80 and self.ForcesBar.Color[4]) or
        (percent < 100 and self.ForcesBar.Color[5]) or self.ForcesBar.CompletionColor
        if percent >= 100 then
            if not self.done then
                local defeated = C_ScenarioInfo.GetCriteriaInfo(steps) and C_ScenarioInfo.GetCriteriaInfo(steps).elapsed or 0
                if defeated then
                    local cur = select(2, GetWorldElapsedTime(1)) - defeated
                    self.forcesTime = cur
                    local pb = self.ForcesSplit.enabled and self:GetPB(self.cmap, self.level, self.seasonID, self.LowerKey)
                    if pb and pb["forces"] then
                        local diff = cur - pb["forces"]
                        local color = (diff == 0 and self.ForcesSplits.EqualColor) or (diff < 0 and self.ForcesSplits.SuccessColor) or self.ForcesSplits.FailColor
                        local prefix = (diff == 0 and "+-0") or (diff < 0 and "-") or "+"
                        if diff < 0 then diff = diff * -1 end
                        self:ApplyTextSettings(F.ForcesBar.Splits, self.ForcesSplits, prefix..self:FormatTime(diff), color)
                    end
                    self.done = true
                    local completionText = defeated and self:FormatTime(defeated) or ""
                    self:ApplyTextSettings(F.ForcesBar.Completion, self.ForcesCompletion, completionText, self.ForcesCompletion.Color)  
                end
            end   
            F.ForcesBar:SetStatusBarColor(unpack(forcesColor))
            F.ForcesBar:SetMinMaxValues(0, 1)
            F.ForcesBar:SetValue(1)          
            F.ForcesBar.PercentCount:Hide()
            F.ForcesBar.RealCount:Hide()
            F.ForcesBar.CurrentPullBar:Hide()
            self:ApplyTextSettings(F.ForcesBar.PercentCount, self.PercentCount, "")
            self:ApplyTextSettings(F.ForcesBar.RealCount, self.RealCount, "")
        elseif not self.done then
            local remaining = self.RealCount.remaining and total-current or current
            local remainingText = self.RealCount.total and string.format("%s/%s", remaining, total) or remaining
            percent = self.PercentCount.remaining and 100-percent or percent
            F.ForcesBar:SetStatusBarColor(unpack(forcesColor))
            F.ForcesBar:SetMinMaxValues(0, total)
            F.ForcesBar:SetValue(current)
            self:ApplyTextSettings(F.ForcesBar.PercentCount, self.PercentCount, string.format("%.2f%%", percent))
            self:ApplyTextSettings(F.ForcesBar.RealCount, self.RealCount, remainingText)
            self:UpdateCurrentPull()
        end
    end
end

function MPT:UpdatePBInfo(preview)
    local pb = self:GetPB(self.cmap, self.level, self.seasonID, self.LowerKey)
    local F = self.Frame
    F.ForcesBar.PBInfo:Hide()
    if preview or (pb and pb.finish) then
        local finishtime = preview and math.random(1500000, 2000000) or pb.finish
        local date = self:GetDateFormat(preview and {11, 10, 2025, 17, 30} or pb.date)
        text = string.format("PB: +%s %s %s", preview and 29 or self.level, self:FormatTime(finishtime/1000), date)
        local parent = (self.PBInfo.AnchoredTo == "MainFrame" and F) or (self.PBInfo.AnchoredTo == "Bosses" and F["Bosses"..self.MaxBossFrame]) or F[self.PBInfo.AnchoredTo]
        self:ApplyTextSettings(F.ForcesBar.PBInfo, self.PBInfo, text, false, parent)
    end
end

function MPT:UpdateCurrentPull()
    local rawValue, percentValue = 0, 0
    for _, value in pairs(self.CurrentPull or {}) do
        if value ~= "DEAD" then
            rawValue = rawValue + value[1]
            percentValue = percentValue + value[2]
        end
    end
    local steps = preview and 5 or select(3, C_Scenario.GetStepInfo())
    if not steps or steps <= 0 then
        return
    end
    local criteria = C_ScenarioInfo.GetCriteriaInfo(steps)
    local total = criteria.totalQuantity
    local current = criteria.quantityString:gsub("%%", "")
    current = tonumber(current)
    local percent = 0
    if current then
        percent = current / total * 100
    end
    local currentPercent = (current/total)*100
    local F = self.Frame
    local currentText = ""
    local percentText = ""
    if self.RealCount.enabled and self.RealCount.pullcount and current < total then
        local color = current + rawValue >= total and self.RealCount.CurrentPullColor or self.RealCount.Color
        if self.RealCount.total then
            currentText = self.RealCount.remaining and string.format("%s/%s", total-current, total) or string.format("%s/%s", current, total)
        else
            currentText = self.RealCount.remaining and total-current or current
        end
        if self.RealCount.AfterPull then
            if self.RealCount.remaining then
                rawValue = rawValue * -1
            end
            currentText = rawValue ~= 0 and string.format("%s(%s)", currentText, current+rawValue) or currentText
        else
            currentText = rawValue ~= 0 and string.format("%s(%s%s)", currentText, self.RealCount.remaining and "-" or "+", rawValue) or currentText
        end
        
        self:ApplyTextSettings(F.ForcesBar.RealCount, self.RealCount, currentText, color)
    end
    if self.PercentCount.enabled and self.PercentCount.pullcount and current < total then
        local color = current + rawValue >= total and self.PercentCount.CurrentPullColor or self.PercentCount.Color
        percentText = string.format("%.2f%%", self.PercentCount.remaining and 100-percent or percent)
        if self.PercentCount.AfterPull then
            if self.PercentCount.remaining then
                percentValue = percentValue * -1
            end
            percentText = percentValue ~= 0 and string.format("%s(%.2f%%)", percentText, percent+percentValue) or percentText
        else
            percentText = percentValue ~= 0 and string.format("%s(%s%.2f%%)", percentText, self.PercentCount.remaining and "-" or "+", percentValue) or percentText
        end
        self:ApplyTextSettings(F.ForcesBar.PercentCount, self.PercentCount, percentText, color)
    end
    if self.CurrentPullBar.enabled and rawValue and rawValue > 0 and percentValue and percentValue > 0 and current < total then
            local xOffset = (F.ForcesBar:GetValue()/total)*F.ForcesBar:GetWidth()        
            F.ForcesBar.CurrentPullBar:SetSize(self.ForcesBar.Width-xOffset, self.ForcesBar.Height)
            F.ForcesBar.CurrentPullBar:ClearAllPoints()    
            self:SetPoint(F.ForcesBar.CurrentPullBar, "LEFT", F.ForcesBar, "LEFT", xOffset, 0)
            F.ForcesBar.CurrentPullBar:SetStatusBarTexture(self.LSM:Fetch("statusbar", self.CurrentPullBar.Texture))
            F.ForcesBar.CurrentPullBar:SetMinMaxValues(0, total-current) -- set max to remaining forces
            F.ForcesBar.CurrentPullBar:SetValue(rawValue)
            F.ForcesBar.CurrentPullBar:SetStatusBarColor(unpack(self.CurrentPullBar.Color))
            F.ForcesBar.CurrentPullBar:SetFrameLevel(F.ForcesBar:GetFrameLevel())
            F.ForcesBar.CurrentPullBar:Show()
    else
        F.ForcesBar.CurrentPullBar:Hide()
    end
end