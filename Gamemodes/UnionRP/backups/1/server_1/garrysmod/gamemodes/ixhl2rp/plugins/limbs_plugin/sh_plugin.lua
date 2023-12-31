local PLUGIN = PLUGIN

PLUGIN.name = "Limbs of everyone"
PLUGIN.author = "Ross"
PLUGIN.description = "Добавляет части тела."

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

function GetHitGroupBone(trace, victim)
	if trace.HitWorld then
		return 0;
	end;
	local ent, pbone = victim or trace.Entity, trace.PhysicsBone
	local bone = ent:TranslatePhysBoneToBone( pbone )
	local bonename = ent:GetBoneName( bone );
	bonename = bonename:lower()
	if bonename:find('head') then
		return 1
	elseif bonename:find('spine') or 
	bonename:find('pelvis') or 
	bonename:find('hips') then
		return 2
	elseif bonename:find('forearm') or 
	bonename:find('arm') or 
	bonename:find('upperarm') or 
	bonename:find('hand') then
		return 4
	elseif bonename:find('thigh') or 
	bonename:find('leg') or 
	bonename:find('flapa') or 
	bonename:find('calf') or 
	bonename:find('foot') then
		return 6
	end;
	return 0;
end;