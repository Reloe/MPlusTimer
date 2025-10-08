local _, MPT = ...

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font","Expressway", [[Interface\Addons\MPlusTimer\Expressway.TTF]])

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