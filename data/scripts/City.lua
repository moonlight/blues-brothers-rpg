--
-- The city area
--

import("Map.lua")

City = Map:subclass
{
	name = "City";

	init = function(self)
		Map.init(self, "data/maps/city1.map")

		-- Spawn the walkie talkie. Needed by the addToInventory function.
		self.walkieTalkie = self:spawn(WalkieTalkie, 1, 126)

		-- Spawn the crowbar needed to remove the putdeksel.
		self:spawn(KeyFob, 66, 42)		

		-- No go areas.
		self:spawn(TooDangerous,  63, 80)
		self:spawn(TooDangerous2, 93, 36)
		
		-- Litter the city with stuff

		self:spawn(Dustbin,  51,  10);
		self:spawn(Dustbin,  89,  10);
		self:spawn(Dustbin, 113,  10);
		self:spawn(Dustbin,   2,  23);
		self:spawn(Dustbin,  39,  23);
		self:spawn(Dustbin,  79,  22);
		self:spawn(Dustbin, 111,  23);
		self:spawn(Dustbin, 102,  73);
		self:spawn(Dustbin,  13,  83);
		self:spawn(Dustbin,  22,  53);
		self:spawn(Dustbin,  48,  80);
		self:spawn(Dustbin, 118, 118);
		self:spawn(Dustbin, 111,  58);
		self:spawn(Dustbin, 124,  44);
		self:spawn(Dustbin,  74,  38);

		self:spawn(MessPile , 119, 161);
		self:spawn(MessPile2, 31, 8);
		self.engines = self:spawn(Engines, 31, 7)
		
		-- Cars in the city
		self:spawn(Car2, 108,  74);
		self:spawn(CarShadow, 108, 74);
		self:spawn(Car,   9,  25);
		obj = self:spawn(CarShadow,   9, 25);	obj.offset_x = 3; obj.offset_y = -22;
		self:spawn(Car2,  17,  55);
		self:spawn(CarShadow,  17, 55);
		self:spawn(Car,  47,  81);
		obj = self:spawn(CarShadow,  47, 81);	obj.offset_x = 3; obj.offset_y = -22;

		-- Spawn the removable `putdeksel'
		self:spawn(Putdeksel, 119, 63);
		
		-- Spawn the enemies
		obj = self:spawn(Punk, 57, 75); obj.dir = DIR_DOWN
		obj = self:spawn(Punk, 57, 77); obj.dir = DIR_UP
		obj = self:spawn(Punk, 95, 31); obj.dir = DIR_RIGHT
		obj = self:spawn(Punk, 97, 31); obj.dir = DIR_LEFT

		-- The doors in this area
		self:spawn(DoorJake, 93, 72);
		self.restPlaceDoor = self:spawn(DoorLocked, 76, 72)

		-- Spawn portals
		self.jakePortal = self:spawn(Portal, 93, 72);
		self.jakePortal:setOutDir(DIR_DOWN);

		self.sewersInPortal = self:spawn(Portal, 119, 63);
		self.sewersInPortal:setOutDir(DIR_UP);

		self.restPlacePortal = self:spawn(Portal, 76, 72)
		self.restPlacePortal:setOutDir(DIR_DOWN)

		copcar = self:spawn(CopCar, 106, 123);
	end;

	defaultproperties = {
		mapNameBitmap = m_get_bitmap("suburbs.tga"),
		musicFilename = "data/music/4.ogg",
	}
}
