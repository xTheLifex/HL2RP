--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	https://creativecommons.org/licenses/by-nc-nd/3.0/legalcode
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("itd");
COMMAND.tip = "Describe a local event or action, quietly.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local text = table.concat(arguments, " ");
	local talkRadius = math.min(Clockwork.config:Get("talk_radius"):Get() / 3, 80);
	if (text == "") then
		Clockwork.player:Notify(player, "You did not specify enough text!");
		
		return;
	end;
	Clockwork.chatBox:SetMultiplier(0.75);
	Clockwork.chatBox:AddInTargetRadius(player, "it", text, player:GetPos(), talkRadius);
end;

COMMAND:Register();