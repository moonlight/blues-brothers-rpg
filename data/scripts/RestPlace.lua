--
-- Rest place
--

import("Map.lua")

RestPlace = Map:subclass
{
	name = "RestPlace";

	init = function(self)
		Map.init(self, "data/maps/leesplace.map")

		-- Spawn portals
		self.doorPortal = self:spawn(Portal, 14, 23)
		self.doorPortal:setOutDir(DIR_UP)
		self.sewerPortal = self:spawn(Portal, 20, 20)
		self.doorPortal:setOutDir(DIR_DOWN)
	end;

	defaultproperties = {
		mapNameBitmap = m_get_bitmap("restplace.tga"),
	}
}
