--
-- Lee's place
--

import("Map.lua")

LeesPlace = Map:subclass
{
	name = "LeesPlace";

	init = function(self)
		Map.init(self, "data/maps/leesplace.map")

		-- Spawn portals
		self.doorPortal = self:spawn(Portal, 10, 25)
		self.doorPortal:setOutDir(DIR_UP)

		self:spawn(Toilet, 15, 23);
		self:spawn(Washstand, 16, 22)
		self:spawn(Couch, 29, 23);
		self:spawn(Clock, 31, 15);
		self:spawn(TV, 31, 21);
		self:spawn(Bed, 15, 17);

		self:spawn(Lee, 32, 18);
	end;

	defaultproperties = {
		mapNameBitmap = m_get_bitmap("leesplace.tga"),
	}
}
