-- A huge Christmas tree

import("Decoration.lua")

ChristmasTree = Decoration:subclass
{
	name = "ChristmasTree";

	defaultproperties = {
		bitmap = m_get_bitmap("xmastree.bmp"),
		convTableKeyword = "ChristmasTree",
		bCenterOnTile = false,
		bCenterBitmap = false,
		w = 2,
		offset_y = -10,
	}
}
