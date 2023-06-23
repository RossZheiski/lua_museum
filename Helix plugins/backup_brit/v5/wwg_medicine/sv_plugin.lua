local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
	timer.Simple(.25, function()
		local id = character:GetID();

		// If this body isn't loaded yet;
		if !ix.body.instances[id] then
			// Load(cache) the body and all wound instances for character.
			ix.body.Load( id )

			// Load diseases;
			ix.disease.Load( id )
		end;
	end);
end;

function PLUGIN:CharacterDeleted(client, id, current)
	// If character is deleted - uncache and erase his body, wounds, diseases data from global table and database;
	if ix.body.instances[id] then
		// Erase diseases data;
		ix.disease.Remove( id, true )

		// Erase wounds and body data;
		ix.body.Remove( id, true )
	end;
end;

function PLUGIN:PlayerDisconnected(client)
	// If server is shutting down then don't do it.
	if ix.shuttingDown then
		return;
	end

	// "Uncache" the bodies, wounds and diseases;
	local s64 = client:SteamID64()
	local cache = ix.char.cache[s64]
	
	if cache then
		for _, id in ipairs(cache) do
			ix.disease.Remove( id )
			ix.body.Remove( id )
		end
	end
end;

function PLUGIN:EntityTakeDamage(target, damage)
	local attacker, dmg, index = damage:GetAttacker(), damage:GetDamage(), damage:GetDamageType()

	// For situations when target is ragdolled, for example.
	target = target:GetNetVar("player") || target;

	// To check if target can receive wounds or prevent double damage.
	if !ix.body.CanReceiveWounds(target) || dmg == 0 then return end;

	// Trace coverup.
	local trace = ix.body.trace(attacker)
	if !trace then return end;

	// Search bone. If not found - we need a torso (exclusive situations).
	local bone = ix.body.list[trace.HitGroup]
	if !bone then bone = "torso" end;

	local injury = ix.injury.list[ index ]
	if injury then
		local rand = math.random(100)
		// If injury can cause bleed wound, amount < 2 and damage < 20 and random < 10% or damage >= 20 and random < 50%.
		if injury.bleeding && ix.wound.GetAmount( target:GetCharacter():GetID(), "bleed", bone ) < 2 
		&& (( dmg < 20 && rand < 10 ) || ( dmg >= 20 && rand < 50 )) then
			ix.wound.CreateBleed( target, bone )
		end

		// If injury can cause fracture wound and random < 5%.
		if injury.fracture then
			ix.wound.CreateFracture( target, bone, 5 )
		end;

		// If injury can cause a burn.
		if injury.burn then
			ix.wound.CreateBurn( target, bone, dmg )
		end

		// If you get hit in the arm with more than 20hp damage, there is a 30% chance you drop your weapon.
		if dmg > 20 && rand < 30 && (bone == "r_arm" || bone == "l_arm") then
			local weapon = target:GetActiveWeapon()
			local item = weapon.ixItem;
			if item then
				ix.item.Spawn(item.uniqueID, target:GetPos(), nil, target:GetAngles(), item.data)
				item:Remove()
				target:StripWeapon( weapon:GetClass() )
			end
		end
	end;

	// Damage scale. For reference see sh_plugin.lua;
	damage:ScaleDamage( ix.medical.multiply[bone] || 1 )
end;

// Called on gamemode init.
function PLUGIN:LoadData()
	local query;

	// Create wounds table if not exists;
	query = mysql:Create("ix_wounds")
		query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("uniqueID", "VARCHAR(255) NOT NULL")
		query:Create("bone", "VARCHAR(255) NOT NULL")
		query:Create("time", "INT(11) UNSIGNED NOT NULL")
		query:Create("charID", "INT(11) UNSIGNED NOT NULL")
		query:Create("data", "TEXT DEFAULT NULL")
		query:PrimaryKey("id")
	query:Execute()

	// Create disease table if not exists;
	query = mysql:Create("ix_diseases")
		query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("uniqueID", "VARCHAR(255) NOT NULL")
		query:Create("charID", "INT(11) UNSIGNED NOT NULL")
		query:Create("occured", "INT(11) UNSIGNED NOT NULL")
		query:PrimaryKey("id")
	query:Execute()
end;

// Called on server shutdowns, etc.
function PLUGIN:SaveData()
	local query;

	// Remove loaded characers wounds from database and re-insert it;
	for id, data in pairs( ix.body.characters ) do
		query = mysql:Delete("ix_wounds")
			query:Where("charID", id)
		query:Execute()
		
		for _, woundID in pairs( data ) do
			local wound = ix.wound.instances[ woundID ];
			if wound then
				query = mysql:Insert("ix_wounds")
					query:Insert("uniqueID", wound.uniqueID)
					query:Insert("bone", wound.bone)
					query:Insert("time", wound.time)
					query:Insert("charID", wound.charID)
					query:Insert("data", util.TableToJSON(wound.data))
				query:Execute()
			end
		end
	end

	// Remove loaded characers diseases from database and re-insert it;
	for id, body in pairs( ix.body.instances ) do
		query = mysql:Delete("ix_diseases")
			query:Where("charID", id)
		query:Execute()

		for _, diseaseID in pairs( body.diseases ) do
			local disease = ix.disease.instances[ diseaseID ];

			if disease then
				query = mysql:Insert("ix_diseases")
					query:Insert("uniqueID", disease.uniqueID)
					query:Insert("occured", disease.occured)
					query:Insert("charID", disease.charID)
				query:Execute()
			end
		end
	end

end;

function PLUGIN:GetFallDamage(client, speed)
	// Default helix fall damage
	local damage = (speed - 580) * (100 / 444);

	// Get the random leg
	local leg = math.random(100) > 50 && "l_leg" || "r_leg"

	// If amount of fractures on provided leg is < 1.
	if ix.wound.GetAmount( client:GetCharacter():GetID(), "fracture", leg ) < 1 then
		ix.wound.CreateFracture( client, leg, math.min(damage * 2, 100) )
	end;

	return damage
end


-- ix.wound.CreateBleed( Entity(1), "r_leg" )

-- ix.medical.Debug()
/*
	TODO:
	1. Diseases
	2. Medicine

	Внести в документацию таблицы, обращение к ним
*/