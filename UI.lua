local _, MPT = ...

local options = { 
	name = "General Settings",
	handler = MPTUI,
	type = "group",
	args = {
        General = {
            type = "group",
            name = "General",
            order = 1,
            args = {
                HideTracker = {
			        type = "toggle",
                    order = 2,
			        name = "Hide Objective Tracker",
			        desc = "Hides Blizzard's Objective Tracker during an active M+",
			        set = function(_, value) MPT:SetSV("HideTracker", value) end,
                    get = function() return MPT.HideTracker end,
		        },        
		        LowerKey = {
			        type = "toggle",
                    order = 3,
			        name = "Data from Lower KeyLevel",
			        desc = "Get Split Timers from one key level lower if no data for current level exists",
			        set = function(_, value) MPT:SetSV("LowerKey", value) end,
                    get = function() return MPT.LowerKey end,
		        },
        
		        Spacing= {
			        type = "range",
                    order = 5,
                    min= -5,
                    max = 10,
                    step = 1,
			        name = "Bar Spacing",
			        desc = "Spacing for each Bar",
			        set = function(_, value) MPT:SetSV("Spacing", value, true) end,
                    get = function() return MPT.Spacing end,
		        },
        
		        UpdateRate = {
			        type = "range",
                    order = 6,
                    min = 0.1,
                    max = 3, 
                    step = 0.1,
			        name = "Update Interval",
			        desc = "How often the timer updates",
			        set = function(_, value) MPT:SetSV("UpdateRate", value) end,
                    get = function() return MPT.UpdateRate end,
		        },
        
		        Scale = {
			        type = "range",
                    order = 4,
                    min = 0.1,
                    max = 3,
                    step = 0.01,
			        name = "Group Scale",
			        desc = "Scale of the entire Display",
			        set = function(_, value) MPT:SetSV("Scale", value) if MPT.Frame and MPT.Frame:IsShown() then MPT.Frame:SetScale(value) end end,
                    get = function() return MPT.Scale end,
		        },
        		
                Preview = {
                    type = "execute",
                    order = 1,
                    name = "Preview",
                    desc = "Show a preview of the Display",
                    func = function() 
                        if not MPT.IsPreview then -- not currently in preview
                            MPT:Init(true)
                            MPT:MoveFrame(true) 
                        elseif C_ChallengeMode.IsChallengeModeActive() then -- in preview and currently in m+ so we display real states
                            MPT:Init(false)
                            MPT:MoveFrame(false)
                        elseif MPT.Frame and MPT.Frame:IsShown() then -- in preview but not in m+ so we hide the frame
                            MPT.Frame:Hide()
                            MPT.IsPreview = false
                        end 
                    end,
                },
            },
        },
        TimerBar = {
            type = "group",
            name = "Timer Bar",
            order = 3,
            args = {
                ChestTimerDisplay = {
			        type = "select",
                    order = 7,
                    values = {
                        [1] = "Relevant Timers",
                        [2] = "All Timers",
                        [3] = "No Timers",
                    },
			        name = "Chest Timer Mode",
			        desc = "Choose which Chest Timers you want to see",
			        set = function(_, value) MPT:SetSV({"TimerBar", "ChestTimerDisplay"}, value, true) end,
                    get = function() return MPT.TimerBar.ChestTimerDisplay end,
		        },
            },
	    },
    },
}


function MPTUI:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MPTUI", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MPTUI", "Mythic Plus Timer")
	self:RegisterChatCommand("mpt", "SlashCommand")
	self:RegisterChatCommand("mythicplus", "SlashCommand")
	self:RegisterChatCommand("mythicplusTimer", "SlashCommand")
	self.message = 3
end

