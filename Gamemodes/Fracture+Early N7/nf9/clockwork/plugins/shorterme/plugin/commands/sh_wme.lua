﻿local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("Wme");
COMMAND.tip = "Speak in third person to others around you, but only in whisper range.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local text = table.concat(arguments, " ");
	
	if (text == "") then
		Clockwork.player:Notify(player, "Вы ввели недостаточное количество текста!");
		
		return;
	end;

	Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub(text, "^.", string.lower), player:GetPos(), math.min(Clockwork.config:Get("talk_radius"):Get() / 3, 80));
end;

COMMAND:Register();