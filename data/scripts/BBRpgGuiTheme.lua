--
-- The BBRpg GUI theme
-- By Bjørn Lindeijer

import("GuiTheme.lua")


BBRpgGuiTheme = GuiTheme:subclass
{
	name = "BBRpgGuiTheme";

	drawBox = function(self, x, y, w, h)
		local alpha = m_get_alpha()

		-- Shadow
		m_set_alpha(128)
		self:drawBoxEx(
			self.shadow,
			self.shadowUL, self.shadowUR, self.shadowLL, self.shadowLR,
			self.shadow,   self.shadow,   self.shadow,   self.shadow,
			x+2, y+2, w, h
		)

		-- The actual box
		m_set_alpha(200)
		self:drawBoxEx(
			self.bg,
			self.cornerUL, self.cornerUR, self.cornerLL, self.cornerLR,
			self.borderU,  self.borderL,  self.borderR,  self.borderD,
			x, y, w, h
		)

		m_set_alpha(alpha)
	end;
	
	getTextColor = function(self)
		return 190, 190, 190
	end;
}
