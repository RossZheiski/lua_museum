﻿local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "King Cobra";
	ITEM.model = "models/weapons/tfa_ins2/w_thanez_cobra.mdl";
	ITEM.weight = 1.3;
	ITEM.category = "Оружие";
	ITEM.uniqueID = "tfa_ins2_thanez_cobra";
	ITEM.description = "";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
	ITEM.attachmentOffsetAngles = Angle(360, 290, -90);
	ITEM.attachmentOffsetVector = Vector(5, -7, -4);

function ITEM:AdjustAttachmentOffsetInfo(player, entity, info)
	if ( string.find(player:GetModel(), "female") ) then
		info.offsetAngle = Angle(-90, 90, 0);
		info.offsetVector = Vector(4, -4, 2);
	end;
end;

ITEM:Register();