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
	bPlaceable = true;
	
	beginPlay = function(self)
		Decoration.beginPlay(self)
		self.snowTop = self:spawn(SnowOnDustbin, x, y)
	end;

	setPosition = function(self, x, y)
	    Decoration.setPosition(self, x, y)

		if (self.snowTop) then
			self.snowTop.x = self.x
			self.snowTop.y = self.y
		end
	end;

	takeDamage = function(self, damage)
		m_play_sample("bbsfx_hit4.wav")
		ActionController:addSequence{
			ActionParallel{
				ActionTweenVariable(
					self, "offset_x", 20, 1, self.offset_x,
					function(from, to, perc)
						return from + math.ceil(math.mod(perc * 6, 2) - 0.5)
					end
				),
			},
			ActionSetVariable(self, "offset_x", self.offset_x),
		}
		if (self.snowTop) then
			ActionController:addSequence{
				ActionTweenVariable(
					self.snowTop, "offset_x", 20, 1, self.snowTop.offset_x,
					function(from, to, perc)
						return from + math.ceil(math.mod(perc * 6, 2) - 0.5)
					end
				),
				ActionSetVariable(self.snowTop, "offset_x", -7),
			}
		end
		if (self.snowTop and (not self.snowfalling)) then
			ActionController:addSequence{
				ActionSetVariable(self, "snowfalling", true),
				ActionTweenVariable(self.snowTop, "offset_z", 20, -6),
				ActionSetVariable(self.snowTop, "offset_z", 14),
				ActionChangeBitmap(self.snowTop, m_get_bitmap("dustbin_snow3.bmp")),
				ActionTweenVariable(self.snowTop, "alpha", 300, 0),
				ActionChangeBitmap(self.snowTop, m_get_bitmap("dustbin_snow1.bmp")),
				ActionTweenVariable(self.snowTop, "alpha", 500, 122),
				ActionSetVariable(self, "snowfalling", false),
				ActionTweenVariable(self.snowTop, "alpha", 500, 255),
			}
		end
	end;
	
	defaultproperties = {
		obstacle = 1,
		snowfalling = false,
		draw_mode = DM_ALPHA,
		bitmap = m_get_bitmap("dustbin.tga"),
		convTableKeyword = "Dustbin",
		snowTop = SnowOnDustbin,
	}
}

SnowOnDustbin = Actor:subclass
{
	name = "SnowOnDustbin";
	bPlaceable = false;
	
	defaultproperties = {
	    offset_z = 14,
	    offset_y = 10,
	    offset_x = -7,
	    alpha = 255,
	    draw_mode = DM_TRANS,
	    bitmap = m_get_bitmap("dustbin_snow1.bmp"),
	}
}

Keyboard = Decoration:subclass
{
	name = "Keyboard";
	
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
		convTableKeyword = "Keyboard",
	}
}

Onderstel = Decoration:subclass
{
	name = "Onderstel";
	bPlaceable = true;

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
		Decoration.init(self)
	end;

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("guitar.bmp"),
		convTableKeyword = "Guitar",
	}
}

TV = Decoration:subclass
{
	name = "TV";
	bPlaceable = true;

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("tv.bmp"),
	}
}

