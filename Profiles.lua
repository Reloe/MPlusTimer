local _, MPT = ...

function MPT:SetMainProfile(name)
    if MPTSV.Profiles[name] then
        MPTSV.MainProfile = name
    end
end

function MPT:LoadProfile(name)    
    if not MPTSV.Profiles then MPTSV.Profiles = {} end
    if not MPTSV.ProfileKey then MPTSV.ProfileKey = {} end
    
    local CharName, Realm = UnitFullName("player")
    if not Realm then
        Realm = GetNormalizedRealmName()
    end
    local ProfileKey = CharName.."-"..Realm
    if name and MPTSV.Profiles[name] then -- load requested profile
        MPT:ModernizeProfile(MPTSV.Profiles[name])
        for k, v in pairs(MPTSV.Profiles[name]) do
            MPT[k] = v
        end

        MPT.ActiveProfile = name
        MPTSV.ProfileKey[ProfileKey] = name
        
        if not MPTSV.MainProfile then
            MPT:SetMainProfile(name)
        end
    elseif MPTSV.ProfileKey[ProfileKey] and MPTSV.Profiles[MPTSV.ProfileKey[ProfileKey]] then -- load saved profile if no profile name was provided/the requested profile doesn't exist
        MPT:LoadProfile(MPTSV.ProfileKey[ProfileKey])
    elseif MPTSV.MainProfile then -- load the selected Main Profile -> player is logging onto a new character
        MPT:LoadProfile(MPTSV.MainProfile)
    else
        MPT:CreateProfile("default") -- no valid profile found so we make/load the default profile
    end
end

function MPT:ModernizeProfile(profile)
    if MPT:GetVersion() > profile.Version then
        if profile.Version < 2 then  
            -- add stuff to profile that was missing in that version.
        end

        profile.Version = MPT:GetVersion()
    end
end

function MPT:CreateImportedProfile(data, name)
    if data and name then
        if MPTSV.Profiles[name] then -- change name if profile already exists
            name = name.." 2"
            MPT:CreateImportedProfile(data, name)
        else
            MPTSV.Profiles[name] = data
            MPT:LoadProfile(name)
        end
    end
end

function MPT:GetSV(key)
    local ref = MPT
    if type(key) == "table" and ref then           
        for i=1, #key do
            ref = ref[key[i]]
        end
    else
        ref = MPT[key]
    end
    return ref
end

