local _, MPT = ...

local f = CreateFrame("Frame")
f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_SLOTTED")
f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHALLENGE_MODE_START")
f:RegisterEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED")
f:RegisterEvent("CHALLENGE_MODE_COMPLETED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("SCENARIO_CRITERIA_UPDATE")

f:SetScript("OnEvent", function(self, e, ...)
    MPT:EventHandler(e, ...)
end)

function MPT:EventHandler(e, ...) -- internal checks whether the event comes from addon comms. We don't want to allow blizzard events to be fired manually
    if e == "CHALLENGE_MODE_KEYSTONE_SLOTTED" and MPT.CloseBags then
        CloseAllBags()
    elseif e == "CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN" and MPT.KeySlot then
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
        if MPT.HideTracker and not MPT.Hooked then
            MPT.Hooked = true
            local frame = MPT.Kaliels and _G["!KalielsTrackerFrame"] or ObjectiveTrackerFrame
            hooksecurefunc(frame, "Show", function() 
                if IsInInstance() and C_ChallengeMode.IsChallengeModeActive() then frame:Hide() end
            end)
        end
        if C_ChallengeMode.IsChallengeModeActive() then
            MPT:Init(false)
        elseif MPT.Frame and MPT.Frame:IsShown() then 
            MPT.Frame:Hide()
        end
    elseif e == "ZONE_CHANGED_NEW_AREA" then
        if C_ChallengeMode.IsChallengeModeActive() then
            MPT:Init(false)
        end
    elseif e == "CHALLENGE_MODE_DEATH_COUNT_UPDATED" then
        MPT:UpdateKeyInfo(false, true)
    elseif e == "CHALLENGE_MODE_START" then
        MPT:Init()
        C_Timer.After(MPT.UpdateRate, function()
            MPT:EventHandler("FRAME_UPDATE")
        end)
    elseif e == "CHALLENGE_MODE_COMPLETED" then
        MPT:UpdateTimerBar(false, true)
        MPT:UpdateEnemyForces(false, false)
        MPT:SaveToSV(true) -- 
    elseif e == "SCENARIO_CRITERIA_UPDATE" then
        MPT:UpdateBosses(false, false)
        MPT:UpdateEnemeyForces(false, false, false)
    elseif e == "FRAME_UPDATE" and C_ChallengeMode.IsChallengeModeActive() then
        C_Timer.After(MPT.UpdateRate, function()
            MPT:EventHandler("FRAME_UPDATE")
        end)
        MPT:UpdateTimerBar()

        

    elseif e == "PLAYER_LOGIN" then        
        if not MPTSV then -- first load of the addon
            MPTSV = {}
            MPT:CreateProfile("default") 
        else       
            MPT:LoadProfile()
        end
        C_MythicPlus.RequestMapInfo()
        local seasonID = C_MythicPlus.GetCurrentSeason()
        if C_ChallengeMode.IsChallengeModeActive() then
            MPT:Init(false)
            C_Timer.After(MPT.UpdateRate, function()
                MPT:EventHandler("FRAME_UPDATE")
            end)
        end
        if seasonID > 0 then
            if MPT.BestTime and MPT.BestTime.seasonID then
                if seasonID > MPT.BestTime.seasonID then                    
                    if MPTSV.Profiles[MPT.ActiveProfile] then
                        MPTSV.Profiles[MPT.ActiveProfile].BestTime = {}
                        MPTSV.Profiles[MPT.ActiveProfile].BestTime.seasonID = seasonID
                    end
                end
            else 
                MPT.BestTime = {}
                MPT.BestTime.seasonID = seasonID
                if MPTSV.Profiles[MPT.ActiveProfile] then
                    MPTSV.Profiles[MPT.ActiveProfile].BestTime = {}
                    MPTSV.Profiles[MPT.ActiveProfile].BestTime.seasonID = seasonID
                end
            end
        end
        if MPTSV.debug then
            MPTAPI = MPT
            print("Debug mode for Mythic Plus Timer is currently enabled. You can disable it with '/mpt debug'")
        end
    
        
        --[[
    elseif e == "GOSSIP_SHOW" then
        if MPT.Kaliels and MPT.HideTracker then
            local frame = aura_env.frame
            C_Timer.After(0.2, function()
                    if IsInInstance() and C_ChallengeMode.IsChallengeModeActive() then frame:Hide() end
            end)
        end
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
    elseif e == "PLAYER_LOGIN" then
        MPT.Kaliels = C_AddOns.IsAddOnLoaded("!KalielsTracker")

        aura_env.popup = function()
    for index = 1, STATICPOPUP_NUMDIALOGS do
        local frame = _G["StaticPopup"..index]
        if frame and frame:IsShown() then
            return true
        end
    end
    return false
end
        ]]
    end
end