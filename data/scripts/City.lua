--
-- The city area
--

import("Map.lua")

City = Map:subclass
{
	name = "City";

	init = function(self)
		Map.init(self, "data/maps/city1.map")

		-- Spawn the crowbar needed to remove the putdeksel.
		self:spawn(KeyFob, 66, 42)		

		-- No go areas.
		self:spawn(TooDangerous,  63, 80)
		self:spawn(TooDangerous2, 93, 36)
		
		-- Litter the city with stuff
		self:spawn(MessPile , 119, 161);
		self:spawn(Dustbin  , 102,  73);
		self:spawn(Car2     , 108,  74);

		self:spawn(Skimasks , 107,  54);
		self:spawn(Rope     ,  22,  81);
		self:spawn(Nitrofuel,  39,  19);

		-- Spawn the removable `putdeksel'
		self:spawn(Putdeksel, 119, 63);
		
		-- Spawn the enemies
		obj = self:spawn(Punk, 57, 75); obj.dir = DIR_DOWN
		obj = self:spawn(Punk, 57, 77); obj.dir = DIR_UP
		obj = self:spawn(Punk, 95, 31); obj.dir = DIR_RIGHT
		obj = self:spawn(Punk, 97, 31); obj.dir = DIR_LEFT

		-- The doors in this area
		self:spawn(DoorJake, 93, 72);

		-- Spawn portals
		self.jakePortal = self:spawn(Portal, 93, 72);
		self.jakePortal:setOutDir(DIR_DOWN);

		self.sewersInPortal = self:spawn(Portal, 119, 63);
		self.sewersInPortal:setOutDir(DIR_UP);

		copcar = self:spawn(CopCar, 106, 123);
--		Wheel1 = self:spawn(Wheel, 107, 123);
--		Wheel1.offset_x = 5;
--		Wheel2 = self:spawn(Wheel, 110, 123);
--		Wheel2.offset_x = -7;
	end;
}
