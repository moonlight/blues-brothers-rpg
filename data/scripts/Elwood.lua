
import("Player.lua")

Elwood = Player:subclass
{
	name = "Elwood";

	defaultproperties = {
		draw_mode = DM_MASKED,
		deathBitmap  = m_get_bitmap("elwood_dead.bmp"),
		talkieBitmap = m_get_bitmap("elwood_talk.bmp"),
		sleepBitmap  = m_get_bitmap("bed_elwood.bmp"),
		charAnim = extr_char_anim(m_get_bitmap("elwood.bmp"), 23, 40),
		hitSounds = {
			"Au2.wav",
			"Au2.wav",
			"Ow1.wav",
			"Ow1.wav",
			"Huuuw.wav",
		},
	};
}
