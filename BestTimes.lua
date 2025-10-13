local _, MPT = ...

function MPT:CreateFakeSV()
    MPTSV.BestTime[15] = {
        [499] = {
            [16] = {
                finish = 1150000,
                forces = 1150,
                level = 16,
                date = {20, 5, 2024, 12, 15},
                [1] = 250,
                [2] = 500,
                [3] = 750,
                [4] = 1000,
                BossNames = {"Alpha", "Beta", "Gamma", "Delta"},
            },
            [17] = {
                finish = 1100000,
                forces = 1100,
                level = 17,
                date = {25, 5, 2024, 10, 30},
                [1] = 200,
                [2] = 400,
                [3] = 600,
                [4] = 800,
                BossNames = {"Epsilon", "Zeta", "Eta", "Theta"},
            },
            [5] = {
                finish = 300000,
                forces = 300,
                level = 5,
                date = {1, 5, 2024, 9, 0},
                [1] = 300,
                BossNames = {"Solo Boss"},
            },
            [10] = {
                finish = 700000,
                forces = 700,
                level = 10,
                date = {3, 5, 2024, 11, 0},
                [1] = 200,
                [2] = 400,
                [3] = 700,
                BossNames = {"First", "Second", "Third"},
            },
            [15] = {
                finish = 1250000,
                forces = 1250,
                level = 15,
                date = {5, 5, 2024, 14, 0},
                [1] = 310,
                [2] = 620,
                [3] = 930,
                [4] = 1240,
                BossNames = {"Boss One", "Boss Two", "Boss Three", "Boss Four"},
            },
            [14] = {
                finish = 1350000,
                forces = 1350,
                level = 14,
                date = {8, 5, 2024, 16, 20},
                [1] = 410,
                [2] = 820,
                [3] = 1230,
                BossNames = {"Boss A", "Boss B", "Boss C"},
            },
            [13] = {
                finish = 1450000,
                forces = 1450,
                level = 13,
                date = {12, 5, 2024, 18, 10},
                [1] = 500,
                [2] = 1000,
                [3] = 1450,
                BossNames = {"Boss X", "Boss Y", "Boss Z"},
            },
            [12] = {
                finish = 1550000,
                forces = 1550,
                level = 12,
                date = {15, 5, 2024, 20, 5},
                [1] = 600,
                [2] = 1200,
                [3] = 1550,
                BossNames = {"Boss L", "Boss M", "Boss N"},
            },
            [11] = {
                finish = 1650000,
                forces = 1650,
                level = 11,
                date = {18, 5, 2024, 13, 55},
                [1] = 700,
                [2] = 1400,
                [3] = 1650,
                BossNames = {"Boss D", "Boss E", "Boss F"},
            },
            [10] = {
                finish = 1750000,
                forces = 1750,
                level = 10,
                date = {20, 5, 2024, 15, 45},
                [1] = 800,
                [2] = 1600,
                [3] = 1750,
                BossNames = {"Boss G", "Boss H", "Boss I"},
            },
            [9] = {
                finish = 1850000,
                forces = 1850,
                level = 9,
                date = {22, 5, 2024, 17, 35},
                [1] = 900,
                [2] = 1800,
                [3] = 1850,
                BossNames = {"Boss J", "Boss K", "Boss L"},
            },
            [8] = {
                finish = 1950000,
                forces = 1950,
                level = 8,
                date = {24, 5, 2024, 19, 25},
                [1] = 1000,
                [2] = 2000,
                [3] = 1950,
                BossNames = {"Boss M", "Boss N", "Boss O"},
            },
            [7] = {
                finish = 2050000,
                forces = 2050,
                level = 7,
                date = {26, 5, 2024, 21, 15},
                [1] = 1100,
                [2] = 2200,
                [3] = 2050,
                BossNames = {"Boss P", "Boss Q", "Boss R"},
            },
            [6] = {
                finish = 2150000,
                forces = 2150,
                level = 6,
                date = {28, 5, 2024, 23, 5},
                [1] = 1200,
                [2] = 2400,
                [3] = 2150,
                BossNames = {"Boss S", "Boss T", "Boss U"},
            },
            [5] = {
                finish = 2250000,
                forces = 2250,
                level = 5,
                date = {30, 5, 2024, 10, 0},
                [1] = 1300,
                [2] = 2600,
                [3] = 2250,
                BossNames = {"Boss V", "Boss W", "Boss X"},
            },
            [4] = {
                finish = 2350000,
                forces = 2350,
                level = 4,
                date = {1, 6, 2024, 12, 50},
                [1] = 1400,
                [2] = 2800,
                [3] = 2350,
                BossNames = {"Boss Y", "Boss Z", "Boss AA"},
            },
            [3] = {
                finish = 2450000,
                forces = 2450,
                level = 3,
                date = {3, 6, 2024, 14, 40},
                [1] = 1500,
                [2] = 3000,
                [3] = 2450,
                BossNames = {"Boss AB", "Boss AC", "Boss AD"},
            },
            [2] = {
                finish = 2550000,
                forces = 2550,
                level = 2,
                date = {5, 6, 2024, 16, 30},
                [1] = 1600,
                [2] = 3200,
                [3] = 2550,
                BossNames = {"Boss AE", "Boss AF", "Boss AG"},
            },
            [1] = {
                finish = 2650000,
                forces = 2650,
                level = 1,
                date = {7, 6, 2024, 18, 20},
                [1] = 1700,
                [2] = 3400,
                [3] = 2650,
                BossNames = {"Boss AH", "Boss AI", "Boss AJ"},
            },
        }
    }
