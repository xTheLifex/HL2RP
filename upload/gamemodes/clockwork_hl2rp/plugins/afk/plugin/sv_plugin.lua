/* -------------------------------------------------------------------------- */
/*                                 Server Code                                */
/* -------------------------------------------------------------------------- */

Clockwork.config:Add("afk_time", 60, true, true)
Clockwork.config:Add("afk_cooldown", 10, true, true)
Clockwork.config:Add("afk_auto", true, true, true)

util.AddNetworkString("cwAFK")

-- Meta additions

local metaPlayer = FindMetaTable("Player")

function metaPlayer:SetAFK(isAFK)
    local wasAFK = afk.players[self]
    afk.players[self] = isAFK
    net.Start("cwAFK")
    net.WritePlayer(self)
    net.WriteBool(isAFK)
    net.Broadcast()

    if (isAFK and !wasAFK) then
        Clockwork.player:Notify(self, {"You are now AFK!"})
    end
    
    if (wasAFK and !isAFK) then
        Clockwork.player:Notify(self, {"You are no longer AFK!"})
    end
end

-- Clear AFK if player chats.
function afk:ChatBoxMessageAdded(info)
    if not ( Clockwork.config:Get("afk_auto"):Get() ) then return end
    local listeners = info.listeners
    local speaker = info.speaker
    local text = info.text
    local class = info.class

    if not IsValid(speaker) then return end
    speaker:SetAFK(false)
end

-- Calculate last activity time
-- Clear AFK if player looks around
-- Set AFK if player hasn't had any activity.
function afk:PlayerThink(ply, curTime, infoTable)
    ply.LastActivity = ply.LastActivity or curTime
    ply.LastAimVector = ply.LastAimVector or ply:GetAimVector()

    -- Calculate the angle difference between the current aim vector and the last recorded aim vector
    local aimChange = ply:GetAimVector():Dot(ply.LastAimVector)

    -- If the player's aim vector has significantly changed, they are considered active
    if (aimChange < 0.99) then -- Adjust threshold as needed
        if (ply:IsAFK()) then ply:SetAFK(false) end
        ply.LastActivity = curTime
        ply.LastAimVector = ply:GetAimVector()
    end

    -- Check if the player has been inactive for longer than the configured AFK time
    if (curTime - ply.LastActivity > Clockwork.config:Get("afk_time"):Get()) then
        if (!ply:IsAFK()) then ply:SetAFK(true) end
    end
end

-- Detect if the player is trying to move
hook.Add("KeyPress", "AFKPlayerKeyPress", function(ply, key)
    if not IsValid(ply) then return end

    local KEYS = {
        [IN_FORWARD] = true,
        [IN_BACK] = true,
        [IN_LEFT] = true,
        [IN_RIGHT] = true,
        [IN_MOVELEFT] = true,
        [IN_MOVERIGHT] = true,
        [IN_USE] = true,
        [IN_ALT1] = true,
        [IN_ALT2] = true,
        [IN_ATTACK] = true,
        [IN_ATTACK2] = true,
    }

    -- Check if the player is actively pressing specified keys
    if KEYS[key] == true then
        if (ply:IsAFK()) then ply:SetAFK(false) end
        ply.LastActivity = CurTime()
    end
end)