-- ElecDoor


import("Actor.lua")

ElecDoor = Actor:subclass
{
	name = "ElecDoor";

	init = function(self)
		Actor.init(self)

		self.toStatus = self.status
		self:updateBitmap()

		if (self.status ~= 1) then self.obstacle = 1
		else self.obstacle = 0 end
	end;

	tick = function(self)
		if (self.isLocked) then return end;
		
		-- Make the door automatically close after openTime seconds
		if (self.closeTimer > 0) then
			self.closeTimer = self.closeTimer - 1
			if (self.closeTimer <= 0) then
				self.closeTimer = 1
				if (table.getn(m_get_objects_at(self.x, self.y, self.map)) == 1) then
					self.closeTimer = 0
					self.toStatus = 0
				end
			end
		end

		if (self.status < self.toStatus) then
			self.status = self.status + (0.01 / self.period)
			if (self.status > 1) then self.status = 1 end
			self:updateBitmap()

			if (self.status == 1) then
				self.closeTimer = self.openTime * 100
			end
		elseif (self.status > self.toStatus) then
			self.status = self.status - (0.01 / self.period)
			if (self.status <= 0) then
				self.status = 0
				self.tick_time = 0
			end
			self:updateBitmap()
		end
		if (self.status ~= 1) then self.obstacle = 1
		else self.obstacle = 0 end
	end;

	updateBitmap = function(self)
		local s = math.sin(self.status * 0.5 * math.pi)
		local bi = (table.getn(self.bitmaps) - 1) * s + 1

		self.bitmap = self.bitmaps[math.ceil(bi - 0.5)]
	end;

	activatedBy = function(self, obj)
		if (self.status == 0 or self.status == 1) then
			if (self.toStatus == 0) then self.toStatus = 1
			else self.toStatus = 0 end
		end
		self.tick_time = 1
	end;

	event_bumped_into = function(self, obj)
		self.toStatus = 1
		self.tick_time = 1
	end;

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = -3,
		tick_time = 0,
		isLocked = false,
		closeTimer = 0,
		openTime = 3,
		period = 0.25,
		bCanActivate = true,
		obstacle = 1,
		toStatus = 0,
		status = 0,
		bitmaps = extr_array(m_get_bitmap("elec_door.bmp"), 29, 59),
	}
}

