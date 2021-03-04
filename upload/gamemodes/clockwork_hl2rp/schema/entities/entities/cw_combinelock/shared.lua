--[[ 
    © CloudSixteen.com do not share, re-distribute or modify
    without permission of its author (kurozael@gmail.com).

    Clockwork was created by Conna Wiles (also known as kurozael.)
    http://cloudsixteen.com/license/clockwork.html
--]]

DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "kurozael";
ENT.PrintName = "Combine Lock";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;
ENT.PhysgunDisabled = true;
ENT.noHandsPickup = true;

-- Called when the datatables are setup.
function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "SmokeChargeTime");
	self:NetworkVar("Float", 1, "FlashTime");
	self:NetworkVar("Bool", 0, "Locked");
end;

-- A function to get whether the entity is locked.
function ENT:IsLocked()
	return self:GetLocked();
end;
