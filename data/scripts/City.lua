--
-- The city area
--

import("Map.lua")

City = Map:subclass
{
	name = "City";

	init = function(self)
		Map.init(self, "data/maps/city1.map")

		-- Litter the city with stuff
		self:spawn(MessPile , 119, 161);
		self:spawn(Dustbin  , 102,  73);
		self:spawn(Car2     , 108,  74);

		self:spawn(Skimasks , 107,  54);
		self:spawn(Rope     ,  22,  81);
		self:spawn(Nitrofuel,  39,  19);

		-- Spawn two enemies
		self:spawn(Junk, 83, 73);
		self:spawn(Punk, 82, 73);

		-- The doors in this area
		self:spawn(DoorJake  ,  93,  72);
		self:spawn(DoorLocked,  76,  72);
		self:spawn(DoorLocked,  85,  72);

		-- Spawn portals
		self.jakePortal = self:spawn(Portal, 93, 72);
		self.jakePortal:setOutDir(DIR_DOWN);

		copcar = self:spawn(CopCar, 106, 123);
--		Wheel1 = self:spawn(Wheel, 107, 123);
--		Wheel1.offset_x = 5;
--		Wheel2 = self:spawn(Wheel, 110, 123);
--		Wheel2.offset_x = -7;
	end;
}
