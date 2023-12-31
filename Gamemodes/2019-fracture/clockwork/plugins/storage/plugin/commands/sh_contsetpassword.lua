--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local COMMAND = Clockwork.command:New("ContSetPassword");

COMMAND.tip = "Set a container's password.";
COMMAND.text = "<string Pass>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	
	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			local model = string.lower(trace.Entity:GetModel());
			
			if (cwStorage.containerList[model]) then
				if (!trace.Entity.inventory) then
					cwStorage.storage[trace.Entity] = trace.Entity;
					trace.Entity.inventory = {};
				end;
				
				trace.Entity.cwPassword = table.concat(arguments, " ");
				
				Clockwork.player:Notify(player, {"YouSetContainerPassword"});
			else
				Clockwork.player:Notify(player, {"ContainerNotValid"});
			end;
		else
			Clockwork.player:Notify(player, {"ContainerNotValid"});
		end;
	else
		Clockwork.player:Notify(player, {"ContainerNotValid"});
	end;
end;

COMMAND:Register();