--
-- This file builds on top of the Cave Adventure conversation windows class.
--
-- By Bjorn Lindeijer

import("ConversationWindow.lua")


BBRpgConversationWindow = ConversationWindow:subclass
{
	name = "BBRpgConversationWindow";
	
	init = function(self)
		ConversationWindow.init(self)
		
		-- Get and set some sizes
		self.font = "font_sansserif8.pcx"
		m_set_font(self.font)
		self.space_width, self.line_height = m_text_size(" ")
		local w, h = m_screen_size()
		self.x = w * (1/8)
		self.h = h * (1/6) + 5 - 2
		self.y = h - (self.h + (self.x / 2))
		self.w = w - 2 * self.x
		self.nr_lines = math.floor(self.h / self.line_height)
	end;	
}
