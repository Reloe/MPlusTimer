local _, MPT = ...
local L = LibStub("AceLocale-3.0"):GetLocale("MPlusTimer")

StaticPopupDialogs["MPT_DELETE_RUN"] = {
    text = L["Are you sure you want to delete this run?"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        if not MPT.SelectedSeason or not MPT.SelectedDungeon or not MPT.SelectedLevel then return end
        if MPTSV.BestTime and MPTSV.BestTime[MPT.SelectedSeason] and MPTSV.BestTime[MPT.SelectedSeason][MPT.SelectedDungeon] and MPTSV.BestTime[MPT.SelectedSeason][MPT.SelectedDungeon][MPT.SelectedLevel] then
            MPTSV.BestTime[MPT.SelectedSeason][MPT.SelectedDungeon][MPT.SelectedLevel] = nil
            if next(MPTSV.BestTime[MPT.SelectedSeason][MPT.SelectedDungeon]) == nil then
                if next(MPTSV.BestTime[MPT.SelectedSeason]) == nil then
                    MPTSV.BestTime[MPT.SelectedSeason] = nil
                    MPT:ShowSeasonFrames()
                else
                    MPT:ShowLevelFrames(MPT.SelectedDungeon, MPT.SelectedSeason)
                end
            else
                MPT:ShowLevelFrames(MPT.SelectedDungeon, MPT.SelectedSeason)
            end
        end
    end,
    hideOnEscape = true,
}
StaticPopupDialogs["MPT_DELETE_CHARACTER"] = {
    text = L["Are you sure you want to delete this character's history?"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
       if not MPT.SelectedSeason or not MPT.SelectedCharacter then return end
         if MPTSV.History and MPTSV.History[MPT.SelectedSeason] and MPTSV.History[MPT.SelectedSeason][MPT.SelectedCharacter] then
              MPTSV.History[MPT.SelectedSeason][MPT.SelectedCharacter] = nil
              if next(MPTSV.History[MPT.SelectedSeason]) == nil then
                MPTSV.History[MPT.SelectedSeason] = nil
                MPT.BestTimeFrame.PBDataFrame:Hide()
                MPT:ShowSeasonFrames()
              else
                MPT:ShowCharacterFrames(MPT.SelectedSeason)
              end
         end
    end,
    hideOnEscape = true,
}

function MPT:CreateEditPanel()
    local F = self.BestTimeFrame
    if not F then return end
    if not F.RunEditPanel then
        F.RunEditPanel = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.RunEditPanel:SetSize(300, 450)
        self:SetPoint(F.RunEditPanel, "BOTTOMLEFT", F.PBDataFrame, "BOTTOMLEFT", 0, 0)
        self:AddBackDrop(F.RunEditPanel, 2, {0.2, 0.6, 1, 1})

        -- Dungeon Name
        F.RunEditPanel.DungeonLabel = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel, "TOPLEFT", 20, -20, L["Dungeon:"])
        F.RunEditPanel.DungeonDropdown = CreateFrame("Frame", nil, F.RunEditPanel, "UIDropDownMenuTemplate")
        self:SetPoint(F.RunEditPanel.DungeonDropdown, "TOPLEFT", F.RunEditPanel.DungeonLabel, "BOTTOMLEFT", -20, -2)

        -- Level EditBox
        F.RunEditPanel.LevelLabel = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.DungeonDropdown, "BOTTOMLEFT", 20, -10, L["Level:"])
        F.RunEditPanel.LevelEdit = self:CreateEditBox(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.LevelLabel, "BOTTOMLEFT", 5, -2, 60, 20)
        F.RunEditPanel.LevelEdit:SetNumeric(true)

        -- Completion Time EditBox
        F.RunEditPanel.CompletionLabel = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.LevelEdit, "BOTTOMLEFT", -5, -10, L["Completion Time:"])
        F.RunEditPanel.CompletionEdit = self:CreateEditBox(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.CompletionLabel, "BOTTOMLEFT", 5, -2, 80, 20)

        -- Enemy Forces Time EditBox
        F.RunEditPanel.ForcesLabel = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.CompletionEdit, "BOTTOMLEFT", -5, -10, L["Enemy Forces Time:"])
        F.RunEditPanel.ForcesEdit = self:CreateEditBox(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.ForcesLabel, "BOTTOMLEFT", 5, -2, 80, 20)

        -- Bosses
        F.RunEditPanel.BossLabels = {}
        F.RunEditPanel.BossEdits = {}
        F.RunEditPanel.BossTimeLabels = {}
        F.RunEditPanel.BossTimeEdits = {}
        for i = 1, 5 do
            local yOffset = -10 - ((i-1)*38)
            F.RunEditPanel.BossLabels[i] = self:CreateLabel(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.ForcesEdit, "BOTTOMLEFT", -5, yOffset, L["Boss %s Name:"]:format(i))
            F.RunEditPanel.BossEdits[i] = self:CreateEditBox(F.RunEditPanel, "TOPLEFT", F.RunEditPanel.BossLabels[i], "BOTTOMLEFT", 5, -2, 120, 20)
            F.RunEditPanel.BossTimeEdits[i] = self:CreateEditBox(F.RunEditPanel, "LEFT", F.RunEditPanel.BossEdits[i], "RIGHT", 10, 0, 60, 20)
            F.RunEditPanel.BossTimeLabels[i] = self:CreateLabel(F.RunEditPanel, "BOTTOMLEFT", F.RunEditPanel.BossTimeEdits[i], "TOPLEFT", -5, 0, L["Time:"])
        end

        -- Save Button
        F.RunEditPanel.SaveButton = self:CreateButton(80, 28, F.RunEditPanel, true, false, {0.15, 0.5, 0.2, 0.9}, nil, "Expressway", 13, {1, 1, 1, 1}, L["Save"])
        self:SetPoint(F.RunEditPanel.SaveButton, "BOTTOMLEFT", F.RunEditPanel, "BOTTOMLEFT", 20, 10)
        F.RunEditPanel.SaveButton:SetScript("OnClick", function(s)
            local BossNames = {}
            local BossTimes = {}
            for i = 1, 5 do
                local name = F.RunEditPanel.BossEdits[i]:GetText()
                local bosstime = F.RunEditPanel.BossTimeEdits[i]:GetText()
                if bosstime and bosstime ~= "" then
                    BossNames[i] = name and name ~= "" and name or (bosstime and bosstime ~= "" and L["Boss %s"]:format(i)) or nil -- add placeholder bossname if it's not given
                    BossTimes[i] = bosstime and bosstime ~= "" and self:StrToTime(bosstime) or nil                
                    if not BossTimes[i] then
                        print(L["Invalid time format for Boss "]..i..L[". For Timers you are expected to supply a string in the format mm:ss"])
                        return
                    end
                end
            end
            local time = self:StrToTime(F.RunEditPanel.CompletionEdit:GetText())
            local forces = self:StrToTime(F.RunEditPanel.ForcesEdit:GetText())
            local level = F.RunEditPanel.LevelEdit:GetNumber()
            if (not time) or (not forces) then
                print(L["Invalid time format. For Timers you are expected to supply a string in the format mm:ss"])
                return 
            end
            if level == 0 or next(BossTimes) == nil then
                print(L["You must fill in at least Level, Completion Time, Enemy Forces Time and one Boss Timer."])
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
        F.RunEditPanel.CancelButton = self:CreateButton(80, 28, F.RunEditPanel, true, false, {0.5, 0.15, 0.15, 0.9}, nil, "Expressway", 13, {1, 1, 1, 1}, L["Cancel"])
        self:SetPoint(F.RunEditPanel.CancelButton, "LEFT", F.RunEditPanel.SaveButton, "RIGHT", 10, 0)
        F.RunEditPanel.CancelButton:SetScript("OnClick", function(s)
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
    editbox:SetScript("OnEditFocusGained", function(s)
        s:EnableKeyboard(true)
    end)
    editbox:SetScript("OnEditFocusLost", function(s)
        s:EnableKeyboard(false)
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
        self:SetPoint(F, "TOPLEFT", UIParent, "TOPLEFT", x, -y)
        F:SetFrameStrata("HIGH")
        F:EnableMouse(true)
        F:SetMovable(true)
        F:SetClampedToScreen(true)
        F:RegisterForDrag("LeftButton")
        F:SetScript("OnDragStart", function(s)
            s:StartMoving()
        end)
        F:SetScript("OnDragStop", function(s)
            s:StopMovingOrSizing()
            local scale = s:GetScale() or 1
            local x = s:GetLeft()
            local y = (UIParent:GetTop() - (s:GetTop() * scale)) / scale
            self:SetPoint(s, "TOPLEFT", UIParent, "TOPLEFT", x, -y)
        end)
        self.SelectedSeasonButton = nil
        self.SelectedDungeonButton = nil
        self.SelectedLevelButton = nil

        F:SetResizable(true)        
        F.Handle = self:CreateButton(20, 20, F)
        self:SetPoint(F.Handle, "BOTTOMRIGHT", F, "BOTTOMRIGHT", -2, 2)
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
        F.Handle:SetScript("OnDragStart", function(s)
            initialWidth, initialHeight = F:GetWidth(), F:GetHeight()
            local cursorX, cursorY = GetCursorPosition()
            initialX, initialY = cursorX / UIParent:GetScale(), cursorY / UIParent:GetScale()
            dragging = true
            s:SetScript("OnUpdate", function()
                if dragging then
                    local cursorX, cursorY = GetCursorPosition()
                    cursorX, cursorY = cursorX / UIParent:GetScale(), cursorY / UIParent:GetScale()
                    local dx = cursorX - initialX
                    local dy = cursorY - initialY
                    local newWidth = math.max(minWidth, math.min(maxWidth, initialWidth + dx))
                    local newHeight = math.max(minHeight, math.min(maxHeight, initialHeight - dy))
                    F:SetSize(newWidth, newHeight)
                    if F.SeasonButtonFrame then F.SeasonButtonFrame:SetWidth(newWidth) end
                    if F.DungeonButtonFrame then F.DungeonButtonFrame:SetHeight(newHeight - (F.SeasonButtonFrame and F.SeasonButtonFrame:GetHeight() or 40)) end
                    if F.LevelButtonFrame then F.LevelButtonFrame:SetHeight(newHeight - (F.SeasonButtonFrame and F.SeasonButtonFrame:GetHeight() or 40)) end
                    if F.PBDataFrame then F.PBDataFrame:SetSize(newWidth - (F.DungeonButtonFrame and F.DungeonButtonFrame:GetWidth() or 160) - (F.LevelButtonFrame and F.LevelButtonFrame:GetWidth() or 135), newHeight - (F.SeasonButtonFrame and F.SeasonButtonFrame:GetHeight() or 40)) end
                    if F.LevelContent then F.LevelContent:SetHeight(newHeight - (F.SeasonButtonFrame and F.SeasonButtonFrame:GetHeight() or 40)) end
                    if F.PBDataText2 then F.PBDataText2:SetWidth(F.PBDataFrame:GetWidth()-155) end
                end
            end)
        end)
        F.Handle:SetScript("OnDragStop", function(s)
            dragging = false
            s:SetScript("OnUpdate", nil)
        end)

        -- Close Button
        F.CloseButton = CreateFrame("Button", nil, F, "UIPanelCloseButton")
        F.CloseButton:SetSize(24, 24)
        self:SetPoint(F.CloseButton, "TOPRIGHT", F, "TOPRIGHT", -8, -8)
        F.CloseButton:SetScript("OnClick", function(s)
            StaticPopup_Hide("MPT_DELETE_RUN") -- hide when literally any button is pressed because the parameters have changed
            StaticPopup_Hide("MPT_DELETE_CHARACTER") -- hide when literally any button is pressed because the parameters have changed
            F:Hide()
        end)

        -- Background
        self:AddBGBackground(F, "BG", "Border", 2, {0, 0, 0, 0.7}, {0.2, 0.6, 1, 1})

        -- Season Buttons
        local seasonheight = 40
        F.SeasonButtonFrame = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.SeasonButtonFrame:SetSize(width, seasonheight)
        self:SetPoint(F.SeasonButtonFrame, "TOPLEFT", F, "TOPLEFT", 0, 0)

        F.SeasonButtons = {}
        self:AddBackDrop(F.SeasonButtonFrame, 1, {0.2, 0.6, 1, 1})

        -- Dungeon Buttons
        local dungeonwidth = 160
        F.DungeonButtonFrame = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.DungeonButtonFrame:SetSize(dungeonwidth, height-seasonheight)
        self:SetPoint(F.DungeonButtonFrame, "TOPLEFT", F.SeasonButtonFrame, "BOTTOMLEFT", 0, 0)
        F.DungeonButtons = {}
        self:AddBackDrop(F.DungeonButtonFrame, 1, {0.2, 0.6, 1, 1})


        -- Level Buttons
        local levelwidth = 135
        F.LevelButtonFrame = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.LevelButtonFrame:SetSize(levelwidth, height-seasonheight)
        self:SetPoint(F.LevelButtonFrame, "TOPLEFT", F.DungeonButtonFrame, "TOPRIGHT", 0, 0)
        F.LevelButtons = {}
        self:AddBackDrop(F.LevelButtonFrame, 1, {0.2, 0.6, 1, 1})

        -- Level Scroll Frame
        F.LevelScrollFrame = CreateFrame("ScrollFrame", nil, F.LevelButtonFrame, "UIPanelScrollFrameTemplate")
        self:SetPoint(F.LevelScrollFrame, "TOPLEFT", F.LevelButtonFrame, "TOPLEFT", 0, -5)
        self:SetPoint(F.LevelScrollFrame, "BOTTOMRIGHT", F.LevelButtonFrame, "BOTTOMRIGHT", -27, 5, true)

        F.LevelContent = CreateFrame("Frame", nil, F.LevelScrollFrame)
        F.LevelContent:SetSize(levelwidth, 1)
        F.LevelScrollFrame:SetScrollChild(F.LevelContent)


        -- PB Frame
        F.PBDataFrame = CreateFrame("Frame", nil, F, "BackdropTemplate")
        F.PBDataFrame:SetSize(width-dungeonwidth-levelwidth, height-seasonheight)
        self:SetPoint(F.PBDataFrame, "TOPLEFT", F.LevelButtonFrame, "TOPRIGHT", 0, 0)
        self:AddBackDrop(F.PBDataFrame, 1, {0.2, 0.6, 1, 1})

        -- Delete Button
        F.DeleteButton = CreateFrame("Button", nil, F.PBDataFrame)
        F.DeleteButton:SetSize(120, 32)
        self:SetPoint(F.DeleteButton, "TOPRIGHT", F.PBDataFrame, "TOPRIGHT", -20, -20)
        self:AddBackground(F.DeleteButton, "BG", {0.45, 0.10, 0.10, 0.9})
        self:CreateText(F.DeleteButton, "Text", {FontSize=14})
        self:SetPoint(F.DeleteButton.Text, "CENTER", F.DeleteButton, "CENTER", 0, 0)
        F.DeleteButton:Hide()
        self:AddMouseoverTooltip(F.DeleteButton, L["Delete the selected run from your saved best times. This does not delete it from the Total Stats. It is simply for comparison purposes."])

        F.TotalStatsButton = self:CreateButton(140, 40, F, true, false, {1, 1, 0.3, 0.7}, nil, "Expressway", 13, {1, 1, 1, 1}, L["Show Stats"])
        self:SetPoint(F.TotalStatsButton, "BOTTOM", F.DungeonButtonFrame, "BOTTOM", 0, 10)
        F.TotalStatsButton:SetScript("OnClick", function(s)
            if self.SelectedDungeonButton then
                self.SelectedDungeonButton.Border:Hide()
            end
            self:HidePBButtons(1)
            self:ShowCharacterFrames(self.SelectedSeason)
        end)
        self:AddMouseoverTooltip(F.TotalStatsButton, L["Show your Stats for the selected Season"])
                
        -- Scale Slider
        F.ScaleSlider = CreateFrame("Slider", nil, F, "OptionsSliderTemplate")
        F.ScaleSlider:SetMinMaxValues(0.5, 2)
        F.ScaleSlider:SetValueStep(0.05)
        F.ScaleSlider:SetValue(1)
        F.ScaleSlider:SetWidth(200)
        self:SetPoint(F.ScaleSlider, "BOTTOMRIGHT", F, "BOTTOMRIGHT", -20, 20)
        self:CreateText(F.ScaleSlider, "Text", {Anchor="TOP", RelativeTo="BOTTOM", yOffset=-2, text =L["Frame Scale"]})
        F.ScaleSlider:SetScript("OnMouseUp", function(s)
            F:SetScale(s:GetValue())
        end)

        local version = "v"..C_AddOns.GetAddOnMetadata("MPlusTimer", "Version")
        --@debug@
        if version == "v@project-version@" then
            version = L["Dev Build"]
        end
        --@end-debug@
        self:CreateText(F, "Title", {
            Anchor = "TOP",
            RelativeTo = "TOP",
            xOffset = 0,
            yOffset = -6,
            Font = "Expressway",
            FontSize = 12,
            Outline = "OUTLINE",
            ShadowColor = {0,0,0,1},
            ShadowOffset = {1,-1},
            Color = {1, 1, 1, 1},
            text = L["MPlusTimer "]..version
        })

        self:CreateEditPanel()
    end
end

function MPT:HidePBButtons(level)
    local F = self.BestTimeFrame
    if level >= 1 then -- Clicking on Level/Character Button
        StaticPopup_Hide("MPT_DELETE_RUN") -- hide when literally any button is pressed because the parameters have changed
        StaticPopup_Hide("MPT_DELETE_CHARACTER") -- hide when literally any button is pressed because the parameters have changed
        if F.PBDataText then F.PBDataText:Hide() end
        if F.PBDataText2 then F.PBDataText2:Hide() end
        if F.DeleteButton then F.DeleteButton:Hide() end
        if F.RunEditPanel then F.RunEditPanel:Hide() end
        if self.SelectedLevelButton then
            self.SelectedLevelButton.Border:Hide()
            self.SelectedLevel = nil
            if self.SelectedLevelButton.BorderFrame then self.SelectedLevelButton.BorderFrame:Hide() end
        end  
    end
    if level >= 2 then -- Clicking on Dungeon Button
        for k, v in pairs(F.LevelButtons or {}) do
            v:Hide()
        end
        if self.SelectedLevelButton then
            self.SelectedLevelButton.Border:Hide()
            self.SelectedLevel = nil
            if self.SelectedLevelButton.BorderFrame then self.SelectedLevelButton.BorderFrame:Hide() end
        end  
        if self.SelectedDungeonButton then
            self.SelectedDungeonButton.Border:Hide()
            self.SelectedDungeon = nil
        end   
    end
    if level >= 3 then -- Showing Dungeon Buttons
        for k, v in pairs(F.DungeonButtons or {}) do
            v:Hide()
        end     
    end
    if level >= 4 then -- Clicking on Season Button
        if self.SelectedSeasonButton then
            self.SelectedSeasonButton.Border:Hide()
            self.SelectedSeason = nil
        end
    end
    if level >= 5 then -- Frame opening
        for k, v in pairs(F.SeasonButtons or {}) do
            v:Hide()
        end        
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
    self.BestTimeFrame:Show()
    self:ShowSeasonFrames()
end

function MPT:ShowSeasonFrames() -- Showing Frame & Season Buttons
    local F = self.BestTimeFrame
    if not F then return end
    self:HidePBButtons(5)
    local first = true
    local last = 0
    self.SelectedSeason = self.seasonID
    self.SelectedDungeon = nil
    self.SelectedLevel = nil
    for i = 50, 1, -1 do
        if MPTSV.BestTime and MPTSV.BestTime[i] then
            local parent = first and F.SeasonButtonFrame or F.SeasonButtons[last]
            local btn = F.SeasonButtons[i]
            if not btn then
                btn = self:CreateButton(130, 25, parent, true, true, {0.3, 0.3, 0.3, 0.9}, {0.2, 0.6, 1, 0.5}, "Expressway", 13, {1, 1, 1, 1})
                F.SeasonButtons[i] = btn
            end
            btn = F.SeasonButtons[i]
            self:SetPoint(btn, "LEFT", parent, "LEFT", first and 10 or 140, 0)
            btn.Text:SetText(self.SeasonData[i].name)
            btn:Show()
            btn:SetScript("OnClick", function(s)
                self:HidePBButtons(4)
                self.SelectedSeasonButton = s
                self.SelectedSeason = i
                s.Border:Show()
                self:ShowDungeonFrames(i)
            end)
            first = false
            last = i
        end
    end
    F:Show()
    if F.SeasonButtons[self.seasonID] then
        self.SelectedSeasonButton = F.SeasonButtons[self.seasonID]
        self.SelectedSeasonButton.Border:Show()
    end
    self:ShowDungeonFrames(self.seasonID) -- Select Current Season when initially loaded
end

function MPT:ShowDungeonFrames(seasonID) -- Showing Dungeon Buttons
    local F = self.BestTimeFrame
    if not F then return end
    if F and seasonID then
        local num = 1
        self:HidePBButtons(3)   
        if not MPTSV.BestTime then MPTSV.BestTime = {} end
        for i, cmap in pairs(self.SeasonData[seasonID].Dungeons) do
            local parent = num == 1 and F.DungeonButtonFrame or F.DungeonButtons[num-1]
            local name = self:GetDungeonName(cmap)
            local btn = F.DungeonButtons[num]
            if not btn then
                btn = self:CreateButton(140, 40, parent, true, true, {0.3, 0.3, 0.3, 0.9}, {0.2, 0.6, 1, 0.5}, "Expressway", 15, {1, 1, 1, 1})
                F.DungeonButtons[num] = btn
            end
            self:SetPoint(btn, "TOP", parent, "TOP", 0, num == 1 and -10 or -50)
            btn:SetScript("OnClick", function(s)
                self:HidePBButtons(2)
                self.SelectedDungeonButton = s
                self.SelectedDungeon = cmap
                self:ShowLevelFrames(cmap, seasonID)
                s.Border:Show()
            end)
            btn.Text:SetText(name)
            btn:Show()
            num = num+1
        end        
    end
end


function MPT:ShowLevelFrames(cmap, seasonID) -- Showing Level Buttons
    local F = self.BestTimeFrame
    if not F then return end
    self:HidePBButtons(2)
    local num = 1
    local first = true
    for level = 100, 1, -1 do
        local pb = self:GetPB(cmap, level, seasonID)
        if pb or level == 100 then
            local btn = F.LevelButtons[num]
            local color = level == 100 and {0, 0.7, 0, 0.9} or {0.3, 0.3, 0.3, 0.9}
            if not btn then
                btn = self:CreateButton(90, 40, F.LevelContent, true, true, color, {0.2, 0.6, 1, 0.5}, "Expressway", 16, {1, 1, 1, 1})
                btn.BorderFrame = CreateFrame("Frame", nil, btn, "BackdropTemplate")
                btn.BorderFrame:SetAllPoints(btn)
                btn.BorderFrame:SetBackdrop({
                    edgeFile = "Interface\\Buttons\\WHITE8x8",
                    edgeSize = 2,
                })
                btn.BorderFrame:SetBackdropBorderColor(1, 1, 1, 1)
                btn.BorderFrame:Hide()
                F.LevelButtons[num] = btn
            end
            self:SetPoint(btn, "TOP", F.LevelContent, "TOP", -5, num == 1 and -5 or ((num-1)*-45)-5)
            btn.BG:SetColorTexture(unpack(color))
            if level ~= 100 then
                btn:SetScript("OnClick", function(s)
                    self:HidePBButtons(1)
                    self.SelectedLevelButton = s
                    self.SelectedLevel = level
                    self:ShowPBDataFrame(seasonID, cmap, level)
                    s.Border:Show()
                end)
                if first then
                    first = false
                    self.SelectedLevelButton = btn
                    self.SelectedLevel = level
                    self:ShowPBDataFrame(seasonID, cmap, level)
                    btn.Border:Show()
                end 
                btn.Text:SetText(level)
            else
                btn:SetScript("OnClick", function(s)
                    self:ShowEditPanel(seasonID, cmap)
                end)
                btn.Text:SetText(L["+ Add Run"])
            end
            btn:Show()
            num = num+1
        end
    end
    F.LevelContent:SetHeight(num*50)
end

function MPT:ShowCharacterFrames(seasonID)
    local F = self.BestTimeFrame
    if not F then return end
    self:HidePBButtons(2)
    local num = 1
    local first = true
    local history = MPTSV.History and MPTSV.History[seasonID]
    if history then
        num = self:AddCharacterButton({name = L["Total"]}, num, seasonID, nil, {r = 0, g = 0.7, b = 0, a = 0.9}) -- Total Stats Button
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
        btn.BorderFrame = CreateFrame("Frame", nil, btn, "BackdropTemplate")
        btn.BorderFrame:SetAllPoints(btn)
        btn.BorderFrame:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 3,
        })
        btn.BorderFrame:SetBackdropBorderColor(1, 1, 1, 1)
        btn.BorderFrame:Hide()
        F.LevelButtons[num] = btn        
    end
    self:SetPoint(btn, "TOP", F.LevelContent, "TOP", -5, num == 1 and -5 or ((num-1)*-45)-5)
    local color = color or self:GetClassColor(data.class)
    btn.BG:SetColorTexture(color.r, color.g, color.b, color.a)
    btn.colors = color
    btn:SetScript("OnClick", function(s)
        if self.SelectedLevelButton then -- this gets niled on the hiding so need to do it before
            local color = self.SelectedLevelButton.colors
            self.SelectedLevelButton.BG:SetColorTexture(color.r, color.g, color.b, color.a)
        end
        self:HidePBButtons(1)
        self.SelectedLevelButton = btn
        self.SelectedCharacter = G
        self:ShowTotalStatsFrame(seasonID, G, G)
        --btn.Border:Show()
        if data.class == "PRIEST" then
            btn.BorderFrame:SetBackdropBorderColor(1, 0, 0, 1) -- use red border for priests
        end
        btn.BorderFrame:Show()
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
        --btn.Border:Show()
        if data.class == "PRIEST" then
            btn.BorderFrame:SetBackdropBorderColor(1, 0, 0, 1) -- use red border for priests
        end
        btn.BorderFrame:Show()
    end
    num = num+1  
    return num   
end


function MPT:ShowPBDataFrame(seasonID, cmap, level) -- Showing PB Data
    local F = self.BestTimeFrame
    if not F then return end
    if F.PBDataFrame then
        self:HidePBButtons(1)
        local pbdata = self:GetPB(cmap, level, seasonID)
        local text = ""
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
            text = string.format(L["Dungeon: %s\nTime: %s\n"], self:GetDungeonName(cmap), self:FormatTime(pbdata.finish/1000))
            for i=1, #(pbdata["BossNames"] or {}) do
                if pbdata["BossNames"] and pbdata["BossNames"][i] and pbdata[i] then
            text = text..string.format("%s: %s\n", pbdata["BossNames"][i] or L["Unknown"], self:FormatTime(pbdata[i]))
                end
            end
            local date = self:GetDateFormat(pbdata.date)
            if date == "" then date = L["No Date - Imported or manually Added Run"] else date = L["Date: "]..date end
            text = text..string.format(L["Enemy Forces: %s\n%s\n"], self:FormatTime(pbdata.forces), date)       
            F.DeleteButton:Show()
            self:AddMouseoverTooltip(F.DeleteButton, L["Delete the currently selected run from your saved best times.\nIt does not remove it from your total run history."])
            F.DeleteButton.Text:SetText(L["Delete Run"])
            F.DeleteButton:SetScript("OnClick", function(s)
                StaticPopup_Show("MPT_DELETE_RUN")
            end)
        end
        if completedruns > 0 or depletedruns > 0 or abandonedruns > 0 then
            local runtext = completedruns + depletedruns == 1 and L["Run"] or L["Runs"]
            text = text..string.format(L["Total: |cFFFFFF4D%s|r %s (|cFF00FF00%s|r Intime, |cFFFF0000%s|r Depleted, |cFFFFAA00%s|r Abandoned)"], completedruns + depletedruns, runtext, completedruns, depletedruns, abandonedruns)
        end
        if text ~= "" then
            if not F.PBDataText then
                F.PBDataText = F.PBDataFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                self:SetPoint(F.PBDataText, "TOPLEFT", F.PBDataFrame, "TOPLEFT", 5, -10)
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
        self:HidePBButtons(1)
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
        if not history then return end
        if characteronly then
            history = history[G]
            if not history then return end
            for i, cmap in pairs(self.SeasonData[seasonID].Dungeons) do
                local data = history[cmap]
                if data and (data.intime > 0 or data.depleted > 0) then
                    local name = self:Utf8Sub(self:GetDungeonName(cmap), 1, 15)
                    text = text..string.format("|cFF3399FF%s|r:\n", name)
                    local runtext = data.intime + data.depleted == 1 and L["Run"] or L["Runs"]
                    text2 = text2..string.format(L["|cFFFFFF4D%s|r %s (|cFF00FF00%s|r Intime, |cFFFF0000%s|r Depleted, |cFFFFAA00%s|r Abandoned)"],
                    data.intime + data.depleted, runtext, data.intime, data.depleted, data.abandoned)
                    local bestkey = data.fastestrun and self:FormatTime(data.fastestrun/1000)
                    if bestkey then
                        text2 = text2..string.format(L[", Best Key: |cFF00FF00+%s|r in |cFFFFFF4D%s|r\n"], data.highestrun, bestkey)
                    else
                        text2 = text2.."\n"
                    end
                    totalcompletedkeys = totalcompletedkeys + data.intime
                    totaldepletedkeys = totaldepletedkeys + data.depleted
                    totalabandoned = totalabandoned + data.abandoned
                end
            end    
            
            F.DeleteButton.Text:SetText(L["Delete Character"])
            F.DeleteButton:SetScript("OnClick", function(s)
                StaticPopup_Show("MPT_DELETE_CHARACTER")
            end)
            F.DeleteButton:Show()
            self:AddMouseoverTooltip(F.DeleteButton, L["Delete the selected character from your saved history.\nThis does not delete their runs from your saved best times.\nKeep in mind that these will be added again when you log into that character\nDeletion is meant for characters that no longer exist or have been transferred"])
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
                local runtext = completed + depleted == 1 and L["Run"] or L["Runs"]
                text2 = text2..string.format(L["|cFFFFFF4D%s|r %s (|cFF00FF00%s|r Intime, |cFFFF0000%s|r Depleted, |cFFFFAA00%s|r Abandoned)"],
                completed + depleted, runtext, completed, depleted, abandoned)
                local bestkey = fastestrun[cmap] and self:FormatTime(fastestrun[cmap]/1000)
                if bestkey then
                    text2 = text2..string.format(L[", Best Key: |cFF00FF00+%s|r in |cFFFFFF4D%s|r\n"], highestkey[cmap], bestkey)
                else
                    text2 = text2.."\n"
                end
            end
        end        
        text = string.format(L["Total Run Stats: |cFFFFFF4D%s|r Runs (|cFF00FF00%s|r Intime, |cFFFF0000%s|r Depleted, |cFFFFAA00%s|r Abandoned)\n"], totalcompletedkeys+totaldepletedkeys, totalcompletedkeys, totaldepletedkeys, totalabandoned)..text
        if not F.PBDataText then
            F.PBDataText = F.PBDataFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self:SetPoint(F.PBDataText, "TOPLEFT", F.PBDataFrame, "TOPLEFT", 5, -10)
        end
        if not F.PBDataText2 then
            F.PBDataText2 = F.PBDataFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self:SetPoint(F.PBDataText2, "TOPLEFT", F.PBDataFrame, "TOPLEFT", 155, -30)
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
    end
end
