--
-- Jake's place
--

import("Map.lua")

JakesPlace = Map:subclass
{
	name = "JakesPlace";

	init = function(self)
		Map.init(self, "jakesplace.map")

		-- Spawn portals
		self.doorPortal = self:spawn(Portal, 10, 25)
		self.doorPortal:setOutDir(DIR_UP)

		--self:spawn(WallJakesPlace, 5, 21);
		self:spawn(Keyboard, 10, 17);
		self:spawn(Onderstel, 10, 17);
		self:spawn(Guitar, 17, 17);
		self:spawn(Toilet, 5, 23);
		self:spawn(Washstand, 6, 22)
		self:spawn(Couch, 13, 23);
		self:spawn(Clock, 15, 15);
		self:spawn(TV, 15, 21);
		self:spawn(Bed, 5, 17);
		self:spawn(Crowbar, 17, 19)
	end;

	defaultproperties = {
		mapNameBitmap = m_get_bitmap("jakesplace.tga"),
		musicFilename = "data/music/city.ogg",
	};
}
