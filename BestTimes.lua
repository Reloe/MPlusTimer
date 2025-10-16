local _, MPT = ...

function MPT:CreateFakeSV()    
    for i=1, 50 do
        local cmap = self.SeasonData[15].Dungeons[math.random(1, 8)]
        local BossNames = {"Big Dragon", "Evil Mage", "Ugly Troll", "Addon Apocalypse", "Kungen"}
        local BossTimes = {math.random(100, 200), math.random(250, 350), math.random(400, 500), math.random(550, 650), math.random(700, 800)}
        local time = math.random(900000, 1300000)
        local forces = math.random(600, 700)
        local level = math.random(10, 20)
        local intime = math.random(1, 5) <= 4
        self:UpdatePB(time, forces, cmap, level, {monthDay = math.random(1,28), month = math.random(1, 12), year = 2025, hour = math.random(0,23), minute = math.random(0,59)}, BossTimes, BossNames, intime)
        if math.random(1, 5) == 1 then
            self:AddHistory(false, cmap, level, false, true)
        end
    end
    self:AddHistory(false, 499, 5, false, true)
end

function MPT:UpdatePB(time, forces, cmap, level, date, BossTimes, BossNames, intime) -- called on completion of a run
    if (not self.seasonID) or self.seasonID == 0 then
        C_MythicPlus.RequestMapInfo()
        self.seasonID = C_MythicPlus.GetCurrentSeason()
        if not self.seasonID or self.seasonID == 0 then return end
    end
    if not MPTSV.BestTime then MPTSV.BestTime = {} end
    if not MPTSV.BestTime[self.seasonID] then MPTSV.BestTime[self.seasonID] = {} end
    if not MPTSV.BestTime[self.seasonID][cmap] then MPTSV.BestTime[self.seasonID][cmap] = {} end
    if not MPTSV.BestTime[self.seasonID][cmap][level] then MPTSV.BestTime[self.seasonID][cmap][level] = {} end
    local before = MPTSV.BestTime[self.seasonID][cmap][level]["finish"]
    if not MPTSV.BestTime[self.seasonID][cmap][level]["finish"] or time < MPTSV.BestTime[self.seasonID][cmap][level]["finish"] then
        MPTSV.BestTime[self.seasonID][cmap][level]["finish"] = time
        MPTSV.BestTime[self.seasonID][cmap][level]["forces"] = forces
        MPTSV.BestTime[self.seasonID][cmap][level]["level"] = level
        MPTSV.BestTime[self.seasonID][cmap][level]["date"] = {date.monthDay, date.month, date.year, date.hour, date.minute}
        if not MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] then MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] = {} end
        for i, v in ipairs(BossTimes or {}) do
            MPTSV.BestTime[self.seasonID][cmap][level][i] = v
            if BossNames[i] then
                MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"][i] = BossNames[i]
            end
        end
    end
    return before
end

function MPT:AddCharacterHistory(tryagain)
    local data = (C_MythicPlus.GetRunHistory(true, true))
    if MPTSV.LastHistoryData == data or data == {} then 
        if tryagain then
            C_Timer.After(10, function() self:AddCharacterHistory(false) end) -- try again in 10 seconds. Data is weird on initial login
        end
        return     
    end
    MPTSV.LastHistoryData = data
    if not data or #data == 0 then return end
    local G = UnitGUID("player")    
    if (not self.seasonID) or self.seasonID == 0 then
        C_MythicPlus.RequestMapInfo()
        self.seasonID = C_MythicPlus.GetCurrentSeason()
        if not self.seasonID or self.seasonID == 0 then return end
    end
    if not MPTSV.History then MPTSV.History = {} end
    if not MPTSV.History[self.seasonID] then MPTSV.History[self.seasonID] = {} end
    if not MPTSV.History[self.seasonID][G] then MPTSV.History[self.seasonID][G] = {name = UnitName("player"), realm = GetNormalizedRealmName(), class = select(2, UnitClass("player"))} end
    for i, v in ipairs(data) do
        if (not MPTSV.History[self.seasonID][G].keys) or (not MPTSV.History[self.seasonID][G].keys[i]) then -- only add this run if it hasn't been added before
            local cmap = v.mapChallengeModeID
            local level = v.level
            local time = v.durationSec
            local intime = v.completed
            if not MPTSV.History[self.seasonID][G][cmap] then MPTSV.History[self.seasonID][G][cmap] = {intime = 0, depleted = 0, highestrun = 0, abandoned = 0} end
            if not MPTSV.History[self.seasonID][G][cmap][level] then MPTSV.History[self.seasonID][G][cmap][level] = {intime = 0, depleted = 0, abandoned = 0} end
            if not MPTSV.History[self.seasonID][G].keys then MPTSV.History[self.seasonID][G].keys = {} end
            MPTSV.History[self.seasonID][G].keys[i] = true
            self:AddHistory(time, cmap, level, intime, false)
        end
    end
end

function MPT:AddHistory(time, cmap, level, intime, abandoned) -- abandoned runs get added manually. Everything else is through API    
    local G = UnitGUID("player")
    if abandoned and level and cmap then
        if not MPTSV.History[self.seasonID] then MPTSV.History[self.seasonID] = {} end
        if not MPTSV.History[self.seasonID][G] then MPTSV.History[self.seasonID][G] = {name = UnitName("player"), realm = GetNormalizedRealmName(), class = select(3, UnitClass("player"))} end
        if not MPTSV.History[self.seasonID][G][cmap] then MPTSV.History[self.seasonID][G][cmap] = {intime = 0, depleted = 0, highestrun = 0, abandoned = 0} end
        if not MPTSV.History[self.seasonID][G][cmap][level] then MPTSV.History[self.seasonID][G][cmap][level] = {intime = 0, depleted = 0, abandoned = 0} end
        MPTSV.History[self.seasonID][G][cmap].abandoned = MPTSV.History[self.seasonID][G][cmap].abandoned + 1
        MPTSV.History[self.seasonID][G][cmap][level].abandoned = MPTSV.History[self.seasonID][G][cmap][level].abandoned + 1
        print('adding abandoned run for', cmap, level)
        return
    end
    if time and not MPTSV.History[self.seasonID][G][cmap].fastestrun then
        MPTSV.History[self.seasonID][G][cmap].fastestrun = time*1000
    end
    if intime then
        MPTSV.History[self.seasonID][G][cmap].intime = MPTSV.History[self.seasonID][G][cmap].intime + 1
        MPTSV.History[self.seasonID][G][cmap][level].intime = MPTSV.History[self.seasonID][G][cmap][level].intime + 1
        if level > MPTSV.History[self.seasonID][G][cmap].highestrun then -- save highest run, which is then also "fastest" run
            MPTSV.History[self.seasonID][G][cmap].highestrun = level
            MPTSV.History[self.seasonID][G][cmap].fastestrun = time*1000
        elseif level == MPTSV.History[self.seasonID][G][cmap].highestrun and time*1000 < MPTSV.History[self.seasonID][G][cmap].fastestrun then
            MPTSV.History[self.seasonID][G][cmap].fastestrun = time*1000 -- save faster run if same level
        end
    else
        MPTSV.History[self.seasonID][G][cmap][level].depleted = MPTSV.History[self.seasonID][G][cmap][level].depleted + 1
        MPTSV.History[self.seasonID][G][cmap].depleted = MPTSV.History[self.seasonID][G][cmap].depleted + 1
    end
