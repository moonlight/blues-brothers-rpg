-- 
-- A Crocodile.
-- 
-- Temporarily blindly copied from Hedde Bosman's rat by Georg Muntingh!

import("Player.lua")
import("AdvAIRandom")

Crocodile = Enemy:subclass
{
	name = "Crocodile";
	bPlaceable = true;
	
	defaultproperties = {
		attackMinDam = 3,
		attackMaxDam = 6,
		maxHealth = 50,
		speed = 3,
		experience = 16,

		offset_y = 6,
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("croc.bmp"), 24, 24),
		deathBitmap = m_get_bitmap("croc_dead.bmp"),
		nature = AGGRESSIVE,
		controllerClass = AdvAIRandom,
		
		hitEffectHeight = 0,
	};
}
