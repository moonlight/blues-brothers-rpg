-- ElecDoor


import("AnimationFunctions.lua")
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
				if (#m_get_objects_at(self.x + 0.5, self.y - 0.5, self.map) == 1) then
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
		local bi = (#self.bitmaps - 1) * s + 1

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

ElecDoorPrison = ElecDoor:subclass
{
	name = "ElecDoorPrison";
	
	activatedBy = function(self, obj)
		if (self.firstime == 2) then
			if self.isLocked2 then
				ActionController:addSequence{
					ActionConversation(lang:getConv("PrisonDoorLocked")),
				}
			else
				ElecDoor.activatedBy(self, obj)
			end
		end
	end;

	switch = function(self, obj)
		self.isLocked2 = not self.isLocked2
	end;

	event_bumped_into = function(self, obj)
		if (not (self.firstTime == 0) and not self.isLocked2) then
			ElecDoor.event_bumped_into(self, obj)
		end

		if (self.firstTime == 0) then
			ActionController:addSequence{
					ActionSequence{
						ActionExModeOn(),
						ActionConversation(lang:getConv("NotYetFightGuards")),
						ActionExModeOff(),
					},
			};
			self.firstTime = 1
		elseif (self.firstTime == 1) then
			ActionController:addSequence{
				ActionExModeOn(),
				ActionWait(30),
				ActionWalkPath(obj, "U3"),
--				ActionSetPosition(self.dummy, obj.x, obj.y - 2),
--				ActionSetCameraTarget(self.dummy, false),
--				ActionTweenVariable(self.dummy, "y", 100, obj.y - 7),
				ActionParallel{
					ActionSequence{
						ActionWait(60),
						ActionSetVariable(self.evil_guard1, "dir", DIR_DOWN),
						ActionWait(10),
						ActionSetVariable(self.evil_guard2, "dir", DIR_DOWN),						
					},
					ActionSequence{
						ActionConversation(lang:getConv("FightGuards")),
					},
				},
				ActionWalkPath(obj, "U2"),
				ActionSetVariable(self, "isLocked2", true),
				ActionExModeOff(),
			};

			self.firstTime = 2
		end
	end;
	
	defaultproperties = {
		firstTime = 0,
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = -3,
		tick_time = 0,
		isLocked = false,
		isLocked2 = false,
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
