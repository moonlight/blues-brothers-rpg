
import("Player.lua")

Elwood = Player:subclass
{
	name = "Elwood";

	defaultproperties = {
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("elwood.bmp"), 23, 40),
	};
}