--[[
© CloudSixteen.com do not share, re-distribute or modify
without permission of its author (kurozael@gmail.com).

Clockwork was created by Conna Wiles (also known as kurozael.)
https://creativecommons.org/licenses/by-nc-nd/3.0/legalcode
--]]

--[[
You don't have to do this, but I think it's nicer.
Alternatively, you can simply use the PLUGIN variable.
--]]
PLUGIN:SetGlobalAlias("cwDelayLOOC");

--[[ You don't have to do this either, but I prefer to separate the functions. --]]
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

if (SERVER) then
	Clockwork.config:Add("looc_interval", 1);
else
	Clockwork.config:AddToSystem("LocalOOCInterval", "looc_interval", "LocalOOCIntervalDesc", 0, 7200);
end;