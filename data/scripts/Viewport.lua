
import("Object.lua")


Viewport = Object:subclass
{
	name = "Viewport";

	init = function(self, x, y, w, h)
		self.x = x or self.x
		self.y = y or self.y
		self.w = w or self.w
		self.h = h or self.h
	end;

	render = function(self)
		if (not self.target or not self.target.map) then
			m_message("No target for viewport")
			return
		end

		local width, height = m_screen_size()

		if (self.target) then
			m_draw_viewport(
				self.x, self.y,
				self.w, self.h,
				self.target.x, self.target.y,
				self.target.map
			)
		end
	end;

	defaultproperties = {
		x = 0,
		y = 0,
		w = 0,
		h = 0,
		tx = 0,
		ty = 0,
		map = nil,
		target = nil,
	};
}
