-- Draws the map name to the screen

import("Interaction.lua")

BBRpgMapname = Interaction:subclass
{
	name = "BBRpgMapname";

	postRender = function(self, canvas)
		if (self.bitmap and self.perc > 0) then
			local scale = math.sin(self.perc * 0.5 * math.pi)
			local screen_w, screen_h = m_screen_size()
			local w, h = m_bitmap_size(self.bitmap)
			local x, y = (screen_w - w)/2, screen_h - (h/2) * scale - h/2 - 16

			canvas:setDrawMode(DM_ALPHA)
			canvas:setCursor(x, y)
			canvas:drawRect(self.bitmap, w, h * scale)
		end
	end;

	defaultproperties = {
		bitmap = nil,
		perc = 0,
	}
}