end

function MPT:UpdatePB(time, cmap, level, date)
    C_MythicPlus.RequestMapInfo()
    self.seasonID = self.seasonID and self.seasonID ~= 0 and self.seasonID or C_MythicPlus.GetCurrentSeason()
    if not MPTSV.BestTime then MPTSV.BestTime = {} end
    if not MPTSV.BestTime[self.seasonID] then MPTSV.BestTime[self.seasonID] = {} end
    if not MPTSV.BestTime[self.seasonID][cmap] then MPTSV.BestTime[self.seasonID][cmap] = {} end
    if not MPTSV.BestTime[self.seasonID][cmap][level] then MPTSV.BestTime[self.seasonID][cmap][level] = {} end
    local before = MPTSV.BestTime[self.seasonID][cmap][level]["finish"]
    if not MPTSV.BestTime[self.seasonID][cmap][level]["finish"] or time < MPTSV.BestTime[self.seasonID][cmap][level]["finish"] then
        MPTSV.BestTime[self.seasonID][cmap][level]["finish"] = time
        MPTSV.BestTime[self.seasonID][cmap][level]["forces"] = time
        MPTSV.BestTime[self.seasonID][cmap][level]["level"] = level
        MPTSV.BestTime[self.seasonID][cmap][level]["date"] = {date.monthDay, date.month, date.year, date.hour, date.minute}
        if not MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] then MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] = {} end
        for i, v in ipairs(self.BossTimes) do
            MPTSV.BestTime[self.seasonID][cmap][level][i] = v
            MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"][i] = self.BossNames[i]
        end
    end
    return before
end

function MPT:GetPB(cmap, level, seasonID)
    C_MythicPlus.RequestMapInfo()
    local seasonID = seasonID or (self.seasonID and self.seasonID ~= 0 and self.seasonID or C_MythicPlus.GetCurrentSeason())
    return MPTSV.BestTime and MPTSV.BestTime[seasonID] and MPTSV.BestTime[seasonID][cmap] and (MPTSV.BestTime[seasonID][cmap][level] or (self.LowerKey and MPTSV.BestTime[seasonID][cmap][level-1]))
end

function MPT:AddPB(cmap, level, seasonID, time, forces, date, BossNames, BossTimes)
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
            self:AddPB(UIDropDownMenu_GetSelectedValue(F.RunEditPanel.DungeonDropdown), level,
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
        local width = 1000
        local height = 700
        F:SetSize(width, height)
        F:SetPoint("CENTER")
        F:SetFrameStrata("HIGH")
        F:EnableMouse(true)
        F:SetMovable(true)
        F:RegisterForDrag("LeftButton")
        F:SetScript("OnDragStart", function(self)
            self:StartMoving()
        end)
        F:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
        end)
        self.SelectedSeasonButton = nil
        self.SelectedDungeonButton = nil
        self.SelectedLevelButton = nil
       
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
        F.DeleteButton.Text:SetText("Delete Run")
        F.DeleteButton:Hide()
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
    self:ShowDungeonFrames(self.seasonID) -- Show Border of Current Season when initially loaded
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
    if F.DeleteButton then F.DeleteButton:Hide() end
    if self.SelectedLevelButton then
        self.SelectedLevelButton.Border:Hide()
    end
    self.SelectedLevel = nil
    local first = true
    for level = 100, 1, -1 do
        if (MPTSV.BestTime[seasonID][cmap] and MPTSV.BestTime[seasonID][cmap][level]) or level == 100 then
            local btn = F.LevelButtons[num]
            if not btn then
                local color = level == 100 and {0, 0.7, 0, 0.9} or {0.3, 0.3, 0.3, 0.9}
                btn = self:CreateButton(90, 40, F.LevelContent, true, true, color, {0.2, 0.6, 1, 0.5}, "Expressway", 16, {1, 1, 1, 1})
                F.LevelButtons[num] = btn
            end
            --btn:SetPoint("TOPLEFT", F.LevelContent, "TOPLEFT", 10, num == 1 and -5 or ((num-1)*-45)-5)
            btn:SetPoint("TOP", F.LevelContent, "TOP", 0, num == 1 and -5 or ((num-1)*-45)-5)
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
        local pbdata = MPTSV.BestTime[seasonID][cmap][level]
        if pbdata and pbdata.finish then
            local text = string.format("Dungeon: %s\nTime: %s\n", self:GetDungeonName(cmap), self:FormatTime(pbdata.finish/1000))
            for i=1, #(pbdata["BossNames"] or {}) do
                if pbdata["BossNames"] and pbdata["BossNames"][i] and pbdata[i] then
                    text = text..string.format("%s: %s\n", pbdata["BossNames"][i] or "Unknown", self:FormatTime(pbdata[i]))
                end
            end
            local date = self:GetDateFormat(pbdata.date)
            if date == "" then date = "No Date/Manually Added Run" else date = "Date: "..date end
            local text = text..string.format("Enemy Forces: %s\n%s", self:FormatTime(pbdata.forces), date)
            if not F.PBDataText then
                F.PBDataText = F.PBDataFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                F.PBDataText:SetPoint("TOPLEFT", F.PBDataFrame, "TOPLEFT", 5, -10)
            end
            F.PBDataText:SetText(text)
            F.PBDataText:Show()
            F.PBDataText:SetJustifyH("LEFT")
            F.PBDataText:SetFont(self.LSM:Fetch("font", "Expressway"), 20, "OUTLINE")
            F.PBDataText:SetTextColor(1, 1, 1, 1)
            F.DeleteButton:Show()
        end
    end
end