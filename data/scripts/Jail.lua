--
-- Functions that fill the jail
--

import("Map.lua")

Jail = Map:subclass
{
	name = "Jail";

	init = function(self)
		local obj

		Map.init(self, "data/maps/jail.map")

		self:spawn(Table,    22, 16);
		self:spawn(Table,    35, 16);
		self:spawn(Table,    15, 44);
		self:spawn(Table,    55, 30);
		self:spawn(Table,    55, 16);
		
		self:spawn(ElecDoor, 23, 21);
		door1 = self:spawn(ElecDoor, 36, 21);
		self:spawn(ElecDoor, 56, 21);
		self:spawn(ElecDoor, 56, 35);
		self:spawn(ElecDoor, 16, 49);
		self:spawn(ElecDoor, 15, 21);
		self:spawn(ElecDoor, 14, 35);
		self:spawn(ElecDoor, 16, 35);
		self:spawn(ElecDoor, 18, 35);
		obj = self:spawn(ElecDoor, 47, 13);	obj.isLocked = true
		obj = self:spawn(ElecDoor, 44, 49);	obj.isLocked = true
		obj = self:spawn(ElecDoor, 54, 49); obj.isLocked = true
		obj = self:spawn(ElecDoor, 37, 35); obj.isLocked = true
		obj = self:spawn(ElecDoor, 25, 35); obj.isLocked = true

		self:spawn(Painting, 33, 13)
		self:spawn(Painting2, 17, 41)
		self:spawn(Boss    , 36, 15)
		self:spawn(PileOfPaper, 38, 15)
		self:spawn(Plant1  , 18, 14)
		self:spawn(Plant1  , 28, 14)
		self:spawn(Plant1  , 31, 14)
		self:spawn(Plant1  , 41, 14)
		self:spawn(Plant1  , 53, 14)
		self:spawn(Plant1  , 59, 14)
		self:spawn(Plant1  , 53, 28)
		self:spawn(Plant1  , 59, 28)
		self:spawn(Plant1  , 13, 42)
		self:spawn(Plant1  , 19, 42)
		self:spawn(ElevatorButtons, 16, 21)
		self:spawn(XmasTree, 20, 36)

		guard = self:spawn(Guard, 37, 17);

		ActionController:addSequence{
			ActionWait(50),
			ActionShowMapName(m_get_bitmap("bb_title_prison.bmp")),
		}
	end;
}
