--
-- The objects in the sewers
-- By Georg Muntingh

import("Actor.lua")
import("Decoration.lua")

Lever1 = Actor:subclass
{
	name = "Lever1";

	init = function(self)
		Actor.init(self)
		self:updateBitmap()
	end;

	updateBitmap = function(self)
		if (self.isOpen == false) then self.bitmap = self.bitmaps[1]
		else self.bitmap = self.bitmaps[2] end
	end;

	activatedBy = function(self, obj)
		if (self.isOpen == false) then
			self.isOpen = true
		else
			self.isOpen = false
		end
		self:updateBitmap()
	end;

	defaultproperties = {
		offset_y = -12,
		isOpen = false,
		bCanActivate = true,
		bitmaps = extr_array(m_get_bitmap("lever.bmp"), 5, 15),
		ticktime = 1,
	}
}

Ladder1 = Decoration:subclass
{
	name = "Ladder1";

	init = function(self)
		self.convTable = lang:getConv("LadderIn")
		Decoration.init(self)
	end;

	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		offset_y = 0,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("ladder.bmp"),
	}
}

Ladder2 = Decoration:subclass
{
	name = "Ladder2";

	init = function(self)
		self.convTable = lang:getConv("LadderOut")
		Decoration.init(self)
	end;

	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		offset_y = 0,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("ladder.bmp"),
	}
}

WallAndTube = Actor:subclass
{
	name = "WallAndTube";

	init = function(self)
		Actor.init(self)
	end;

	event_bumped_into = function(self, obj)
		local player = m_get_player()

		if (player.dir == DIR_UP) then
			ActionController:addSequence{
				ActionExModeOn(),
				ActionConversation(lang:getConv("WallAndTube1")),
				ActionSetPosition(m_get_player(), 54, 45, DIR_UP),
				ActionExModeOff(),
			}
		else
			ActionController:addSequence{
				ActionExModeOn(),
				ActionConversation(lang:getConv("WallAndTube2")),
				ActionSetPosition(m_get_player(), 54, 47, DIR_DOWN),
				ActionExModeOff(),
			}
		end
			
	end;

	defaultproperties = {
		offset_y = -5,
		offset_z = 8,
		obstacle = 1,
		bCanActivate = true,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("wall_and_tube.bmp"),
	}
}

WallAndTube2 = Actor:subclass
{
	name = "WallAndTube2";

	init = function(self)
		Actor.init(self)
	end;

	event_bumped_into = function(self, obj)
		local player = m_get_player()

		if (player.dir == DIR_DOWN) then
			ActionController:addSequence{
				ActionExModeOn(),
				ActionConversation(lang:getConv("WallAndTube1")),
				ActionSetPosition(m_get_player(), 54, 25, DIR_DOWN),
				ActionExModeOff(),
			}
		else
			ActionController:addSequence{
				ActionExModeOn(),
				ActionConversation(lang:getConv("WallAndTube2")),
				ActionSetPosition(m_get_player(), 54, 23, DIR_UP),
				ActionExModeOff(),
			}
		end
			
	end;

	defaultproperties = {
		obstacle = 1,
		bCanActivate = true,
	}
}