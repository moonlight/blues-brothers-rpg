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
			-- Remove or update the snow particles
			for i,p in ipairs(self.particles) do
				-- Update the position
				p.y = p.y + p.fallspeed / 24
				--p.x = p.x + 0.01 + math.sin(0.5*((1 / p.fallspeed)^2)*(p.y + p.phase)) / 100
				p.x = p.x + 0.01 + (math.sin((p.y + p.phase)) / 100) * p.fallspeed
			end
		end
	end;

	preRender = function(self)
		local viewport = self.master.viewport
		local viewedMap = nil
		local myMap = self.map.map
		if (viewport and viewport.target) then
			viewedMap = viewport.target.map
		end

		if (myMap == viewedMap) then
			-- Calculate viewport on the map
			local minx = viewport.target.x - 0.5 * (viewport.w / 24) - 0.5
			local miny = viewport.target.y - 0.5 * (viewport.h / 24)
			local maxx = minx + (viewport.w / 24) + 0.5
			local maxy = miny + (viewport.h / 24) + 0.5

			-- Add snow particles to reach density
			while (table.getn(self.particles) < self.density) do
				local p = self.map:spawn(SnowParticle, 0, 0, self)
				p.x = math.random(minx * 24, maxx * 24) / 24;
				p.y = math.random(viewport.h) / 24 + miny;
				p.fallspeed = (math.random() + 0.5) * 0.75;
				p.phase = math.random() * math.pi * 2
				if (p.bitmap == m_get_bitmap("snowflake2.tga")) then
					p.fallspeed = p.fallspeed * 0.5;
				end
				table.insert(self.particles, p)
			end

			-- Remove or update the snow particles
			for i,p in ipairs(self.particles) do
				if (p.y > maxy) then
					-- Warp snow back up
					p.y = p.y - viewport.h / 24 - 0.5;
					p.x = math.random(minx * 24, maxx * 24) / 24;
				end

				-- Put particles that moved out of the screen back into it
				if (p.x < minx or p.x > maxx) then
					local newx = math.mod(p.x - minx, maxx - minx)
					if (newx < 0) then newx = newx + (viewport.w / 24) + 0.5 end
					p.x = newx + minx
				elseif (p.y < miny or p.y > maxy) then
					local newy = math.mod(p.y - miny, maxy - miny)
					if (newy < 0) then newy = newy + (viewport.h / 24) + 0.5 end
					p.y = newy + miny
				end
			end
		end
	end;

	defaultproperties = {
		particles = {},
		density = 150,
		tick_time = 1,
		bVisible = true,
		bRequiresTick = true,
		bActive = false,
		map = nil,
	};
}
