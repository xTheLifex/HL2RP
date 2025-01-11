-- Define the command
local COMMAND = Clockwork.command:New("RefundMenu")

COMMAND.tip = "Opens the Refund Menu"
COMMAND.alias = {"Refund", "Refunds"}
COMMAND.text = "Open the refund menu"
COMMAND.arguments = 0

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (CLIENT) then refunds.CreateRefundMenu() end
end

COMMAND:Register()