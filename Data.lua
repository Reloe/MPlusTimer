local _, MPT = ...
MPT.maptoID = { -- MapChallengeMode = JournalInstance
    -- Wrath of the Lich King
    [556] = {278, "Pit of Saron"},
    -- Cata
    [438] = {68, "Vortex Pinnacle"},
    [456] = {65, "Throne"},
    [507] = {71, "Grim Batol"},
    [541] = {67, "Stonecore"},
    -- MoP
    [2] =  {313, "Jade Serpent"},
    [56] = {302, "Stromsout"},
    [57] = {303, "Setting Sun"},
    [58] = {312, "Shadow-Pan"},
    [59] = {324, "Niuzao"},
    [60] = {321, "Mogu'shan"},
    [76] = {246, "Scholomance"},
    [77] = {311, "Scarlet Halls"},
    [78] = {316, "Monastery"},
    
    -- WoD
    [161] = {476, "Skyreach"},
    [163] = {385, "Slag Mines"},
    [164] = {547, "Auchindoun"},
    [165] = {537, "Shadowmoon"},
    [166] = {536, "Grimrail"},
    [167] = {559, "UBRS"},
    [168] = {556, "Everbloom"},
    [169] = {558, "Iron Docks"},
    
    -- Legion
    [197] = {716, "Eye of Azshara"},
    [198] = {762, "Darkheart"},
    [199] = {740, "BRH"},
    [200] = {721, "Halls of Valor"},
    [206] = {767, "Neltharion's Lair"},
    [207] = {707, "Vault"},
    [208] = {727, "Maw of Souls"},
    [209] = {726, "Arcway"},
    [210] = {800, "Court of Stars"},
    [227] = {860, "Kara: Lower"},
    [233] = {900, "Cathedral"},
    [234] = {860, "Kara: Upper"},
    [239] = {945, "Seat"},
    
    -- BfA
    [244] = {968, "Atal'Dazar"},
    [245] = {1001, "Freehold"},
    [246] = {1002, "Tol Dagor"},
    [247] = {1012, "Motherlode"},
    [248] = {1021, "Waycrest"},
    [249] = {1041, "King's Rest"},
    [250] = {1030, "Sethraliss"},
    [251] = {1022, "Underrot"},
    [252] = {1036, "Shrine"},
    [353] = {1023, "Boralus"},
    [369] = {1178, "Junkyard"},
    [370] = {1178, "Workshop"},
    
    -- Shadowlands
    [375] = {1184, "Mists"},
    [376] = {1182, "Necrotic Wake"},
    [377] = {1188, "Other Side"},
    [378] = {1185, "Halls"},
    [379] = {1183, "Plaguefall"},
    [380] = {1189, "Sanguine"},
    [381] = {1186, "Spires"},
    [382] = {1187, "Theater"},
    [391] = {1194, "Streets"},
    [392] = {1194, "Gambit"},
    
    -- Dragonflight
    
    [399] = {1202, "Ruby Pools"},
    [400] = {1198, "Nokhud"},
    [401] = {1203, "Azure Vault"},
    [402] = {1201, "Academy"},
    [403] = {1197, "Uldaman"},
    [404] = {1199, "Neltharus"},
    [405] = {1196, "Brackenhide"},
    [406] = {1204, "Halls"},
    [463] = {1209, "DotI: Lower"},
    [464] = {1209, "DotI: Upper"},
    
    -- The War Within
    
    [499] = {1267, "Priory"},
    [500] = {1268, "The Rookery"},
    [501] = {1269, "Stonevault"},
    [502] = {1274, "City of Threads"},
    [503] = {1271, "Ara-Kara"},
    [504] = {1210, "Darkflame Cleft"},
    [505] = {1270, "Dawnbreaker"},
    [506] = {1272, "Cinderbrew Meadery"},
    [525] = {1298, "Floodgate"},
    [542] = {1303, "Eco-Dome"},

    -- Midnight

    [557] = {1299, "Windrunner Spire"},
    [558] = {1300, "Magisters' Terrace"},
    [559] = {1316, "Nexus-Point"},
    [560] = {1315, "Maisara Caverns"},

    --[[
    [0] = {1304, "Murder Row"},
    [0] = {1311, "Den of Nalorakk"},
    [0] = {1309, "Blinding Vale"},
    [0] = {1313, "Voidscar Arena"},
    ]]
    
}