Bed = Decoration:subclass
{
	name = "Bed";
	bPlaceable = true;

	activatedBy = function(self, obj)
		local bitmapje = self.bitmap
		local schaduwtje = obj.shadow.bitmap
	
		if (obj.health == obj.maxHealth) then
			ActionController:addSequence{
				ActionConversation(lang:getConv("BedAwake")),
			}
		elseif (not self.bOccupied) then
			ActionController:addSequence{
				ActionSetVariable(self, "bOccupied", true),
				ActionConversation(lang:getConv("BedTiredBefore")),
				ActionSetVariable(obj, "bSleeping", true),
				ActionChangeBitmap(self, obj.sleepBitmap),
				ActionChangeBitmap(obj.shadow, nil),
				ActionSetVariable(obj, "alpha", 0),
				ActionSetVariable(obj, "bitmap"),
				ActionSetVariable(obj, "obstacle", 0),
				ActionSetVariable(obj, "onActivate",
					function(self2)
						self2.bSleeping = false
						self2.onActivate = nil
						ActionController:addSequence{
							ActionSetVariable(obj, "alpha", 255),
							ActionSetVariable(obj, "dir", DIR_DOWN),
							ActionChangeBitmap(self, bitmapje),
							ActionChangeBitmap(obj.shadow, schaduwtje),
							ActionConversation(lang:getConv("BedTiredAfter")),
							ActionSetVariable(obj, "obstacle", 1),
							ActionSetVariable(self, "bOccupied", false),
						}
					end),
			}
		else
			ActionController:addSequence{
				ActionConversation(lang:getConv("BedOccupied")),
			}
		end
	end;
	
	defaultproperties = {
		bOccupied = false,
		bCanActivate = true,
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
	bPlaceable = true;

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
	bPlaceable = true;

	init = function(self)
		Decoration.init(self)
	
		self.tick_time = 0
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
	bPlaceable = true;

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

	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionConversation(lang:getConv("FindRope")),
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

	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionConversation(lang:getConv("FindSkimasks")),
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

	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionConversation(lang:getConv("FindNitrofuel")),
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
	bPlaceable = true;

	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionSetVariable(obj, "bWalkieTalkie", true),
			ActionConversation(lang:getConv("FindKeyFob")),
			ActionSetVariable(obj, "bWalkieTalkie", false),
			ActionCallFunction(obj.addToInventory, obj, self),
		};
	end;

	defaultproperties = {
		bCanActivate = true,
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = 8,
		offset_y = -20,
		offset_z = -20,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("keyfob.bmp"),
		inventoryBitmap = m_get_bitmap("keyfob_inv.bmp"),
	}
}

Washstand = Decoration:subclass
{
	name = "Washstand";

	defaultproperties = {
		offset_z = 20,
		
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("washstand.bmp"),
		convTableKeyword = "Washstand",
	}
}

Toilet = Decoration:subclass
{
	name = "Toilet";

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("toilet.bmp"),
		convTableKeyword = "Toilet",
	}
}

Clock = Decoration:subclass
{
	name = "Clock";

	defaultproperties = {
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("clock.bmp"),
		convTableKeyword = "Clock",
	}
}

Car = Decoration:subclass
{
	name = "Car";

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 1,
		w = 3,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("car.bmp"),
		convTableKeyword = "Car",
	}
}

Car2 = Decoration:subclass
{
	name = "Car2";

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 1,
		w = 3,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("car2.bmp"),
		convTableKeyword = "Car2",
	}
}

CarShadow = Decoration:subclass
{
	name = "CarShadow";

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = 2,
		offset_y = -20,
		offset_z = -20,
		obstacle = 1,
		alpha = 70,
		w = 3,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("car2_s.bmp"),
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
		if (not self.isClosed) then
			self:setBitmap(self.bitmaps[2])
			self.obstacle = 0
		else
			self:setBitmap(self.bitmaps[1])
			self.obstacle = 1
		end
	end;

	activatedBy = function(self, obj)
		m_message("DoorJake activated!")
		if (obj:hasObjectType(KeyFob)) then
			if (self.isClosed) then
				self.isClosed = false
			else
				self.isClosed = true
			end
			self:updateBitmap()
		else
			ActionController:addSequence{
				ActionConversation(lang:getConv("JakesDoorLocked")),
			};
		end;
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
	bPlaceable = true;

	init = function(self)
		self.bitmap = self.bitmaps[1]
		Decoration.init(self)
	end;

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = -2,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("door2.bmp"), 28, 50),
		convTableKeyword = "DoorLocked",		
	}
}

DoorInside = Decoration:subclass
{
	name = "DoorInside";
	bPlaceable = true;

	init = function(self)
		self:updateBitmap()
		Decoration.init(self)
	end;

	updateBitmap = function(self)
		if (not self.isClosed) then
			self:setBitmap(self.bitmaps[2])
			self.obstacle = 0
		else
			self:setBitmap(self.bitmaps[1])
			self.obstacle = 1
		end
	end;

	activatedBy = function(self, obj)
		m_message("DoorInside activated!")
		self.isClosed = not self.isClosed

		self:updateBitmap()
	end;

	defaultproperties = {
		bCanActivate = true,		
		bCenterOnTile = false,
		bCenterBitmap = false,
		isClosed = true,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("door4.bmp"), 24, 48),
	}
}

LamppostLeft = Actor:subclass
{
	name = "LamppostLeft";
	bPlaceable = true;
	
	defaultproperties = {
		bitmap = m_get_bitmap("lamppost_snow_w.bmp"),
		offset_y = -15,
		offset_x = -12,
		obstacle = 1,
	};
}