end

function MPT:GetPB(cmap, level, seasonID, lowerkey)
    C_MythicPlus.RequestMapInfo()
    local seasonID = seasonID or (self.seasonID and self.seasonID ~= 0 and self.seasonID or C_MythicPlus.GetCurrentSeason())
    return MPTSV.BestTime and MPTSV.BestTime[seasonID] and MPTSV.BestTime[seasonID][cmap] and (MPTSV.BestTime[seasonID][cmap][level] or (lowerkey and MPTSV.BestTime[seasonID][cmap][level-1]))
end

function MPT:AddRun(cmap, level, seasonID, time, forces, date, BossNames, BossTimes) -- called when manually adding a run
    C_MythicPlus.RequestMapInfo()
    for i, v in ipairs(BossTimes) do
        if type(v) == "string" then
            BossTimes[i] = self:StrToTime(v)
        end
    end
    local seasonID = seasonID or (self.seasonID and self.seasonID ~= 0 and self.seasonID or C_MythicPlus.GetCurrentSeason())
    if not MPTSV.BestTime then MPTSV.BestTime = {} end
    if not MPTSV.BestTime[seasonID] then MPTSV.BestTime[seasonID] = {} end
    if not MPTSV.BestTime[seasonID][cmap] then MPTSV.BestTime[seasonID][cmap] = {} end
    if time and forces and BossNames and cmap and level and BossTimes and type(BossTimes) == "table" then
        MPTSV.BestTime[seasonID][cmap][level] = MPTSV.BestTime[seasonID][cmap][level] or {}
        MPTSV.BestTime[seasonID][cmap][level] = BossTimes
        MPTSV.BestTime[seasonID][cmap][level]["BossNames"] = BossNames
        MPTSV.BestTime[seasonID][cmap][level]["finish"] = time*1000
        MPTSV.BestTime[seasonID][cmap][level]["forces"] = forces
        MPTSV.BestTime[seasonID][cmap][level]["date"] = date
        MPTSV.BestTime[seasonID][cmap][level]["level"] = level
    end
end


function MPT:CreateEditPanel()
    local F = self.BestTimeFrame
    if not F then return end
    if not F.RunEditPanel then
        F.RunEditPanel = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.RunEditPanel:SetSize(300, 450)
        F.RunEditPanel:SetPoint("BOTTOMLEFT", F.PBDataFrame, "BOTTOMLEFT", 0, 0)
        F.RunEditPanel:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 2 })
        F.RunEditPanel:SetBackdropBorderColor(0.2, 0.6, 1, 1)
        F.RunEditPanel:Hide()

        -- Dungeon Name
        F.RunEditPanel.DungeonLabel = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel, "TOPLEFT", 20, -20, "Dungeon:")
        F.RunEditPanel.DungeonDropdown = CreateFrame("Frame", nil, F.RunEditPanel, "UIDropDownMenuTemplate")
        F.RunEditPanel.DungeonDropdown:SetPoint("TOPLEFT", F.RunEditPanel.DungeonLabel, "BOTTOMLEFT", -20, -2)

        -- Level EditBox
        F.RunEditPanel.LevelLabel = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.DungeonDropdown, "BOTTOMLEFT", 20, -10, "Level:")
        F.RunEditPanel.LevelEdit = self:CreateEditBox(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.LevelLabel, "BOTTOMLEFT", 5, -2, 60, 20)
        F.RunEditPanel.LevelEdit:SetNumeric(true)

        -- Completion Time EditBox
        F.RunEditPanel.CompletionLabel = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.LevelEdit, "BOTTOMLEFT", -5, -10, "Completion Time:")
        F.RunEditPanel.CompletionEdit = self:CreateEditBox(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.CompletionLabel, "BOTTOMLEFT", 5, -2, 80, 20)

        -- Enemy Forces Time EditBox
        F.RunEditPanel.ForcesLabel = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.CompletionEdit, "BOTTOMLEFT", -5, -10, "Enemy Forces Time:")
        F.RunEditPanel.ForcesEdit = self:CreateEditBox(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.ForcesLabel, "BOTTOMLEFT", 5, -2, 80, 20)

        -- Bosses
        F.RunEditPanel.BossLabels = {}
        F.RunEditPanel.BossEdits = {}
        F.RunEditPanel.BossTimeLabels = {}
        F.RunEditPanel.BossTimeEdits = {}
        for i = 1, 5 do
            local yOffset = -10 - ((i-1)*38)
            F.RunEditPanel.BossLabels[i] = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.ForcesEdit, "BOTTOMLEFT", -5, yOffset, "Boss "..i.." Name:")
            F.RunEditPanel.BossEdits[i] = self:CreateEditBox(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.BossLabels[i], "BOTTOMLEFT", 5, -2, 120, 20)
            F.RunEditPanel.BossTimeEdits[i] = self:CreateEditBox(F.RunEditPanel, "LEFT", F.RunEditPanel.BossEdits[i], "RIGHT", 10, 0, 60, 20)
            F.RunEditPanel.BossTimeLabels[i] = self:CreateLabel(F.RunEditPanel, "BOTTOMLEFT", F.RunEditPanel.BossTimeEdits[i], "TOPLEFT", -5, 0, "Time:")
        end

        -- Save Button
        F.RunEditPanel.SaveButton = self:CreateButton(80, 28, F.RunEditPanel, true, false, {0.15, 0.5, 0.2, 0.9}, {}, "Expressway", 13, {1, 1, 1, 1}, "Save")
        F.RunEditPanel.SaveButton:SetPoint("BOTTOMLEFT", F.RunEditPanel, "BOTTOMLEFT", 20, 10)
        F.RunEditPanel.SaveButton:SetScript("OnClick", function()
            local BossNames = {}
            local BossTimes = {}
            for i = 1, 5 do
                local name = F.RunEditPanel.BossEdits[i]:GetText()
                local bosstime = F.RunEditPanel.BossTimeEdits[i]:GetText()
                if bosstime and bosstime ~= "" then
                    BossNames[i] = name and name ~= "" and name or (bosstime and bosstime ~= "" and "Boss "..i) or nil -- add placeholder bossname if it's not given
                    BossTimes[i] = bosstime and bosstime ~= "" and self:StrToTime(bosstime) or nil                
                    if not BossTimes[i] then
                        print("Invalid time format for Boss "..i..". For Timers you are expected to supply a string in the format mm:ss")
                        return
                    end
                end
            end
            local time = self:StrToTime(F.RunEditPanel.CompletionEdit:GetText())
            local forces = self:StrToTime(F.RunEditPanel.ForcesEdit:GetText())
            local level = F.RunEditPanel.LevelEdit:GetNumber()
            if (not time) or (not forces) then
                print("Invalid time format. For Timers you are expected to supply a string in the format mm:ss")
                return 
            end
            if level == 0 or next(BossTimes) == nil then
                print("You must fill in at least Level, Completion Time, Enemy Forces Time and one Boss Timer.")
                return 
            end
            time = time
            self:AddRun(UIDropDownMenu_GetSelectedValue(F.RunEditPanel.DungeonDropdown), level,
                nil, time, forces, {},
                BossNames, BossTimes)
            F.RunEditPanel:Hide()
            self:ShowLevelFrames(self.SelectedDungeon, self.SelectedSeason)
        end)

        -- Cancel Button
        F.RunEditPanel.CancelButton = self:CreateButton(80, 28, F.RunEditPanel, true, false, {0.5, 0.15, 0.15, 0.9}, {}, "Expressway", 13, {1, 1, 1, 1}, "Cancel")
        F.RunEditPanel.CancelButton:SetPoint("LEFT", F.RunEditPanel.SaveButton, "RIGHT", 10, 0)
        F.RunEditPanel.CancelButton:SetScript("OnClick", function()
            F.RunEditPanel:Hide()
        end)
        
        F.RunEditPanel:EnableKeyboard(false)
        self:EnableEditBoxKeyboard(F.RunEditPanel.LevelEdit)
        self:EnableEditBoxKeyboard(F.RunEditPanel.CompletionEdit)
        self:EnableEditBoxKeyboard(F.RunEditPanel.ForcesEdit)
        for i = 1, 5 do
            self:EnableEditBoxKeyboard(F.RunEditPanel.BossEdits[i])
            self:EnableEditBoxKeyboard(F.RunEditPanel.BossTimeEdits[i])
        end
    end
