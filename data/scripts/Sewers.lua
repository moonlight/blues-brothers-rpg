--
-- Functions that fill the sewers
-- By Georg Muntingh

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
		self:spawn(FenceH5, 131,  47);
		self:spawn(FenceH3, 136,  98);
		self:spawn(FenceV8,  52,  83);
		self:spawn(FenceV8, 153,  83);
		self:spawn(FenceV8, 128,  83);
		self:spawn(FenceV8,   8,  83);
		self:spawn(FenceV7, 153, 118);
		self:spawn(FenceV7,  95, 118);
		self:spawn(FenceV7, 157,  16);

		-- Fence N can be opened by pulling lever N, where N is in {1,2,3,4}.
		self.fence1 = self:spawn(FenceH3, 35, 38);
		self.fence2 = self:spawn(FenceH3, 60, 28);
		self.fence3 = self:spawn(FenceH7, 95, 26);
		self.fence4 = self:spawn(FenceH3, 35, 72);
		self.lever1 = self:spawn(Lever  , 21, 21);
		self.lever2 = self:spawn(Lever  , 48, 70);
		self.lever3 = self:spawn(Lever  , 49, 70);
		self.lever4 = self:spawn(Lever2 , 50, 70);

		-- Make a reference in lever N to fence N, where N is in {1,2,3,4}.
		self.lever1:opens(self.fence1);
		self.lever2:opens(self.fence2);
		self.lever3:opens(self.fence3);
		self.lever4:opens(self.fence4);

		-- Spawn portals
		self.stairsInPortal = self:spawn(Portal,  73,  37);
		self.stairsInPortal:setOutDir(DIR_DOWN);
		self.stairsOutPortal = self:spawn(Portal, 152,  10);
		self.stairsOutPortal:setOutDir(DIR_DOWN);
	end;

	defaultproperties = {
		mapNameBitmap = m_get_bitmap("sewers.tga"),
	}
}
