local _, MPT = ...
_G["MPTAPI"] = {}

function MPT:GetVersion()
    return 1
end

MPT.UI = LibStub("AceAddon-3.0"):NewAddon("Mythic Plus Timer", "AceConsole-3.0")