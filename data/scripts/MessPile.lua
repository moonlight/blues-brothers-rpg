
import("Decoration.lua")


MessPile = Decoration:subclass
{
	name = "MessPile";

	defaultproperties = {
		offset_x = -6,
		offset_y = 6,
		w = 2,
		h = 2,
		obstacle = 1,
		draw_mode = DM_ALPHA,
		bCenterBitmap = false,
		bCenterOnTile = false,
		bitmap = m_get_bitmap("mess_pile.tga"),
		convTable = {
			{{"{PLAYER}", "Wow, here's a pile that's hard to clean up."}},
		},
	}
}