end

function MPT:ShowEditPanel(seasonID, cmap)
    local F = self.BestTimeFrame
    if not F or not F.RunEditPanel then return end    
    F.RunEditPanel:Show()
    local dungeons = {}
    for i, cmap in ipairs(self.SeasonData[seasonID].Dungeons) do
        table.insert(dungeons, {cmap = cmap, name = self:GetDungeonName(cmap)})
    end
    UIDropDownMenu_Initialize(F.RunEditPanel.DungeonDropdown, function(self, level, menuList)
        for i, name in ipairs(dungeons) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = name.name
            info.arg1 = name.cmap
            info.value = name.cmap
            info.func = function(data, arg1)
                UIDropDownMenu_SetSelectedValue(F.RunEditPanel.DungeonDropdown, data.arg1)
            end
            info.checked = (name.cmap == UIDropDownMenu_GetSelectedValue(F.RunEditPanel.DungeonDropdown))
            UIDropDownMenu_AddButton(info)
        end
    end)
    UIDropDownMenu_SetSelectedValue(F.RunEditPanel.DungeonDropdown, cmap)
    local pb = self:GetPB(cmap, self.SelectedLevel, seasonID)
    if pb then
        for i, name in ipairs(pb.BossNames or {}) do
            F.RunEditPanel.BossEdits[i]:SetText(name)
        end
        for i, time in ipairs(pb) do
            F.RunEditPanel.BossTimeEdits[i]:SetText(self:FormatTime(time))
        end
        local level = pb.level or 0
        local completionTime = pb.finish and self:FormatTime(pb.finish/1000) or ""
        local forcesTime = pb.forces and self:FormatTime(pb.forces) or ""
        F.RunEditPanel.LevelEdit:SetText(level)
        F.RunEditPanel.CompletionEdit:SetText(completionTime)
        F.RunEditPanel.ForcesEdit:SetText(forcesTime)
    else
        for i = 1, 5 do
            F.RunEditPanel.BossEdits[i]:SetText("")
            F.RunEditPanel.BossTimeEdits[i]:SetText("")
        end
        F.RunEditPanel.LevelEdit:SetText("")
        F.RunEditPanel.CompletionEdit:SetText("")
        F.RunEditPanel.ForcesEdit:SetText("")
    end
end

function MPT:EnableEditBoxKeyboard(editbox)
    -- Only enable keyboard input when focused to allow movement
    editbox:SetAutoFocus(false)
    editbox:SetScript("OnEditFocusGained", function(self)
        self:EnableKeyboard(true)
    end)
    editbox:SetScript("OnEditFocusLost", function(self)
        self:EnableKeyboard(false)
    end)
end

