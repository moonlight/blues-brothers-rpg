
import("Player.lua")

Punk = Enemy:subclass
{
	name = "Punk";
	bPlaceable = true;

	defaultproperties = {
		speed = 2.5,
		maxHealth = 160,
		experience = 50,
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("punk.bmp"), 23, 43),
		deathBitmap = m_get_bitmap("punk_dead.bmp"),
	};
}