LamppostRight = Actor:subclass
{
	name = "LamppostRight";
	bPlaceable = true;
	
	defaultproperties = {
		bitmap = m_get_bitmap("lamppost_snow_e.bmp"),
		offset_y = -15,
		offset_x = 9,
		obstacle = 1,
	};
}

Waterplas = Actor:subclass
{
	name = "Waterplas";
	bPlaceable = true;
	
	defaultproperties = {
		bitmap = m_get_bitmap("waterplas.bmp"),
		offset_y = -8,
		offset_x = 0,
		obstacle = 0,
	};
}

Sewerput = Actor:subclass
{
	name = "Sewerput";
	bPlaceable = true;
	
	defaultproperties = {
		bitmap = m_get_bitmap("sewerput.bmp"),
		offset_y = -8,
		offset_x = 0,
		obstacle = 0,
	};
}

Putdeksel = Actor:subclass
{
	name = "Putdeksel";
	bPlaceable = true;

	activatedBy = function(self, obj)
		if (obj:hasObjectType(Crowbar)) then
			ActionController:addSequence{
				ActionParallel{
					ActionConversation(lang:getConv("RemovePutdeksel")),
					ActionSequence{
						ActionTweenVariable(self, "offset_x", 50, -15),
						ActionSetVariable(self, "obstacle", 0),
					}
				}
			}
			self.bCanActivate = false
		else
			ActionController:addSequence{
				ActionConversation(lang:getConv("CantRemovePutdeksel")),
			}
		end;
	end;

	defaultproperties = {
		bCanActivate = true,
		offset_x = -1,
		offset_y = -11,
		offset_z = -6,
		bitmap = m_get_bitmap("putdeksel.bmp"),
		obstacle = 1,
	}
}

Crowbar = Decoration:subclass
{
	name = "Crowbar";
	bPlaceable = true;
	
	activatedBy = function(self, obj)
		ActionController:addSequence{
			ActionSetVariable(obj, "bWalkieTalkie", true),
			ActionConversation(lang:getConv("Crowbar")),
			ActionSetVariable(obj, "bWalkieTalkie", false),
			ActionCallFunction(obj.addToInventory, obj, self),
		}
	end;
	
	defaultproperties = {
		bCanActivate = true,
		obstacle = 1,
		bitmap = m_get_bitmap("crowbar.bmp"),
		inventoryBitmap = m_get_bitmap("crowbar.bmp"),
	}
}

TooDangerous = Actor:subclass
{
	name = "TooDangerous";

	event_stand_on = function(self, obj)
		if (not brian.free) then
			ActionController:addSequence{
				ActionExModeOn(),	
				ActionConversation(lang:getConv("TooDangerous")),
				ActionWalkPath(obj,"R1"),
				ActionExModeOff(),
			}
		end
	end;

	defaultproperties = {
		bCanActivate = true,	
		obstacle = 0,
		w = 1,
		h = 8,
	}	
}

TooDangerous2 = Actor:subclass
{
	name = "TooDangerous2";

	event_stand_on = function(self, obj)
		if (not brian.free) then
			local dummy = cityMap:spawn(Dummy, obj.x, obj.y)

			ActionController:addSequence{
				ActionExModeOn(),	
				ActionSetCameraTarget(dummy, false),
				ActionTweenVariable(dummy, "y", obj.x, obj.y - 4),
				ActionConversation(lang:getConv("TooDangerous")),
				ActionSetCameraTarget(obj, true),
				ActionWalkPath(obj,"D1"),
			
				ActionExModeOff(),
			}
		end
	end;

	defaultproperties = {
		bCanActivate = true,	
		obstacle = 0,
		w = 7,
		h = 1,
	}
}

WalkieTalkie = Actor:subclass
{
	name = "WalkieTalkie";

	defaultproperties = {
		inventoryBitmap = m_get_bitmap("talkie.bmp"),
		obstacle = 0,
	}
}

Engines = Actor:subclass
{
	name = "Engines";

	defaultproperties = {
		inventoryBitmap = m_get_bitmap("engines.bmp"),
		obstacle = 0,
	}
}

Lee = Actor:subclass
{
	name = "Lee";
	bPlaceable = true;

	defaultproperties = {
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("lee.bmp"),
		obstacle = 0,
	}
}
