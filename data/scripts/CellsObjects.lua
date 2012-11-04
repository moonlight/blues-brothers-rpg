--
-- The objects in the cells map
-- By Georg Muntingh

import("AnimationFunctions.lua")
import("Decoration.lua")

Count1 = Decoration:subclass
{
	name = "Count1";
	bPlaceable = true;
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("count_1.bmp"),
	}
}

Count2 = Decoration:subclass
{
	name = "Count2";
	bPlaceable = true;	

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("count_2.bmp"),
	}
}

Count3 = Decoration:subclass
{
	name = "Count3";
	bPlaceable = true;
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("count_3.bmp"),
	}
}

Count4 = Decoration:subclass
{
	name = "Count4";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("count_4.bmp"),
	}
}


Count5 = Decoration:subclass
{
	name = "Count5";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("count_5.bmp"),
	}
}

Count6 = Decoration:subclass
{
	name = "Count6";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("count_6.bmp"),
	}
}

AlmostPi = Decoration:subclass
{
	name = "AlmostPi";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("almost_pi.bmp"),
	}
}

Convergence = Decoration:subclass
{
	name = "Convergence";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		draw_mode = DM_TRANS,
		bitmap = m_get_bitmap("convergence.bmp"),
	}	
}

PrisonBed = Decoration:subclass
{
	name = "PrisonBed";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 1,
		w = 3,
		offset_x = 0,
		offset_y = 0,
		draw_mode = DM_ALPHA,
		bitmap = m_get_bitmap("bed2.tga"),
	}	
}

PrisonDoor1 = Decoration:subclass
{
	name = "PrisonDoor1";
	bPlaceable = true;	

	init = function(self)
		Actor.init(self)
		self.bitmap = self.bitmaps[1]
	end;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 1,
		w = 1,
		offset_x = 0,
		offset_y = 0,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("door3.bmp"), 24, 48),
	}	
}

PrisonDoor2 = Decoration:subclass
{
	name = "PrisonDoor2";
	bPlaceable = true;

	init = function(self)
		Actor.init(self)
		self.bitmap = self.bitmaps[self.status + 1]
		self.obstacle = 1 - self.status
	end;

	switch = function(self, obj)
		self.status = 1 - self.status
		self.bitmap = self.bitmaps[self.status + 1]
		self.obstacle = 1 - self.status
	end;

	defaultproperties = {
		bCanActivate = true,
		bCenterOnTile = false,
		bCenterBitmap = false,
		status = 0,
		w = 1,
		offset_x = 0,
		offset_y = 0,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("door3.bmp"), 24, 48),
	}	
}

SewageDrain = Decoration:subclass
{
	name = "SewageDrain";
	bPlaceable = true;	
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		obstacle = 0,
		w = 1,
		offset_x = 0,
		offset_y = -24,
		offset_z = -24,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("sewagedrain.bmp"),		
	}	
}

Shower = Decoration:subclass
{
	name = "Shower";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = true,
		obstacle = 0,
		offset_y = -4,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("shower.bmp"),
	}
}

Soap = Decoration:subclass
{
	name = "Soap";
	bPlaceable = true;

	defaultproperties = {
		bCenterOnTile = true,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("soap.bmp"),
		convTableKeyword = "Soap",
	}
}

Button = Decoration:subclass
{
	name = "Button";

	activatedBy = function(self, obj)
		if (self.acceptDir and obj.dir ~= self.acceptDir) then
			ActionController:addSequence{
				ActionConversation(lang:getConv("ButtonOutOfReach")),
			}
			return
		end

		self.isPushed = not self.isPushed

		local append = ""
		
		if (self.door) then
			self.door:switch()

			if ((self.door:instanceOf(ElecDoorPrison) and not self.door.isLocked2) or
				(self.door:instanceOf(PrisonDoor2) and self.door.obstacle == 0)) then
				append = "Open"
			else
				append = "Close"
			end
		end

		if (self.convKeyword) then
			ActionController:addSequence{
				ActionConversation(lang:getConv(self.convKeyword .. append)),
			}
		else
			ActionController:addSequence{
				ActionConversation(lang:getConv("PushButton")),
			}
		end
	end;
	
	defaultproperties = {
		bCanActivate = true,
		obstacle = 0,
		door = nil,
		isPushed = false,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("crowbar.bmp"),
		ticktime = 1,
	}
}

