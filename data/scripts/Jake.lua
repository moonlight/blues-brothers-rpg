
import("Player.lua")

Jake = Player:subclass
{
	name = "Jake";

	defaultproperties = {
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("jake.bmp"), 23, 43),
	};
}