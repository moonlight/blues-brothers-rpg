-- The evil prisoners, moehaha
-- By Georg Muntingh

import("Player.lua")

Prisoner1 = Enemy:subclass
{
	name = "Prisoner1";

	defaultproperties = {
		speed = 2,
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("prisoner1.bmp"), 24, 34),
	};
}

Prisoner2 = Enemy:subclass
{
	name = "Prisoner2";

	defaultproperties = {
		speed = 2,
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("prisoner2.bmp"), 23, 40),
	};
}

Prisoner3 = Enemy:subclass
{
	name = "Prisoner3";

	defaultproperties = {
		speed = 2,
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("prisoner3.bmp"), 24, 34),
	};
}
