
import("Player.lua")

Brian = Player:subclass
{
	name = "Brian";

	defaultproperties = {
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("brian.bmp"), 23, 40),
	};
}