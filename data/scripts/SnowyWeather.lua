-- This weather effect keeps references to a map and a viewport
-- to be able to determine if it should update the snow and to
-- do so if it should.
--
-- By Bjorn Lindeijer


import("Object.lua")

SnowParticle = Actor:subclass
{
	name = "SnowParticle";

	init = function(self)
		if (math.random() > 0.5) then
			self.bitmap = m_get_bitmap("snowflake2.tga")
		end
	end;

	defaultproperties = {
		bitmap = m_get_bitmap("snowflake1.tga"),
		draw_mode = DM_ALPHA,
		in_air = 1,
	};
}


SnowyWeather = Interaction:subclass
{
	name = "SnowyWeather";
	
	init = function(self, map)
		self.map = map
	end;

	tick = function(self)
		local viewport = self.master.viewport
		local viewedMap = nil
		local myMap = self.map.map
		if (viewport and viewport.target) then
			viewedMap = viewport.target.map
		end

		if (myMap == viewedMap) then
			-- Add snow particles to reach density
			while (table.getn(self.particles) < self.density) do
				local p = self.map:spawn(SnowParticle, 0, 0, self)
				p.x = math.random(viewport.w) / 24;
				p.y = math.random(viewport.h * 2) / 24;
				p.real_z = math.random(viewport.h);
				p.fallspeed = math.random() + 0.5;
				if (p.bitmap == m_get_bitmap("snowflake2.tga")) then
					p.fallspeed = p.fallspeed * 0.5;
				end
				table.insert(self.particles, p)
			end

			-- Calculate viewport on the map
			local minx = viewport.target.x - 0.5 * (viewport.w / 24)
			local miny = viewport.target.y - 0.5 * (viewport.h / 24)
			local maxx = minx + (viewport.w / 24)
			local maxy = miny + ((viewport.h * 2) / 24)

			-- Remove or update the snow particles
			for i,v in ipairs(self.particles) do
				if (v.real_z < 0) then
					-- Snow hit the floor, time to warp it back up
					v.real_z = math.random(viewport.h);
					v.x = math.random(viewport.w) / 24;
					v.y = math.random(viewport.h * 2) / 24;
				end

				-- Put particles that moved out of the screen back into it
				if (v.x < minx or v.x > maxx) then
					local newx = math.mod((v.x - minx) * 24, viewport.w) / 24
					if (newx < 0) then newx = newx + (viewport.w / 24) end
					v.x = newx + minx
				elseif (v.y < miny or v.y > maxy) then
					local newy = math.mod((v.y - miny) * 24, viewport.h * 2) / 24
					if (newy < 0) then newy = newy + ((viewport.h * 2) / 24) end
					v.y = newy + miny
				end

				-- Update the position
				v.real_z = v.real_z - v.fallspeed
				v.offset_z = v.real_z
			end
		end
	end;

	postRender = function(self, canvas)
		--[[
		local viewport = self.master.viewport

		for i,v in ipairs(self.particles) do
			local x, y = viewport:mapToScreen(v.offset_x, v.offset_y)
			canvas:setCursor(x, y)
			canvas:drawIcon(v.bitmap2)
		end
		]]
	end;

	defaultproperties = {
		particles = {},
		density = 200,
		tick_time = 1,
		bVisible = false,
		bRequiresTick = true,
		bActive = false,
		map = nil,
	};
}
