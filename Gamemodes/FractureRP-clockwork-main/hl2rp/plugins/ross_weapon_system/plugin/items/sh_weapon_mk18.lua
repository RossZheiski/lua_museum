local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "MK18";
	ITEM.model = "models/weapons/tfa_ins2/w_mk18.mdl";
	ITEM.weight = 2.1;
	ITEM.uniqueID = "tfa_ins2_mk18";
	ITEM.category = "Оружие";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine1";
	ITEM.attachmentOffsetAngles = Angle(360, 180, -10);
	ITEM.attachmentOffsetVector = Vector(3, 3, 8);
ITEM:Register();