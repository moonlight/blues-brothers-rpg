
import("Player.lua")

Junk = Enemy:subclass
{
	name = "Junk";
	bPlaceable = true;

	defaultproperties = {
		speed = 2,
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("junk.bmp"), 23, 40),
	};
}
