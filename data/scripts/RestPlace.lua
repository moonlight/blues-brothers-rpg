--
-- Rest place
--

import("Map.lua")

RestPlace = Map:subclass
{
	name = "RestPlace";

	init = function(self)
		Map.init(self, "data/maps/restplace.map")

		-- Spawn portals
		self.doorPortal = self:spawn(Portal, 14, 23)
		self.doorPortal:setOutDir(DIR_UP)
		self.sewerPortal = self:spawn(Portal, 20, 20)
		self.sewerPortal:setOutDir(DIR_DOWN)
		self.doorPortal.onUse = function()
			cityMap.restPlaceDoor.bitmap = cityMap.restPlaceDoor.bitmaps[2]
			cityMap.restPlaceDoor.obstacle = 0
			cityMap.restPlaceDoor.convTableKeyword = nil
		end
	end;

	defaultproperties = {
		mapNameBitmap = m_get_bitmap("restplace.tga"),
	}
}