function MPT:CreatePBFrame()       
        
    if not self.PBInfoFrame then
        -- Main Frame
        self.BestTimeFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        local F = self.BestTimeFrame
        local width = 1200
        local height = 700
        F:SetSize(width, height)
        local screenWidth = UIParent:GetWidth()
        local screenHeight = UIParent:GetHeight()
        local x = (screenWidth - width) / 2
        local y = (screenHeight - height) / 2
        F:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, -y)
        F:SetFrameStrata("HIGH")
        F:EnableMouse(true)
        F:SetMovable(true)
        F:SetClampedToScreen(true)
        F:RegisterForDrag("LeftButton")
        F:SetScript("OnDragStart", function(self)
            self:StartMoving()
        end)
        F:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local scale = self:GetScale() or 1
            local x = self:GetLeft()
            local y = (UIParent:GetTop() - (self:GetTop() * scale)) / scale
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, -y)
        end)
        self.SelectedSeasonButton = nil
        self.SelectedDungeonButton = nil
        self.SelectedLevelButton = nil

        F:SetResizable(true)
        F.Handle = CreateFrame("Button", nil, F)
        F.Handle:SetSize(20, 20)
        F.Handle:SetPoint("BOTTOMRIGHT", F, "BOTTOMRIGHT", -2, 2)
        F.Handle:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        F.Handle:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        F.Handle:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        F.Handle:SetFrameStrata("TOOLTIP")
        F.Handle:EnableMouse(true)
        F.Handle:RegisterForDrag("LeftButton")
        local minWidth, minHeight = 800, 500
        local maxWidth, maxHeight = 1600, 1200
        local initialWidth, initialHeight, initialX, initialY
        local dragging = false
        F.Handle:SetScript("OnDragStart", function(self)
            initialWidth, initialHeight = F:GetWidth(), F:GetHeight()
            local cursorX, cursorY = GetCursorPosition()
            initialX, initialY = cursorX / UIParent:GetScale(), cursorY / UIParent:GetScale()
            dragging = true
            self:SetScript("OnUpdate", function()
                if dragging then
                    local cursorX, cursorY = GetCursorPosition()
                    cursorX, cursorY = cursorX / UIParent:GetScale(), cursorY / UIParent:GetScale()
                    local dx = cursorX - initialX
                    local dy = cursorY - initialY
                    local newWidth = math.max(minWidth, math.min(maxWidth, initialWidth + dx))
                    local newHeight = math.max(minHeight, math.min(maxHeight, initialHeight - dy))
                    F:SetSize(newWidth, newHeight)
                    MPTSV.PBFrameWidth = newWidth
                    MPTSV.PBFrameHeight = newHeight
                    if F.SeasonButtonFrame then F.SeasonButtonFrame:SetWidth(newWidth) end
                    if F.DungeonButtonFrame then F.DungeonButtonFrame:SetHeight(newHeight - (F.SeasonButtonFrame and F.SeasonButtonFrame:GetHeight() or 40)) end
                    if F.LevelButtonFrame then F.LevelButtonFrame:SetHeight(newHeight - (F.SeasonButtonFrame and F.SeasonButtonFrame:GetHeight() or 40)) end
                    if F.PBDataFrame then F.PBDataFrame:SetSize(newWidth - (F.DungeonButtonFrame and F.DungeonButtonFrame:GetWidth() or 160) - (F.LevelButtonFrame and F.LevelButtonFrame:GetWidth() or 135), newHeight - (F.SeasonButtonFrame and F.SeasonButtonFrame:GetHeight() or 40)) end
                    if F.LevelContent then F.LevelContent:SetHeight(newHeight - (F.SeasonButtonFrame and F.SeasonButtonFrame:GetHeight() or 40)) end
                    if F.PBDataText2 then F.PBDataText2:SetWidth(F.PBDataFrame:GetWidth()-155) end
                end
            end)
        end)
        F.Handle:SetScript("OnDragStop", function(self)
            dragging = false
            self:SetScript("OnUpdate", nil)
        end)

        -- Close Button
        F.CloseButton = CreateFrame("Button", nil, F, "UIPanelCloseButton")
        F.CloseButton:SetSize(24, 24)
        F.CloseButton:SetPoint("TOPRIGHT", F, "TOPRIGHT", -8, -8)
        F.CloseButton:SetScript("OnClick", function()
            F:Hide()
        end)

        -- Background
        F.BG = F:CreateTexture(nil, "BACKGROUND")
        F.BG:SetAllPoints(F)
        F.BG:SetColorTexture(0, 0, 0, 0.7)

        -- Background Border
        F.BGBorder = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.BGBorder:SetAllPoints(F)
        F.BGBorder:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8", 
            edgeSize = 2,
        })
        F.BGBorder:SetBackdropBorderColor(0.2, 0.6, 1, 1)

        -- Season Buttons
        local seasonheight = 40
        F.SeasonButtonFrame = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.SeasonButtonFrame:SetSize(width, seasonheight)
        F.SeasonButtonFrame:SetPoint("TOPLEFT", F, "TOPLEFT", 0, 0)
        F.SeasonButtons = {}
        F.SeasonButtonFrame:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        F.SeasonButtonFrame:SetBackdropBorderColor(0.2, 0.6, 1, 1)

        -- Dungeon Buttons
        local dungeonwidth = 160
        F.DungeonButtonFrame = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.DungeonButtonFrame:SetSize(dungeonwidth, height-seasonheight)
        F.DungeonButtonFrame:SetPoint("TOPLEFT", F.SeasonButtonFrame, "BOTTOMLEFT", 0, 0)
        F.DungeonButtons = {}
        F.DungeonButtonFrame:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        F.DungeonButtonFrame:SetBackdropBorderColor(0.2, 0.6, 1, 1)


        -- Level Buttons
        local levelwidth = 135
        F.LevelButtonFrame = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.LevelButtonFrame:SetSize(levelwidth, height-seasonheight)
        F.LevelButtonFrame:SetPoint("TOPLEFT", F.DungeonButtonFrame, "TOPRIGHT", 0, 0)
        F.LevelButtons = {}
        F.LevelButtonFrame:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        F.LevelButtonFrame:SetBackdropBorderColor(0.2, 0.6, 1, 1)

        -- Level Scroll Frame
        F.LevelScrollFrame = CreateFrame("ScrollFrame", nil, F.LevelButtonFrame, "UIPanelScrollFrameTemplate")
        F.LevelScrollFrame:SetPoint("TOPLEFT", F.LevelButtonFrame, "TOPLEFT", 0, -5)
        F.LevelScrollFrame:SetPoint("BOTTOMRIGHT", F.LevelButtonFrame, "BOTTOMRIGHT", -27, 5)

        F.LevelContent = CreateFrame("Frame", nil, F.LevelScrollFrame)
        F.LevelContent:SetSize(levelwidth, 1)
        F.LevelScrollFrame:SetScrollChild(F.LevelContent)


        -- PB Frame
        F.PBDataFrame = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.PBDataFrame:SetSize(width-dungeonwidth-levelwidth, height-seasonheight)
        F.PBDataFrame:SetPoint("TOPLEFT", F.LevelButtonFrame, "TOPRIGHT", 0, 0)
        F.PBDataFrame:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        F.PBDataFrame:SetBackdropBorderColor(0.2, 0.6, 1, 1)

        -- Delete Button
        F.DeleteButton = CreateFrame("Button", nil, F.PBDataFrame)
        F.DeleteButton:SetSize(100, 32)
        F.DeleteButton:SetPoint("TOPRIGHT", F.PBDataFrame, "TOPRIGHT", -20, -20)
        F.DeleteButton.BG = F.DeleteButton:CreateTexture(nil, "BACKGROUND")
        F.DeleteButton.BG:SetAllPoints()
        F.DeleteButton.BG:SetColorTexture(0.45, 0.10, 0.10, 0.9)
        F.DeleteButton.Text = F.DeleteButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        F.DeleteButton.Text:SetPoint("CENTER", F.DeleteButton, "CENTER", 0, 0)
        F.DeleteButton.Text:SetFont(self.LSM:Fetch("font", "Expressway"), 14, "OUTLINE")
        F.DeleteButton.Text:SetTextColor(1, 1, 1, 1)
        F.DeleteButton:Hide()
        self:AddMouseoverTooltip(F.DeleteButton, "Delete the selected run from your saved best times. This does not delete it from the Total Stats. It is simply for comparison purposes.")

        F.TotalStatsButton = self:CreateButton(140, 40, F, true, false, {1, 1, 0.3, 0.7}, {}, "Expressway", 13, {1, 1, 1, 1}, "Show Stats")
        F.TotalStatsButton:SetPoint("BOTTOM", F.DungeonButtonFrame, "BOTTOM", 0, 10)
        F.TotalStatsButton:SetScript("OnClick", function()
            if self.SelectedLevelButton then
                self.SelectedLevelButton.Border:Hide()
            end
            self.SelectedLevel = nil
            self:ShowCharacterFrames(self.SelectedSeason)
        end)
        self:AddMouseoverTooltip(F.TotalStatsButton, "Show your Stats for the selected Season")
                
        -- Scale Slider
        F.ScaleSlider = CreateFrame("Slider", nil, F, "OptionsSliderTemplate")
        F.ScaleSlider:SetMinMaxValues(0.5, 2)
        F.ScaleSlider:SetValueStep(0.05)
        F.ScaleSlider:SetValue(1)
        F.ScaleSlider:SetWidth(200)
        F.ScaleSlider:SetPoint("BOTTOMRIGHT", F, "BOTTOMRIGHT", -20, 20)
        F.ScaleSlider.Text = F.ScaleSlider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        F.ScaleSlider.Text:SetPoint("TOP", F.ScaleSlider, "BOTTOM", 0, -2)
        F.ScaleSlider.Text:SetText("Frame Scale")
        F.ScaleSlider:SetScript("OnMouseUp", function(self)
            F:SetScale(self:GetValue())
        end)

        self:CreateEditPanel()
    end
