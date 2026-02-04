local _, MPT = ...
local L = LibStub("AceLocale-3.0"):GetLocale("MPlusTimer")
local Serialize = LibStub("AceSerializer-3.0")
local Compress = LibStub("LibDeflate")

function MPTAPI:ImportProfile(string, key, mainProfile) -- global import function
    if string then
        local decoded = Compress:DecodeForPrint(string)
        local decompressed = Compress:DecompressDeflate(decoded)
        local success, data = Serialize:Deserialize(decompressed)
        local name = key or data.name -- get name from data if it's not specifically provided
        if success and data and name then
            data.name = name -- ensure the profile key has the same name as stored in the profile table
            MPT:CreateImportedProfile(data, name, mainProfile)
            return true
        else
            print (L["Failed to import profile into MPlusTimer"])
            return false
        end
    end
end

function MPTAPI:GetExportString(key) -- global export function
    key = key or MPT.ActiveProfile -- export current profile if no key is provided
    if key and MPTSV.Profiles[key] then
        local serialized = Serialize:Serialize(MPTSV.Profiles[key])
        local compressed = Compress:CompressDeflate(serialized)
        local encoded = Compress:EncodeForPrint(compressed)
        return encoded
    end
end

function MPT:CreateImportedProfile(data, name, mainProfile)
    if data then
        name = name or data.name
        if not name then return end
        if MPTSV.Profiles[name] then -- change name if profile already exists
            name = name.." 2"
            self:CreateImportedProfile(data, name, mainProfile)
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
        if MPTSV.MainProfile and MPTSV.ProfileKey[ProfileKey] == "default" then 
            -- load main profile if character was using default profile before but user now has a main profile
            self:LoadProfile(MPTSV.MainProfile)
        else
            self:LoadProfile(MPTSV.ProfileKey[ProfileKey])
        end
    elseif MPTSV.MainProfile then -- load the selected Main Profile -> player is logging onto a new character
        self:LoadProfile(MPTSV.MainProfile)
    else
        self:CreateProfile("default") -- no valid profile found so we make/load the default profile
    end
end

function MPT:GetVersion()
    return 3
end

function MPT:ModernizeProfile(profile, generic)
    if generic then -- update non-profile settings if they don't exist yet
        if MPTSV.CloseBags == nil then MPTSV.CloseBags = true end
        if MPTSV.KeySlot == nil then MPTSV.KeySlot = true end
        if MPTSV.MinimapIcon == nil then MPTSV.MinimapIcon = {hide = true} end
    elseif profile and self:GetVersion() > profile.Version then
        if profile.Version < 2 then
            profile.TimerText.Decimals = 1
            profile.TimerText.SuccessColor = {0, 1, 0, 1}
            profile.TimerText.FailColor = {1, 0, 0, 1}
            profile.RealCount.CurrentPullColor = {0, 1, 0, 1}
            profile.PercentCount.CurrentPullColor = {0, 1, 0, 1}
            profile.Version = 2
        end
        if profile.Version < 3 then
            profile.Tick1 = profile.Ticks or {
                enabled = true,
                Width = 2,
                Color = {1, 1, 1, 1},
            }
            profile.Tick2 = profile.Ticks or {
                enabled = true,
                Width = 2,
                Color = {1, 1, 1, 1},
            }
            profile.Ticks = nil
            profile.RealCount.SquareBrackets = true
            profile.PercentCount.SquareBrackets = true
            profile.DeathCounter.ShowTimer = false
            profile.DeathCounter.SquareBrackets = true
            profile.TimerText.Space = true
            profile.Version = 3
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
                print(L["Cannot anchor to this element, it would create a loop. You need to first change the Anchor of"], value,  L["before you can set it as anchor target."])                return
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