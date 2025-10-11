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
            print("Failed to import profile into Mythic Plus Timer")
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
            -- add stuff to profile that was missing in that version.
        end

        profile.Version = self:GetVersion()
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

function MPT:SetSV(key, value, update, BestTimes)
    if key and MPTSV.Profiles[self.ActiveProfile] then
        if type(key) == "table" then
            local ref = MPTSV.Profiles[self.ActiveProfile]
            local MPTref = self
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
            MPTSV.Profiles[self.ActiveProfile][key] = value
            self[key] = value
        end
    elseif BestTimes and MPTSV.Profiles[self.ActiveProfile] then -- Save Best Times to SV at end of run
        MPTSV.Profiles[self.ActiveProfile].BestTime = self.BestTime
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
    local data = CopyTable(MPT.DefaultProfile)
    data.Version = self:GetVersion()
    data.name = name
    MPTSV.Profiles[name] = data
    self:LoadProfile(name)
    if name ~= "default" and not MPTSV.MainProfile then
        MPTSV.MainProfile = name -- if no main profile is set, we set the first created profile as main profile
    end
end