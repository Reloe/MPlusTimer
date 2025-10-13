local _, MPT = ...

function MPT:CreateFakeSV()
    MPTSV.BestTime[15] = {
        [499] = {
            [15] = {
                finish = 1234567,
                forces = 1234567,
                level = 15,
                date = {15, 5, 2024, 14, 30},
                [1] = 300000,
                [2] = 600000,
                [3] = 900000,
                [4] = 1200000,
                BossNames = {"Boss One", "Boss Two", "Boss Three", "Boss Four"},
            },
        },
        [500] = {
            [14] = {
                finish = 1300000,
                forces = 1300000,
                level = 14,
                date = {10, 5, 2024, 16, 45},
                [1] = 400000,
                [2] = 800000,
                [3] = 1200000,
                BossNames = {"Boss A", "Boss B", "Boss C"},
            },
        },
        [501] = {
            [16] = {
                finish = 1150000,
                forces = 1150000,
                level = 16,
                date = {20, 5, 2024, 12, 15},
                [1] = 250000,
                [2] = 500000,
                [3] = 750000,
                [4] = 1000000,
                BossNames = {"Alpha", "Beta", "Gamma", "Delta"},
            },
            [17] = {
                finish = 1100000,
                forces = 1100000,
                level = 17,
                date = {25, 5, 2024, 10, 30},
                [1] = 200000,
                [2] = 400000,
                [3] = 600000,
                [4] = 800000,
                BossNames = {"Epsilon", "Zeta", "Eta", "Theta"},
            },
            [5] = {
                finish = 300000,
                forces = 300000,
                level = 5,
                date = {1, 5, 2024, 9, 0},
                [1] = 300000,
                BossNames = {"Solo Boss"},
            },
            [10] = {
                finish = 700000,
                forces = 700000,
                level = 10,
                date = {3, 5, 2024, 11, 0},
                [1] = 200000,
                [2] = 400000,
                [3] = 700000,
                BossNames = {"First", "Second", "Third"},
            },
            [15] = {
                finish = 1250000,
                forces = 1250000,
                level = 15,
                date = {5, 5, 2024, 14, 0},
                [1] = 310000,
                [2] = 620000,
                [3] = 930000,
                [4] = 1240000,
                BossNames = {"Boss One", "Boss Two", "Boss Three", "Boss Four"},
            },
            [14] = {
                finish = 1350000,
                forces = 1350000,
                level = 14,
                date = {8, 5, 2024, 16, 20},
                [1] = 410000,
                [2] = 820000,
                [3] = 1230000,
                BossNames = {"Boss A", "Boss B", "Boss C"},
            },
            [13] = {
                finish = 1450000,
                forces = 1450000,
                level = 13,
                date = {12, 5, 2024, 18, 10},
                [1] = 500000,
                [2] = 1000000,
                [3] = 1450000,
                BossNames = {"Boss X", "Boss Y", "Boss Z"},
            },
            [12] = {
                finish = 1550000,
                forces = 1550000,
                level = 12,
                date = {15, 5, 2024, 20, 5},
                [1] = 600000,
                [2] = 1200000,
                [3] = 1550000,
                BossNames = {"Boss L", "Boss M", "Boss N"},
            },
            [11] = {
                finish = 1650000,
                forces = 1650000,
                level = 11,
                date = {18, 5, 2024, 13, 55},
                [1] = 700000,
                [2] = 1400000,
                [3] = 1650000,
                BossNames = {"Boss D", "Boss E", "Boss F"},
            },
            [10] = {
                finish = 1750000,
                forces = 1750000,
                level = 10,
                date = {20, 5, 2024, 15, 45},
                [1] = 800000,
                [2] = 1600000,
                [3] = 1750000,
                BossNames = {"Boss G", "Boss H", "Boss I"},
            },
            [9] = {
                finish = 1850000,
                forces = 1850000,
                level = 9,
                date = {22, 5, 2024, 17, 35},
                [1] = 900000,
                [2] = 1800000,
                [3] = 1850000,
                BossNames = {"Boss J", "Boss K", "Boss L"},
            },
            [8] = {
                finish = 1950000,
                forces = 1950000,
                level = 8,
                date = {24, 5, 2024, 19, 25},
                [1] = 1000000,
                [2] = 2000000,
                [3] = 1950000,
                BossNames = {"Boss M", "Boss N", "Boss O"},
            },
            [7] = {
                finish = 2050000,
                forces = 2050000,
                level = 7,
                date = {26, 5, 2024, 21, 15},
                [1] = 1100000,
                [2] = 2200000,
                [3] = 2050000,
                BossNames = {"Boss P", "Boss Q", "Boss R"},
            },
            [6] = {
                finish = 2150000,
                forces = 2150000,
                level = 6,
                date = {28, 5, 2024, 23, 5},
                [1] = 1200000,
                [2] = 2400000,
                [3] = 2150000,
                BossNames = {"Boss S", "Boss T", "Boss U"},
            },
            [5] = {
                finish = 2250000,
                forces = 2250000,
                level = 5,
                date = {30, 5, 2024, 10, 0},
                [1] = 1300000,
                [2] = 2600000,
                [3] = 2250000,
                BossNames = {"Boss V", "Boss W", "Boss X"},
            },
            [4] = {
                finish = 2350000,
                forces = 2350000,
                level = 4,
                date = {1, 6, 2024, 12, 50},
                [1] = 1400000,
                [2] = 2800000,
                [3] = 2350000,
                BossNames = {"Boss Y", "Boss Z", "Boss AA"},
            },
            [3] = {
                finish = 2450000,
                forces = 2450000,
                level = 3,
                date = {3, 6, 2024, 14, 40},
                [1] = 1500000,
                [2] = 3000000,
                [3] = 2450000,
                BossNames = {"Boss AB", "Boss AC", "Boss AD"},
            },
            [2] = {
                finish = 2550000,
                forces = 2550000,
                level = 2,
                date = {5, 6, 2024, 16, 30},
                [1] = 1600000,
                [2] = 3200000,
                [3] = 2550000,
                BossNames = {"Boss AE", "Boss AF", "Boss AG"},
            },
            [1] = {
                finish = 2650000,
                forces = 2650000,
                level = 1,
                date = {7, 6, 2024, 18, 20},
                [1] = 1700000,
                [2] = 3400000,
                [3] = 2650000,
                BossNames = {"Boss AH", "Boss AI", "Boss AJ"},
            },
        }
    }
    MPTSV.BestTime[16] = {
        [502] = {
            [15] = {
                finish = 1250000,
                forces = 1250000,
                level = 15,
                date = {5, 6, 2024, 14, 0},
                [1] = 310000,
                [2] = 620000,
                [3] = 930000,
                [4] = 1240000,
                BossNames = {"Boss One", "Boss Two", "Boss Three", "Boss Four"},
            },
        },
        [503] = {
            [14] = {
                finish = 1350000,
                forces = 1350000,
                level = 14,
                date = {8, 6, 2024, 16, 20},
                [1] = 410000,
                [2] = 820000,
                [3] = 1230000,
                BossNames = {"Boss A", "Boss B", "Boss C"},
            },
        },
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

function MPT:CreatePBFrame()
    if not self.PBInfoFrame then
        -- Main Frame
        self.BestTimeFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        local F = self.BestTimeFrame
        local width = 1000
        local height = 600
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
            edgeSize = 1,
        })
        F.BGBorder:SetBackdropBorderColor(0, 0, 0, 1)

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
        F.SeasonButtonFrame:SetBackdropBorderColor(0, 0, 0, 1)

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
        F.DungeonButtonFrame:SetBackdropBorderColor(0, 0, 0, 1)


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
        F.LevelButtonFrame:SetBackdropBorderColor(0, 0, 0, 1)

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
        F.PBDataFrame:SetBackdropBorderColor(0, 0, 0, 1)

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
                    MPTSV.BestTime[self.SelectedSeason][self.SelectedDungeon] = nil
                    if next(MPTSV.BestTime[self.SelectedSeason]) == nil then
                        MPTSV.BestTime[self.SelectedSeason] = nil
                        self:ShowSeasonFrames()
                    else
                        self:ShowDungeonFrames(self.SelectedSeason)
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
            if not F.SeasonButtons[i] then
                local btn = CreateFrame("Button", nil, parent)
                btn:SetSize(130, 25)
                btn.BG = btn:CreateTexture(nil, "BACKGROUND")
                btn.BG:SetAllPoints()
                btn.BG:SetColorTexture(0.3, 0.3, 0.3, 0.9)
                btn:SetNormalTexture("")
                btn:SetHighlightTexture("")
                btn:SetPushedTexture("")
                btn.Border = btn:CreateTexture(nil, "OVERLAY")
                btn.Border:SetAllPoints()
                btn.Border:SetColorTexture(0.2, 0.6, 1, 0.5)
                btn.Border:Hide()
                btn.Text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                btn.Text:SetPoint("CENTER", btn, "CENTER", 0, 0)
                btn.Text:SetFont(self.LSM:Fetch("font", "Expressway"), 13, "OUTLINE")
                btn.Text:SetTextColor(1, 1, 1, 1)
                F.SeasonButtons[i] = btn
            end
            local btn = F.SeasonButtons[i]
            btn:SetPoint("LEFT", parent, "LEFT", first and 10 or 140, 0)
            btn.Text:SetText(self.SeasonName[i])
            btn:Show()
            btn:SetScript("OnClick", function()
                self:ShowDungeonFrames(i)
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
                btn.Border:Show()
                for k, v in pairs(F.LevelButtons or {}) do
                    v:Hide()
                end
                self.SelectedSeasonButton = btn  
                self.SelectedSeason = i       
                self.SelectedDungeon = nil
                self.SelectedLevel = nil
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
        for cmap, leveltable in pairs(MPTSV.BestTime[seasonID]) do
            local parent = num == 1 and F.DungeonButtonFrame or F.DungeonButtons[num-1]
            local name = self.maptoID[cmap] and self.maptoID[cmap][2] or "Unknown"
            local btn = F.DungeonButtons[num]
            if not btn then
                btn = CreateFrame("Button", nil, parent)
                btn:SetSize(140, 40)
                btn.BG = btn:CreateTexture(nil, "BACKGROUND")
                btn.BG:SetAllPoints()
                btn.BG:SetColorTexture(0.3, 0.3, 0.3, 0.9)
                btn:SetNormalTexture("")
                btn:SetHighlightTexture("")
                btn:SetPushedTexture("")
                btn.Border = btn:CreateTexture(nil, "OVERLAY")
                btn.Border:SetAllPoints()
                btn.Border:SetColorTexture(0.2, 0.6, 1, 0.5)
                btn.Border:Hide()
                btn.Text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                btn.Text:SetPoint("CENTER", btn, "CENTER", 0, 0)
                btn.Text:SetFont(self.LSM:Fetch("font", "Expressway"), 15, "OUTLINE")
                btn.Text:SetTextColor(1, 1, 1, 1)
                F.DungeonButtons[num] = btn
            end
            btn:SetPoint("TOP", parent, "TOP", 0, num == 1 and -10 or -50)
            btn:SetScript("OnClick", function()
                self:ShowLevelFrames(cmap, seasonID)
                if self.SelectedDungeonButton then
                    self.SelectedDungeonButton.Border:Hide()
                end
                if self.SelectedLevelButton then
                    self.SelectedLevelButton.Border:Hide()
                end
                if F.PBDataText then F.PBDataText:Hide() end
                if F.DeleteButton then F.DeleteButton:Hide() end
                btn.Border:Show()
                self.SelectedDungeonButton = btn
                self.SelectedDungeon = cmap
                self.SelectedLevel = nil
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
    for level = 100, 1, -1 do
        if MPTSV.BestTime[seasonID][cmap][level] then
            if not F.LevelButtons[num] then
                local btn = CreateFrame("Button", nil, F.LevelContent)
                btn:SetSize(90, 40)
                btn.BG = btn:CreateTexture(nil, "BACKGROUND")
                btn.BG:SetAllPoints()
                btn.BG:SetColorTexture(0.3, 0.3, 0.3, 0.9)
                btn:SetNormalTexture("")
                btn:SetHighlightTexture("")
                btn:SetPushedTexture("")
                btn.Border = btn:CreateTexture(nil, "OVERLAY")
                btn.Border:SetAllPoints()
                btn.Border:SetColorTexture(0.2, 0.6, 1, 0.5)
                btn.Border:Hide()
                btn.Text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                btn.Text:SetPoint("CENTER", btn, "CENTER", 0, 0)
                btn.Text:SetFont(self.LSM:Fetch("font", "Expressway"), 16, "OUTLINE")
                btn.Text:SetTextColor(1, 1, 1, 1)
                F.LevelButtons[num] = btn
            end
            local btn = F.LevelButtons[num]
            --btn:SetPoint("TOPLEFT", F.LevelContent, "TOPLEFT", 10, num == 1 and -5 or ((num-1)*-45)-5)
            btn:SetPoint("TOP", F.LevelContent, "TOP", 0, num == 1 and -5 or ((num-1)*-45)-5)
            btn:SetScript("OnClick", function()
                self:ShowPBDataFrame(cmap, level, seasonID)
                if self.SelectedLevelButton then
                    self.SelectedLevelButton.Border:Hide()
                end
                btn.Border:Show()
                self.SelectedLevelButton = btn
                self.SelectedLevel = level
            end)
            btn.Text:SetText(level)
            btn:Show()
            num = num+1
        end
    end
    F.LevelContent:SetHeight(num*50)
end

function MPT:ShowPBDataFrame(cmap, level, seasonID) -- Showing PB Data
    local F = self.BestTimeFrame
    if not F then return end
    if F.PBDataFrame then
        local pbdata = MPTSV.BestTime[seasonID][cmap][level]
        if pbdata and pbdata.finish then
            local text = string.format("Dungeon: %s\nTime: %s\n", self.maptoID[cmap] and self.maptoID[cmap][2] or "Unknown", self:FormatTime(pbdata.finish/1000))
            for i=1, #(pbdata["BossNames"] or {}) do
                if pbdata["BossNames"] and pbdata["BossNames"][i] then
                    text = text..string.format("%s: %s\n", pbdata["BossNames"][i] or "Unknown", self:FormatTime(pbdata[i]/1000))
                end
            end
            local text = text..string.format("Enemy Forces: %s\nDate: %s", self:FormatTime(pbdata.forces/1000), self:GetDateFormat(pbdata.date))
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