end

function MPT:HidePBButtons()
    local F = self.BestTimeFrame
    if not F then return end
    for k, v in pairs(F.SeasonButtons or {}) do
        v:Hide()
    end
    for k, v in pairs(F.DungeonButtons or {}) do
        v:Hide()
    end
    for k, v in pairs(F.LevelButtons or {}) do
        v:Hide()
    end
    if F.PBDataText then
        F.PBDataText:Hide()
    end
    if F.PBDataText2 then
        F.PBDataText2:Hide()
    end
    if F.DeleteButton then
        F.DeleteButton:Hide()
    end
    if F.RunEditPanel then
        F.RunEditPanel:Hide()
    end
end

function MPT:ShowPBFrame()
    if self.BestTimeFrame then
        if self.BestTimeFrame:IsShown() then
            self.BestTimeFrame:Hide()
            return
        end
    else
        self:CreatePBFrame()
    end    
    self:HidePBButtons()
    self.BestTimeFrame:Show()
    self:ShowSeasonFrames()
end

function MPT:ShowSeasonFrames() -- Showing Frame & Season Buttons
    local F = self.BestTimeFrame
    if not F then return end
    local first = true
    local last = 0
    self.SelectedSeason = self.seasonID
    self.SelectedDungeon = nil
    self.SelectedLevel = nil
    for k, v in pairs(F.SeasonButtons or {}) do
        v.Border:Hide()
        v:Hide()
    end
    for k, v in pairs(F.DungeonButtons or {}) do
        v.Border:Hide()
        v:Hide()
    end
    for k, v in pairs(F.LevelButtons or {}) do
        v.Border:Hide()
        v:Hide()
    end
    for i = 50, 1, -1 do
        if MPTSV.BestTime and MPTSV.BestTime[i] then
            local parent = first and F.SeasonButtonFrame or F.SeasonButtons[last]
            local btn = F.SeasonButtons[i]
            if not btn then
                btn = self:CreateButton(130, 25, parent, true, true, {0.3, 0.3, 0.3, 0.9}, {0.2, 0.6, 1, 0.5}, "Expressway", 13, {1, 1, 1, 1})
                F.SeasonButtons[i] = btn
            end
            btn = F.SeasonButtons[i]
            btn:SetPoint("LEFT", parent, "LEFT", first and 10 or 140, 0)
            btn.Text:SetText(self.SeasonData[i].name)
            btn:Show()
            btn:SetScript("OnClick", function()
                if self.SelectedSeasonButton then
                    self.SelectedSeasonButton.Border:Hide()
                end                
                if self.SelectedDungeonButton then
                    self.SelectedDungeonButton.Border:Hide()
                end
                if self.SelectedLevelButton then
                    self.SelectedLevelButton.Border:Hide()
                end       
                if F.PBDataText then F.PBDataText:Hide() end
                if F.PBDataText2 then F.PBDataText2:Hide() end
                if F.DeleteButton then F.DeleteButton:Hide() end
                for k, v in pairs(F.LevelButtons or {}) do
                    v:Hide()
                end
                self.SelectedSeasonButton = btn  
                self.SelectedSeason = i       
                self.SelectedDungeon = nil
                self.SelectedLevel = nil
                self:ShowDungeonFrames(i)
                btn.Border:Show()
            end)
            if self.SelectedSeasonButton ~= btn then
                btn.Border:Hide()
            end
            first = false
            last = i
        end
    end
    F:Show()
    if F.SeasonButtons[self.seasonID] then
        self.SelectedSeasonButton = F.SeasonButtons[self.seasonID]
        F.SeasonButtons[self.seasonID].Border:Show()
    end
    self:ShowDungeonFrames(self.seasonID) -- Select Current Season when initially loaded
