local _, MPT = ...
local Serialize = LibStub("AceSerializer-3.0")
local Compress = LibStub("LibDeflate")

function MPTAPI:ImportProfile(string, key, mainProfile)
    if string then
        local decoded = Compress:DecodeForPrint(string)
        local decompressed = Compress:DecompressDeflate(decoded)
        local success, data = Serialize:Deserialize(decompressed)
        local name = key or data.name
        if success and data and name then
            data.name = name -- ensure the profile key has the same name as stored in the profile table
            MPT:CreateImportedProfile(data, name, mainProfile)
            return true
        else
            print("Failed to import profile into MPlusTimer")
            return false
        end
    end
end

function MPT:CreateImportedProfile(data, name, mainProfile)
    if data then
        name = name or data.name
        if not name then return end
        if MPTSV.Profiles[name] then -- change name if profile already exists
            name = name.." 2"
            self:CreateImportedProfile(data, name)
        else
            data.name = name -- ensure the profile key has the same name as stored in the profile table
            MPTSV.Profiles[name] = data
            self:LoadProfile(name)            
            if mainProfile then
                MPT:SetMainProfile(name)
            end
        end
    end
end

function MPTAPI:GetExportString(key)
    key = key or MPT.ActiveProfile
    if key and MPTSV.Profiles[key] then
        local serialized = Serialize:Serialize(MPTSV.Profiles[key])
        local compressed = Compress:CompressDeflate(serialized)
        local encoded = Compress:EncodeForPrint(compressed)
        return encoded
    end
end

function MPT:ExportProfile(key)
    local exportString = MPTAPI:GetExportString(key or self.ActiveProfile)
end

function MPT:SetMainProfile(name)
    if MPTSV.Profiles[name] then
        MPTSV.MainProfile = name
    end
end

function MPT:ResetProfile()
    if self.ActiveProfile and MPTSV.Profiles[self.ActiveProfile] then
        local oldname = MPTSV.Profiles[self.ActiveProfile].name
        MPTSV.Profiles[self.ActiveProfile] = nil
        MPT:CreateProfile(oldname)
    end

end
function MPT:DeleteProfile(name)
    if name and MPTSV.Profiles[name] and name ~= "default" then
        MPTSV.Profiles[name] = nil
        if MPTSV.MainProfile == name then
            MPTSV.MainProfile = nil
        end
        if self.ActiveProfile == name then
            self:CreateProfile("default") -- if current active profile gets deleted, we either load or create a default profile
        end
    end
end

function MPT:CopyProfile(name)
    if name and MPTSV.Profiles[self.ActiveProfile] and MPTSV.Profiles[name] then
        local oldname = MPTSV.Profiles[self.ActiveProfile].name
        MPTSV.Profiles[self.ActiveProfile] = CopyTable(MPTSV.Profiles[name])
        MPTSV.Profiles[self.ActiveProfile].name = oldname
        self:LoadProfile(self.ActiveProfile)
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
        self:ModernizeProfile(MPTSV.Profiles[name])
        for k, v in pairs(MPTSV.Profiles[name]) do
            self[k] = v
        end
        self.ActiveProfile = name
        MPTSV.ProfileKey[ProfileKey] = name
        self:UpdateDisplay()
    elseif MPTSV.ProfileKey[ProfileKey] and MPTSV.Profiles[MPTSV.ProfileKey[ProfileKey]] then -- load saved profile if no profile name was provided/the requested profile doesn't exist
        self:LoadProfile(MPTSV.ProfileKey[ProfileKey])
    elseif MPTSV.MainProfile then -- load the selected Main Profile -> player is logging onto a new character
        self:LoadProfile(MPTSV.MainProfile)
    else
        self:CreateProfile("default") -- no valid profile found so we make/load the default profile
    end
end

function MPT:ModernizeProfile(profile)
    if self:GetVersion() > profile.Version then
        if profile.Version < 2 then
            profile.TimerText.Decimals = 1
            profile.TimerText.SuccessColor = {0, 1, 0, 1}
            profile.TimerText.FailColor = {1, 0, 0, 1}
            profile.RealCount.CurrentPullColor = {0, 1, 0, 1}
            profile.PercentCount.CurrentPullColor = {0, 1, 0, 1}
            -- add stuff to profile that was missing in that version.
        end

        self.Version = self:GetVersion()
    end
end

function MPT:GetSV(key)
    local ref = self
    if type(key) == "table" and ref then           
        for i=1, #key do
            ref = ref[key[i]]
        end
    else
        ref = self[key]
    end
    return ref
