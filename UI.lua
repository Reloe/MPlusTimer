local _, MPT = ...

MPT.LSM = LibStub("LibSharedMedia-3.0")
MPT.LSM:Register("font", "Expressway", [[Interface\Addons\MPlusTimer\Expressway.TTF]])

local fontlist = MPT.LSM:List("font")
local fontTable = {}
for _, font in ipairs(fontlist) do
    fontTable[font] = font
end

local texturelist = MPT.LSM:List("statusbar")
local textureTable = {}
for _, texture in ipairs(texturelist) do
    textureTable[texture] = texture
end

function MPT:CreateTextSetting(name, key, order, Color)
    local settings = {
        type = "group",
        name = name,
        order = order,
        args = {}
    }    
    settings.args.enabled = self:CreateToggle(1, "Enable", "Enabled", {key, "enabled"}, true)
    settings.args.Anchor = self:CreateDropDown(2, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER"}, "Anchor", "", {key, "Anchor"}, true)
    settings.args.RelativeTo = self:CreateDropDown(3, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER"}, "Relative To", "", {key, "RelativeTo"}, true)
    settings.args.xOffset = self:CreateRange(4, "X Offset", "X Offset of the Text", -1000, 1000, 1, {key, "xOffset"}, true)
    settings.args.yOffset = self:CreateRange(5, "Y Offset", "Y Offset of the Text", -1000, 1000, 1, {key, "yOffset"}, true)
    settings.args.Font = self:CreateDropDown(6, fontTable, "Font", "", {key, "Font"}, true)
    settings.args.FontSize = self:CreateRange(7, "Font Size", "Size of the Font", 6, 40, 1, {key, "FontSize"}, true)
    settings.args.Outline = self:CreateDropDown(8, {["NONE"] = "None", ["OUTLINE"] = "Outline", ["THICKOUTLINE"] = "Thick Outline", ["MONOCHROME"] = "Monochrome"}, "Font Outline", "", {key, "Outline"}, true)
    settings.args.ShadowColor = self:CreateColor(9, "Shadow Color", "", {key, "ShadowColor"}, true)
    settings.args.ShadowXOffset = self:CreateRange(10, "Shadow X Offset", "Shadow X Offset of the Text", -5, 5, 1, {key, "ShadowOffset", 1}, true)
    settings.args.ShadowYOffset = self:CreateRange(11, "Shadow Y Offset", "Shadow Y Offset of the Text", -5, 5, 1, {key, "ShadowOffset", 2}, true)
    if Color then settings.args.Color = self:CreateColor(12, "Color", "", {key, "Color"}, true) end
    return settings
end

function MPT:CreateStatusBarSettings(name, key, order)
    local settings = {
        type = "group",
        name = name,
        order = order,
        args = {}
    }    
    settings.args.Width = self:CreateRange(1, "Width", "Width of the Status Bar", 50, 1000, 1, {key, "Width"}, true)
    settings.args.Height = self:CreateRange(2, "Height", "Height of the Status Bar", 6, 200, 1, {key, "Height"}, true)
    settings.args.xOffset = self:CreateRange(3, "X Offset", "X Offset of the Status Bar", -1000, 1000, 1, {key, "xOffset"}, true)
    settings.args.yOffset = self:CreateRange(4, "Y Offset", "Y Offset of the Status Bar", -1000, 1000, 1, {key, "yOffset"}, true)
    settings.args.Texture = self:CreateDropDown(5, textureTable, "Texture", "", {key, "Texture"}, true)
    settings.args.BorderColor = self:CreateColor(7, "Border Color", "", {key, "BorderColor"}, true)
    settings.args.BorderSize = self:CreateRange(8, "Border Size", "Size of the Border", 1, 10, 1, {key, "BorderSize"}, true)
    settings.args.BackgroundColor = self:CreateColor(9, "Background Color", "", {key, "BackgroundColor"}, true)
    return settings
end

function MPT:CreateToggle(order, name, desc, key, update)
    local t = {}
    t.order = order
    t.type = "toggle"
    t.name = name
    t.desc = desc
    t.set = function(_, value) self:SetSV(key, value, update) end
    t.get = function() return self:GetSV(key) end
    return t
end

function MPT:CreateColor(order, name, desc, key, update)
    local t = {}
    t.order = order
    t.type = "color"
    t.hasAlpha = true
    t.name = name
    t.desc = desc
    t.set = function(_, r, g, b, a) self:SetSV(key, {r, g, b, a}, update) end
    t.get = function() return unpack(self:GetSV(key)) end
    return t
end

function MPT:CreateDropDown(order, values, name, desc, key, update)
    local t = {}
    t.order = order
    t.values = values
    t.type = "select"
    t.name = name
    t.desc = desc
    t.set = function(_, value) self:SetSV(key, value, update) end
    t.get = function() return self:GetSV(key) end
    return t
end

function MPT:CreateRange(order, name, desc, min, max, step, key, update)
    local t = {}
    t.order = order
    t.type = "range"
    t.name = name
    t.desc = desc
    t.min = min
    t.max = max
    t.step = step
    t.set = function(_, value) self:SetSV(key, value, update) end
    t.get = function() return self:GetSV(key) end
    return t
end

local GeneralOptions = {
    type = "group",
    name = "General Options",
    order = 1,
    args = {
        Preview = {
            type = "execute",
            order = 1,
            name = "Preview",
            desc = "Show a preview of the Display",
            func = function() 
                if not MPT.IsPreview then -- not currently in preview
                    MPT:Init(true) -- Frame is set to movable in here as well
                elseif C_ChallengeMode.IsChallengeModeActive() then -- in preview and currently in m+ so we display real states
                    MPT:Init(false)
                    MPT:MoveFrame(false)
                elseif MPT.Frame and MPT.Frame:IsShown() then -- in preview but not in m+ so we hide the frame
                    MPT:MoveFrame(false)
                    MPT:ShowFrame(false)
                end 
            end,         
        },        
        HideTracker = MPT:CreateToggle(2, "Hide Objective Tracker", "Hides Blizzard's Objective Tracker during an active M+", "HideTracker"),
        LowerKey = MPT:CreateToggle(3, "Data from Lower KeyLevel", "Get Split Timers from one key level lower if no data for current level exists", "LowerKey"),
        Spacing = MPT:CreateRange(4, "Bar Spacing", "Spacing for each Bar", -5, 10, 1, "Spacing", true),
        UpdateRate = MPT:CreateRange(5, "Update Interval", "How often the timer updates", 0.1, 3, 0.1, "UpdateRate"),
        Scale = MPT:CreateRange(6, "Group Scale", "Scale of the entire Display", 0.1, 3, 0.01, "Scale", true),
        CloseBags = MPT:CreateToggle(7, "Close Bags", "Automatically close bags after inserting the Keystone", "CloseBags"),
        Keyslot = MPT:CreateToggle(8, "Automatic Keyslot", "Automatically insert Keystone", "KeySlot"),     	
    }
}
local Position = {
    type = "group",
    name = "Frame Position",
    order = 2,
    args = {
        Anchor = MPT:CreateDropDown(1, {["CENTER"] = "CENTER", ["TOP"] = "TOP", ["BOTTOM"] = "BOTTOM", ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Anchor", "", {"Position", "Anchor"}, true),
        relativeTo = MPT:CreateDropDown(2, {["CENTER"] = "CENTER", ["TOP"] = "TOP", ["BOTTOM"] = "BOTTOM", ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Relative To", "", {"Position", "relativeTo"}, true),
        xOffset = MPT:CreateRange(3, "X Offset", "X Offset", -4000, 4000, 1, {"Position", "xOffset"}, true),
        yOffset = MPT:CreateRange(4, "Y Offset", "Y Offset", -4000, 4000, 1, {"Position", "yOffset"}, true),        
    }
}
local Background = {
    type = "group",
    name = "Background",
    order = 3,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable Background", {"Background", "enabled"}, true),
        Color = MPT:CreateColor(2, "Color", "Color of the Background", {"Background", "Color"}, true),
        BorderColor = MPT:CreateColor(3, "Border Color", "Color of the Border", {"Background", "BorderColor"}, true),
        BorderSize = MPT:CreateRange(4, "Border Size", "Size of the Border", 1, 10, 1, {"Background", "BorderSize"}, true),
    }
}

local General = {
    type = "group",
    name = "General",
    handler = MPTUI,
    order = 1,
    childGroups = "tab",
    args = {
        GeneralOptions = GeneralOptions,
        Position = Position,
        Background = Background,  
    },
}


local KeyInfoBar = {
    type = "group",
    name = "Key Info Bar",
    order = 2,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable Key Info Bar", {"KeyInfo", "enabled"}, true),
        Width = MPT:CreateRange(2, "Width", "Width of the Key Info Bar", 50, 1000, 1, {"KeyInfo", "Width"}, true),
        Height = MPT:CreateRange(3, "Height", "Height of the Key Info Bar", 10, 200, 1, {"KeyInfo", "Height"}, true),
        xOffset = MPT:CreateRange(4, "X Offset", "X Offset of the Key Info Bar", -500, 500, 1, {"KeyInfo", "xOffset"}, true),
        yOffset = MPT:CreateRange(5, "Y Offset", "Y Offset of the Key Info Bar", -500, 500, 1, {"KeyInfo", "yOffset"}, true),
    }
}
local KeyLevel = MPT:CreateTextSetting("Key Level", "KeyLevel", 2, true)
local DungeonName = MPT:CreateTextSetting("Dungeon Name", "DungeonName", 3, true)
local Affixes = MPT:CreateTextSetting("Affixes", "AffixIcons", 4, true)
local Deaths = MPT:CreateTextSetting("Deaths", "DeathCounter", 5, true)
local DeathIcon = {
    type = "group",
    name = "Death Icon",
    order = 6,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable Death Icon", {"enabled", "Iconenabled"}, true),
        iconAnchor = MPT:CreateDropDown(2, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER"}, "Anchor", "", {"DeathCounter", "IconAnchor"}, true),
        iconRelativeTo = MPT:CreateDropDown(3, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER"}, "Relative To", "", {"DeathCounter", "IconRelativeTo"}, true),
        xOffset = MPT:CreateRange(4, "X Offset", "X Offset of the Death Icon", -500, 500, 1, {"Icon XOffset", "IconxOffset"}, true),
        yOffset = MPT:CreateRange(5, "Y Offset", "Y Offset of the Death Icon", -500, 500, 1, {"Icon YOffset", "IconyOffset"}, true),
    }
}
local KeyInfo = {
    name = "Key Info Bar",
    handler = MPTUI,
    type = "group",
    order = 2,
    childGroups = "tab",
    args = {
        KeyInfoBar = KeyInfoBar,
        KeyLevel = KeyLevel,
        DungeonName = DungeonName,
        Affixes = Affixes,
        Deaths = Deaths,
    },
}

local TimerStatusBar = MPT:CreateStatusBarSettings("Timer Bar", "TimerBar", 1)
TimerStatusBar.args.ChestTimerDisplay = MPT:CreateDropDown(10, {[1] = "Relevant Chest Timer", [2] = "All Chest Timers", [3] = "No Chest Timer"}, "Chest Timer Display", "Which Chest Timers are to be displayed", {"TimerBar", "ChestTimerDisplay"}, true)
TimerStatusBar.args.DepleteColor = MPT:CreateColor(10, "Deplete Color", "Color of the Timer Bar when the timer is depleted", {"TimerBar", "Color", 1})
TimerStatusBar.args.OneChestColor = MPT:CreateColor(11, "One Chest Color", "Color of the Timer Bar when you are in the one chest range", {"TimerBar", "Color", 2})
TimerStatusBar.args.TwoChestColor = MPT:CreateColor(12, "Two Chest Color", "Color of the Timer Bar when you are in the two chest range", {"TimerBar", "Color", 3})
TimerStatusBar.args.ThreeChestColor = MPT:CreateColor(13, "Three Chest Color", "Color of the Timer Bar when you are in the three chest range", {"TimerBar", "Color", 4})
local TimerText = MPT:CreateTextSetting("Main Timer", "TimerText", 2, true)
local ChestTimer1 = MPT:CreateTextSetting("Chest Timer 1", "ChestTimer1", 1, true)
ChestTimer1.args.BehindColor = MPT:CreateColor(11, "Behind Color", "Color of the 1 Chest Timer when behind the timer", {"ChestTimer1", "BehindColor"}, true)
ChestTimer1.args.AheadColor = MPT:CreateColor(12, "Ahead Color", "Color of the 1 Chest Timer when ahead of the timer", {"ChestTimer1", "AheadColor"}, true)
local ChestTimer2 = MPT:CreateTextSetting("Chest Timer 2", "ChestTimer2", 2, true)
ChestTimer2.args.BehindColor = MPT:CreateColor(11, "Behind Color", "Color of the 2 Chest Timer when behind the timer", {"ChestTimer2", "BehindColor"}, true)
ChestTimer2.args.AheadColor = MPT:CreateColor(12, "Ahead Color", "Color of the 2 Chest Timer when ahead of the timer", {"ChestTimer2", "AheadColor"}, true)
local ChestTimer3 = MPT:CreateTextSetting("Chest Timer 3", "ChestTimer3", 3, true)
ChestTimer3.args.BehindColor = MPT:CreateColor(11, "Behind Color", "Color of the 3 Chest Timer when behind the timer", {"ChestTimer3", "BehindColor"}, true)
ChestTimer3.args.AheadColor = MPT:CreateColor(12, "Ahead Color", "Color of the 3 Chest Timer when ahead of the timer", {"ChestTimer3", "AheadColor"}, true)
local ChestTimer = {
    type = "group",
    name = "Chest Timer",
    childGroups = "tab",
    order = 3,
    args = {
        ChestTimer1 = ChestTimer1,
        ChestTimer2 = ChestTimer2,
        ChestTimer3 = ChestTimer3,
    }
}
local ComparisonTimer = MPT:CreateTextSetting("Comparison Timer", "ComparisonTimer", 4)
ComparisonTimer.args.SuccessColor = MPT:CreateColor(12, "Success Color", "Color of the Comparison Timer when a new PB was achieved", {"ComparisonTimer", "SuccessColor", 1}, true)
ComparisonTimer.args.FailureColor = MPT:CreateColor(13, "Failure Color", "Color of the Comparison Timer on slower Runs", {"ComparisonTimer", "FailColor", 1}, true)
ComparisonTimer.args.EqualColor = MPT:CreateColor(14, "Equal Color", "Color of the Comparison Timer +-0 runs", {"ComparisonTimer", "EqualColor", 1}, true)
local Ticks = {
    type = "group",
    name = "Ticks",
    order = 5,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable Timer Ticks", {"Ticks", "enabled"}, true),
        Width = MPT:CreateRange(2, "Tick Width", "Width of each Tick", 1, 10, 1, {"Ticks", "Width"}, true),
        Color = MPT:CreateColor(3, "Tick Color", "Color of the Ticks", {"Ticks", "Color"}, true),
    },
}
local TimerBar = {
    name = "Timer Bar",
    handler = MPTUI,
    type = "group",
    order = 3,
    childGroups = "tab",
    args = {
        StatusBar = TimerStatusBar,
        TimerText = TimerText,
        ChestTimer = ChestTimer,
        ComparisonTimer = ComparisonTimer,
        Ticks = Ticks,
    },
}


local BossName = MPT:CreateTextSetting("Boss Name", "BossName", 1, true)
BossName.args.MaxLength = MPT:CreateRange(11, "Max Length", "Maximum Length of the Boss Name", 0, 100, 1, {"BossName", "MaxLength"}, true)
BossName.args.CompletionColor = MPT:CreateColor(12, "Completion Color", "Color of the Boss Name after the boss was defeated", {"BossName", "CompletionColor"}, true)
local BossSplit = MPT:CreateTextSetting("Boss Split", "BossSplit", 2, true)
BossSplit.args.SuccessColor = MPT:CreateColor(12, "Success Color", "Color of the Boss Split if the timer is faster than the previous best", {"BossSplit", "SuccessColor"}, true)
BossSplit.args.FailColor = MPT:CreateColor(13, "Fail Color", "Color of the Boss Split if the timer is slower than the previous best", {"BossSplit", "FailColor"}, true)
BossSplit.args.EqualColor = MPT:CreateColor(14, "Equal Color", "Color of the Boss Split if the timer is equal to the previous best", {"BossSplit", "EqualColor"}, true)
local BossTimer = MPT:CreateTextSetting("Boss Timer", "BossTimer", 3, true)
BossTimer.args.SuccessColor = MPT:CreateColor(12, "Success Color", "Color of the Boss Timer if the timer is faster than the previous best", {"BossTimer", "SuccessColor"}, true)
BossTimer.args.FailColor = MPT:CreateColor(13, "Fail Color", "Color of the Boss Timer if the timer is slower than the previous best", {"BossTimer", "FailColor"}, true)
BossTimer.args.EqualColor = MPT:CreateColor(14, "Equal Color", "Color of the Boss Timer if the timer is equal to the previous best", {"BossTimer", "EqualColor"}, true)
local BossesBar = {
    type = "group",
    name = "Bosses Bar",
    order = 4,
    args = {
        Width = MPT:CreateRange(1, "Bosses Bar Width", "Width of the Bosses Bar", 10, 200, 1, {"Bosses", "Width"}, true),
        Height = MPT:CreateRange(2, "Bosses Bar Height", "Height of the Bosses Bar", 10, 200, 1, {"Bosses", "Height"}, true),
        XOffset = MPT:CreateRange(3, "Bosses Bar X Offset", "X Offset of the Bosses Bar", -500, 500, 1, {"Bosses", "xOffset"}, true),
        YOffset = MPT:CreateRange(4, "Bosses Bar Y Offset", "Y Offset of the Bosses Bar", -500, 500, 1, {"Bosses", "yOffset"}, true),
    }
}   

local Bosses = {
    type = "group",
    name = "Bosses",
    handler = MPTUI,
    order = 4,
    childGroups = "tab",
    args = {
        BossName = BossName,
        BossSplit = BossSplit,
        BossTimer = BossTimer,
        BossesBar = BossesBar,
    }
}

local ForcesBar = MPT:CreateStatusBarSettings("Forces Bar", "ForcesBar", 1)
ForcesBar.args.Zero = MPT:CreateColor(10, "0-20 Color", "Color of the Forces Bar from 0 to 20%", {"ForcesBar", "Color", 1}, true)
ForcesBar.args.Twenty = MPT:CreateColor(11, "21-40 Color", "Color of the Forces Bar from 21 to 40%", {"ForcesBar", "Color", 2}, true)
ForcesBar.args.Forty = MPT:CreateColor(12, "41-60 Color", "Color of the Forces Bar from 41 to 60%", {"ForcesBar", "Color", 3}, true)
ForcesBar.args.Sixty = MPT:CreateColor(13, "61-80 Color", "Color of the Forces Bar from 61 to 80%", {"ForcesBar", "Color", 4}, true)
ForcesBar.args.Eighty = MPT:CreateColor(14, "81-99 Color", "Color of the Forces Bar from 81 to 99%", {"ForcesBar", "Color", 5}, true)
ForcesBar.args.Completion = MPT:CreateColor(15, "100% Color", "Color of the Forces Bar at 100%", {"ForcesBar", "CompletionColor"}, true)
local PercentText = MPT:CreateTextSetting("Percent Text", "PercentCount", 2, true)
PercentText.args.remaining = MPT:CreateToggle(11, "Show Remaining", "Show Remaining Percent instead of current Percent", {"PercentCount", "remaining"}, true)
local CurrentText = MPT:CreateTextSetting("Current Text", "RealCount", 3, true)
CurrentText.args.remaining = MPT:CreateToggle(11, "Show Remaining", "Show Remaining Count instead of current Count", {"RealCount", "remaining"}, true)
CurrentText.args.total = MPT:CreateToggle(12, "Show Total", "Show Total Count", {"RealCount", "total"}, true)
local ForcesSplits = MPT:CreateTextSetting("Split Text", "ForcesSplits", 4, true)
ForcesSplits.args.SuccessColor = MPT:CreateColor(12, "Success Color", "Color of the Split if the timer is faster than the previous best", {"ForcesSplits", "SuccessColor"}, true)
ForcesSplits.args.FailColor = MPT:CreateColor(13, "Fail Color", "Color of the Split if the timer is slower than the previous best", {"ForcesSplits", "FailColor"}, true)
ForcesSplits.args.EqualColor = MPT:CreateColor(14, "Equal Color", "Color of the Split if the timer is equal to the previous best", {"ForcesSplits", "EqualColor"}, true)
local ForcesCompletion = MPT:CreateTextSetting("Completion Time", "ForcesCompletion", 5, true)
local EnemyForces = {
    type = "group",
    name = "Forces",
    handler = MPTUI,
    order = 5,
    childGroups = "tab",
    args = {
        ForcesBar = ForcesBar,
        PercentText = PercentText,
        CurrentText = CurrentText,
        ForcesCompletion = ForcesCompletion,
        ForcesSplits = ForcesSplits,
    }
}
local MainProfile = {
    type = "select",
    name = "Main Profile",
    desc = "Select a Main Profile, which will automatically load on any new character",
    order = 4,
    values = function()
        local profiles = {}
        for _, profile in pairs(MPTSV.Profiles) do
            profiles[profile.name] = profile.name
        end
        return profiles
    end,            
    set = function(_, value) 
        MPT:SetMainProfile(value)
     end,
    get = function() return MPTSV.MainProfile end,
}
local NewProfile = {
    type = "input",
    name = "New Profile",
    desc = "Create a new profile with the entered name",
    order = 5,
    set = function(_, value) MPT:CreateProfile(value) end,
    get = function() return "" end,
}

local ActiveProfile = {
    type = "select",
    name = "Active Profile",
    desc = "Select Active Profile",
    order = 6,
    values = function()
        local profiles = {}
        for _, profile in pairs(MPTSV.Profiles) do
            profiles[profile.name] = profile.name
        end
        return profiles
    end,
    set = function(_, value) MPT:LoadProfile(value) end,
    get = function() return MPT.ActiveProfile end,
}
local CopyProfile = {
    type = "select",
    name = "Copy from Profile",
    desc = "Copy settings from the selected profile into the current profile",
    order = 7,
    values = function()
        local profiles = {}
        for _, profile in pairs(MPTSV.Profiles) do
            profiles[profile.name] = profile.name
        end
        return profiles
    end,
    set = function(_, value) MPT:CopyProfile(value) end,
    get = function() return "" end,
}
local DeleteProfile = {
    type = "select",
    name = "Delete Profile",
    desc = "Delete the selected profile",
    order = 8,
    values = function()
        local profiles = {}
        for _, profile in pairs(MPTSV.Profiles) do
            if profile.name ~= "default" then
                profiles[profile.name] = profile.name
            end
        end
        return profiles
    end,
    set = function(_, value) MPT:DeleteProfile(value) end,
    get = function() return "" end,
}


local Profiles = {
    type = "group",
    name = "Profiles",
    order = 6,
    args = {
        Description = {
            type = "description",
            order = 1,
            name = "You can change the Active Profile here as well as setting a Main Profile, which will automatically load on any new character.",
        },
        ResetDescription = {
            type = "description",
            order = 2,
            name = "Reset your current active profile to the default settings. THIS CANNOT BE UNDONE",
        },
        Reset = {
            type = "execute",
            order = 3,
            name = "Reset Current Profile",
            func = function() MPT:ResetProfile() end,
        },
        MainProfile = MainProfile,
        NewProfile = NewProfile,
        ActiveProfile = ActiveProfile,
        CopyDescription = {
            type = "description",
            order = 5,
            name = "Copy the settings from another profile into your current profile.",
        },
        CopyProfile = CopyProfile,
        DeleteDescription = {
            type = "description",
            order = 7,
            name = "Delete a profile.",
        },
        DeleteProfile = DeleteProfile,
        ExportProfile = {
            type = "input",
            order = 9,
            name = "Export Profile",
            desc = "Export your current profile to a string",
            get = function() return MPTAPI:GetExportString() end,
            set = function() end,
            width = "full",
        },
        ImportProfile = {
            type = "input",
            order = 10,
            multiline = 10,
            name = "Import Profile",
            desc = "Import a profile from a string",
            set = function(_, value) MPTAPI:ImportProfile(value) end,
            get = function() return "" end,
        },
    }
}

local options= { 
	name = "General Settings",
	handler = MPTUI,
    childGroups = "tab",
	type = "group",
	args = {
        General = General,
        KeyInfoBar = KeyInfo,
        TimerBar = TimerBar,
        Bosses = Bosses,
        EnemyForces = EnemyForces,
    },    
}


function MPT.UI:OnInitialize()
    local AceConfig = LibStub("AceConfig-3.0")
	AceConfig:RegisterOptionsTable("MPTUI", options)
    AceConfig:RegisterOptionsTable("MPTProfiles", Profiles)
    local AceConfigdialog = LibStub("AceConfigDialog-3.0")
	self.optionsFrame = AceConfigdialog:AddToBlizOptions("MPTUI", "Mythic Plus Timer")
    self.profilesFrame = AceConfigdialog:AddToBlizOptions("MPTProfiles", "Profiles", "Mythic Plus Timer") -- needs to be after the optionsFrame is created
	self:RegisterChatCommand("mpt", "SlashCommand")
	self:RegisterChatCommand("mythicplus", "SlashCommand")
	self:RegisterChatCommand("mythicplusTimer", "SlashCommand")
end