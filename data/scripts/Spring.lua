--
-- The spring by Frode
--

import("Decoration.lua")
import("Animation.lua")
import("lang.lua")


Spring = Decoration:subclass
{
	name = "Spring";

	init = function(self)
		self.convTable = {
			lang:getConv("REFRESHING"),
			lang:getConv("COULD_USE_THAT"),
			lang:getConv("MUCH_BETTER"),
		}
		Decoration.init(self)
	end;

	activatedBy = function(self, instigator)
		Decoration.activatedBy(self, instigator)

		if (instigator.health < instigator.maxHealth) then
			ActionController:addSequence({
				ActionTweenVariable(instigator, "health", 2*(instigator.maxHealth - instigator.health), instigator.maxHealth),
			})
		end
	end;

	defaultproperties = {
		animType = LinearAnimation,
		animSeq = extr_array(m_get_bitmap("spring.bmp"), 48, 72),
		animSpeed = 1 / 8,
		w = 2,
		h = 1,
		bCanActivate = true,
		bCenterOnTile = false,
		bCenterBitmap = false,
	};
}
