--
-- The cells area
--

import("Map.lua")

Cells = Map:subclass
{
	name = "Cells";

	init = function(self)
		local obj

		Map.init(self, "data/maps/cells.map")

		-- White stripes at the wall
		obj = self:spawn(Count5, 50, 46); obj.offset_x =  5; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 50, 46); obj.offset_x = 15; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count6, 50, 46); obj.offset_x = 25; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 50, 46); obj.offset_x = 37; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 50, 46); obj.offset_x = 47; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 50, 46); obj.offset_x = 57; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count3, 50, 46); obj.offset_x = 67; obj.offset_y = -5; obj.alpha = 90

		obj = self:spawn(Count5, 35, 39); obj.offset_x =  5; obj.offset_y = -6; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 15; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 25; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count6, 35, 39); obj.offset_x = 35; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 47; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 57; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 67; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 77; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 87; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 97; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x =  5; obj.offset_y =  5; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 15; obj.offset_y =  5; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 25; obj.offset_y =  6; obj.alpha = 90
		obj = self:spawn(Count5, 35, 39); obj.offset_x = 35; obj.offset_y =  6; obj.alpha = 90
		obj = self:spawn(Count2, 35, 39); obj.offset_x = 45; obj.offset_y =  6; obj.alpha = 90

		obj = self:spawn(Count5, 50, 25); obj.offset_x =  5; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 50, 25); obj.offset_x = 15; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 50, 25); obj.offset_x = 25; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count1, 50, 25); obj.offset_x = 36; obj.offset_y = -5; obj.alpha = 90

		obj = self:spawn(Count5, 15, 18); obj.offset_x =  5; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 15, 18); obj.offset_x = 15; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 15, 18); obj.offset_x = 25; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 15, 18); obj.offset_x = 35; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 15, 18); obj.offset_x = 45; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 15, 18); obj.offset_x =  5; obj.offset_y =  7; obj.alpha = 90
		obj = self:spawn(Count4, 15, 18); obj.offset_x = 15; obj.offset_y =  5; obj.alpha = 90

		obj = self:spawn(Count5, 16, 69); obj.offset_x =  5; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 16, 69); obj.offset_x = 15; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 16, 69); obj.offset_x = 25; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count1, 16, 69); obj.offset_x = 36; obj.offset_y = -5; obj.alpha = 90

		obj = self:spawn(Count5, 28, 83); obj.offset_x =  5; obj.offset_y = -6; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 15; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 25; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count6, 28, 83); obj.offset_x = 35; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 47; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 57; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 67; obj.offset_y = -4; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 77; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 87; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 97; obj.offset_y = -5; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x =  5; obj.offset_y =  5; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 15; obj.offset_y =  5; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 25; obj.offset_y =  6; obj.alpha = 90
		obj = self:spawn(Count5, 28, 83); obj.offset_x = 35; obj.offset_y =  6; obj.alpha = 90
		obj = self:spawn(Count2, 28, 83); obj.offset_x = 45; obj.offset_y =  6; obj.alpha = 90

		obj = self:spawn(Count2, 51,104); obj.offset_x =  6; obj.offset_y =  6; obj.alpha = 90

		-- Prison Beds
		self:spawn(PrisonBed, 51,  20)
		self:spawn(PrisonBed, 51,  27)
		self:spawn(PrisonBed, 51,  34)
		self:spawn(PrisonBed, 51,  41)
		self:spawn(PrisonBed, 51,  48)
		self:spawn(PrisonBed, 51,  55)
		
		self:spawn(PrisonBed, 51,  71)
		self:spawn(PrisonBed, 51,  78)
		self:spawn(PrisonBed, 51,  85)
		self:spawn(PrisonBed, 51,  92)
		self:spawn(PrisonBed, 51,  99)
		self:spawn(PrisonBed, 51, 106)

		self:spawn(PrisonBed, 30,  85)
		self:spawn(PrisonBed, 30,  92)
		self:spawn(PrisonBed, 30,  99)

		obj = self:spawn(PrisonBed, 14,  20); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  27); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  34); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  41); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  48); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  55); obj.offset_x = 7

		obj = self:spawn(PrisonBed, 14,  71); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  78); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  85); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  92); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14,  99); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 14, 106); obj.offset_x = 7

		obj = self:spawn(PrisonBed, 35,  85); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 35,  92); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 35,  99); obj.offset_x = 7
		

		-- Other decoration
		obj = self:spawn(AlmostPi, 49, 75); obj.offset_x = 6; obj.offset_y = 6; obj.alpha = 90
		obj = self:spawn(Convergence, 14, 68); obj.offset_x = 6; obj.offset_y = 6; obj.alpha = 90

		-- Spawn electric doors
		obj = self:spawn(ElecDoor, 11, 61);
		obj.isLocked = true;
		self:spawn(ElecDoor, 34, 63);
				
		-- Spawn portals
		self.sewersOutPortal = self:spawn(Portal, 65, 77);
		self.sewersOutPortal:setOutDir(DIR_UP);
	end;
}
