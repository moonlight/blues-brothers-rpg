--
-- Functions that fill the sewers
--

import("Map.lua")

Sewers = Map:subclass
{
	name = "Sewers";

	init = function(self)
		local fence1;

		Map.init(self, "data/maps/sewers1.map")

		self:spawn(WallAndTube, 54, 47);
		self:spawn(WallAndTube2, 54, 25);
		self:spawn(Ladder1,  73,  37);
		self:spawn(Ladder2, 152,  10);
		self:spawn(FenceH5, 131,  46);
		self:spawn(FenceH7,  95,  25);
		self:spawn(FenceH3,  35,  37);
		self:spawn(FenceH3,  35,  71);
		self:spawn(FenceH3,  60,  27);
		self:spawn(FenceH3, 136,  97);
		self:spawn(FenceV8, 153,  83);
		self:spawn(FenceV8, 128,  83);
		self:spawn(FenceV8,   8,  83);
		self:spawn(FenceV7, 153, 118);
		self:spawn(FenceV7,  95, 118);
		self:spawn(FenceV7, 157,  16);
		self:spawn(Lever1,   48,  69);
		self:spawn(Lever1,   49,  69);
		self:spawn(Lever1,   50,  69);
		self:spawn(Lever1,   21,  21);

		-- Spawn portals
		self.stairsPortal = self:spawn(Portal, 73, 37)
	end;
}

