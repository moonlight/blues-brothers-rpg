
import("Player.lua")

Brian = Player:subclass
{
	name = "Brian";

	defaultproperties = {
		draw_mode = DM_MASKED,
		talkieBitmap = m_get_bitmap("brian_talk.bmp"),
		deathBitmap = m_get_bitmap("brian_dead.bmp"),
		sleepBitmap = m_get_bitmap("bed_brian.bmp"),
		charAnim = extr_char_anim(m_get_bitmap("brian.bmp"), 23, 40),
		free = false,
		hitSounds = {
			"Guhgh.wav",
			"Au.wav",
			"Ah1.wav",
		},
	};
}
