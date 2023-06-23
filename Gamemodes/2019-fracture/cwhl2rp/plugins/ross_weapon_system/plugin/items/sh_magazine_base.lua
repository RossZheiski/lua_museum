﻿local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Magazine Base";
ITEM.uniqueID = "mag_base";
ITEM.model = "models/props_lab/binderblue.mdl";
ITEM.weight = 50;
ITEM.useText = "Зарядить обойму";
ITEM.category = "Магазины";
ITEM.description = "";
ITEM.maxClip = 30;
ITEM.ammoType = "";
ITEM.customFunctions = {"Достать патроны", "Вставить патроны"};
ITEM.useSound = "items/ammopickup.wav";

ITEM.WeaponsCanUse = {};

ITEM:AddData("Clip", -1, true);
ITEM:AddData("AmmoType", "", true);

function ITEM:OnUse(player, itemEntity)	
	local weaponact = player:GetActiveWeapon();
	local weapon = Clockwork.item:GetByWeapon(weaponact);

	if table.HasValue(self.WeaponsCanUse, weaponact:GetClass()) && weaponact.Primary.Ammo == self:GetData("AmmoType") && !weapon:GetData("Mag") then
		weapon:SetData("Mag", true);
		weapon:SetData("NameMag", self.uniqueID);
		player:GiveAmmo(math.Clamp(weapon:GetData("ClipTwo") + self:GetData("Clip"), 0, weaponact:GetMaxClip1() ), self:GetData("AmmoType"));
	elseif weaponact.Primary.Ammo != self:GetData("AmmoType") then
		Clockwork.player:Notify(player, "У оружия не тот тип боеприпасов!");
	elseif weapon:GetData("Mag") then
		Clockwork.player:Notify(player, "У оружия в руках уже есть магазин.");
	else
		Clockwork.player:Notify(player, "У вас нет подохдящего оружия!");
		return false;
	end;
end;

function ITEM:OnDrop(player, position) 

	return true
end;

if (SERVER) then
	function ITEM:OnInstantiated()

		if (self:GetData("Clip") == -1) then
			self:SetData("Clip", self("maxClip"));
		end;

		if (self:GetData("AmmoType") == "") then
			self:SetData("AmmoType", self("ammoType"));
		end;
	
	end;

	function ITEM:OnCustomFunction(player, funcName)
		if (funcName == "Достать патроны") then
			Clockwork.player:SetAction(player, "Unload", 10, 2, function()

				Clockwork.player:SetAction(player, "Unload", false);
			end);
		end;
		if (funcName == "Вставить патроны") then

		end;		
	end;
else
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;

		local clientSideInfo = "";

		local warming = self:GetData("Clip");
		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, ""..math.floor(warming)..".", Color(234, 112, 30));
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
end;

Clockwork.item:Register(ITEM);