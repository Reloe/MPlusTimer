local _, MPT = ...


function MPT.UI:SlashCommand(msg)
    if msg == "debug" then
        if MPTSV.debug then
            MPTSV.debug = false
            MPTAPI = {}
            print("Disabled debug mode for Mythic Plus Timer")
        else
            MPTSV.debug = true
            MPTAPI = MPT
            print("Enabled debug mode for Mythic Plus Timer, which allows accessing all local functions")
        end
    elseif msg == "preview" then
        if not MPT.IsPreview then -- not currently in preview
            MPT:Init(true) -- Frame is set to movable in here as well
        elseif C_ChallengeMode.IsChallengeModeActive() then -- in preview and currently in m+ so we display real states
            MPT:Init(false)
            MPT:MoveFrame(false)
        elseif MPT.Frame and MPT.Frame:IsShown() then -- in preview but not in m+ so we hide the frame
            MPT:ShowFrame(false)
        end 
    else
        Settings.OpenToCategory(self.optionsFrame.name)
    end
end