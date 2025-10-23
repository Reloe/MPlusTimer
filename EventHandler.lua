local _, MPT = ...

local f = CreateFrame("Frame")
f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_SLOTTED")
f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHALLENGE_MODE_START")
f:RegisterEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED")
f:RegisterEvent("CHALLENGE_MODE_COMPLETED")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
f:RegisterEvent("SCENARIO_POI_UPDATE")
f:RegisterEvent("INSTANCE_ABANDON_VOTE_FINISHED")

f:SetScript("OnEvent", function(self, e, ...)
    MPT:EventHandler(e, ...)
end)

function MPT:ToggleEventRegister(On)
    if On then
        f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        f:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
        f:RegisterEvent("PLAYER_REGEN_ENABLED")
        f:RegisterEvent("PLAYER_DEAD")
        if not self.Timer then
            self.Timer = C_Timer.NewTimer(self.UpdateRate, function()
                self.Timer = nil
                self:EventHandler("FRAME_UPDATE")
            end)
        end
    else
        if GetRestrictedActionStatus then return end -- disable for midnight. Edit this later when I know how the API works
        f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        f:UnregisterEvent("UNIT_THREAT_LIST_UPDATE")
        f:UnregisterEvent("PLAYER_REGEN_ENABLED")
        f:UnregisterEvent("PLAYER_DEAD")
    end
end

