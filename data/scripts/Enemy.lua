
import("Character.lua")
import("BloodSplat.lua")

Enemy = Character:subclass
{
	name = "Enemy";


	--== Commands ==--

	attack = function(self)
		if (self.bAttacking == false and self.walking == 0 and self.charging == 0) then
			m_message("Enemy "..self:toString().." attacking.")
			self.bAttacking = true

			-- See if there is something at the attacked location
			local ax, ay = self.x, self.y
			if (self.dir == DIR_LEFT)  then ax = ax - 1 end
			if (self.dir == DIR_RIGHT) then ax = ax + 1 end
			if (self.dir == DIR_UP)    then ay = ay - 1 end
			if (self.dir == DIR_DOWN)  then ay = ay + 1 end

			local attackedObjs = m_get_objects_at(ax, ay, self.map)
			local damage = self.attackMinDam + math.random(self.attackMaxDam - self.attackMinDam)

			-- Deal damage
			for index, object in attackedObjs do
				if (object:instanceOf(Actor)) then
					object:takeDamage(damage, self)
				end
			end

			-- Enable next attack after attackTime + chargeTime game ticks
			ActionController:addSequence{
				ActionWait(self.attackTime),
				ActionSetVariable(self, "bAttacking", false),
				ActionSetVariable(self, "charging", self.chargeTime),
			}
		end
	end;


	--== Notifications ==--

	takeDamage = function(self, damage, instigator, damageType, momentum, location)
		m_message("Enemy "..self:toString().." took "..damage.." damage.")

		-- If not dead, play fair
		if (not self.bDead) then
			Character.takeDamage(self, damage, instigator, damageType, momentum, location)
			if (damage > 0 and self.hitEffectClass) then
				local obj = self:spawn(self.hitEffectClass, self.x, self.y)
				obj.offset_z = obj.offset_z + self.hitEffectHeight
			end
		end
	end;

	died = function(self, killer, damageType, location)
		Character.died(self, killer, damageType, location)

		-- Give players experience
		if (killer and killer:instanceOf(Player)) then
			killer:gainExperience(self.experience)
		end

		-- Disable animation and display death bitmap
		self.charAnim = nil
		self:setBitmap(self.deathBitmap)

		-- Fade away
		ActionController:addSequence({
			ActionWait(100),
			ActionSetVariable(self, "draw_mode", DM_TRANS),
			ActionTweenVariable(self, "alpha", 200, 0),
			ActionDestroyObject(self),
		})

		-- Enemies don't need tick when dead
		self.tick_time = 0
	end;


	defaultproperties = {
		experience = 0,
		attackTime = 50,
		chargeTime = 100,
		charging = 0,
		attackMinDam = 0,
		attackMaxDam = 5,

		bDead = false,
		bAttacking = false,

		hitEffectClass = BloodSplat,
		hitEffectHeight = 24,
		deathBitmap = nil,

		controllerClass = AIController,
	};
}
