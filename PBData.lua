local _, MPT = ...

function MPT:UpdatePB(time, forces, cmap, level, date, BossTimes, BossNames) -- called on completion of a run
    if (not self.seasonID) or self.seasonID == 0 then
        C_MythicPlus.RequestMapInfo()
        self.seasonID = C_MythicPlus.GetCurrentSeason()
        if (not self.seasonID) or self.seasonID == 0 then return end
    end
    if not MPTSV.BestTime then MPTSV.BestTime = {} end
    if not MPTSV.BestTime[self.seasonID] then MPTSV.BestTime[self.seasonID] = {} end
    if not MPTSV.BestTime[self.seasonID][cmap] then MPTSV.BestTime[self.seasonID][cmap] = {} end
    if not MPTSV.BestTime[self.seasonID][cmap][level] then MPTSV.BestTime[self.seasonID][cmap][level] = {} end
    local before = MPTSV.BestTime[self.seasonID][cmap][level]["finish"] or (self.LowerKey and MPTSV.BestTime[self.seasonID][cmap][level-1] and MPTSV.BestTime[self.seasonID][cmap][level-1]["finish"])
    if (not MPTSV.BestTime[self.seasonID][cmap][level]["finish"]) or time < MPTSV.BestTime[self.seasonID][cmap][level]["finish"] then
        MPTSV.BestTime[self.seasonID][cmap][level]["finish"] = time
        MPTSV.BestTime[self.seasonID][cmap][level]["forces"] = forces
        MPTSV.BestTime[self.seasonID][cmap][level]["level"] = level
        MPTSV.BestTime[self.seasonID][cmap][level]["date"] = {date.monthDay, date.month, date.year, date.hour, date.minute}
        if not MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] then MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] = {} end
        for i, v in ipairs(BossTimes or {}) do
            MPTSV.BestTime[self.seasonID][cmap][level][i] = v
            if BossNames[i] then
                MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"][i] = BossNames[i]
            end
        end
    end
    return before
end

function MPT:AddCharacterHistory(tryagain)
    if PlayerIsTimerunning() then return end -- do not add remix data
    C_MythicPlus.RequestMapInfo() -- try to refresh data
    if (not self.seasonID) or self.seasonID == 0 then
        self.seasonID = C_MythicPlus.GetCurrentSeason()
        if (not self.seasonID) or self.seasonID == 0 then return end -- avoid doing anything if no seasonID was found, we are likely in pre-season
    end
    local G = UnitGUID("player") 
    local data = (C_MythicPlus.GetRunHistory(true, true))
    if (not data) or #data == 0 then
        -- nil the current character if no/empty data.
        if MPTSV.History[self.seasonID] and MPTSV.History[self.seasonID][G] then MPTSV.History[self.seasonID][G] = nil end
        return
    end
    if not MPTSV.History then MPTSV.History = {} end
    if not MPTSV.History[self.seasonID] then MPTSV.History[self.seasonID] = {} end
    -- clear current character data to avoid duplicates
    local olddata = MPTSV.History[self.seasonID][G] and CopyTable(MPTSV.History[self.seasonID][G]) -- need this to keep abandoned data
    MPTSV.History[self.seasonID][G] = {name = UnitName("player"), realm = GetNormalizedRealmName(), class = select(2, UnitClass("player"))}
    for i, v in ipairs(data) do
        local cmap = v.mapChallengeModeID
        local level = v.level
        local time = v.durationSec
        local intime = v.completed
         -- only add runs from dungeons of the current season. Might be relevant for remix? 
        if self.SeasonData[self.seasonID] and self.SeasonData[self.seasonID].Dungeons and tContains(self.SeasonData[self.seasonID].Dungeons, cmap) then
            if not MPTSV.History[self.seasonID][G][cmap] then MPTSV.History[self.seasonID][G][cmap] = {intime = 0, depleted = 0, highestrun = 0, abandoned = (olddata and olddata[cmap] and olddata[cmap].abandoned) or 0} end
            if not MPTSV.History[self.seasonID][G][cmap][level] then MPTSV.History[self.seasonID][G][cmap][level] = {intime = 0, depleted = 0, abandoned = (olddata and olddata[cmap] and olddata[cmap][level] and olddata[cmap][level].abandoned) or 0} end
            if not MPTSV.History[self.seasonID][G].keys then MPTSV.History[self.seasonID][G].keys = {} end
            MPTSV.History[self.seasonID][G].keys[i] = true
            self:AddHistory(time, cmap, level, intime, false)
        end
    end
end

