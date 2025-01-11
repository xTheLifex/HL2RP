--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Citizen");

FACTION.useFullName = true;
FACTION.material = "hl2rp2/factions/citizen";
FACTION.startingInv = {
	["cw_suitcase"] = 1
}
FACTION.models = {
	female = {
		"models/ug/humans/female_01.mdl",
		"models/ug/humans/female_02.mdl",
		"models/ug/humans/female_03.mdl",
		"models/ug/humans/female_04.mdl",
		"models/ug/humans/female_06.mdl",
		"models/ug/humans/female_07.mdl",
		"models/ug/humans/female_10.mdl",
		"models/ug/humans/female_11.mdl",
		"models/ug/humans/female_17.mdl",
		"models/ug/humans/female_18.mdl",
		"models/ug/humans/female_19.mdl",
		"models/ug/humans/female_24.mdl",
		"models/ug/humans/female_25.mdl",
	},
	male = {
		"models/ug/humans/male_01.mdl",
		"models/ug/humans/male_02.mdl",
		"models/ug/humans/male_03.mdl",
		"models/ug/humans/male_04.mdl",
		"models/ug/humans/male_05.mdl",
		"models/ug/humans/male_06.mdl",
		"models/ug/humans/male_07.mdl",
		"models/ug/humans/male_08.mdl",
		"models/ug/humans/male_09.mdl",
		"models/ug/humans/male_10.mdl",
		"models/ug/humans/male_11.mdl",
		"models/ug/humans/male_12.mdl",
		"models/ug/humans/male_15.mdl",
		"models/ug/humans/male_16.mdl",
	};
};

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (Schema:PlayerIsCombine(player)) then
		if (name) then
			local models = self.models[ string.lower(player:QueryCharacter("gender")) ];

			if (models) then
				player:SetCharacterData("model", models[ math.random(#models) ], true);

				Clockwork.player:SetName(player, name, true);
			end;
		else
			return false, "You need to specify a name as the third argument!";
		end;
	end;
end;

FACTION_CITIZEN = FACTION:Register();
