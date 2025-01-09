local PLUGIN = PLUGIN;
local Clockwork = Clockwork;
local cwOption = Clockwork.option;

COMMAND = Clockwork.command:New("Help");
COMMAND.tip = "Contacts all staff, please be descriptive and patient.";
COMMAND.text = "<string Text>";
COMMAND.flag = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"adminhelp", "admin", "staff", "report"}

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Clockwork.player:IsAdmin(player)) then
		player:CPNotify("You are staff, use /A chat instead.", cwOption:GetKey("cannot_do_icon"));
		return;
	end;
	
	local curTime = CurTime();
	if (player.nextAdminHelp and player.nextAdminHelp > curTime) then
		player:CPNotify("Please wait another "..math.ceil(player.nextAdminHelp - curTime).." seconds before using /Help again.", cwOption:GetKey("wait_icon"));
		return;
	end;

	player.nextAdminHelp = curTime + Clockwork.config:Get("admin_help_interval"):Get();

	local listeners = PLUGIN:GetAllAdmins();
	if (#listeners == 0) then
		player:CPNotify("No staff are currently online, please wait until one gets on. You can use our /Discord to contact offline staff, if it's urgent.", "award_star_delete");
	end;

	listeners[#listeners + 1] = player;

	Clockwork.chatBox:Add(listeners, player, "cp_adminhelp", table.concat(arguments, " "));
end;

COMMAND:Register();