--
-- The objects in the cells map
-- By Georg Muntingh

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
		offset_y = -12,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("bed2.bmp"),
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
		offset_y = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("sewagedrain.bmp"),		
	}	
}
