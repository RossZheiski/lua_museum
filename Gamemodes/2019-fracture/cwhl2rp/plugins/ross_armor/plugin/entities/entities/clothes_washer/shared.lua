ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Washer";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = true;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("clothes_washer")
	entity:SetPos(trace.HitPos + Vector(0, 0, 90))
	local model = "models/props_wasteland/laundry_washer003.mdl"

	local angles = (entity:GetPos() - client:GetPos()):Angle()
	angles.p = 0
	angles.y = 0
	angles.r = 0

	entity:SetAngles(angles)
	entity:Spawn()
	entity:Activate()

	for k, v in pairs(ents.FindInBox(entity:LocalToWorld(entity:OBBMins()), entity:LocalToWorld(entity:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then 
			entity:SetPos(v:GetPos())
			entity:SetAngles(v:GetAngles())
			SafeRemoveEntity(v)

			break
		end
	end

	return entity
end

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 1, "AmountOfCleaning" )
	self:NetworkVar( "Bool", 2, "TurnOn" )

	self:SetAmountOfCleaning(0);
	self:SetTurnOn(false)
end;