Button2 = Decoration:subclass
{
	name = "Button2";

	activatedBy = function(self, obj)
		self.isPushed = not self.isPushed
		
		if (self.prison_door) then
			if (not self.isPushed) then
				self.prison_door.isLocked2 = true
			else
				self.prison_door.isLocked2 = false
			end
		end
	end;
	
	defaultproperties = {
		bCanActivate = true,
		obstacle = 0,
		prison_door = nil,
		isPushed = false,
		bitmap = nil,
		ticktime = 1,
	}
}


ControlPanel = Decoration:subclass
{
	name = "ControlPanel";
	bPlaceable = true;

	defaultproperties = {
		obstacle = 0,
		h = 3,
		w = 4,
		bitmap = m_get_bitmap("controlpanel.bmp"),
	}
}

TriggerFreeBrian = Actor:subclass
{
	name = "TriggerFreeBrian";

	event_stand_on = function(self, obj)
		if (self.firstTime == true) then
			if (obj == elwood) then
				ActionController:addSequence{
					ActionExModeOn(),	
					ActionSetVariable(brian, "free", true),
					ActionWalkPath(obj,"U3"),
					ActionCallFunction(playerSwitcher.addPlayerHost, playerSwitcher, brian),
					ActionConversation(lang:getConv("FindBrian1Elwood")),
					ActionCallFunction(brian.addToInventory, brian, cityMap.walkieTalkie),
					ActionSetVariable(elwood, "bWalkieTalkie", true),
					ActionSetVariable(brian, "bWalkieTalkie", true),
					ActionConversation(lang:getConv("FindBrian2Elwood")),
					ActionSetVariable(elwood, "bWalkieTalkie", false),
					ActionSetVariable(brian, "bWalkieTalkie", false),
					ActionFadeOutMusic(100),
					ActionFadeOutMap(100),
					ActionSetPosition(jake, 14, 18, DIR_RIGHT, jakesMap),
					ActionSetPosition(brian, 15, 19, DIR_UP, jakesMap),
					ActionSetPosition(elwood, 16, 18, DIR_LEFT, jakesMap),
					ActionCallFunction(jake.setSleeping, jake, false),
					ActionCallFunction(elwood.setSleeping, elwood, false),
					ActionPlaySong(jakesMap.musicFilename, 100),
					ActionFadeInMap(100),
					ActionShowMapName(m_get_bitmap("jakesplace.tga")),
					ActionWait(200),
					ActionConversation(lang:getConv("EscapedInAppartment")),
					ActionExModeOff(),
				}
				self.firstTime = false
			else
				ActionController:addSequence{
					ActionExModeOn(),
					ActionSetVariable(brian, "free", true),
					ActionWalkPath(obj,"U3"),
					ActionConversation(lang:getConv("FindBrian1Jake")),
					ActionCallFunction(brian.addToInventory, brian, cityMap.walkieTalkie),
					ActionSetVariable(jake, "bWalkieTalkie", true),
					ActionSetVariable(brian, "bWalkieTalkie", true),
					ActionConversation(lang:getConv("FindBrian2Jake")),
					ActionSetVariable(jake, "bWalkieTalkie", false),
					ActionSetVariable(brian, "bWalkieTalkie", false),
					ActionFadeOutMusic(100),
					ActionFadeOutMap(100),
					ActionSetPosition(jake, 14, 18, DIR_RIGHT, jakesMap),
					ActionSetPosition(brian, 15, 19, DIR_UP, jakesMap),
					ActionSetPosition(elwood, 16, 18, DIR_LEFT, jakesMap),
					ActionCallFunction(jake.setSleeping, jake, false),
					ActionCallFunction(elwood.setSleeping, elwood, false),
					ActionPlaySong(jakesMap.musicFilename, 100),
					ActionFadeInMap(100),
					ActionShowMapName(m_get_bitmap("jakesplace.tga")),
					ActionWait(200),
					ActionConversation(lang:getConv("EscapedInAppartment")),
					ActionExModeOff(),
				}
				self.firstTime = false
			end
		end
	end;

	defaultproperties = {
		firstTime = true,
		obstacle = 0,
		bitmap = nil,
	}
}
