--
-- The objects in the sewers
-- By Georg Muntingh

import("Actor.lua")
import("Decoration.lua")

Lever = Actor:subclass
{
	name = "Lever";

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
		
		if (self.gate) then
			self.gate:switch()
		end
		self:updateBitmap()
	end;
	
	opens = function(self, gate)		self.gate = gate
	end;
	defaultproperties = {
		gate = nil,
		offset_y = -12,
		offset_x = 12,
		isOpen = false,
		bCanActivate = true,
		bitmaps = extr_array(m_get_bitmap("lever.bmp"), 5, 15),
		ticktime = 1,
	}
}

Lever2 = Actor:subclass
{
	name = "Lever2";

	init = function(self)
		Actor.init(self)
		self:updateBitmap()
	end;

	updateBitmap = function(self)
		if (self.isOpen == false) then self.bitmap = self.bitmaps[1]
		else self.bitmap = self.bitmaps[2] end
	end;

	activatedBy = function(self, obj)
		if (obj == elwood) then
			ActionController:addSequence{
				ActionConversation(lang:getConv("LeverElwood")),
			};			
			if (self.isOpen == false) then
				self.isOpen = true
			else
				self.isOpen = false
			end
			if (self.gate) then
				self.gate:switch()
			end			self:updateBitmap()
		else
			ActionController:addSequence{
				ActionConversation(lang:getConv("LeverNotElwood")),
			};
		end
	end;
	
	opens = function(self, gate)		self.gate = gate
	end;
	defaultproperties = {
		gate = nil,
		offset_y = -12,
		offset_x = 12,
		isOpen = false,
		bCanActivate = true,
		bitmaps = extr_array(m_get_bitmap("lever.bmp"), 5, 15),
		ticktime = 1,
	}
}

Ladder1 = Decoration:subclass
{
	name = "Ladder1";

	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		offset_y = 0,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("ladder.bmp"),
		convTableKeyword = "LadderIn",
	}
}

Ladder2 = Decoration:subclass
{
	name = "Ladder2";

	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		offset_y = 0,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("ladder.bmp"),
		convTableKeyword = "LadderOut",
	}
}

WallAndTube = Actor:subclass
{
	name = "WallAndTube";

	init = function(self)
		Actor.init(self)
	end;
	event_bumped_into = function(self, player)
		if (player:instanceOf(Elwood)) then
			ActionController:addSequence{
				ActionExModeOn(),	
				ActionConversation(lang:getConv("WallAndTubeElwood")),
				ActionExModeOff(),
			}
		else
			if (player.dir == DIR_UP) then
				ActionController:addSequence{
					ActionExModeOn(),
					ActionConversation(lang:getConv("WallAndTube1")),
					ActionSetPosition(player, 54, 46, DIR_UP),
					ActionExModeOff(),
				}
			else
				ActionController:addSequence{
					ActionExModeOn(),
					ActionConversation(lang:getConv("WallAndTube2")),
					ActionSetPosition(player, 54, 48, DIR_DOWN),
					ActionExModeOff(),
				}
			end
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

	event_bumped_into = function(self, player)

		if (player:instanceOf(Elwood)) then
			ActionController:addSequence{
				ActionExModeOn(),	
				ActionConversation(lang:getConv("WallAndTubeElwood")),
				ActionExModeOff(),
			}
		else
			if (player.dir == DIR_DOWN) then
				ActionController:addSequence{
					ActionExModeOn(),
					ActionConversation(lang:getConv("WallAndTube1")),
					ActionSetPosition(player, 54, 26, DIR_DOWN),
					ActionExModeOff(),
				}
			else
				ActionController:addSequence{
					ActionExModeOn(),
					ActionConversation(lang:getConv("WallAndTube2")),
					ActionSetPosition(player, 54, 24, DIR_UP),
					ActionExModeOff(),
				}
			end
		end			
	end;

	defaultproperties = {
		obstacle = 1,
		bCanActivate = true,
	}
}