end

function MPT:SetSV(key, value, update)
    if key and MPTSV.Profiles[self.ActiveProfile] then
        if type(key) == "table" then
            local ref = MPTSV.Profiles[self.ActiveProfile]
            local MPTref = self
            for i=1, #key-1 do
                ref = ref[key[i]]
                MPTref = MPTref[key[i]]
            end
            if self:HasAnchorLoop(key[1], value) then
                print("Cannot anchor to this element, it would create a loop. You need to first change the Anchor of", value, "before you can set it as anchor target.")
                return
            end
            ref[key[#key]] = value
            MPTref[key[#key]] = value
        else
            MPTSV.Profiles[self.ActiveProfile][key] = value
            self[key] = value
        end
    elseif MPTSV.Profiles[self.ActiveProfile] then -- full SV update
        for k, v in pairs(MPTSV.Profiles[self.ActiveProfile]) do
            v = self[k]
        end
    end
    if update then -- update display if settings were changed while the display is shown
        MPT:UpdateDisplay()
    end
end

function MPT:CreateProfile(name)
    if not MPTSV.Profiles then MPTSV.Profiles = {} end
    if not MPTSV.ProfileKey then MPTSV.ProfileKey = {} end
    if MPTSV.Profiles[name] then -- if profile with that name already exists we load it instead.
        self:LoadProfile(name)
        return 
    end
    local data = CopyTable(self.DefaultProfile)
    data.Version = self:GetVersion()
    data.name = name
    MPTSV.Profiles[name] = data
    self:LoadProfile(name)
    if name ~= "default" and not MPTSV.MainProfile then
        MPTSV.MainProfile = name -- if no main profile is set, we set the first created profile as main profile
    end
end

function MPT:ImportWAData(data)
    local data = {}
    local WANames = {"M+ Bosses", "M+ Enemy Forces Bar"}
    if not WeakAuras then print("Could not import WA data, WeakAura Addon appears to not be loaded") return end
    local LS = LibStub("LibSerialize") -- WA uses this library so we don't include it ourselves
    for i, name in ipairs(WANames) do
        local aura = WeakAuras.GetData(name)
        local saved = aura and aura.information and aura.information.saved
        if not saved then print("Could not import WA data, the aura appears to be missing or renamed") return end
        local decodedPrint =  Compress:DecodeForPrint(saved)
        local decompressedDeflated = Compress:DecompressDeflate(decodedPrint)
        local success, deserialized = LS:Deserialize(decompressedDeflated)
        if (not success) or (not deserialized) then print("Importing WA data failed.") return end
        if i == 1 then data.Bosses = deserialized else data.Forces = deserialized end     
    end
    if not data or not data.Bosses or not data.Forces or next(data.Bosses) == nil or next(data.Forces) == nil then
        print("Could not import WA data, there appears to be no data available.")
        return 
    end
    if not MPTSV.BestTime then MPTSV.BestTime = {} end
    if not MPTSV.BestTime[self.seasonID] then MPTSV.BestTime[self.seasonID] = {} end
    local importcount = 0
    for cmap, leveldata in pairs(data.Bosses) do
        if data.Forces[cmap] then
            if not MPTSV.BestTime[self.seasonID][cmap] then MPTSV.BestTime[self.seasonID][cmap] = {} end
            for level, timedata in pairs(leveldata) do
                if data.Forces[cmap][level] then
                    if not MPTSV.BestTime[self.seasonID][cmap][level] then MPTSV.BestTime[self.seasonID][cmap][level] = {} end
                    if not MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] then MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"] = {} end
                    local before = MPTSV.BestTime[self.seasonID][cmap][level]["finish"]
                    if (not before) or (timedata["finish"] < before) then
                        MPTSV.BestTime[self.seasonID][cmap][level]["finish"] = timedata["finish"]
                        MPTSV.BestTime[self.seasonID][cmap][level]["forces"] = data.Forces[cmap][level][0]
                        MPTSV.BestTime[self.seasonID][cmap][level]["level"] = level
                        MPTSV.BestTime[self.seasonID][cmap][level]["date"] = {}
                        for i=1, 5 do
                            if timedata[i] then
                                MPTSV.BestTime[self.seasonID][cmap][level][i] = timedata[i]
                                MPTSV.BestTime[self.seasonID][cmap][level]["BossNames"][i] = "Boss "..i
                            end
                        end
                        importcount = importcount + 1
                    end
                end
            end
        end
    end
    print("Successfully imported", importcount, "best times from WA into MPlusTimer.")
end