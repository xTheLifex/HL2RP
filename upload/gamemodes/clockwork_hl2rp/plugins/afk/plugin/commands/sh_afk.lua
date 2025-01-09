local COMMAND = Clockwork.command:New("Afk");

COMMAND.tip = "Marks yourself as AFK.";
COMMAND.text = "";
COMMAND.flags = CMD_DEFAULT;
-- COMMAND.access = "a";
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(ply, arguments)
    if CLIENT then return end
    if not IsValid(ply) then return end

    -- Check cooldown before processing the change
    local timeout = afk.timeout[ply] or 0
    if CurTime() < timeout then 
        Clockwork.player:Notify(ply, {"You must wait before going AFK again!"})
        return
    end

    ply:SetAFK(true)
    afk.timeout[ply] = CurTime() + Clockwork.config:Get("afk_cooldown"):Get()
end;

COMMAND:Register();