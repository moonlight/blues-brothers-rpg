--
-- The Actor is basically an Object with a part that is present in the
-- engine. Any engine Actor variable that is either assigned or read, is
-- causing transparent assign and read operations to the engine C++ class.
--

import("Object.lua")


Actor = Object:subclass
{
	name = "Actor";

	--== CLASS FUNCTIONS ==--

	-- Creates a new instance of this class
	new = function(self, map, ...)
		if (self._instance) then error("new() called on instance, should be called on class.") end

		m_message("Creating new "..self.name)
		local obj = {}
		setmetatable(obj, {__index = self})
		obj._class = self
		obj._instance = true

		-- Setup the binding with the engine
		m_register_object(obj, map)

		-- Assign default properties
		for key, value in pairs(self.defaultproperties) do obj[key] = value; end
		if (obj.init) then obj:init(unpack(arg)); end

		return obj
	end;

	-- Makes a class a subclass of this class
	subclass = function(self, t)
		subclass = Object.subclass(self, t)

		-- Register the new class with the engine
		m_register_class(subclass.name)

		return subclass
	end;

	--== OBJECT FUNCTIONS ==--

	init = function(self)
		self.health = self.maxHealth

		if (self.bCenterBitmap and self.bitmap) then
			w, h = m_bitmap_size(self.bitmap)
			self.offset_x = -w / 2
		end
	end;


	tick = function(self)
		-- Handle animation
		if (self.currentAnim) then
			if (self.bAnimating) then
				local length = self.currentAnim:length()
				local newTime = self.animTime + self.animSpeed

				if (newTime >= length) then
					if (self.bLoopAnim) then
						self:setAnimTime(newTime - length)
					else
						self:freezeAnimAt(length)
					end
					self:animEnd(self.currentAnim)
				else
					self:setAnimTime(newTime)
				end
			end
		end
	end;

	-- Called right before the screen gets rendered
	preRender = function(self)
		-- Make include a generic attachment scheme here?
	end;

	toString = function(self)
		return self.name .. "[" .. self.id .. "]"
	end;

	distanceTo = function(self, actor)
		return math.sqrt((self.x - actor.x)^2 + (self.y - actor.y)^2)
	end;

	directionTo = function(self, actor, y)
		local dx, dy

		if (type(actor) == "table") then
			dx = actor.x - self.x
			dy = actor.y - self.y
		else
			-- Treat (actor, y) as location (x, y)
			dx = actor - self.x
			dy = y - self.y
		end

		if (math.abs(dx) > math.abs(dy)) then
			if (dx > 0) then return DIR_RIGHT
			else return DIR_LEFT
			end
		else
			if (dy > 0) then return DIR_DOWN
			else return DIR_UP
			end
		end
	end;


	-- Returns a table containing the directions in which free tiles where found.
	freeTilesAround = function(self)
		dirs = {}
		if (table.getn(m_get_objects_at(self.x - 1, self.y, self.map)) == 0) then table.insert(dirs, DIR_LEFT ) end
		if (table.getn(m_get_objects_at(self.x + 1, self.y, self.map)) == 0) then table.insert(dirs, DIR_RIGHT) end
		if (table.getn(m_get_objects_at(self.x, self.y - 1, self.map)) == 0) then table.insert(dirs, DIR_UP   ) end
		if (table.getn(m_get_objects_at(self.x, self.y + 1, self.map)) == 0) then table.insert(dirs, DIR_DOWN ) end
		return dirs
	end;

	randomFreeTileAround = function(self)
		local dirs = self:freeTilesAround()
		if (table.getn(dirs) > 0) then return dirs[math.random(table.getn(dirs))] end
		return nil
	end;


	-- Spawns an actor, defaults to spawning at the spawner's location
	-- and with the spawner as owner.
	spawn = function(self, class, x, y, map, owner)
		if (not class or type(class) ~= "table") then error("No valid class to spawn specified!") end
		if (not map) then
			if (self.map) then
				map = self.map
			else
				error("Could not determine map to spawn object on!")
			end
		end
		local obj = class:new(map)

		-- Set position
		if (self._instance or (x and y)) then
			obj:setPosition(x or self.x, y or self.y)
		end

		-- Set owner
		local owner = owner or self
		if (owner) then obj:setOwner(owner) end

		return obj
	end;


	--== NOTIFICATIONS ==--

	-- The instigator, damageType, momentum and location are all optional.
	takeDamage = function(self, damage, instigator, damageType, momentum, location)
	end;

	-- Health ran out
	died = function(self, killer, damageType, location)
	end;

	-- Object was removed from the engine
	destroyed = function(self)
	end;


	destroy = function(self)
		m_destroy_object(self)
	end;


	--== Manipulating this Actor ==--

	setSize = function(self, w, h)
		self.w = w
		self.h = h
	end;

	setPosition = function(self, x, y)
		if (self.bCenterOnTile) then
			self.x = x + 0.5
			self.y = y - 0.5
		else
			self.x = x
			self.y = y
		end
	end;

	setOffset = function(self, offset_x, offset_y, offset_z)
		self.offset_x = offset_x
		self.offset_y = offset_y
		self.offset_z = offset_z
	end;

	setOwner = function(self, owner)
		self.owner = owner
	end;

	setMap = function(self, map)
		if (type(map) == "userdata") then
			self.map = map
		elseif (map:instanceOf(Map)) then
			self.map = map.map
		else
			error("Type error, object of type Map or map pointer expected.")
		end
	end;

	setBitmap = function(self, bitmap)
		self.bitmap = bitmap

		if (self.bCenterBitmap and self.bitmap) then
			w, h = m_bitmap_size(self.bitmap)
			self.offset_x = -w / 2
		end
	end;


	--== ANIMATION FUNCTIONS ==--

	playAnim = function(self, anim, rate)
		self.currentAnim = anim
		self.animSpeed = rate or 1
		self:setAnimTime(1)
		self.bAnimating = true
	end;

	loopAnim = function(self, anim, rate)
		self:playAnim(anim, rate)
		self.bLoopAnim = true
	end;

	isAnimating = function(self)
		return self.bAnimating
	end;

	finishAnim = function(self)
		self:freezeAnimAt(self.currentAnim:length())
	end;

	stopAnimating = function(self)
		self.bAnimating = false
	end;

	animStopLooping = function(self)
		self.bLoopAnim = false;
	end;

	freezeAnimAt = function(self, time)
		self:setAnimTime(time)
		self:stopAnimating()
	end;

	setAnimTime = function(self, time)
		self.animTime = time
		if (self.currentAnim) then
			self:setBitmap(self.currentAnim:getFrameAt(self.animTime))
		end
	end;


	-- Animation notification

	animEnd = function(self, anim)
	end;



	--
	-- DEFAULT PROPERTIES
	--

	defaultproperties = {
		bDead = false,
		owner = nil,

		speed = 2,
		x = 0,
		y = 0,
		w = 1,
		h = 1,
		offset_x = 0,
		offset_y = 0,
		offset_z = 0,
		draw_mode = DM_MASKED,
		alpha = 255,
		dir = DIR_DOWN,
		tick_time = 0,
		obstacle = 0,
		travel = 0,

		-- Animation variables
		currentAnim = nil,
		bAnimating = false,
		bLoopAnim = false,
		animTime = 0,
		animSpeed = 0,

		bCenterBitmap = false,
		bCenterOnTile = false,
	};


	-- Class properties

	bPlaceable = false,       -- Will instances of this class be placeable in the editor
	bPersistant = false,      -- Will instances of this class be saved with maps
}
