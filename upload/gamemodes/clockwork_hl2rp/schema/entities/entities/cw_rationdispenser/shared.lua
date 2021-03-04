--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "kurozael";
ENT.PrintName = "Ration Dispenser";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;
ENT.PhysgunDisabled = true;

-- Called when the datatables are setup.
function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "RationTime");
	self:NetworkVar("Float", 1, "FlashTime");
	self:NetworkVar("Bool", 0, "Locked");
end;

-- A function to get whether the entity is locked.
function ENT:IsLocked()
	return self:GetLocked();
end;