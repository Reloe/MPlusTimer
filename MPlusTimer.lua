local _, MPT = ...
_G["MPTAPI"] = {}
local L = LibStub("AceLocale-3.0"):GetLocale("MPlusTimer")
MPT.L = L
MPT.UI = LibStub("AceAddon-3.0"):NewAddon("MPlusTimer", "AceConsole-3.0")
MPT.LSM = LibStub("LibSharedMedia-3.0")
MPT.LSM:Register("font","Expressway", [[Interface\Addons\MPlusTimer\Media\Expressway.TTF]])