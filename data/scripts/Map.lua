--
-- The Map class
-- By Bjørn Lindeijer


import("Object.lua")

Map = Object:subclass
{
	name = "Map";

	init = function(self, mapName)
		self.map = m_load_map(mapName)
		if (not self.map or type(self.map) ~= "userdata") then
			error("Error while loading map \"".. mapName.."\"!")
		end
	end;

	spawn = function(self, class, x, y, owner)
		return Actor:spawn(class, x, y, self.map, owner)
	end;

	defaultproperties = {
		map = nil,
	}
}
