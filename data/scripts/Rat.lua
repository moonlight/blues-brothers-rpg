-- 
-- A rat.
-- 
-- bodged by Hedde Bosman

import("Player.lua")
import("AdvAIRandom")

Rat = Enemy:subclass
{
	name = "Rat";
	bPlaceable = true;
	
	defaultproperties = {
		speed = 3,
		experience = 8,

		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("rat.bmp"), 16, 16),
		nature = NEUTRAL,
		controllerClass = AdvAIRandom,
		
		hitEffectHeight = 0,
	};
}
