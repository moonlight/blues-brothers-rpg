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

		-- Dummy used for the cameratarget in the arena.
		local dummy = self:spawn(Dummy, 0, 0)
		
		-- Buttons to open the prison_door (1) and the door of Brians cell (2)
		local button1 = self:spawn(Button, 31, 56)
		local button2 = self:spawn(Button, 32, 56)

		-- Evil guards
		local evil_guard1 = self:spawn(EnemyGuard, 33, 55); evil_guard1.dir = DIR_RIGHT
		local evil_guard2 = self:spawn(EnemyGuard, 35, 55); evil_guard2.dir = DIR_LEFT
		
		-- Evil prisoners
		self:spawn(Prisoner1, 51, 21)
		self:spawn(Prisoner1, 51, 28)
		self:spawn(Prisoner2, 51, 35)
		self:spawn(Prisoner1, 51, 42)
		self:spawn(Prisoner2, 51, 49)
		self:spawn(Prisoner2, 51, 56)

		self:spawn(Prisoner1, 16, 21)
		self:spawn(Prisoner2, 16, 28)
		self:spawn(Prisoner2, 16, 35)
		self:spawn(Prisoner1, 16, 42)
		self:spawn(Prisoner3, 16, 49)
		self:spawn(Prisoner1, 16, 56)
				
		self:spawn(Prisoner1, 51,  72)
		self:spawn(Prisoner1, 51,  79)
		self:spawn(Prisoner2, 51,  86)
		self:spawn(Prisoner2, 51,  93)
		self:spawn(Prisoner1, 51, 100)
		self:spawn(Prisoner1, 51, 107)

		self:spawn(Prisoner1, 16,  72)
		self:spawn(Prisoner1, 16,  79)
		self:spawn(Prisoner2, 16,  86)
		self:spawn(Prisoner1, 16,  93)
		self:spawn(Prisoner2, 16, 100)
		self:spawn(Prisoner1, 16, 107)
		
		self:spawn(Prisoner1, 30, 28)
		self:spawn(Prisoner3, 30, 35)
		self:spawn(Prisoner2, 30, 42)

		self:spawn(Prisoner1, 37, 28)
		self:spawn(Prisoner2, 37, 35)
		self:spawn(Prisoner1, 37, 42)
		
		self:spawn(Prisoner2, 30,  86)
		self:spawn(Prisoner2, 30,  93)
		self:spawn(Prisoner1, 30, 100)

		self:spawn(Prisoner2, 37,  86)
		self:spawn(Prisoner2, 37,  93)
		self:spawn(Prisoner1, 37, 100)

		self:spawn(Prisoner1, 23, 115)
		self:spawn(Prisoner2, 30, 115)
		self:spawn(Prisoner3, 37, 115)


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

		-- Flatscreens
		obj = self:spawn(Flatscreen, 33, 57); obj.offset_y = -10; obj.offset_z = 15
		obj = self:spawn(Flatscreen, 38, 57); obj.offset_y = -10; obj.offset_z = 15

		-- Prison beds
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

		obj = self:spawn(PrisonBed, 35,  27); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 35,  34); obj.offset_x = 7
		obj = self:spawn(PrisonBed, 35,  41); obj.offset_x = 7

		-- Other decoration
		obj = self:spawn(AlmostPi, 49, 75); obj.offset_x = 6; obj.offset_y = 6; obj.alpha = 90
		obj = self:spawn(Convergence, 14, 68); obj.offset_x = 6; obj.offset_y = 6; obj.alpha = 90

		-- Spawn electric doors
		obj = self:spawn(ElecDoor, 11, 61)
		obj.isLocked = true

		local prison_door = self:spawn(ElecDoorPrison, 34, 63)
		prison_door.evil_guard1 = evil_guard1
		prison_door.evil_guard2 = evil_guard2
		prison_door.dummy = dummy
		button1.prison_door = prison_door
		button2.prison_door = prison_door -- Should later be used for Brians door		

		-- Spawn portals
		self.sewersOutPortal = self:spawn(Portal, 65, 77);
		self.sewersOutPortal:setOutDir(DIR_UP);
	end;
}
