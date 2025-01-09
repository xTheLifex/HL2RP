/* -------------------------------------------------------------------------- */
/*                                 Client Code                                */
/* -------------------------------------------------------------------------- */

Clockwork.config:AddToSystem("AFK - Auto", "afk_auto", "Enables players automatically going AFK.", nil, nil, nil, "AFK")
Clockwork.config:AddToSystem("AFK - Idle Time", "afk_time", "Time in seconds before someone is considered AFK.", 1, 720, nil, "AFK")
Clockwork.config:AddToSystem("AFK - Cooldown", "afk_cooldown", "Time in seconds before someone can /afk again.", 1, 720, nil, "AFK")

-- Meta additions
local metaPlayer = FindMetaTable("Player")

function metaPlayer:SetAFK(isAFK)
    afk.players[self] = isAFK or true
end

net.Receive("cwAFK", function ()
    local ply = net.ReadPlayer()
    local isAFK = net.ReadBool()

    if not IsValid(ply) then return end
end)

function afk.DrawTargetPlayerStatus(ply, alpha, x, y)
    if not IsValid(ply) then return end

    local color = Color(65,128,128)
    local gender, thirdperson = ply:GetPronouns()

    if ply:Alive() and ply:IsAFK() then
        return Clockwork.kernel:DrawInfo(thirdperson .. " player seems to be AFK.", x, y, color, alpha)
    end
end