function MPT:EventHandler(e, ...) -- internal checks whether the event comes from addon comms. We don't want to allow blizzard events to be fired manually
    if e == "INSTANCE_ABANDON_VOTE_FINISHED" and C_ChallengeMode.IsChallengeModeActive() then
        local success = ...
        self:AddHistory(false, self.cmap, self.level, false, success)
    elseif e == "CHALLENGE_MODE_KEYSTONE_SLOTTED" and MPTSV.CloseBags then
        CloseAllBags()
    elseif e == "CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN" and MPTSV.KeySlot then
        local index = select(3, GetInstanceInfo())
        if index == 8 or index == 23 then
            local IDs = {138019, 158923, 180653, 186159, 187786, 151086}
            for bagID = 0, NUM_BAG_SLOTS do
                for invID = 1, C_Container.GetContainerNumSlots(bagID) do
                    local itemID = C_Container.GetContainerItemID(bagID, invID)
                    if itemID and tContains(IDs, itemID) then 
                        local item = ItemLocation:CreateFromBagAndSlot(bagID, invID)
                        if item:IsValid() then
                            local canuse = C_ChallengeMode.CanUseKeystoneInCurrentMap(item)
                            if canuse then
                                C_Container.PickupContainerItem(bagID, invID)
                                C_Timer.After(0.1, function()
                                        if CursorHasItem() then
                                            C_ChallengeMode.SlotKeystone()
                                        end
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    elseif e == "PLAYER_ENTERING_WORLD" then
        local login, reload, delayed = ...
        if login or reload then
            C_Timer.After(10, function() self:EventHandler("PLAYER_ENTERING_WORLD", false, false, true) end) -- re initiate after 10 seconds as a lot of this data is not available on initial login
        end
        if self.HideTracker and not self.Hooked then
            self.Hooked = true
            local frame = C_AddOns.IsAddOnLoaded("!KalielsTracker") and _G["!KalielsTrackerFrame"] or ObjectiveTrackerFrame
            hooksecurefunc(frame, "Show", function() 
                if IsInInstance() and C_ChallengeMode.IsChallengeModeActive() then frame:Hide() end
            end)
        end
        C_MythicPlus.RequestMapInfo()
        local seasonID = C_MythicPlus.GetCurrentSeason()
        if C_ChallengeMode.IsChallengeModeActive() then
            self:Init(false)
            self:ToggleEventRegister(true)
        else
            self:ShowFrame(false)
            self:ToggleEventRegister(false)
        end
        if seasonID > 0 and (login or reload or delayed) then
            if not MPTSV.BestTime then MPTSV.BestTime = {} end
            if not MPTSV.History then MPTSV.History = {} end
            if not MPTSV.BestTime[seasonID] then MPTSV.BestTime[seasonID] = {} end
            if not MPTSV.History[seasonID] then MPTSV.History[seasonID] = {} end
            MPTSV.HistoryData = MPTSV.HistoryData or {}
            self.seasonID = seasonID
            local G = UnitGUID("player")
            -- only allow delayed data because data on initial login contains other character's data.
            if delayed and MPTSV.History and MPTSV.History[seasonID] then
                self:AddCharacterHistory()
            end
        end
    elseif e == "CHALLENGE_MODE_DEATH_COUNT_UPDATED" then
        self:UpdateKeyInfo(false, true)
    elseif e == "CHALLENGE_MODE_START" then
        self:Init()
        self:ToggleEventRegister(true)
    elseif e == "CHALLENGE_MODE_COMPLETED" then
        self:UpdateTimerBar(false, true, false)
        self:UpdateEnemyForces(false, false, true)
        self:SetSV(false, false, false, true)
        self:ToggleEventRegister(false)
        C_MythicPlus.RequestMapInfo() -- try to refresh data
        C_Timer.After(5, function() self:AddCharacterHistory() end) -- add to history 5s delayed to make sure blizzard API has the data
    elseif e == "SCENARIO_CRITERIA_UPDATE" and C_ChallengeMode.IsChallengeModeActive() then
        self:UpdateBosses(false, false)
        self:UpdateEnemyForces(false, false, false)
    elseif e == "SCENARIO_POI_UPDATE" and C_ChallengeMode.IsChallengeModeActive() then
        self:UpdateEnemyForces(false, false, false)
    elseif e == "FRAME_UPDATE" and C_ChallengeMode.IsChallengeModeActive() then
        if not self.Timer then
            self.Timer = C_Timer.NewTimer(self.UpdateRate, function()
                self.Timer = nil
                self:EventHandler("FRAME_UPDATE")
            end)
            self:UpdateTimerBar()
        end

    elseif e == "PLAYER_LOGIN" then        
        if not MPTSV then -- first load of the addon
            MPTSV = {}            
            MPTSV.LowerKey = true
            MPTSV.CloseBags = true
            MPTSV.KeySlot = true
            MPTSV.BestTime = {}
            self:CreateProfile("default") 
        else
            self:ModernizeProfile(false, true)
            self:LoadProfile()
        end        
        if MPTSV.debug then
            MPTAPI = MPT
            print("Debug mode for MPlusTimer is currently enabled. You can disable it with '/mpt debug'")
        end
    elseif e == "COMBAT_LOG_EVENT_UNFILTERED" and C_ChallengeMode.IsChallengeModeActive() then
        if GetRestrictedActionStatus then return end -- disable for midnight. Edit this later when I know how the API works
        local _, se, _, _, _, _, _, destGUID = CombatLogGetCurrentEventInfo()
        if (se == "UNIT_DIED" or se == "UNIT_DESTROYED" or se == "UNIT_DISSIPATES") and destGUID then
            if self.CurrentPull and self.CurrentPull[destGUID] then
                self.CurrentPull[destGUID] = "DEAD"
                if not self.done then self:UpdateCurrentPull() end
            end
        end
    elseif e == "UNIT_THREAT_LIST_UPDATE" and C_ChallengeMode.IsChallengeModeActive() and InCombatLockdown() then
        if GetRestrictedActionStatus then return end -- disable for midnight. Edit this later when I know how the API works
        local unit = ...
        if unit and UnitExists(unit) then
            local guid = UnitGUID(unit)
            self.CurrentPull = self.CurrentPull or {}
            if guid and not self.CurrentPull[guid] then
                local npcid = select(6, strsplit("-", guid))
                if npcid then                        
                    local value = MDT and MDT:GetEnemyForces(tonumber(npcid))
                    if value and value ~= 0 then
                        self.CurrentPull[guid] = {value, (value / (self.totalcount)) * 100}
                        self:UpdateCurrentPull()         
                    end
                end
            end            
        end
    elseif (e == "PLAYER_REGEN_ENABLED" or e == "PLAYER_DEAD") and C_ChallengeMode.IsChallengeModeActive() then
        if GetRestrictedActionStatus then return end -- disable for midnight. Edit this later when I know how the API works
        for k, _ in pairs(self.CurrentPull or {}) do
            self.CurrentPull[k] = nil
        end
        if not self.done then self:UpdateCurrentPull() end
    end
end
    
        
        --[[
    elseif e == "GOSSIP_SHOW" then
        if UnitExists("npc") and (not aura_env.config.gossipctrl or not IsControlKeyDown()) then
            local GUID = UnitGUID("npc")
            local id = select(6, strsplit("-", GUID))
            id = tonumber(id)
            if aura_env.gossips[id] and aura_env.gossips[id].enabled then
                local title = C_GossipInfo.GetOptions()
                local num = aura_env.gossips[id].number
                if title[num] and title[num].gossipOptionID then
                    local popupWasShown = aura_env.popup()
                    C_GossipInfo.SelectOption(title[num].gossipOptionID)
                    local popupIsShown = aura_env.popup()
                    if popupIsShown then
                        if not popupWasShown then
                            StaticPopup1Button1:Click()
                        end
                    end
                    C_Timer.After(0.3, function()
                            C_GossipInfo.CloseGossip()
                    end)
                end
            end
        end
    for index = 1, STATICPOPUP_NUMDIALOGS do
        local frame = _G["StaticPopup"..index]
        if frame and frame:IsShown() then
            return true
        end
    end
    return false
end
        ]]