end

function MPT:ShowDungeonFrames(seasonID) -- Showing Dungeon Buttons
    local F = self.BestTimeFrame
    if not F then return end
    if F and seasonID then
        local num = 1
        for k, v in pairs(F.DungeonButtons or {}) do
            v.Border:Hide()
            v:Hide()
        end
        for k, v in pairs(F.LevelButtons or {}) do
            v.Border:Hide()
            v:Hide()
        end        
        if not MPTSV.BestTime then MPTSV.BestTime = {} end
        for i, cmap in pairs(self.SeasonData[seasonID].Dungeons) do
            local parent = num == 1 and F.DungeonButtonFrame or F.DungeonButtons[num-1]
            local name = self:GetDungeonName(cmap)
            local btn = F.DungeonButtons[num]
            if not btn then
                btn = self:CreateButton(140, 40, parent, true, true, {0.3, 0.3, 0.3, 0.9}, {0.2, 0.6, 1, 0.5}, "Expressway", 15, {1, 1, 1, 1})
                F.DungeonButtons[num] = btn
            end
            btn:SetPoint("TOP", parent, "TOP", 0, num == 1 and -10 or -50)
            btn:SetScript("OnClick", function()
                if self.SelectedDungeonButton then
                    self.SelectedDungeonButton.Border:Hide()
                end
                if self.SelectedLevelButton then
                    self.SelectedLevelButton.Border:Hide()
                end
                if F.PBDataText then F.PBDataText:Hide() end
                if F.PBDataText2 then F.PBDataText2:Hide() end
                if F.DeleteButton then F.DeleteButton:Hide() end
                self.SelectedDungeonButton = btn
                self.SelectedDungeon = cmap
                self.SelectedLevel = nil
                self:ShowLevelFrames(cmap, seasonID)
                btn.Border:Show()
            end)
            if self.SelectedDungeonButton ~= btn then
                btn.Border:Hide()
            end
            btn.Text:SetText(name)
            btn:Show()
            num = num+1
        end        
    end
end


function MPT:ShowLevelFrames(cmap, seasonID) -- Showing Level Buttons
    local F = self.BestTimeFrame
    if not F then return end
    local num = 1
    for k, v in pairs(F.LevelButtons or {}) do
        v.Border:Hide()
        v:Hide()
    end
    if F.PBDataText then F.PBDataText:Hide() end
    if F.PBDataText2 then F.PBDataText2:Hide() end
    if F.DeleteButton then F.DeleteButton:Hide() end
    if self.SelectedLevelButton then
        self.SelectedLevelButton.Border:Hide()
    end
    self.SelectedLevel = nil
    local first = true
    for level = 100, 1, -1 do
        local pb = self:GetPB(cmap, level, seasonID)
        if pb or level == 100 then
            local btn = F.LevelButtons[num]
            local color = level == 100 and {0, 0.7, 0, 0.9} or {0.3, 0.3, 0.3, 0.9}
            if not btn then
                btn = self:CreateButton(90, 40, F.LevelContent, true, true, color, {0.2, 0.6, 1, 0.5}, "Expressway", 16, {1, 1, 1, 1})
                F.LevelButtons[num] = btn
            end
            btn:SetPoint("TOP", F.LevelContent, "TOP", 0, num == 1 and -5 or ((num-1)*-45)-5)
            btn.BG:SetColorTexture(unpack(color))
            if level ~= 100 then
                btn:SetScript("OnClick", function()
                    if self.SelectedLevelButton then
                        self.SelectedLevelButton.Border:Hide()
                    end
                    self.SelectedLevelButton = btn
                    self.SelectedLevel = level
                    self:ShowPBDataFrame(seasonID, cmap, level)
                    btn.Border:Show()
                end)
                if first then
                    first = false
                    if self.SelectedLevelButton then
                        self.SelectedLevelButton.Border:Hide()
                    end
                    self.SelectedLevelButton = btn
                    self.SelectedLevel = level
                    self:ShowPBDataFrame(seasonID, cmap, level)
                    btn.Border:Show()
                end 
                btn.Text:SetText(level)
            else
                btn:SetScript("OnClick", function()
                    self:ShowEditPanel(seasonID, cmap)
                end)
                btn.Text:SetText("+ Add Run")
            end
            btn:Show()
            num = num+1
        end
    end
    F.LevelContent:SetHeight(num*50)
end

