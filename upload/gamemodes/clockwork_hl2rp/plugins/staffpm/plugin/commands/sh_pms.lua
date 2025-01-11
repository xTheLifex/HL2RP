local COMMAND = Clockwork.command:New("PMS")

COMMAND.tip = "CmdStaffPM"
COMMAND.alias = {"StaffPM", "SPM"}
COMMAND.text = "<Player> <Message> - Sends a message as staff anonymously."
COMMAND.access = "o"
COMMAND.arguments = 2

-- function Clockwork.chatBox:Add(listeners, speaker, class, text, data)

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])

	if target then
		Clockwork.chatBox:Add({player, target}, player, "staffpm", table.concat(arguments, " ", 2))
	else
		Clockwork.player:Notify(player, {"NotValidPlayer", arguments[1]})
	end
end

COMMAND:Register()
