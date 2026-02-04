local _, MPT = ...
local L = LibStub("AceLocale-3.0"):GetLocale("MPlusTimer")
local LDB = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)
local AceConfigdialog = LibStub("AceConfigDialog-3.0")



function MPT:CreateMiniMapButton()
    if not LDB then return end
    local databroker = LDB:NewDataObject("MPlusTimer", {
        type = "launcher",
        label = "MPlusTimer",
        icon = [[Interface\Icons\inv_relics_hourglass]],
        showInCompartment = true,
        OnClick = function(self, button)
            if button == "LeftButton" then
                Settings.OpenToCategory(MPT.UI.optionsFrame.name)
            elseif button == "RightButton" then
                MPT:ShowPBFrame()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("MPlusTimer", 0, 1, 1)
            tooltip:AddLine(L["MINIMAP_TOOLTIP"]:format(L["Left click"], L["Right click"]))
        end
    })
    if (databroker and not LDBIcon:IsRegistered("MPlusTimer")) then
        LDBIcon:Register("MPlusTimer", databroker, MPTSV.MinimapIcon)
        LDBIcon:AddButtonToCompartment("MPlusTimer")
    end
end

StaticPopupDialogs["MPT_RESET_PROFILE"] = {
    text = L["Are you sure you want to reset the current profile to the default settings?"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        MPT:ResetProfile()
    end
}

function MPT:GetAllFonts()
    local fontlist = MPT.LSM:List("font")
    local fontTable = {}
    for _, font in ipairs(fontlist) do
        fontTable[font] = font
    end
    return fontTable
end

function MPT:GetAllTextures()
    local texturelist = MPT.LSM:List("statusbar")
    local textureTable = {}
    for _, texture in ipairs(texturelist) do
        textureTable[texture] = texture
    end
    return textureTable
end

function MPTAPI:GetAllTextures()
    local texturelist = MPT.LSM:List("statusbar")
    local textureTable = {}
    for _, texture in ipairs(texturelist) do
        textureTable[texture] = texture
    end
    return textureTable
end

function MPT:CreateTextSetting(name, key, order, Color)
    local settings = {
        type = "group",
        name = name,
        order = order,
        args = {}
    }    
    settings.args.enabled = self:CreateToggle(1, "Enable", "Enabled", {key, "enabled"}, true)
    settings.args.Anchor = self:CreateDropDown(2, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Anchor", "", {key, "Anchor"}, true)
    settings.args.RelativeTo = self:CreateDropDown(3, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Relative To", "", {key, "RelativeTo"}, true)
    settings.args.xOffset = self:CreateRange(4, "X Offset", "X Offset of the Text", -200, 200, 1, {key, "xOffset"}, true)
    settings.args.yOffset = self:CreateRange(5, "Y Offset", "Y Offset of the Text", -200, 200, 1, {key, "yOffset"}, true)    
    settings.args.Font = self:CreateDropDown(6, "fonts", "Font", "", {key, "Font"}, true)
    settings.args.FontSize = self:CreateRange(7, "Font Size", "Size of the Font", 6, 40, 1, {key, "FontSize"}, true)
    settings.args.Outline = self:CreateDropDown(8, {["NONE"] = "None", ["OUTLINE"] = "Outline", ["THICKOUTLINE"] = "Thick Outline", ["MONOCHROME"] = "Monochrome"}, "Font Outline", "", {key, "Outline"}, true)
    if Color then settings.args.Color = self:CreateColor(9, "Color", "", {key, "Color"}, true) end
    settings.args.ShadowGap = self:CreateSpace(20)
    settings.args.ShadowXOffset = self:CreateRange(21, "Shadow X Offset", "Shadow X Offset of the Text", -5, 5, 1, {key, "ShadowOffset", 1}, true)
    settings.args.ShadowYOffset = self:CreateRange(22, "Shadow Y Offset", "Shadow Y Offset of the Text", -5, 5, 1, {key, "ShadowOffset", 2}, true)
    settings.args.ShadowColor = self:CreateColor(23, "Shadow Color", "", {key, "ShadowColor"}, true)
    return settings
end

function MPT:CreateStatusBarSettings(name, key, order)
    local settings = {
        type = "group",
        name = name,
        order = order,
        args = {}
    }    
    settings.args.Width = self:CreateRange(4, "Width", "Width of the Status Bar", 50, 1000, 1, {key, "Width"}, true)
    settings.args.Height = self:CreateRange(5, "Height", "Height of the Status Bar", 6, 100, 1, {key, "Height"}, true)
    settings.args.Texture = self:CreateDropDown(6, "textures", "Texture", "", {key, "Texture"}, true)
    settings.args.xOffset = self:CreateRange(7, "X Offset", "X Offset of the Status Bar", -300, 300, 0.1, {key, "xOffset"}, true)
    settings.args.yOffset = self:CreateRange(8, "Y Offset", "Y Offset of the Status Bar", -300, 300, 0.1, {key, "yOffset"}, true)
    settings.args.SizeGap = self:CreateSpace(9)
    settings.args.BorderSize = self:CreateRange(10, "Border Size", "Size of the Border", 1, 10, 1, {key, "BorderSize"}, true)
    settings.args.BorderColor = self:CreateColor(11, "Border Color", "", {key, "BorderColor"}, true)
    settings.args.BackgroundColor = self:CreateColor(12, "Background Color", "", {key, "BackgroundColor"}, true)
    return settings
end

function MPT:CreateToggle(order, name, desc, key, update)
    local t = {}
    t.order = order
    t.type = "toggle"
    t.name = L[name] or name  -- Nutzt Lokalisierung
    t.desc = L[desc] or desc  -- Nutzt Lokalisierung
    t.set = function(_, value) self:SetSV(key, value, update) end
    t.get = function() return self:GetSV(key) end
    return t
end

function MPT:CreateColor(order, name, desc, key, update)
    local t = {}
    t.order = order
    t.type = "color"
    t.hasAlpha = true
    t.name = rawget(L, name) or name
    if desc == "" or desc == nil then
        t.desc = desc
    else
        t.desc = rawget(L, desc) or desc
    end
    t.set = function(_, r, g, b, a) self:SetSV(key, {r, g, b, a}, update) end
    t.get = function() return unpack(self:GetSV(key)) end
    return t
end

function MPT:CreateDropDown(order, values, name, desc, key, update)
    local t = {}
    t.order = order
    if values == "textures" then
        t.values = function() return self:GetAllTextures() end
    elseif values == "fonts" then
        t.values = function() return self:GetAllFonts() end
    else
        t.values = values
    end
    
    t.type = "select"
    t.name = rawget(L, name) or name
    if desc == "" or desc == nil then
        t.desc = desc
    else
        t.desc = rawget(L, desc) or desc
    end
    t.set = function(_, value) self:SetSV(key, value, update) end
    t.get = function() return self:GetSV(key) end
    return t
end

function MPT:CreateRange(order, name, desc, min, max, step, key, update)
    local t = {}
    t.order = order
    t.type = "range"
    t.name = rawget(L, name) or name
    if desc == "" or desc == nil then
        t.desc = desc
    else
        t.desc = rawget(L, desc) or desc
    end
    t.min = min
    t.max = max
    t.step = step
    t.set = function(_, value) self:SetSV(key, value, update) end
    t.get = function() return self:GetSV(key) end
    return t
end


function MPT:CreateSpace(order)
    local t = {}
    t.order = order
    t.type = "description"
    t.name = " "
    t.width = "full"
    return t
end


local PreviewButton = {
    type = "execute", 
    order = 1,
    name = L["Preview/Unlock"],
    desc = L["Preview/Unlock Desc"],
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
}

local MainOptions = {
    type = "group",
    name = L["Non-Display Settings"],
    args = {
        Preview = PreviewButton,
        ViewBestTimes = {
            type = "execute",
            order = 2,
            name = L["View Best Times"],
            desc = L["View Best Times Desc"],
            func = function() 
                MPT:ShowPBFrame()
            end,         
        },
        UpdateRate = MPT:CreateRange(3, "Update Interval", "Update Interval Desc", 0.1, 3, 0.1, "UpdateRate"),        
        Gap = MPT:CreateSpace(4),
        AutoGossip = {
            type = "toggle",
            order = 5,
            name = L["Auto Accept Gossip"],
            desc = L["Auto Accept Gossip Desc"],
            set = function(_, value) MPTSV.AutoGossip = value end,
            get = function() return MPTSV.AutoGossip end,
        },
        CloseBags = {
            type = "toggle",
            order = 6,
            name = L["Close Bags"],
            desc = L["Close Bags Desc"],
            set = function(_, value) MPTSV.CloseBags = value end,
            get = function() return MPTSV.CloseBags end,
        },
        KeySlot = {
            type = "toggle",
            order = 7,
            name = L["Automatic Keyslot"],
            desc = L["Automatic Keyslot Desc"],
            set = function(_, value) MPTSV.KeySlot = value end,
            get = function() return MPTSV.KeySlot end,
        },
        LowerKey = {
            type = "toggle",
            order = 8,
            name = L["Data from Lower Level"],
            desc = L["Data from Lower Level Desc"],
            set = function(_, value) MPTSV.LowerKey = value end,
            get = function() return MPTSV.LowerKey end,
        },
        MinimapIcon = {
            type = "toggle",
            order = 9,
            name = L["Hide Minimap Icon"],
            desc = L["Hide Minimap Icon Desc"],
            set = function(_, value) MPTSV.MinimapIcon.hide = value LDBIcon:Refresh("MPlusTimer", MPTSV.MinimapIcon) end,
            get = function() return MPTSV.MinimapIcon.hide end,
        },
    }
}
local Position = {
    type = "group",
    name = L["Frame Position"],
    order = 2,
    args = {
              
    }
}
local Background = {
    type = "group",
    name = L["Background"],
    order = 3,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable Background", {"Background", "enabled"}, true),
        Color = MPT:CreateColor(2, "Color", "Color of the Background", {"Background", "Color"}, true),
        BorderColor = MPT:CreateColor(3, "Border Color", "Color of the Border", {"Background", "BorderColor"}, true),
        xOffset = MPT:CreateRange(4, "X Offset", "X Offset of the Background", -300, 300, 0.1, {"Background", "xOffset"}, true),
        yOffset = MPT:CreateRange(5, "Y Offset", "Y Offset of the Background", -300, 300, 0.1, {"Background", "yOffset"}, true),
        BorderSize = MPT:CreateRange(6, "Border Size", "Size of the Border", 1, 10, 1, {"Background", "BorderSize"}, true),
        WidthOffset = MPT:CreateRange(7, "Width Offset", "Additional or less Width", -300, 300, 0.1, {"Background", "WidthOffset"}, true),
        HeightOffset = MPT:CreateRange(8, "Height Offset", "Additional or less Height", -300, 300, 0.1, {"Background", "HeightOffset"}, true),
    }
}

local GeneralOptions = {
    type = "group",
    name = L["General Options"],
    order = 1,
    args = {
        Preview = PreviewButton,
        FrameStrata = MPT:CreateDropDown(2, {["BACKGROUND"] = "BACKGROUND", ["LOW"] = "LOW", ["MEDIUM"] = "MEDIUM", ["HIGH"] = "HIGH", ["DIALOG"] = "DIALOG", ["FULLSCREEN"] = "FULLSCREEN", ["FULLSCREEN_DIALOG"] = "FULLSCREEN_DIALOG", ["TOOLTIP"] = "TOOLTIP"}, "Frame Strata", "Frame Strata Desc", "FrameStrata", true),
        Gap = MPT:CreateSpace(3),
        Scale = MPT:CreateRange(4, "Group Scale", "Scale of the entire Display", 0.1, 3, 0.01, "Scale", true),
        AllFonts = {
            type = "select",
            order = 5,
            name = L["Change All Fonts"],
            desc = L["Changes all fonts used in the main display of the addon at once - doesn't apply to settings / best times UI"],
            values = function() return MPT:GetAllFonts() end, 
            set = function(_, value)
                MPT:SetSV({"KeyLevel", "Font"}, value, false)
                MPT:SetSV({"DungeonName", "Font"}, value, false)
                MPT:SetSV({"DeathCounter", "Font"}, value, false)
                MPT:SetSV({"TimerText", "Font"}, value, false)
                MPT:SetSV({"ChestTimer1", "Font"}, value, false)
                MPT:SetSV({"ChestTimer2", "Font"}, value, false)
                MPT:SetSV({"ChestTimer3", "Font"}, value, false)
                MPT:SetSV({"ComparisonTimer", "Font"}, value, false)
                MPT:SetSV({"BossName", "Font"}, value, false)
                MPT:SetSV({"BossSplit", "Font"}, value, false)
                MPT:SetSV({"BossTimer", "Font"}, value, false)
                MPT:SetSV({"PercentCount", "Font"}, value, false)
                MPT:SetSV({"RealCount", "Font"}, value, false)
                MPT:SetSV({"ForcesSplits", "Font"}, value, false)
                MPT:SetSV({"ForcesCompletion", "Font"}, value, false)
                MPT:SetSV({"PBInfo", "Font"}, value, false)
                MPT:UpdateDisplay()                
            end,
            get = function() return "" end,
        },
        HideTracker = MPT:CreateToggle(6, "Hide Objective Tracker", "Hides Blizzard's Objective Tracker during an active M+", "HideTracker"),
        Spacing = MPT:CreateRange(7, "Bar Spacing", "Spacing for each Bar", -5, 10, 1, "Spacing", true),
        AllTextures = {
            type = "select",
            order = 8,
            name = L["Change All Textures"],
            desc = L["Changes all bar textures at once"],
            values = function() return MPT:GetAllTextures() end,
            set = function(_, value)
                MPT:SetSV({"TimerBar", "Texture"}, value, false)
                MPT:SetSV({"ForcesBar", "Texture"}, value, false)
                MPT:SetSV({"CurrentPullBar", "Texture"}, value, false)
                MPT:UpdateDisplay()                
            end,
            get = function() return "" end,
        },
        Desc = {
            type = "header",
            order = 9,
            name = L["Main Frame Positioning"],
        },
        Anchor = MPT:CreateDropDown(10, {["CENTER"] = "CENTER", ["TOP"] = "TOP", ["BOTTOM"] = "BOTTOM", ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Anchor", "", {"Position", "Anchor"}, true),
        relativeTo = MPT:CreateDropDown(11, {["CENTER"] = "CENTER", ["TOP"] = "TOP", ["BOTTOM"] = "BOTTOM", ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Relative To", "", {"Position", "relativeTo"}, true),
        Gap = MPT:CreateSpace(12),
        xOffset = MPT:CreateRange(13, "X Offset", "X Offset", -4000, 4000, 0.1, {"Position", "xOffset"}, true),
        yOffset = MPT:CreateRange(14, "Y Offset", "Y Offset", -4000, 4000, 0.1, {"Position", "yOffset"}, true),  
    } 
}
local General = {
    type = "group",
    name = L["General"],
    childGroups = "tab",
    order = 1,
    args = {
        General = GeneralOptions,
        Background = Background,
    }
}


local KeyInfoBar = {
    type = "group",
    name = L["Key Info Bar"],
    order = 2,
    args = {
        AnchoredTo = MPT:CreateDropDown(1, {["MainFrame"] = L["Main Frame"], ["TimerBar"] = L["Timer Bar"], ["Bosses"] = L["Bosses"], ["ForcesBar"] = L["Forces Bar"]}, "Anchored To", "What the Key Info Bar is anchored to", {"KeyInfo", "AnchoredTo"}, true),
        Anchor = MPT:CreateDropDown(2, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Anchor", "", {"KeyInfo", "Anchor"}, true),
        RelativeTo = MPT:CreateDropDown(3, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Relative To", "", {"KeyInfo", "RelativeTo"}, true),
        Width = MPT:CreateRange(4, "Width", "Width of the Key Info Bar", 50, 1000, 1, {"KeyInfo", "Width"}, true),
        Height = MPT:CreateRange(5, "Height", "Height of the Key Info Bar", 6, 100, 1, {"KeyInfo", "Height"}, true),
        Gap = MPT:CreateSpace(6),
        xOffset = MPT:CreateRange(7, "X Offset", "X Offset of the Key Info Bar", -300, 300, 0.1, {"KeyInfo", "xOffset"}, true),
        yOffset = MPT:CreateRange(8, "Y Offset", "Y Offset of the Key Info Bar", -300, 300, 0.1, {"KeyInfo", "yOffset"}, true),
    }
}
local KeyLevel = MPT:CreateTextSetting(L["Key Level"], "KeyLevel", 2, true)
local DungeonName = MPT:CreateTextSetting(L["Dungeon Name"], "DungeonName", 3, true)
DungeonName.args.Shorten = MPT:CreateRange(11, "Shorten", "Shorten Dungeon Name after X Characters", 5, 30, 1, {"DungeonName", "Shorten"}, true)
local Affixes = MPT:CreateTextSetting(L["Affixes"], "AffixIcons", 4, true)
local Deaths = MPT:CreateTextSetting(L["Deaths"], "DeathCounter", 5, true)
Deaths.args.ShowTime = MPT:CreateToggle(11, "Show Time of Deaths", "Show the total time lost from deaths", {"DeathCounter", "ShowTimer"}, true)
Deaths.args.DeathBrackets = MPT:CreateToggle(12, "Square Brackets", "Show Death Count in Square Brackets instead of Round Brackets", {"DeathCounter", "SquareBrackets"}, true)
local DeathIcon = {
    type = "group",
    name = L["Death Icon"],
    order = 6,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable Death Icon", {"DeathCounter", "Iconenabled"}, true),
        iconAnchor = MPT:CreateDropDown(2, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER"}, "Anchor", "", {"DeathCounter", "IconAnchor"}, true),
        iconRelativeTo = MPT:CreateDropDown(3, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER"}, "Relative To", "", {"DeathCounter", "IconRelativeTo"}, true),
        xOffset = MPT:CreateRange(4, "X Offset", "X Offset of the Death Icon", -300, 300, 1, {"DeathCounter", "IconxOffset"}, true),
        yOffset = MPT:CreateRange(5, "Y Offset", "Y Offset of the Death Icon", -300, 300, 1, {"DeathCounter", "IconyOffset"}, true),
    }
}
local KeyInfo = {
    name = L["Key Info Bar"],
    type = "group",
    order = 2,
    childGroups = "tab",
    args = {
        KeyInfoBar = KeyInfoBar,
        KeyLevel = KeyLevel,
        DungeonName = DungeonName,
        Affixes = Affixes,
        Deaths = Deaths,
        DeathIcon = DeathIcon,
    },
}

local TimerStatusBar = MPT:CreateStatusBarSettings(L["Timer Bar"], "TimerBar", 1)
TimerStatusBar.args.AnchoredTo = MPT:CreateDropDown(1, {["MainFrame"] = L["Main Frame"], ["KeyInfo"] = L["Key Info Bar"], ["Bosses"] = L["Bosses"], ["ForcesBar"] = L["Forces Bar"]}, "Anchored To", "What the Timer Bar is anchored to", {"TimerBar", "AnchoredTo"}, true)
TimerStatusBar.args.Anchor = MPT:CreateDropDown(2, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Anchor", "", {"TimerBar", "Anchor"}, true)
TimerStatusBar.args.RelativeTo = MPT:CreateDropDown(3, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Relative To", "", {"TimerBar", "RelativeTo"}, true)
TimerStatusBar.args.OneChestColor = MPT:CreateColor(13, "One Chest Color", "Color of the Timer Bar when you are in the one chest range", {"TimerBar", "Color", 2})
TimerStatusBar.args.TwoChestColor = MPT:CreateColor(14, "Two Chest Color", "Color of the Timer Bar when you are in the two chest range", {"TimerBar", "Color", 3})
TimerStatusBar.args.ThreeChestColor = MPT:CreateColor(15, "Three Chest Color", "Color of the Timer Bar when you are in the three chest range", {"TimerBar", "Color", 4})
TimerStatusBar.args.DepleteColor = MPT:CreateColor(16, "Deplete Color", "Color of the Timer Bar when the timer is depleted", {"TimerBar", "Color", 1})
TimerStatusBar.args.ChestTimerDisplay = MPT:CreateDropDown(17, {[1] = L["Relevant Chest Timer"], [2] = L["All Chest Timers"], [3] = L["No Chest Timer"]}, "Chest Timer Display", "Which Chest Timers are to be displayed", {"TimerBar", "ChestTimerDisplay"}, true)
local TimerText = MPT:CreateTextSetting(L["Main Timer"], "TimerText", 2, true)
TimerText.args.Decimals = MPT:CreateDropDown(11, {[0] = "0", [1] = "1", [2] = "2", [3] = "3"}, "Final Time Decimals", "Number of decimal places on the Final Timer", {"TimerText", "Decimals"}, true)
TimerText.args.SuccessColor = MPT:CreateColor(12, "Intime Color", "Color of the Timer Text on timing the key", {"TimerText", "SuccessColor"}, true)
TimerText.args.FailColor = MPT:CreateColor(13, "Deplete Color", "Color of the Timer Text on deplete", {"TimerText", "FailColor"}, true)
TimerText.args.Space = MPT:CreateToggle(14, "Add Spacing", "Adds a space before and after the '/' for readability", {"TimerText", "Space"}, true)


           
local ChestTimer1 = MPT:CreateTextSetting(L["Chest Timer 1"], "ChestTimer1", 1, true)
ChestTimer1.args.AheadColor = MPT:CreateColor(11, "Ahead Color", "Color of the 1 Chest Timer when ahead of the timer", {"ChestTimer1", "AheadColor"}, true)
ChestTimer1.args.BehindColor = MPT:CreateColor(12, "Behind Color", "Color of the 1 Chest Timer when behind the timer", {"ChestTimer1", "BehindColor"}, true)
local ChestTimer2 = MPT:CreateTextSetting(L["Chest Timer 2"], "ChestTimer2", 2, true)
ChestTimer2.args.AheadColor = MPT:CreateColor(11, "Ahead Color", "Color of the 2 Chest Timer when ahead of the timer", {"ChestTimer2", "AheadColor"}, true)
ChestTimer2.args.BehindColor = MPT:CreateColor(12, "Behind Color", "Color of the 2 Chest Timer when behind the timer", {"ChestTimer2", "BehindColor"}, true)
local ChestTimer3 = MPT:CreateTextSetting(L["Chest Timer 3"], "ChestTimer3", 3, true)
ChestTimer3.args.AheadColor = MPT:CreateColor(11, "Ahead Color", "Color of the 3 Chest Timer when ahead of the timer", {"ChestTimer3", "AheadColor"}, true)
ChestTimer3.args.BehindColor = MPT:CreateColor(12, "Behind Color", "Color of the 3 Chest Timer when behind the timer", {"ChestTimer3", "BehindColor"}, true)
local ChestTimer = {
    type = "group",
    name = L["Chest Timer"],
    childGroups = "tab",
    order = 3,
    args = {
        ChestTimer1 = ChestTimer1,
        ChestTimer2 = ChestTimer2,
        ChestTimer3 = ChestTimer3,
    }
}
local ComparisonTimer = MPT:CreateTextSetting(L["Comparison Timer"], "ComparisonTimer", 4)
ComparisonTimer.args.Gap = MPT:CreateSpace(11)
ComparisonTimer.args.SuccessColor = MPT:CreateColor(12, "Success Color", "Color of the Comparison Timer when a new PB was achieved", {"ComparisonTimer", "SuccessColor"}, true)
ComparisonTimer.args.FailureColor = MPT:CreateColor(13, "Failure Color", "Color of the Comparison Timer on slower Runs", {"ComparisonTimer", "FailColor"}, true)
ComparisonTimer.args.EqualColor = MPT:CreateColor(14, "Equal Color", "Color of the Comparison Timer +-0 runs", {"ComparisonTimer", "EqualColor"}, true)
local Tick1 = {
    type = "group",
    name = "2 Chest Tick",
    order = 1,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable 2 Chest Tick", {"Tick1", "enabled"}, true),
        Width = MPT:CreateRange(2, "2 Chest Tick Width", "Width of 2 Chest Tick", 1, 10, 1, {"Tick1", "Width"}, true),
        Color = MPT:CreateColor(3, "2 Chest Tick Color", "Color of 2 Chest Tick", {"Tick1", "Color"}, true),
    }
}
local Tick2 = {
    type = "group",
    name = "3 Chest Tick",
    order = 2,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable 3 Chest Tick", {"Tick2", "enabled"}, true),
        Width = MPT:CreateRange(2, "3 Chest Tick Width", "Width of 3 Chest Tick", 1, 10, 1, {"Tick2", "Width"}, true),
        Color = MPT:CreateColor(3, "3 Chest Tick Color", "Color of 3 Chest Tick", {"Tick2", "Color"}, true),
    }
}

local Ticks = {
    type = "group",
    name = L["Ticks"],
    childGroups = "tab",
    order = 5,
    args = {
        Tick1 = Tick1,
        Tick2 = Tick2,
    },
}
local TimerBar = {
    name = L["Timer Bar"],
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

local BossesBar = {
    type = "group",
    name = L["Bosses Bar"],
    order = 1,
    args = {
        AnchoredTo = MPT:CreateDropDown(1, {["MainFrame"] = L["Main Frame"], ["KeyInfo"] = L["Key Info Bar"], ["TimerBar"] = L["Timer Bar"], ["ForcesBar"] = L["Forces Bar"]}, "Anchored To", "What the Bosses Bar is anchored to", {"Bosses", "AnchoredTo"}, true),
        Anchor = MPT:CreateDropDown(2, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Anchor", "", {"Bosses", "Anchor"}, true),
        RelativeTo = MPT:CreateDropDown(3, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Relative To", "", {"Bosses", "RelativeTo"}, true),
        Width = MPT:CreateRange(4, "Bosses Bar Width", "Width of the Bosses Bar", 50, 1000, 1, {"Bosses", "Width"}, true),
        Height = MPT:CreateRange(5, "Bosses Bar Height", "Height of the Bosses Bar", 6, 100, 1, {"Bosses", "Height"}, true),
        Gap = MPT:CreateSpace(6),
        XOffset = MPT:CreateRange(7, "Bosses Bar X Offset", "X Offset of the Bosses Bar", -300, 300, 0.1, {"Bosses", "xOffset"}, true),
        YOffset = MPT:CreateRange(8, "Bosses Bar Y Offset", "Y Offset of the Bosses Bar", -300, 300, 0.1, {"Bosses", "yOffset"}, true),
    }
}   
local BossName = MPT:CreateTextSetting(L["Boss Name"], "BossName", 2, true)
BossName.args.MaxLength = MPT:CreateRange(11, "Max Length", "Maximum Length of the Boss Name", 5, 40, 1, {"BossName", "MaxLength"}, true)
BossName.args.CompletionColor = MPT:CreateColor(12, "Completion Color", "Color of the Boss Name after the boss was defeated", {"BossName", "CompletionColor"}, true)
local BossSplit = MPT:CreateTextSetting(L["Boss Split"], "BossSplit", 3, true)
BossSplit.args.SuccessColor = MPT:CreateColor(12, "Success Color", "Color of the Boss Split if the timer is faster than the previous best", {"BossSplit", "SuccessColor"}, true)
BossSplit.args.FailColor = MPT:CreateColor(13, "Fail Color", "Color of the Boss Split if the timer is slower than the previous best", {"BossSplit", "FailColor"}, true)
BossSplit.args.EqualColor = MPT:CreateColor(14, "Equal Color", "Color of the Boss Split if the timer is equal to the previous best", {"BossSplit", "EqualColor"}, true)
local BossTimer = MPT:CreateTextSetting(L["Boss Timer"], "BossTimer", 4, true)
BossTimer.args.SuccessColor = MPT:CreateColor(12, "Success Color", "Color of the Boss Timer if the timer is faster than the previous best", {"BossTimer", "SuccessColor"}, true)
BossTimer.args.FailColor = MPT:CreateColor(13, "Fail Color", "Color of the Boss Timer if the timer is slower than the previous best", {"BossTimer", "FailColor"}, true)
BossTimer.args.EqualColor = MPT:CreateColor(14, "Equal Color", "Color of the Boss Timer if the timer is equal to the previous best", {"BossTimer", "EqualColor"}, true)


local Bosses = {
    type = "group",
    name = L["Bosses"],
    order = 4,
    childGroups = "tab",
    args = {
        BossesBar = BossesBar,
        BossName = BossName,
        BossSplit = BossSplit,
        BossTimer = BossTimer,
    }
}

local ForcesBar = MPT:CreateStatusBarSettings(L["Forces Bar"], "ForcesBar", 1)
ForcesBar.args.AnchoredTo = MPT:CreateDropDown(1, {["MainFrame"] = L["Main Frame"], ["KeyInfo"] = L["Key Info Bar"], ["TimerBar"] = L["Timer Bar"], ["Bosses"] = L["Bosses"]}, "Anchored To", "What the Forces Bar is anchored to", {"ForcesBar", "AnchoredTo"}, true)
ForcesBar.args.Anchor = MPT:CreateDropDown(2, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Anchor", "", {"ForcesBar", "Anchor"}, true)
ForcesBar.args.RelativeTo = MPT:CreateDropDown(3, {["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT", ["CENTER"] = "CENTER", ["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}, "Relative To", "", {"ForcesBar", "RelativeTo"}, true)
ForcesBar.args.Zero = MPT:CreateColor(13, "0-20 Color", "Color of the Forces Bar from 0 to 20%", {"ForcesBar", "Color", 1}, true)
ForcesBar.args.Twenty = MPT:CreateColor(14, "21-40 Color", "Color of the Forces Bar from 21 to 40%", {"ForcesBar", "Color", 2}, true)
ForcesBar.args.Forty = MPT:CreateColor(15, "41-60 Color", "Color of the Forces Bar from 41 to 60%", {"ForcesBar", "Color", 3}, true)
ForcesBar.args.Sixty = MPT:CreateColor(16, "61-80 Color", "Color of the Forces Bar from 61 to 80%", {"ForcesBar", "Color", 4}, true)
ForcesBar.args.Eighty = MPT:CreateColor(17, "81-99 Color", "Color of the Forces Bar from 81 to 99%", {"ForcesBar", "Color", 5}, true)
ForcesBar.args.Completion = MPT:CreateColor(18, "100% Color", "Color of the Forces Bar at 100%", {"ForcesBar", "CompletionColor"}, true)
local PercentText = MPT:CreateTextSetting(L["Percent Text"], "PercentCount", 2, true)
PercentText.args.remaining = MPT:CreateToggle(11, "Show Remaining", "Show Remaining Percent instead of current Percent", {"PercentCount", "remaining"}, true)
local CurrentText = MPT:CreateTextSetting(L["Count Text"], "RealCount", 3, true)
CurrentText.args.remaining = MPT:CreateToggle(11, "Show Remaining", "Show Remaining Count instead of current Count", {"RealCount", "remaining"}, true)
CurrentText.args.total = MPT:CreateToggle(12, "Show Total", "Show Total Count", {"RealCount", "total"}, true)
local ForcesSplits = MPT:CreateTextSetting(L["Split Text"], "ForcesSplits", 4, false)
ForcesSplits.args.Gap = MPT:CreateSpace(11)
ForcesSplits.args.SuccessColor = MPT:CreateColor(12, "Success Color", "Color of the Split if the timer is faster than the previous best", {"ForcesSplits", "SuccessColor"}, true)
ForcesSplits.args.FailColor = MPT:CreateColor(13, "Fail Color", "Color of the Split if the timer is slower than the previous best", {"ForcesSplits", "FailColor"}, true)
ForcesSplits.args.EqualColor = MPT:CreateColor(14, "Equal Color", "Color of the Split if the timer is equal to the previous best", {"ForcesSplits", "EqualColor"}, true)
local ForcesCompletion = MPT:CreateTextSetting(L["Completion Time"], "ForcesCompletion", 5, true)
local CurrentPullBar = {
    type = "group",
    name = L["Current Pull"],
    order = 6,
    args = {
        enabled = MPT:CreateToggle(1, "Enable", "Enable Current Pull Bar", {"CurrentPullBar", "enabled"}, true),
        Color = MPT:CreateColor(2, "Color", "Color of the Current Pull Bar", {"CurrentPullBar", "Color"}, true),
        texture = MPT:CreateDropDown(3, "textures", "Texture", "", {"CurrentPullBar", "Texture"}, true),
        Realenabled = MPT:CreateToggle(4, "RealCount Pull", "Show Current Pull Real Count", {"RealCount", "pullcount"}, true),
        Percentenabled = MPT:CreateToggle(5, "Percent Pull", "Show Current Pull Percent", {"PercentCount", "pullcount"}, true),
        Gap1 = MPT:CreateSpace(6),
        RealRemaining = MPT:CreateToggle(7, "RealCount Remaining", "Show Remaining Count instead of current Count for Current Pull", {"RealCount", "remaining"}, true),
        PercentRemaining = MPT:CreateToggle(8, "Percent Remaining", "Show Remaining Percent instead of current Percent for Current Pull", {"PercentCount", "remaining"}, true),
        Gap2 = MPT:CreateSpace(9),
        RealAfterPull = MPT:CreateToggle(10, "RealCount After Pull", "Show Count after Pull instead of how much you are gaining", {"RealCount", "afterPull"}, true),
        PercentAfterPull = MPT:CreateToggle(11, "Percent After Pull", "Show Percent after Pull instead of how much you are gaining", {"PercentCount", "afterPull"}, true),
        Gap3 = MPT:CreateSpace(12),
        CountBrackets = MPT:CreateToggle(13, "Square Brackets Count", "Uses Square instead of Round Brackets", {"RealCount", "SquareBrackets"}, true),
        PercentBrackets = MPT:CreateToggle(14, "Square Brackets Perc", "Uses Square instead of Round Brackets", {"PercentCount", "SquareBrackets"}, true),
        Gap4 = MPT:CreateSpace(15),
        RealTotalCount = MPT:CreateToggle(16, "Show Total", "Show Total Count needed", {"RealCount", "total"}, true),
    }
}
local EnemyForces = {
    type = "group",
    name = L["Enemy Forces"],
    order = 5,
    childGroups = "tab",
    args = {
        ForcesBar = ForcesBar,
        PercentText = PercentText,
        CurrentText = CurrentText,
        CurrentPullBar = CurrentPullBar,
        ForcesCompletion = ForcesCompletion,
        ForcesSplits = ForcesSplits,
    }
}
local PBInfo = MPT:CreateTextSetting(L["PB Info"], "PBInfo", 6, true)
PBInfo.args.Format = MPT:CreateDropDown(11, {[1] = "DD/MM/YY", [2] = "MM/DD/YY"}, "Date Format", "Format in which the date is displayed", {"PBInfo", "Format"}, true)
PBInfo.args.AnchoredTo = MPT:CreateDropDown(12, {["MainFrame"] = L["Main Frame"], ["KeyInfo"] = L["Key Info Bar"], ["TimerBar"] = L["Timer Bar"], ["Bosses"] = L["Bosses"], ["ForcesBar"] = L["Forces Bar"]}, "Anchored To", "What the PB Info is anchored to", {"PBInfo", "AnchoredTo"}, true)




local MainProfile = {
    type = "select",
    name = L["Main Profile"],
    desc = L["Select a Main Profile, which will automatically load on any new character"],
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
    name = L["New Profile"],
    desc = L["Create a new profile with the entered name"],
    order = 5,
    set = function(_, value) MPT:CreateProfile(value) end,
    get = function() return "" end,
}

local ActiveProfile = {
    type = "select",
    name = L["Active Profile"],
    desc = L["Select Active Profile"],
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
    name = L["Copy from Profile"],
    desc = L["Copy settings from the selected profile into the current profile"],
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
    name = L["Delete Profile"],
    desc = L["Delete the selected profile - You cannot delete the default profile."],
    order = 10,
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

local profiles = {
    type = "group",
    name = L["Profiles"],
    order = 6,
    args = {
        Description = {
            type = "description",
            order = 1,
            name = L["You can change the Active Profile here as well as setting a Main Profile, which will automatically load on any new character."],
        },
        ResetDescription = {
            type = "description",
            order = 2,
            name = L["Reset your current active profile to the default settings. THIS CANNOT BE UNDONE"],
        },
        Reset = {
            type = "execute",
            order = 3,
            name = L["Reset Current Profile"],
            func = function() StaticPopup_Show("MPT_RESET_PROFILE") end,
        },
        MainProfile = MainProfile,
        Seperate = {
            type = "description",
            order = 4.5,
            name = "",
            width = "full",
        },
        NewProfile = NewProfile,
        ActiveProfile = ActiveProfile,
        CopyProfile = CopyProfile,
        ExportProfile = {
            type = "input",
            order = 8,
            name = L["Export Profile"],
            desc = L["Export your current profile to a string"],
            get = function() return MPTAPI:GetExportString() end,
            set = function() end,
            width = "full",
            multiline = 5,
        },
        ImportProfile = {
            type = "input",
            order = 9,
            name = L["Import Profile"],
            desc = L["Import a profile from a string"],
            set = function(_, value) MPTAPI:ImportProfile(value) end,
            get = function() return "" end,
            width = "full",
            multiline = 10,
        },
        DeleteProfile = DeleteProfile,
    }
}

local settings = {
	name = L["Display Settings"],
    childGroups = "tab",
	type = "group",
	args = {
        General = General,
        KeyInfoBar = KeyInfo,
        TimerBar = TimerBar,
        Bosses = Bosses,
        EnemyForces = EnemyForces,
        PBInfo = PBInfo,
    },    
}

function MPT.UI:OnInitialize()
    local AceConfig = LibStub("AceConfig-3.0")
	AceConfig:RegisterOptionsTable("MPlusTimer", MainOptions)
    AceConfig:RegisterOptionsTable("MPTSettings", settings)
    AceConfig:RegisterOptionsTable("MPTProfiles", profiles)
	self.optionsFrame = AceConfigdialog:AddToBlizOptions("MPlusTimer", "MPlusTimer")
    self.settingsFrame = AceConfigdialog:AddToBlizOptions("MPTSettings", L["Display Settings"], "MPlusTimer")
    self.profilesFrame = AceConfigdialog:AddToBlizOptions("MPTProfiles", L["Profiles"], "MPlusTimer")
	self:RegisterChatCommand("mpt", "SlashCommand")
	self:RegisterChatCommand("mplustimer", "SlashCommand")
end
