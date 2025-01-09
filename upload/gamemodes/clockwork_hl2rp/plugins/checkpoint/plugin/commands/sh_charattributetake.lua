
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("CharAttributeTake");
COMMAND.tip = "Take the given amount from a player's attribute.";
COMMAND.alias = {"CharTakeAttribute", "CharRemoveAttribute", "CharDeleteAttribute", "CharAttributeRemove", "CharAttributeDelete"}
COMMAND.text = "<string Name> <string Attribute> <int Amount>";
COMMAND.access = "s";
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local amount = tonumber(arguments[3]);
		if (amount and amount > 0) then
			local success, err = Clockwork.attributes:Update(target, arguments[2], -amount);
			if (!success) then
				if (!err) then
					err = "Something went wrong!"
				end;
			    player:CPNotify(err, Clockwork.option:GetKey("cannot_do_icon"));
			else
				if (Clockwork.config:Get("global_echo"):Get()) then
					for k, v in pairs(_player.GetAll()) do
						if (v != player and v != target) then
							v:CPNotify(player:Name().." has taken "..amount.." from "..target:Name().."'s "..arguments[2]..".", "delete");
						end;
					end;
				end;

				player:CPNotify("You have taken "..amount.." from "..target:Name().."'s "..arguments[2]..".", "delete");
				target:CPNotify(player:Name().." has taken "..amount.." from your "..arguments[2]..".", "delete");
			end;
		else
			player:CPNotify("You did not specify a valid amount!", Clockwork.option:GetKey("cannot_do_icon"));
		end;
	else
		player:CPNotify(arguments[1].." is not a valid player!", Clockwork.option:GetKey("invalid_target_icon"));
	end;
end;

COMMAND:Register();