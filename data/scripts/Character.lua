--
-- A character is a pawn with a specific animation scheme
-- By Bjorn Lindeijer

import("Pawn.lua")
import("Shadow.lua")


Character = Pawn:subclass
{
	name = "Character";

	init = function(self, char)
		self.inventory = {}

		self:updateBitmap()

		if (self.shadowClass) then
			self.shadow = self:spawn(self.shadowClass, self.x, self.y)
		end

		Pawn.init(self)
	end;

	updateBitmap = function(self)
		local ani = self.charAnim
		if (ani) then
			if (self.bAttacking) then
				self.bitmap = ani[self.dir + 1 + 3 * 4]
			else
				if (self.walking == 0 or self.walking < 50) then
					self:setBitmap(ani[self.dir + 1])
				else
					self:setBitmap(ani[self.dir + 1 + (self.leg_used + 1) * 4])
				end
			end
		end
	end;

	event_walk_start = function(self)
		self.leg_used = 1 - self.leg_used
	end;

	event_walk_finished = function(self)
		Pawn.event_walk_finished(self)
		self:updateBitmap()
	end;

	event_dir_change = function(self)
		self:updateBitmap()
	end;

	tick = function(self)
		Pawn.tick(self)
		self:updateBitmap()
	end;

	destroyed = function(self)
		-- Set bDead to prevent AI's from chasing destroyed characters
		self.bDead = true

		Pawn.destroyed(self)
		if (self.shadow) then
			self.shadow:destroy()
		end
	end;

	setMap = function(self, map)
		Pawn.setMap(self, map)
		if (self.shadow) then
			self.shadow:setMap(map)
		end
	end;

	addToInventory = function(self, obj)
		-- To be implemented: Check if there is place in the inventory?

		table.insert(self.inventory, obj)

		-- Make the object irrelevant on the map (not perfect)
		obj.bitmap = nil
		obj.obstacle = 0
		obj.bCanActivate = false
		obj.bCarried = true
	end;

	hasObject = function(self, obj)
		for k,v in pairs(self.inventory) do
			if (v == obj) then return true end
		end
	end;

	hasObjectType = function(self, class)
		for k,v in pairs(self.inventory) do
			if (v:instanceOf(class)) then return true end
		end
	end;

	-- To be implemented: removeFromInventory = function(self, obj)

	defaultproperties = {
		inventory = nil,
		leg_used = 0,
		tick_time = 1,
		walking = 0,
		charAnim = nil,
		shadow = nil,
		shadowClass = Shadow,

		bAttacking = false,
	};
}