function MPT:ShowPBDataFrame(seasonID, cmap, level) -- Showing PB Data
    local F = self.BestTimeFrame
    if not F then return end
    if F.PBDataFrame then
        local pbdata = self:GetPB(cmap, level, seasonID)
        local text = ""
        F.DeleteButton:Hide()
        local history = MPTSV.History and MPTSV.History[seasonID]
        local completedruns = 0
        local depletedruns = 0
        local abandonedruns = 0
        --if not MPTSV.History[self.seasonID][G][cmap][level] then MPTSV.History[self.seasonID][G][cmap][level] = {intime = 0, depleted = 0, abandoned = 0} end
        for G, charHistory in pairs(history or {}) do
            for lvl, data in pairs(charHistory[cmap] or {}) do
                if lvl == level and data and type(data) == "table" and (data.intime > 0 or data.depleted > 0) then
                    completedruns = completedruns + data.intime
                    depletedruns = depletedruns + data.depleted
                    abandonedruns = abandonedruns + data.abandoned
                end
            end
        end
        if pbdata and pbdata.finish then
            text = string.format("Dungeon: %s\nTime: %s\n", self:GetDungeonName(cmap), self:FormatTime(pbdata.finish/1000))
            for i=1, #(pbdata["BossNames"] or {}) do
                if pbdata["BossNames"] and pbdata["BossNames"][i] and pbdata[i] then
                    text = text..string.format("%s: %s\n", pbdata["BossNames"][i] or "Unknown", self:FormatTime(pbdata[i]))
                end
            end
            local date = self:GetDateFormat(pbdata.date)
            if date == "" then date = "No Date - Imported or manually Added Run" else date = "Date: "..date end
            text = text..string.format("Enemy Forces: %s\n%s\n", self:FormatTime(pbdata.forces), date)            
            if F.PBDataText2 then
                F.PBDataText2:Hide()
            end
            F.DeleteButton:Show()
            self:AddMouseoverTooltip(F.DeleteButton, "Delete the currently selected run from your saved best times.\nIt does not remove it from your total run history.")
            F.DeleteButton.Text:SetText("Delete Run")
            F.DeleteButton:SetScript("OnClick", function()
                if not self.SelectedSeason or not self.SelectedDungeon or not self.SelectedLevel then return end
                if MPTSV.BestTime and MPTSV.BestTime[self.SelectedSeason] and MPTSV.BestTime[self.SelectedSeason][self.SelectedDungeon] and MPTSV.BestTime[self.SelectedSeason][self.SelectedDungeon][self.SelectedLevel] then
                    MPTSV.BestTime[self.SelectedSeason][self.SelectedDungeon][self.SelectedLevel] = nil
                    if next(MPTSV.BestTime[self.SelectedSeason][self.SelectedDungeon]) == nil then
                        if next(MPTSV.BestTime[self.SelectedSeason]) == nil then
                            MPTSV.BestTime[self.SelectedSeason] = nil
                            self:ShowSeasonFrames()
                        else
                            self:ShowLevelFrames(self.SelectedDungeon, self.SelectedSeason)
                        end
                    else
                        self:ShowLevelFrames(self.SelectedDungeon, self.SelectedSeason)
                    end
                end
            end)
        end     
        if completedruns > 0 or depletedruns > 0 or abandonedruns > 0 then
            local runtext = completedruns + depletedruns == 1 and "Run" or "Runs"
            text = text..string.format("Total: |cFFFFFF4D%s|r %s (|cFF00FF00%s|r Intime, |cFFFF0000%s|r Depleted, |cFFFFAA00%s|r Abandoned)", completedruns + depletedruns, runtext, completedruns, depletedruns, abandonedruns)
        end
        if text ~= "" then
            if not F.PBDataText then
                F.PBDataText = F.PBDataFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                F.PBDataText:SetPoint("TOPLEFT", F.PBDataFrame, "TOPLEFT", 5, -10)
            end
            F.PBDataText:SetText(text)
            F.PBDataText:SetJustifyH("LEFT")
            F.PBDataText:SetFont(self.LSM:Fetch("font", "Expressway"), 20, "OUTLINE")
            F.PBDataText:SetTextColor(1, 1, 1, 1)
            F.PBDataText:Show()
        end
    end
end

function MPT:ShowTotalStatsFrame(seasonID, characteronly, GUID)
    local F = self.BestTimeFrame
    if not F then return end
    if F.PBDataFrame then
        local G = GUID or UnitGUID("player")
        local history = MPTSV.History and MPTSV.History[seasonID]
        local completedruns = {}
        local depletedruns = {}
        local abandonedruns = {}
        local highestkey = {}
        local fastestrun = {}
        local totalcompletedkeys = 0
        local totaldepletedkeys = 0
        local totalabandoned = 0
        local text = ""
        local text2 = ""
        F.DeleteButton:Hide()
        if not history then return end
        if characteronly then
            history = history[G]
            if not history then return end
            for i, cmap in pairs(self.SeasonData[seasonID].Dungeons) do
                local data = history[cmap]
                if data and (data.intime > 0 or data.depleted > 0) then
                    local name = self:Utf8Sub(self:GetDungeonName(cmap), 1, 15)
                    text = text..string.format("|cFF3399FF%s|r:\n", name)
                    local runtext = data.intime + data.depleted == 1 and "Run" or "Runs"
                    text2 = text2..string.format("|cFFFFFF4D%s|r %s (|cFF00FF00%s|r Intime, |cFFFF0000%s|r Depleted, |cFFFFAA00%s|r Abandoned)",
                    data.intime + data.depleted, runtext, data.intime, data.depleted, data.abandoned)
                    local bestkey = data.fastestrun and self:FormatTime(data.fastestrun/1000)
                    if bestkey then
                        text2 = text2..string.format(", Best Key: |cFF00FF00+%s|r in |cFFFFFF4D%s|r\n", data.highestrun, bestkey)
                    else
                        text2 = text2.."\n"
                    end
                    totalcompletedkeys = totalcompletedkeys + data.intime
                    totaldepletedkeys = totaldepletedkeys + data.depleted
                    totalabandoned = totalabandoned + data.abandoned
                end
            end    
            
            F.DeleteButton.Text:SetText("Delete Character")
            F.DeleteButton:SetScript("OnClick", function()
                if not self.SelectedSeason or not self.SelectedCharacter then return end
                if MPTSV.History and MPTSV.History[self.SelectedSeason] and MPTSV.History[self.SelectedSeason][self.SelectedCharacter] then
                    MPTSV.History[self.SelectedSeason][self.SelectedCharacter] = nil
                        if next(MPTSV.History[self.SelectedSeason]) == nil then
                            MPTSV.History[self.SelectedSeason] = nil
                            F.PBDataFrame:Hide()
                            self:ShowSeasonFrames()
                        else
                            self:ShowCharacterFrames(self.SelectedSeason)
                        end
                    end
                end)
            F.DeleteButton:Show()
            self:AddMouseoverTooltip(F.DeleteButton, "Delete the selected character from your saved history.\nThis does not delete their runs from your saved best times.\nKeep in mind that these will be added again when you log into that character\nDeletion is meant for characters that no longer exist or have been transferred")
        else
            for i, cmap in pairs(self.SeasonData[seasonID].Dungeons) do
                for G, charHistory in pairs(history or {}) do
                    local data = charHistory[cmap]
                    if data and (data.intime > 0 or data.depleted > 0) then
                        completedruns[cmap] = (completedruns[cmap] or 0) + data.intime
                        depletedruns[cmap] = (depletedruns[cmap] or 0) + data.depleted
                        abandonedruns[cmap] = (abandonedruns[cmap] or 0) + data.abandoned
                        if data.highestrun and (not highestkey[cmap] or data.highestrun > highestkey[cmap]) then
                            highestkey[cmap] = data.highestrun
                            fastestrun[cmap] = data.fastestrun
                        elseif data.highestrun and data.highestrun == highestkey[cmap] and data.fastestrun and (not fastestrun[cmap] or data.fastestrun < fastestrun[cmap]) then
                            fastestrun[cmap] = data.fastestrun
                        end
                        totalcompletedkeys = totalcompletedkeys + data.intime
                        totaldepletedkeys = totaldepletedkeys + data.depleted
                        totalabandoned = totalabandoned + data.abandoned
                    end
                end                
                local name = self:Utf8Sub(self:GetDungeonName(cmap), 1, 15)
                local completed = completedruns[cmap] or 0
                local depleted = depletedruns[cmap] or 0
                local abandoned = abandonedruns[cmap] or 0
                text = text..string.format("|cFF3399FF%s|r:\n", name)
                local runtext = completed + depleted == 1 and "Run" or "Runs"
                text2 = text2..string.format("|cFFFFFF4D%s|r %s (|cFF00FF00%s|r Intime, |cFFFF0000%s|r Depleted, |cFFFFAA00%s|r Abandoned)",
                completed + depleted, runtext, completed, depleted, abandoned)
                local bestkey = fastestrun[cmap] and self:FormatTime(fastestrun[cmap]/1000)
                if bestkey then
                    text2 = text2..string.format(", Best Key: |cFF00FF00+%s|r in |cFFFFFF4D%s|r\n", highestkey[cmap], bestkey)
                else
                    text2 = text2.."\n"
                end
            end
        end        
        text = string.format("Total Run Stats: |cFFFFFF4D%s|r Runs (|cFF00FF00%s|r Intime, |cFFFF0000%s|r Depleted, |cFFFFAA00%s|r Abandoned)\n", totalcompletedkeys+totaldepletedkeys, totalcompletedkeys, totaldepletedkeys, totalabandoned)..text
        if not F.PBDataText then
            F.PBDataText = F.PBDataFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            F.PBDataText:SetPoint("TOPLEFT", F.PBDataFrame, "TOPLEFT", 5, -10)
        end
        if not F.PBDataText2 then
            F.PBDataText2 = F.PBDataFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            F.PBDataText2:SetPoint("TOPLEFT", F.PBDataFrame, "TOPLEFT", 155, -30)
        end
        F.PBDataText:SetText(text)
        F.PBDataText:Show()
        F.PBDataText:SetJustifyH("LEFT")
        F.PBDataText:SetFont(self.LSM:Fetch("font", "Expressway"), 20, "OUTLINE")
        F.PBDataText:SetTextColor(1, 1, 1, 1)
        F.PBDataText2:SetText(text2)
        F.PBDataText2:Show()
        F.PBDataText2:SetJustifyH("LEFT")
        F.PBDataText2:SetFont(self.LSM:Fetch("font", "Expressway"), 20, "OUTLINE")
        F.PBDataText2:SetTextColor(1, 1, 1, 1)
        F.PBDataText2:SetWordWrap(true)
        F.PBDataText2:SetNonSpaceWrap(true)
        F.PBDataText2:SetWidth(F.PBDataFrame:GetWidth()-155)
        F.RunEditPanel:Hide()
    end