function MPT:SetSV(key, value, update, BestTimes)
    if key and MPTSV.Profiles[MPT.ActiveProfile] then
        if type(key) == "table" then
            local ref = MPTSV.Profiles[MPT.ActiveProfile]
            local MPTref = MPT
            local keyname = ""
            for i=1, #key-1 do
                ref = ref[key[i]]
                MPTref = MPTref[key[i]]
                keyname = keyname..key[i].."."
            end
            keyname = keyname..key[#key]
            ref[key[#key]] = value
            MPTref[key[#key]] = value
        else
            MPTSV.Profiles[MPT.ActiveProfile][key] = value
            MPT[key] = value
        end
    elseif BestTimes and MPTSV.Profiles[MPT.ActiveProfile] then -- Save Best Times to SV at end of run
        MPTSV.Profiles[MPT.ActiveProfile].BestTime = MPT.BestTime
    elseif MPTSV.Profiles[MPT.ActiveProfile] then -- full SV update
        for k, v in pairs(MPTSV.Profiles[MPT.ActiveProfile]) do
            v = MPT[k]
        end
    end
    if update then -- update display if settings were changed while the display is shown
        if MPT.IsPreview then
            MPT:Init(true)
        elseif C_ChallengeMode.IsChallengeModeActive() then
            MPT:Init(false)
        end
    end
end

function MPT:CreateProfile(name)
    if not MPTSV.Profiles then MPTSV.Profiles = {} end
    if not MPTSV.ProfileKey then MPTSV.ProfileKey = {} end
    if MPTSV.Profiles[name] then -- if profile with that name already exists we load it instead.
        MPT:LoadProfile(name)
        return 
    end
    local data = {}
    
    data.Version = MPT:GetVersion()
    data.name = name    
    data.Spacing = 3
    data.UpdateRate = 0.2
    data.Scale = 1
    data.HideTracker = true
    data.LowerKey = true
    data.CloseBags = true
    data.KeySlot = true
    data.BestTime = {}
    
    data.Background = {
        enabled = true,
        Color = {0, 0, 0, 0.5},
        BorderColor = {0, 0, 0, 1},
    }
    data.Position = {
        xOffset = 0,
        yOffset = 250,
        Anchor = "RIGHT",
        relativeTo = "RIGHT",
    }
    data.KeyLevel = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "LEFT",
        xOffset = 0,
        yOffset = -1,
        Font = "Expressway",
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}
    }
    data.DungeonName = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "RIGHT",
        xOffset = 0,
        yOffset = 0,
        Font = "Expressway",
        FontSize = 15,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}
    }
    data.AffixIcons = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "RIGHT",
        xOffset = 0,
        yOffset = 0,
        Font = "Expressway",
        FontSize = 14,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}
    }
    data.DeathCounter = {
        enabled = true,
        IconAnchor = "RIGHT",
        IconRelativeTo = "RIGHT",
        Anchor = "RIGHT",
        RelativeTo = "LEFT",
        xOffset = 0,
        yOffset = -1,
        IconxOffset = 0,
        IconyOffset = 0,
        Font = "Expressway",
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}
    }
    data.KeyInfo = {
        enabled = true,
        Width = 330,
        Height = 16,
        xOffset = 0,
        yOffset = 0,
    }

    data.TimerBar = {
        Splits = true,
        Width = 330,
        Height = 24,
        xOffset = 0,
        yOffset = 0,
        Texture = "Details Flat",
        ChestTimerDisplay = 1, -- 1 == relevant timers. 2 == all timers. 3 = no timers
        Color = {{89/255, 90/255, 92/255, 1}, {1, 112/255, 0, 1}, {1, 1, 0, 1}, {128/255, 1, 0, 1}},
        BorderSize = 1,
        BackgroundColor = {0, 0, 0, 0.5},
        BorderColor = {0, 0, 0, 1},    
    }
    data.TimerText = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "LEFT",
        xOffset = 2,
        yOffset = 0,
        Font = "Expressway",
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}
    }
    data.ComparisonTimer = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "LEFT",
        xOffset = 0,
        yOffset = 0,
        Font = "Expressway",
        FontSize = 16,
        Outline = "OUTLINE",
        SuccessColor = {0, 1, 0, 1},
        EqualColor = {1, 0.8, 0, 1},
        FailColor = {1, 0, 0, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0},
    }
    data.ChestTimer = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "RIGHT",
        xOffset = {0, -65, -130},
        yOffset = 0,
        Font = "Expressway",
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        DepleteColor = {1, 0, 0, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0},
    }
    data.Ticks = {        
        enabled = true,
        Width = 2,  
        Color = {1, 1, 1, 1},
    }
    
    data.Bosses = {
        Width = 330,
        Height = 16,
        xOffset = 0,
        yOffset = 0,
    }
    data.BossName = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "LEFT",
        MaxLength = 20,
        xOffset = 2,
        yOffset = 0,
        Font = "Expressway",
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        CompletionColor = {0, 1, 0, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0} 
    }
    data.BossTimer = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "RIGHT",
        xOffset = 0,
        yOffset = 0,
        Font = "Expressway",
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0},
        SuccessColor = {0, 1, 0, 1},
        EqualColor = {1, 0.8, 0, 1},
        FailColor = {1, 0, 0, 1},  
    }
    data.BossSplit = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "RIGHT",
        xOffset = -70,
        yOffset = 0,
        Font = "Expressway",
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0},
        SuccessColor = {0, 1, 0, 1},
        EqualColor = {1, 0.8, 0, 1},
        FailColor = {1, 0, 0, 1},
    }
    data.ForcesBar = {
        enabled = true,
        Width = 330,
        Height = 24,
        xOffset = 0,
        yOffset = 0,
        Texture = "Details Flat",
        Color = {{1, 117/255, 128/255, 1}, {1, 130/255, 72/255, 1}, {1, 197/255, 103/255, 1}, {1, 249/255, 150/255, 1}, {104/255, 205/255, 1, 1}},
        CompletionColor = {205/255, 1, 167/255, 1},        
        BorderSize = 1,
        BackgroundColor = {0, 0, 0, 0.5},
        BorderColor = {0, 0, 0, 1},  
        PercentCount = {
            enabled = true,
            Anchor = "LEFT",
            RelativeTo = "LEFT",
            xOffset = 2,
            yOffset = 0,
            Font = "Expressway",
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0}
        },
        RealCount = {
            enabled = true,
            Anchor = "RIGHT",
            RelativeTo = "RIGHT",
            xOffset = -1,
            yOffset = 0,
            Font = "Expressway",
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0}
        },        
        Splits = {
            enabled = true,
            Anchor = "CENTER",
            RelativeTo = "CENTER",
            xOffset = 0,
            yOffset = 0,
            Font = "Expressway",
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            CompletionColor = {0, 1, 0, 1},
            FailColor = {1, 0, 0, 1},
            EqualColor = {1, 1, 0, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0}
        },
    }
    MPTSV.Profiles[name] = data
    MPT:LoadProfile(name)
end