local _, MPT = ...

SLASH_MPT1 = "/mpt"
SLASH_MPT2 = "/mythicplus"
SLASH_MPT3 = "/mythicplustimer"
SlashCmdList["MPT"] = function(msg)
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
    else
        MPT:ToggleOptions()
    end
end