local _, MPT = ...

function MPT.UI:SlashCommand(msg)
    if msg == "debug" then
        if MPTSV.debug then
            MPTSV.debug = false
            MPTGlobal = nil
            print("Disabled debug mode for MPlusTimer")
        else
            MPTSV.debug = true
            MPTGlobal = MPT
            print("Enabled debug mode for MPlusTimer, which allows accessing all local functions")
        end
    elseif msg == "preview" then
        if not MPT.IsPreview then -- not currently in preview
            self:Init(true) -- Frame is set to movable in here as well
        elseif C_ChallengeMode.IsChallengeModeActive() then -- in preview and currently in m+ so we display real states
            self:Init(false)
            self:MoveFrame(false)
        elseif self.Frame and self.Frame:IsShown() then -- in preview but not in m+ so we hide the frame
            self:ShowFrame(false)
        end 
    elseif msg == "best" then
        self:ShowPBFrame()
    else
        Settings.OpenToCategory(self.optionsFrame.name)
    end
end