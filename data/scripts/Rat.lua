-- 
-- A rat.
-- 
-- bodged by Hedde Bosman

import("Player.lua")
import("AdvAIRandom.lua")
import("Shadow.lua")

Rat = Enemy:subclass
{
	name = "Rat";
	bPlaceable = true;
	
	defaultproperties = {
		speed = 3,
		experience = 8,

		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("rat.bmp"), 16, 16),
		deathBitmap = m_get_bitmap("rat_dead.bmp"),
		nature = NEUTRAL,
		controllerClass = AdvAIRandom,
		shadowClass = RatShadow,
		
		hitEffectHeight = 0,
	};
}

RatShadow = Shadow:subclass
{
	name = "RatShadow";

	defaultproperties = {
		bitmap = m_get_bitmap("rat_s.tga");
	};
}
