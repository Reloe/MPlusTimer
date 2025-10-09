local _, MPT = ...


function MPTUI:SlashCommand(msg)
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
        if MPT.Movable then
            MPT:MoveFrame(false) 
        else
            if not MPT.Frame or not MPT.Frame:IsShown() then
                MPT:Init(true)
            end
            MPT:MoveFrame(true)
        end
    else
        Settings.OpenToCategory(self.optionsFrame.name)
    end
end