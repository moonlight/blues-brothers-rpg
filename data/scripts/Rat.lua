-- 
-- A rat.
-- Edited by Frode Lindeijer
--
-- WARNING: This class is not entirely up to date!

import("Character.lua")
import("AnimationFunctions.lua")


Rat = Character:subclass
{
	name = "Rat";

	init = function(self)
		Character.init(self)
		self:start_animation(rat_anim)
	end;

	died = function(self, killer, damageType, location)
		m_message("Rat death")

		self.animation = nil
		self.bitmap = m_get_bitmap("rat_dead.bmp")
		ActionController:addSequence({
			ActionWait(100),
			ActionSetVariable(self, "draw_mode", DM_TRANS),
			ActionTweenVariable(self, "alpha", 200, 0),
			ActionDestroyObject(self),
		})
	end;

	tick = function(self)
		m_message("Rat tick")

		if (self.charge > 0) then self.charge = self.charge - 1 end

		-- Switch to ready from walking
		if (self.state == AI_WALKING and self.walking == 0) then
			self:setState(AI_READY)
		end

		-- When an AI is ready, it's waiting for something to happen to take action
		if (self.state == AI_READY) then
			-- Check if player is drawing near
			playerDist = playerDistance(self)
			local player = m_get_player()

			if (playerDist < 5 and scared == true) then
				self:walk(reverseDirection(playerDirection(self)))
			elseif (self.walk_interval == 0) then
				self:walk(math.random(4))
				self.walk_interval = 100 + math.random(50)
			end
		end

		if (self.walk_interval > 0) then
			self.walk_interval = self.walk_interval - 1
		end
	end;

	takeDamage = function(self, damage, instigator, damageType, momentum, location)
		m_message("Rat took damage")
		
		self.scared = true
		Character.takeDamage(self, damage, instigator, damageType, momentum, location)
	end;

	defaultproperties = {
		draw_mode = DM_MASKED,
		speed = 1.5,
		scared = false,
		walk_interval = 100 + math.random(50),
		charAnim = extr_char_anim(m_get_bitmap("rat.bmp"), 16, 16),
	};
}
