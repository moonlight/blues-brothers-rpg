-- The objects that occure in the subcity.

import("Decoration.lua")


WallJakesPlace = Decoration:subclass
{
	name = "WallJakesPlace";

	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("wall_jakes_place.bmp"),
	}
}

Dustbin = Decoration:subclass
{
	name = "Dustbin";

	takeDamage = function(self, damage)
		m_message("Dustbin hit!")
		ActionController:addSequence{
			ActionTweenVariable(
				self, "offset_x", 20, 1 , self.offset_x,
				function(from, to, perc)
					return from+math.ceil(math.mod(perc * 6, 2) -0.5)
				end
			),
			ActionSetVariable(self, "offset_x", self.offset_x),
		}
	end;

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_ALPHA,
		bitmap = m_get_bitmap("dustbin.tga"),
		convTable = {
			{{"{PLAYER}", "A dustbin, it's where the dust goes."}},
			{{"{PLAYER}", "What moron would put a dustbin in the middle of the sidewalk?"}},
		},
	}
}

Keyboard = Decoration:subclass
{
	name = "Keyboard";

	init = function(self)
		self.convTable = lang:getConv("Keyboard")
		Decoration.init(self)
	end;

	tick = function(self)
		self.counter = math.mod(self.counter + 1, 8)
		self:updateBitmap()
	end;

	updateBitmap = function(self)
		self.counter = self.counter + 1
		if (self.counter == 1) then self:setBitmap(self.bitmaps[5])
		elseif (self.counter == 5) then self:setBitmap(self.bitmaps[1])
		elseif (self.counter == 2 or self.counter == 6) then self:setBitmap(self.bitmaps[2])
		elseif (self.counter == 3 or self.counter == 7) then self:setBitmap(self.bitmaps[3])
		elseif (self.counter == 4 or self.counter == 8) then self:setBitmap(self.bitmaps[4]) end
		self.counter = self.counter - 1
	end;

	defaultproperties = {
		offset_z = 15,
		obstacle = 0,
		tick_time = 60,
		counter = 1,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("keyboard.bmp"), 56, 13),
		convTable = {
			{{"{PLAYER}","I still got the blues..."}},
		},
	}
}

Onderstel = Decoration:subclass
{
	name = "Onderstel";

	defaultproperties = {
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("onderstel.bmp"),
	}
}

Guitar = Decoration:subclass
{
	name = "Guitar";

	init = function(self)
		self.convTable = lang:getConv("Guitar")
		Decoration.init(self)
	end;

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("guitar.bmp"),
	}
}

TV = Decoration:subclass
{
	name = "TV";

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("tv.bmp"),
	}
}

Bed = Decoration:subclass
{
	name = "Bed";

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = 2,
		offset_y = -5,
		obstacle = 1,
		w = 2,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("bed.bmp"),
	}
}

Couch = Decoration:subclass
{
	name = "Couch";

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = 2,
		offset_y = 2,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("bank.bmp"),
	}
}

CopCar = Decoration:subclass
{
	name = "CopCar";

	init = function(self)
		Decoration.init(self)
	
		self.tick_time = 5
		self.bitmap = self.animSeq[1]
		self:loopAnim(LinearAnimation(self.animSeq))
	end;

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = 8,
		offset_y = -10,
		offset_z = 0,
		obstacle = 1,
		h = 2,
		w = 5,
		draw_mode = DM_MASKED,
		animSeq =  extr_array(m_get_bitmap("car_cop.bmp"),108,50),
	}
}

Wheel = Decoration:subclass
{
	name = "Wheel";

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = 0,
		offset_y = -5,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("wheel.bmp"),
	}
}

Rope = Decoration:subclass
{
	name = "Rope";

	init = function(self)
		Decoration.init(self)
	end;

	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionConversation(lang:getConv("FindRope")),
			ActionExModeOff(),
		};
	end;

	defaultproperties = {
		bCanActivate = true,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("rope.bmp"),
	}
}

Skimasks = Decoration:subclass
{
	name = "Skimasks";

	init = function(self)
		Decoration.init(self)
	end;

	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionConversation(lang:getConv("FindSkimasks")),
			ActionExModeOff(),
		};
	end;

	defaultproperties = {
		bCanActivate = true,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("skimasks.bmp"),
	}
}

Nitrofuel = Decoration:subclass
{
	name = "Nitrofuel";

	init = function(self)
		Decoration.init(self)
	end;

	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionConversation(lang:getConv("FindNitrofuel")),
			ActionExModeOff(),
		};
	end;

	defaultproperties = {
		bCanActivate = true,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("nitrofuel.bmp"),
	}
}

KeyFob = Decoration:subclass
{
	name = "KeyFob";

	init = function(self)
		Decoration.init(self)
	end;

	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionConversation(lang:getConv("FindKeyFob")),
			ActionExModeOff(),
		};
	end;

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		bCanActivate = true,
		offset_x = 8,
		offset_y = -20,
		offset_z = -20,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("keyfob.bmp"),
	}
}

Washstand = Decoration:subclass
{
	name = "Washstand";

	init = function(self)
		self.convTable = lang:getConv("Washstand")
		Decoration.init(self)
	end;

	defaultproperties = {
		offset_z = 20,
		
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("washstand.bmp"),
	}
}

Toilet = Decoration:subclass
{
	name = "Toilet";

	init = function(self)
		self.convTable = lang:getConv("Toilet")
		Decoration.init(self)
	end;

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("toilet.bmp"),
	}
}

Clock = Decoration:subclass
{
	name = "Clock";

	init = function(self)
		self.convTable = lang:getConv("Clock")
		Decoration.init(self)
	end;

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("clock.bmp"),
	}
}

Car2 = Decoration:subclass
{
	name = "Car2";

	init = function(self)
		self.convTable = lang:getConv("Car2")
		Decoration.init(self)
	end;

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 1,
		w = 3,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("car2.bmp"),
	}
}

DoorJake = Decoration:subclass
{
	name = "DoorJake";

	init = function(self)
		self:updateBitmap()
		Decoration.init(self)
	end;

	updateBitmap = function(self)
		if (isClosed == false) then
			self.bitmap = self.bitmaps[2]
			self.obstacle = 0
		else
			self.bitmap = self.bitmaps[1]
			self.obstacle = 1
		end
	end;

	activatedBy = function(self, obj)
		if (isClosed == true) then
			isClosed = false
		else
			isClosed = true			
		end

		self:updateBitmap()
	end;

	defaultproperties = {
		bCanActivate = true,		
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = -2,
		isClosed = true,		
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("door2.bmp"), 28, 50),
	}
}

DoorLocked = Decoration:subclass
{
	name = "DoorLocked";

	init = function(self)
		self.convTable = lang:getConv("DoorLocked")
		self.bitmap = self.bitmaps[1]
		Decoration.init(self)
	end;

	defaultproperties = {
		bCanActivate = true,		
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = -2,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("door2.bmp"), 28, 50),
	}
}
