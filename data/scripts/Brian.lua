
import("Player.lua")

Brian = Player:subclass
{
	name = "Brian";

	defaultproperties = {
		draw_mode = DM_MASKED,
		deathBitmap = m_get_bitmap("brian_dead.bmp"),
		sleepBitmap = m_get_bitmap("bed_brian.bmp"),
		charAnim = extr_char_anim(m_get_bitmap("brian.bmp"), 23, 40),
	};
}