end

function MPT:ShowCharacterFrames(seasonID)
    local F = self.BestTimeFrame
    if not F then return end
    local num = 1
    for k, v in pairs(F.LevelButtons or {}) do
        v.Border:Hide()
        v:Hide()
    end
    if F.PBDataText then F.PBDataText:Hide() end
    if F.PBDataText2 then F.PBDataText2:Hide() end
    if F.DeleteButton then F.DeleteButton:Hide() end
    if self.SelectedLevelButton then
        self.SelectedLevelButton.Border:Hide()
    end
    self.SelectedLevel = nil
    local first = true
    local history = MPTSV.History and MPTSV.History[seasonID]
    if history then
        num = self:AddCharacterButton({name = "Total"}, num, seasonID, nil, {r = 0, g = 0.7, b = 0, a = 0.9}) -- Total Stats Button
        local GUID = UnitGUID("player")
        num = self:AddCharacterButton(history[GUID], num, seasonID, GUID)
        self.SelectedCharacter = GUID
        for G, data in pairs(history or {}) do
            if not (G == GUID) then
                num = self:AddCharacterButton(data, num, seasonID, G)
            end
        end
    end
    F.LevelContent:SetHeight(num*50)
end

function MPT:AddCharacterButton(data, num, seasonID, G, color)
    local F = self.BestTimeFrame
    local btn = F.LevelButtons[num]
    if not data then return num end
    if not btn then
        btn = self:CreateButton(90, 40, F.LevelContent, true, true, {0.3, 0.3, 0.3, 0.9}, {0.2, 0.6, 1, 0.5}, "Expressway", 16, {1, 1, 1, 1})
        F.LevelButtons[num] = btn
    end
    btn:SetPoint("TOP", F.LevelContent, "TOP", 0, num == 1 and -5 or ((num-1)*-45)-5)
    local color = color or self:GetClassColor(data.class)
    btn.BG:SetColorTexture(color.r, color.g, color.b, color.a)
    btn.colors = color
    btn:SetScript("OnClick", function()
        if self.SelectedLevelButton then
            self.SelectedLevelButton.Border:Hide()
            local color = self.SelectedLevelButton.colors
            self.SelectedLevelButton.BG:SetColorTexture(color.r, color.g, color.b, color.a)
        end
        self.SelectedLevelButton = btn
        self.SelectedCharacter = G
        self:ShowTotalStatsFrame(seasonID, G, G)
        btn.Border:Show()
        btn.BG:SetColorTexture(0.3, 0.3, 0.3, 0.9)
    end)        
    local text = data.name
    if data.realm and data.realm ~= GetNormalizedRealmName() then
        text = text.."\n"..data.realm
    end
    btn.Text:SetText(text)
    btn:Show()
    if G and G == UnitGUID("player") then
        self.SelectedLevelButton = btn
        self:ShowTotalStatsFrame(seasonID, true, G)
        btn.Border:Show()
        btn.BG:SetColorTexture(0.3, 0.3, 0.3, 0.9)
    end
    num = num+1  
    return num   
end