--
-- A torch by Frode
--

import("Decoration.lua")
import("Animation.lua")
import("lang.lua")


Torch = Decoration:subclass
{
	name = "Torch";
	
	init = function(self)
		self.convTable = {
			lang:getConv("FIRE_1"),
			lang:getConv("FIRE_2"),
			lang:getConv("FIRE_3"),
		}
		Decoration.init(self)
	end;

	defaultproperties = {
		animType = LinearAnimation,
		animSeq = {
			m_get_bitmap("torch1.bmp"),
			m_get_bitmap("torch2.bmp"),
			m_get_bitmap("torch3.bmp"),
			m_get_bitmap("torch4.bmp"),
			m_get_bitmap("torch5.bmp"),
			m_get_bitmap("torch6.bmp"),
		},
		animSpeed = 1 / 10,
		draw_mode = DM_MASKED,
	};
}
