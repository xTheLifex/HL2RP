local PLUGIN = PLUGIN
local COMMAND = Clockwork.command:New("SetMood");
COMMAND.tip = "Puts your character into a mood. Male citizens only!";
COMMAND.flags = CMD_DEFAULT;

function COMMAND:OnRun(player, arguments)
	if (string.find(player:GetModel(), "ug/humans")) then
		if (table.HasValue(PLUGIN.PersonalityTypes, arguments[1])) then
			player:SetSharedVar("emoteMood", arguments[1])
			player:ChatPrint(arguments[1])
		else
			Clockwork.player:Notify(player, "That is not a valid mood!")
		end
	else
		Clockwork.player:Notify(player, "Your model cannot do this!")
	end
end;

COMMAND:Register();

if (CLIENT) then
	Clockwork.quickmenu:AddCommand("Set Mood", nil, "SetMood", PLUGIN.PersonalityTypes)
end