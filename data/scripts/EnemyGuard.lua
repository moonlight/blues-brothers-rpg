
import("Player.lua")

EnemyGuard = Enemy:subclass
{
	name = "EnemyGuard";

	defaultproperties = {
		speed = 3,
		draw_mode = DM_MASKED,
		charAnim = extr_char_anim(m_get_bitmap("cop.bmp"), 23, 40),

		experience = 0,
		attackTime = 50,
		chargeTime = 100,
		charging = 0,
		attackMinDam = 0,
		attackMaxDam = 5,

		bDead = false,
		bAttacking = false,

		deathBitmap = m_get_bitmap("cop_dead.bmp"),
	};
}
