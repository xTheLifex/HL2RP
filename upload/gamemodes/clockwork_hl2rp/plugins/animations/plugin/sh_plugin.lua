
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");




local PLUGIN = PLUGIN

PLUGIN.PersonalityTypes = {
	"Normal",
	"Casual",
	"Determined",
	"Sassy",
	"Sassy 2",
	"Sassy 3",
	"Bold"
}

PLUGIN.LookupTable = {}

PLUGIN.LookupTable[ "Casual" ] = { 
	[ "idle" ] = "LineIdle01",
	[ "walk" ] = "walk_all_moderate",
}

PLUGIN.LookupTable[ "Determined" ] = { 
	[ "idle" ] = "pose_standing_02",
	[ "walk" ] = "walk_all_moderate",
}

PLUGIN.LookupTable[ "Sassy" ] = { 
	[ "idle" ] = "pose_standing_01",
	[ "walk" ] = "walk_all_moderate",
}

PLUGIN.LookupTable[ "Sassy 2" ] = { 
	[ "idle" ] = "pose_standing_03",
	[ "walk" ] = "walk_all_moderate",
}

PLUGIN.LookupTable[ "Sassy 3" ] = { 
	[ "idle" ] = "pose_standing_04",
	[ "walk" ] = "walk_all_moderate",
}

PLUGIN.LookupTable[ "Bold" ] = { 
	[ "idle" ] = "menu_combine",
	[ "walk" ] = "walk_all_moderate",
}

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:String("emoteMood")
end;

function PLUGIN:PlayerCharacterUnloaded(player)
    player:SetSharedVar("emoteMood", "");
end;

-- A function to get the current mood fo a player.
function PLUGIN:GetPlayerMood(player)
	if (player:GetSharedVar("emoteMood") != "") then
			return player:GetSharedVar("emoteMood")
	end

	return false
end

hook.Add("CalcMainActivity", "OverrideOACrapHooks", function(player, velocity2)
	self = PLUGIN

	if (self:GetPlayerMood(player) and self:GetPlayerMood(player) != "Normal") then
		local mood = self:GetPlayerMood(player)
		local moodTable = self.LookupTable[mood]
		local model = player:GetModel()	
		player.CalcIdeal = Clockwork.animation:GetForModel(model, "stand_idle")
		player.CalcSeqOverride = -1

		if (!Clockwork:HandlePlayerDriving(player) and !Clockwork:HandlePlayerJumping(player) and
			!Clockwork:HandlePlayerDucking(player, velocity2) and !Clockwork:HandlePlayerSwimming(player)) then
			local weapon = player:GetActiveWeapon()

			if (IsValid(weapon)) then
				weapon = weapon:GetClass()

				if (velocity2:Length2D() < 0.5 and weapon == "cw_hands") then
					if (moodTable["idle"] != nil) then
						player.CalcSeqOverride = moodTable["idle"]
					end
				elseif (velocity2:Length2D() >= 0.5 and !player:IsJogging() and !player:IsRunning() and weapon == "cw_hands") then
					if !player:IsOnGround() == true then return false end

					if (moodTable["walk"] != nil) then
						player.CalcSeqOverride = moodTable["walk"]
					end
				elseif player:IsRunning() then
					if !player:IsOnGround() == true then return false end

					if (moodTable["run"] != nil and weapon == "cw_hands") then
							player.CalcSeqOverride = moodTable["run"]
					end
				end
			end
		end

        local eyeAngles = player:EyeAngles()
        local yaw = velocity2:Angle().yaw
        local normalized = math.NormalizeAngle(yaw - eyeAngles.y)
        player:SetPoseParameter("move_yaw", normalized)

		if (player.CalcSeqOverride != -1) then
			player.CalcSeqOverride = player:LookupSequence(player.CalcSeqOverride)
			return player.CalcIdeal, player.CalcSeqOverride
		end
	end
end)