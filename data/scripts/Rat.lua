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
		draw_mode = DM_MASKED,
		speed = 3,
		charAnim = extr_char_anim(m_get_bitmap("rat.bmp"), 16, 16),
		-- hij leest deze nature nog niet uit...
		nature = AGGRESSIVE,
		controllerClass = AdvAIRandom,
		
		hitEffectHeight = 0,
	};
}