function MPT:DefaultValues()
    MPTSV.Spacing = 3
    MPTSV.UpdateRate = 0.2
    MPTSV.Scale = 1
    MPTSV.ChestTimerdisplay = 1 -- currently unused
    MPTSV.TimerBar = {
        Splits = true,
        Width = 330,
        Height = 24,
        XOffset = 0,
        YOffset = 0,
        Texture = LSM:Fetch("statusbar", "Details Flat"),
        Color = {128/255, 1, 0, 1},
        ChestColor = {{89/255, 90/255, 92/255, 1}, {1, 112/255, 0, 1}, {1, 1, 0, 1}, {128/255, 1, 0, 1}},
        BorderSize = 1,
        BackgroundColor = {0, 0, 0, 0.5},
        BorderColor = {0, 0, 0, 1},    
    }
    MPTSV.TimerText = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "LEFT",
        XOffset = 2,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0}
    }
    MPTSV.ComparisonTimer = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "LEFT",
        XOffset = 0,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        SuccessColor = {0, 1, 0, 1},
        EqualColor = {1, 0.8, 0, 1},
        FailColor = {1, 0, 0, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0},
        Justify = "RIGHT",
    }
    MPTSV.ChestTimer = {}
    for i=1, 3 do
        local t = {
            enabled = true,
            Anchor = "RIGHT",
            RelativeTo = "RIGHT",
            XOffset = (i-1)*-65,
            YOffset = 0,
            Font = LSM:Fetch("font", "Expressway"),
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            DepleteColor = {1, 0, 0, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0},
        }
        table.insert(MPTSV.ChestTimer, t)
    end
    MPTSV.Ticks = {        
        enabled = true,
        Width = 2,  
        Color = {1, 1, 1, 1},
    }
    MPTSV.Background = {
        enabled = true,
        Color = {0, 0, 0, 0.57},
        BorderColor = {0, 0, 0, 1},
    }
    MPTSV.Position = {
        XOffset = 0,
        YOffset = 0,
    }
    MPTSV.KeyInfo = {
        Width = 330,
        Height = 16,
        XOffset = 0,
        YOffset = 0,
        KeyLevel = {
            enabled = true,
            Anchor = "LEFT",
            RelativeTo = "LEFT",
            XOffset = 0,
            YOffset = -2,
            Font = LSM:Fetch("font", "Expressway"),
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0}
        },
        DungeonName = {
            enabled = true,
            Anchor = "LEFT",
            RelativeTo = "RIGHT",
            XOffset = 0,
            YOffset = 0,
            Font = LSM:Fetch("font", "Expressway"),
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0}
        },
        AffixIcons = {
            enabled = true,
            Anchor = "LEFT",
            RelativeTo = "RIGHT",
            XOffset = 0,
            YOffset = -2,
            Font = LSM:Fetch("font", "Expressway"),
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0}
        },
        DeathCounter = {
            enabled = true,
            IconAnchor = "RIGHT",
            IconRelativeTo = "RIGHT",
            Anchor = "RIGHT",
            RelativeTo = "LEFT",
            XOffset = 0,
            YOffset = 0,
            IconXOffset = 0,
            IconYOffset = 0,
            Font = LSM:Fetch("font", "Expressway"),
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0}
        },
    }
    MPTSV.Bosses = {
        Width = 330,
        Height = 16,
        XOffset = 0,
        YOffset = 0,
    }
    MPTSV.BossName = {
        enabled = true,
        Anchor = "LEFT",
        RelativeTo = "LEFT",
        XOffset = 2,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        CompletionColor = {0, 1, 0, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0} 
    }
    MPTSV.BossTimer = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "RIGHT",
        XOffset = 0,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0},
        SuccessColor = {0, 1, 0, 1},
        EqualColor = {1, 0.8, 0, 1},
        FailColor = {1, 0, 0, 1},  
    }
    MPTSV.BossSplit = {
        enabled = true,
        Anchor = "RIGHT",
        RelativeTo = "RIGHT",
        XOffset = -70,
        YOffset = 0,
        Font = LSM:Fetch("font", "Expressway"),
        FontSize = 16,
        Outline = "OUTLINE",
        Color = {1, 1, 1, 1},
        ShadowColor = {0, 0, 0, 1},
        ShadowOffset = {0, 0},
        SuccessColor = {0, 1, 0, 1},
        EqualColor = {1, 0.8, 0, 1},
        FailColor = {1, 0, 0, 1},
    }
    MPTSV.ForcesBar = {
        Width = 330,
        Height = 24,
        XOffset = 0,
        YOffset = 0,
        Texture = LSM:Fetch("statusbar", "Details Flat"),
        Color = {{1, 117/255, 128/255, 1}, {1, 130/255, 72/255, 1}, {1, 197/255, 103/255, 1}, {1, 249/255, 150/255, 1}, {104/255, 205/255, 1, 1}},
        CompletionColor = {205/255, 1, 167/255, 1},
        BorderSize = 1,
        BackgroundColor = {0, 0, 0, 0.5},
        BorderColor = {0, 0, 0, 1},  
        PercentCount = {
            enabled = true,
            Anchor = "LEFT",
            RelativeTo = "LEFT",
            XOffset = 0,
            YOffset = 0,
            Font = LSM:Fetch("font", "Expressway"),
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
            XOffset = 0,
            YOffset = 0,
            Font = LSM:Fetch("font", "Expressway"),
            FontSize = 16,
            Outline = "OUTLINE",
            Color = {1, 1, 1, 1},
            ShadowColor = {0, 0, 0, 1},
            ShadowOffset = {0, 0}
        },
    }
end