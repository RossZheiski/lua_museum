--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("grenade_base");
	ITEM.name = "Дымовая Граната";
	ITEM.cost = 0;
	ITEM.classes = {CLASS_EMP, CLASS_EOW};
	ITEM.model = "models/items/grenadeammo.mdl";
	ITEM.weight = 0.8;
	ITEM.category = "Оружие";
	ITEM.uniqueID = "cw_smokegrenade";
	ITEM.business = true;
	ITEM.description = "Маленький предмет цилиндрической формы, напоминающий гранату.";
	ITEM.isAttachment = true;
	ITEM.loweredOrigin = Vector(3, 0, -4);
	ITEM.loweredAngles = Angle(0, 45, 0);
	ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 0);
	ITEM.attachmentOffsetVector = Vector(0, 6.55, 8.72);
ITEM:Register();