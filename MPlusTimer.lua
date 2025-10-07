local _, MPT = ...
_G["MPTAPI"] = {}

function MPTAPI:Init(preview)
    MPT:Init(preview)
end
function MPTAPI:Move(Unlock)
    MPT:MoveFrame(Unlock)
end