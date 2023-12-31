local PLUGIN = PLUGIN
PLUGIN.name = "Compontents plugin"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Some components needed for Ross's plugins."

nut.util.include("cl_fonts.lua")
nut.util.include("sv_plugin.lua")

function RFormatTime(time)
		local formatTime = "";
		if time >= 60 then
				if math.floor(time / 60) > 9 then
					formatTime = math.floor(time / 60) .. ":"
				else
					formatTime = "0" .. math.floor(time / 60) .. ":"
				end;
				if time % 60 < 10 then
					formatTime = formatTime .. "0" .. time % 60
				else
					formatTime = formatTime .. time % 60
				end
		else
				if time % 60 < 10 then
						formatTime = "00:" .. "0" .. time
				else
						formatTime = "00:" .. time
				end;
		end

		return formatTime
end;