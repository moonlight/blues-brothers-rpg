-- JailObjects.lua
-- Objects that appear in jail.
-- By Georg Muntingh

import("Decoration.lua")

Table = Decoration:subclass
{
	name = "Table";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_y = 5,
		obstacle = 1,
		w = 4,
		draw_mode = DM_ALPHA,
		bitmap = m_get_bitmap("table.tga"),
	}
}

Painting = Decoration:subclass
{
	name = "Painting";
	bPlaceable = true;

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_y = -14,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("painting.bmp"),
		convTable = {
			{{"Mr. Prosser", "It's the famous sunflower of Vincent van Gogh."}},
			{{"Mr. Prosser", "Beautiful isn't it?"}},
			{{"Mr. Prosser", "Don't touch it."}},
		},
	}
}

Painting2 = Decoration:subclass
{
	name = "Painting2";
	bPlaceable = true;
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_y = -14,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("painting.bmp"),
		convTable = {
			{{"{Player}", "Another Sunflower of van Gogh?!"}},
			{{"{Player}", "This is weird..."}},
		},

	}
}

Boss = Decoration:subclass
{
	name = "Boss";

	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_y = -7,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("boss.bmp"),
	}
}

PileOfPaper = Decoration:subclass
{
	name = "PileOfPaper";
	bPlaceable = true;
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_y = 18,
		offset_z = 14,
		offset_x = -10,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("pile_of_paper.bmp"),
	}
}

Plant1 = Decoration:subclass
{
	name = "Plant1";
	bPlaceable = true;
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_x = 4,
		offset_y = -17,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("plant1.bmp"),
	}
}

ElevatorButtons = Decoration:subclass
{
	name = "ElevatorButtons";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_y = -21,
		offset_x = -6,
		obstacle = 0,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("elevator_buttons.bmp"),
	}
}

Flatscreen = Decoration:subclass
{
	name = "Flatscreen";
	bPlaceable = true;
	
	defaultproperties = {
		bCenterOnTile = false,
		bCenterBitmap = false,
		offset_y = 0,
		offset_x = 0,
		obstacle = 1,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("flatscreen.bmp"),
	}
}
