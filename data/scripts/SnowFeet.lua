-- Class to make tracks in the snow
--
-- By Bjorn Lindeijer


import("Actor.lua")


SnowFeet = Actor:subclass
{
	name = "SnowFeet";

	init = function(self)
		ActionController:addSequence{
			ActionWait(100),
			ActionTweenVariable(self, "alpha", 800, 0),
			ActionDestroyObject(self),
		}
	end;

	setDirection = function(self, dir)
		if (dir == DIR_UP or dir == DIR_DOWN or dir == DIR_RIGHT or dir == DIR_LEFT) then
			self.dir = dir
			self.bitmap = m_get_bitmap("snow_feet" .. math.floor(dir) .. ".bmp")

			if (dir == DIR_LEFT) then self.offset_x = -7
			elseif (dir == DIR_RIGHT) then self.offset_x = -12
			elseif (dir == DIR_UP) then self.offset_z = -9
			elseif (dir == DIR_DOWN) then 
			end
		end
	end;

	defaultproperties = {
		bitmap = m_get_bitmap("snow_feet1.bmp"),
		offset_x = -7,
		offset_z = -2,
		offset_y = -2,
		alpha = 175,
	};
}
