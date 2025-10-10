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
    settings.args.xOffset = self:CreateRange(4, "X Offset", "X Offset of the Text", -100, 100, 1, {key, "xOffset"}, true)
    settings.args.yOffset = self:CreateRange(5, "Y Offset", "Y Offset of the Text", -100, 100, 1, {key, "yOffset"}, true)
    settings.args.Font = self:CreateDropDown(6, fontTable, "Font", "", {key, "Font"}, true)
    settings.args.FontSize = self:CreateRange(7, "Font Size", "Size of the Font", 6, 32, 1, {key, "FontSize"}, true)
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
    settings.args.Height = self:CreateRange(2, "Height", "Height of the Status Bar", 10, 200, 1, {key, "Height"}, true)
    settings.args.xOffset = self:CreateRange(3, "X Offset", "X Offset of the Status Bar", -500, 500, 1, {key, "xOffset"}, true)
    settings.args.yOffset = self:CreateRange(4, "Y Offset", "Y Offset of the Status Bar", -500, 500, 1, {key, "yOffset"}, true)
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
TimerStatusBar.args.DepleteColor = MPT:CreateColor(10, "Deplete Color", "Color of the Timer Bar when the timer is depleted", {"TimerBar", "Color", 1})
TimerStatusBar.args.OneChestColor = MPT:CreateColor(11, "One Chest Color", "Color of the Timer Bar when you are in the one chest range", {"TimerBar", "Color", 2})
TimerStatusBar.args.TwoChestColor = MPT:CreateColor(12, "Two Chest Color", "Color of the Timer Bar when you are in the two chest range", {"TimerBar", "Color", 3})
TimerStatusBar.args.ThreeChestColor = MPT:CreateColor(13, "Three Chest Color", "Color of the Timer Bar when you are in the three chest range", {"TimerBar", "Color", 4})
local TimerText = MPT:CreateTextSetting("Main Timer", "TimerText", 2, true)
local ChestTimer = MPT:CreateTextSetting("Chest Timer", "ChestTimer", 3, true)
local ComparisonTimer = MPT:CreateTextSetting("Comparison Timer", "ComparisonTimer", 4)
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
local BossSplit = MPT:CreateTextSetting("Boss Split", "BossSplit", 2, true)
local BossTimer = MPT:CreateTextSetting("Boss Timer", "BossTimer", 3, true)
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
local PercentText = MPT:CreateTextSetting("Percent Text", "PercentCount", 2, true)
local CurrentText = MPT:CreateTextSetting("Current Text", "RealCount", 3, true)
local ForcesSplits = MPT:CreateTextSetting("Split Text", "ForcesSplits", 4, true)
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
        ForcesSplits = ForcesSplits,
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
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MPTUI", options)
    local AceConfigdialog = LibStub("AceConfigDialog-3.0")
	self.optionsFrame = AceConfigdialog:AddToBlizOptions("MPTUI", "Mythic Plus Timer")
    --self.optionsFrame = AceConfigdialog:AddToBlizOptions("MPTUI", "Timer Bar", "Mythic Plus Timer", "TimerBar")
	self:RegisterChatCommand("mpt", "SlashCommand")
	self:RegisterChatCommand("mythicplus", "SlashCommand")
	self:RegisterChatCommand("mythicplusTimer", "SlashCommand")
end