function MPT:AddHistory(time, cmap, level, intime, abandoned) -- abandoned runs get added manually. Everything else is through API    
    local G = UnitGUID("player")
    if abandoned and level and cmap then
        if not MPTSV.History[self.seasonID] then MPTSV.History[self.seasonID] = {} end
        if (not self.SeasonData[self.seasonID]) or (not self.SeasonData[self.seasonID].Dungeons) or (not tContains(self.SeasonData[self.seasonID].Dungeons, cmap)) then return end -- only add runs from dungeons of the current season
        if not MPTSV.History[self.seasonID][G] then MPTSV.History[self.seasonID][G] = {name = UnitName("player"), realm = GetNormalizedRealmName(), class = select(3, UnitClass("player"))} end
        if not MPTSV.History[self.seasonID][G][cmap] then MPTSV.History[self.seasonID][G][cmap] = {intime = 0, depleted = 0, highestrun = 0, abandoned = 0} end
        if not MPTSV.History[self.seasonID][G][cmap][level] then MPTSV.History[self.seasonID][G][cmap][level] = {intime = 0, depleted = 0, abandoned = 0} end
        MPTSV.History[self.seasonID][G][cmap].abandoned = (MPTSV.History[self.seasonID][G][cmap].abandoned or 0) + 1
        MPTSV.History[self.seasonID][G][cmap][level].abandoned = (MPTSV.History[self.seasonID][G][cmap][level].abandoned or 0) + 1
        return
    end
    if time and not MPTSV.History[self.seasonID][G][cmap].fastestrun then
        MPTSV.History[self.seasonID][G][cmap].fastestrun = time*1000
    end
    if intime then
        MPTSV.History[self.seasonID][G][cmap].intime = MPTSV.History[self.seasonID][G][cmap].intime + 1
        MPTSV.History[self.seasonID][G][cmap][level].intime = MPTSV.History[self.seasonID][G][cmap][level].intime + 1
        if level > MPTSV.History[self.seasonID][G][cmap].highestrun then -- save highest run, which is then also "fastest" run
            MPTSV.History[self.seasonID][G][cmap].highestrun = level
            MPTSV.History[self.seasonID][G][cmap].fastestrun = time*1000
        elseif level == MPTSV.History[self.seasonID][G][cmap].highestrun and time*1000 < MPTSV.History[self.seasonID][G][cmap].fastestrun then
            MPTSV.History[self.seasonID][G][cmap].fastestrun = time*1000 -- save faster run if same level
        end
    elseif time then 
        MPTSV.History[self.seasonID][G][cmap][level].depleted = MPTSV.History[self.seasonID][G][cmap][level].depleted + 1
        MPTSV.History[self.seasonID][G][cmap].depleted = MPTSV.History[self.seasonID][G][cmap].depleted + 1
    end
end

function MPT:GetPB(cmap, level, seasonID, lowerkey)
    C_MythicPlus.RequestMapInfo()
    self.seasonID = seasonID or ((self.seasonID and self.seasonID ~= 0 and self.seasonID) or C_MythicPlus.GetCurrentSeason())
    return MPTSV.BestTime and MPTSV.BestTime[self.seasonID] and MPTSV.BestTime[self.seasonID][cmap] and (MPTSV.BestTime[self.seasonID][cmap][level] or (lowerkey and MPTSV.BestTime[self.seasonID][cmap][level-1]))
end

function MPT:AddRun(cmap, level, seasonID, time, forces, date, BossNames, BossTimes) -- called when manually adding a run
    C_MythicPlus.RequestMapInfo()
    for i, v in ipairs(BossTimes) do
        if type(v) == "string" then
            BossTimes[i] = self:StrToTime(v)
        end
    end
    self.seasonID = seasonID or (self.seasonID and self.seasonID ~= 0 and self.seasonID or C_MythicPlus.GetCurrentSeason())
    if not MPTSV.BestTime then MPTSV.BestTime = {} end
    if not MPTSV.BestTime[self.seasonID] then MPTSV.BestTime[self.seasonID] = {} end
    if not MPTSV.BestTime[self.seasonID][cmap] then MPTSV.BestTime[self.seasonID][cmap] = {} end
    if time and forces and BossNames and cmap and level and BossTimes and type(BossTimes) == "table" then
        MPTSV.BestTime[self.seasonID][cmap][level] = MPTSV.BestTime[self.seasonID][cmap][level] or {}
        MPTSV.BestTime[self.seasonID][cmap][level] = BossTimes
        MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] = BossNames
        MPTSV.BestTime[self.seasonID][cmap][level]["finish"] = time*1000
        MPTSV.BestTime[self.seasonID][cmap][level]["forces"] = forces
        MPTSV.BestTime[self.seasonID][cmap][level]["date"] = date
        MPTSV.BestTime[self.seasonID][cmap][level]["level"] = level
    end
end