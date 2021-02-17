--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Metropolice Force");

FACTION.isCombineFaction = true;
FACTION.whitelist = true;
FACTION.material = "hl2rp2/factions/mpf";
FACTION.maxArmor = 100;
FACTION.startChatNoise = "npc/overwatch/radiovoice/on1.wav";
FACTION.endChatNoise = "npc/overwatch/radiovoice/off4.wav";
FACTION.models = {
	female = {"models/police_nemez.mdl"},
	male = {"models/police_nemez.mdl"}
};
FACTION.weapons = {
	--"cw_stunstick"
};
FACTION.startingInv = {
	["handheld_radio"] = 1,
	["arccw_uspmatch"] = 1,
	["ammo_pistol"] = 2,
	["cw_stunstick"] = 1,
};
FACTION.respawnInv = {
	["ammo_pistol"] = 2
};
FACTION.entRelationship = {
	["npc_combine_s"] = "Like",
	["npc_helicopter"] = "Like",
	["npc_metropolice"] = "Like",
	["npc_manhack"] = "Like",
	["npc_combinedropship"] = "Like",
	["npc_rollermine"] = "Like",
	["npc_stalker"] = "Like",
	["npc_turret_floor"] = "Like",
	["npc_combinegunship"] = "Like",
	["npc_cscanner"] = "Like",
	["npc_clawscanner"] = "Like",
	["npc_strider"] = "Like",
	["npc_turret_ceiling"] = "Like",
	["npc_turret_ground"] = "Like",
	["npc_combine_camera"] = "Like"
};
FACTION.ranks = {
	["RCT"] = {
		position = 12,
		class = "Metropolice Recruit",
		default = true
	},
	["i5"] = {
		position = 11,
		class = "Metropolice Recruit"
	},
	["i4"] = {
		position = 10,
		class = "Metropolice Recruit"
	},
	["i3"] = {
		position = 9,
		class = "Metropolice Recruit"
	},
	["i2"] = {
		position = 8,
		class = "Metropolice Recruit"
	},
	["i1"] = {
		position = 7,
		class = "Metropolice Recruit"
	},
	["OfC"] = {
		position = 6,
		class = "Elite Metropolice",
		model = "models/police_nemez.mdl"
	},
	["EpU"] = {
		position = 5,
		class = "Elite Metropolice",
		model = "models/police_nemez.mdl"
	},
	["DvL"] = {
		position = 4,
		class = "Elite Metropolice",
		model = "models/police_nemez.mdl",
		canPromote = 6,
		canDemote = 5
	},
	["CmD"] = {
		position = 3,
		class = "Elite Metropolice",
		model = "models/police_nemez.mdl",
		canPromote = 5,
		canDemote = 4
	},
	["SeC"] = {
		position = 2,
		class = "Elite Metropolice",
		model = "models/police_nemez.mdl",
		canPromote = 4,
		canDemote = 3
	},
	["ReC"] = {
		position = 1,
		class = "Elite Metropolice",
		model = "models/police_nemez.mdl",
		canPromote = 3,
		canDemote = 2
	},
};

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	return "UCA:C17.RCT-" .. Clockwork.kernel:ZeroNumberToDigits(math.random(1, 999), 3);
end;

-- Called when a player's model should be assigned for the faction.
function FACTION:GetModel(player, character)
	if (character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_OTA or faction.name == FACTION_SCANNER) then
		if (name) then
			Clockwork.player:SetName(player, string.gsub(player:QueryCharacter("name"), ".+(%d%d%d)", "UCA:C17.RCT-.%1"), true);
		else
			return false, "You need to specify a name as the third argument!";
		end;
	else
		Clockwork.player:SetName(player, self:GetName(player, player:GetCharacter()));
	end;

	if (player:QueryCharacter("gender") == GENDER_MALE) then
		player:SetCharacterData("model", self.models.male[1], true);
	else
		player:SetCharacterData("model", self.models.female[1], true);
	end;
end;

FACTION_MPF = FACTION:Register();
