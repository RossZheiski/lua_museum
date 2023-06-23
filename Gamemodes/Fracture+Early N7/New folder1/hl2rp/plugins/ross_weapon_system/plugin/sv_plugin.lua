
local PLUGIN = PLUGIN;
local p = FindMetaTable("Player");
local math = math;
local cl = math.Clamp;

local TFA = TFA;

function p:HoldingTFAweapon()

	if Schema:IsPlayerCombineRank(self, "SCN") || self:IsRagdolled() then return false end;

	local wep = self:GetActiveWeapon():GetClass()

	if string.StartWith( wep, "tfa_" ) then
		return true;
	end;

	return false;
end;


function PLUGIN:EntityFireBullets(entity, bulletInfo) 
	if (entity:IsPlayer() && entity:IsValid()) then
		local random = math.random(0, 110)
		local weapon;
		weapon = entity:GetActiveWeapon();
		local wep = Clockwork.item:GetByWeapon(weapon);
		if wep == nil then
			return;
		end;
		local dat = wep:GetData("Quality");
		local rr = math.random(dat + 1);
		if dat <= 5 && rr > dat then
			weapon:SetJammed(true)
			player.reloadING = CurTime() + 3
		end;
		if wep && random > 90 then
			wep:SetData("Quality", cl(dat - wep:GetData("RollDamage")/100, 0, 10));
		end;
	end;
end;

-- Адаптация для ТФА.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local weapon = player:GetActiveWeapon();

	if player:Alive() then
		if player:HoldingTFAweapon() && weapon:IsSafety() then
			Clockwork.player:SetWeaponRaised(player, false)
		elseif player:HoldingTFAweapon() && !weapon:IsSafety() then
			Clockwork.player:SetWeaponRaised(player, true)
		end;
	end;

end;

function PLUGIN:KeyPress(player, key)
	local weaponact = player:GetActiveWeapon();
	local pInvWeight = player:GetInventoryWeight();
	local pMaxWeight = player:GetMaxWeight();
	local useButton = player:KeyDownLast( IN_USE ); local speedButton = player:KeyDownLast( IN_SPEED ); local reload = key == IN_RELOAD;
	local tfa = player:HoldingTFAweapon();

	if reload && !player:HoldingTFAweapon() then

		if !weaponact.weaponDelayRise || CurTime() >= weaponact.weaponDelayRise then

			Clockwork.player:SetWeaponRaised(player, !Clockwork.player:GetWeaponRaised(player))
	
			weaponact.weaponDelayRise = CurTime() + 2
		end;

	end;

	if reload && player:GetFaction() != FACTION_SCANNER then

		if weaponact != nil && !IsWeaponMelee( weaponact:GetClass() ) && tfa then
			local weppy = Clockwork.item:GetByWeapon(weaponact)
			local items = Clockwork.inventory:GetAsItemsList(player:GetInventory());
			local ammocount = player:GetAmmoCount( weaponact.Primary.Ammo );
			if !weppy:GetData('Mag') && weppy:GetData('ClipOne') == 0 && (!player.ReloadDelay || CurTime() >= player.ReloadDelay) then
				
				for k, v in ipairs(items) do
					if v("baseItem") == "mag_base" && table.HasValue(v.WeaponsCanUse, weaponact:GetClass()) && v:GetData('Clip') > 0 then
						Clockwork.item:Use(player, v, true)
					end;
				end;
				player.ReloadDelay = CurTime() + (TFA.GetStatus( 'reloading' ) + 1)
			elseif (!useButton && !speedButton) && weppy:GetData('Mag') && weppy:GetData('ClipOne') >= 0 && (!player.ReloadDelay || CurTime() >= player.ReloadDelay) then
					if weppy:GetData("ClipOne") >= 0 then
						player:GiveItem( Clockwork.item:CreateInstance(weppy:GetData("NameMag"), nil, {Clip = weppy:GetData("ClipOne")}), true );
						player:RemoveAmmo(weppy:GetData("ClipOne"), weaponact.Primary.Ammo);
						weppy:SetData("ClipOne", 0); weaponact:SetClip1( 0 );
						weppy:SetData("Mag", false); weppy:SetData("NameMag", "");
					elseif ammocount >= 0 then
						player:GiveItem( Clockwork.item:CreateInstance(wepsy:GetData("NameMag"), nil, {Clip = ammocount}), true );
						player:RemoveAmmo(ammocount, weaponact.Primary.Ammo);					
						wepsy:SetData("ClipTwo", 0); weaponact:SetClip2( 0 );
						wepsy:SetData("Mag", false); wepsy:SetData("NameMag", "");
					end;
					player:EmitSound('nb_c7erdx/magout.wav')
				player.ReloadDelay = CurTime() + (math.Clamp(TFA.GetStatus( 'reloading' ) - 2, 0, 1000))
			end;
		end;
	end;
	
end;

function PLUGIN:ItemEntityTakeDamage(itemEntity, itemTable, damageInfo)
	if itemTable:IsBasedFrom('weapon_base') then
		itemTable:SetData('Quality', cl(itemTable:GetData("Quality") - math.random(0.1, 2), 0, 10) );
		damageInfo:ScaleDamage(0);
	end;
end;