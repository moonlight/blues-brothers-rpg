--
-- A base class for anything that walks like a character
-- By Bjorn Lindeijer

import("Actor.lua")


Pawn = Actor:subclass
{
	name = "Pawn";

	init = function(self)
		self.health = self.maxHealth

		-- Create the default controller, if present
		if (not self.controller and self.controllerClass) then
			self.controller = self.controllerClass()
			self.controller:possess(self)
		end

		Actor.init(self)
	end;

	tick = function(self)
		Actor.tick(self)
		if (self.controller) then
			self.controller:tick()
		end
	end;



	--== BEING POSSESSED ==--

	possessedBy = function(self, controller)
		self.controller = controller
	end;

	unPossessed = function(self)
		self.controller = nil
	end;


	--== TAKING DAMAGE ==--

	takeDamage = function(self, damage, instigator, damageType, momentum, location)
		if (damage > 0) then
			local actualDamage = damage
			self.health = self.health - damage

			if (self.health <= 0) then
				-- Pawn died
				local killer
				if (instigator) then
					killer = instigator.controller
				end
				self:died(killer, damageType, location)
			else
				if (self.controller) then
					self.controller:notifyTakeDamage(actualDamage, instigator, damageType, momentum, location);
				end
			end

			self:makeNoise(15)
		end
	end;

	died = function(self, killer, damageType, location)
		self.bDead = true
		-- Become bleeding body and fade away (implement in subclass)
	end;


	--== MOVING ==--

	walk = function(self, dir, no_collision)
		if (self.walking == 0) then
			if (no_collision) then
				m_walk_obj_nocol(self, dir)
			else
				m_walk_obj(self, dir)
			end
			if (self.walking ~= 0) then
				self:makeNoise(10)
			end
		end
	end;

	attack = function(self)
		-- Implement in subclass
	end;

	-- Making noise will cause surrounding Pawns to hear the noise with
	--  hearedLoudness = max(0.1, min(loudness, loudness / (distanceInTiles ^ 2)))
	makeNoise = function(self, loudness)
		m_make_noise(self, loudness)
	end;

	hearNoise = function(self, loudness, noiseMaker)
		--self:log("Heared noise with loudness "..loudness.." from "..noiseMaker:toString())
		if (self.controller) then
			self.controller:notifyHearNoise(loudness, noiseMaker)
		end
	end;

	-- This actor bumps into an obstacle
	event_bump_into = function(self, obj)
		if (self.controller) then
			self.controller:notifyBumpInto(obj)
		end
	end;

	-- Another actor bumps into this actor
	event_bumped_into = function(self, obj)
		if (self.controller) then
			self.controller:notifyBumpedInto(obj)
		end
	end;

	-- This actor finishes its current walking step
	event_walk_finished = function(self)
		if (self.controller) then
			self.controller:notifyWalkFinished(obj)
		end
	end;


	defaultproperties = {
		bSleeping = false,

		-- The Controller possessing this Pawn
		controller = nil,

		maxHealth = 100,
		speed = 3,
		--offset_y = -6,
		draw_mode = DM_ALPHA,
		obstacle = 1,
		bCenterBitmap = true,

		controllerClass = nil,
		bCenterOnTile = true,
	};
}
