-- An controller which makes its Pawn walk around randomly, scared, aggressive, neutral or moody...
--
-- Bodged by Hedde Bosman

import("Controller.lua")

SCARED = 1
NEUTRAL = 2
AGGRESSIVE = 3
MOODY = 4

AdvAIRandom = Controller:subclass
{
	name = "AdvAIRandom";

	init = function(self)
		self.waitTime = math.random(100) + 10
	end;

	-- == depending on this nature choose a target (to be scared of) ==-
	setTargetWithNature = function(self, nature, target)
		if ((nature == NEUTRAL) or (nature == AGGRESSIVE)) then
			self.target = target;
			self.scaring = nil;
		elseif (nature == SCARED) then
			self.target = nil;
			self.scaring = target;
		elseif (nature == MOODY) then
			self:setTargetWithNature(self.nature_tmp, target)
		else
			m_message("what am i? who am i? how did i get here? what's that i'm hearing? hmmm lets call it wind...")
		end;
	end;

	-- == -- == notifiers == -- == --
	-- 
	notifyBumpInto = function(self, obj)
		-- Pause for some time and choose another direction
		self.waitTime = math.random(100) + 10
	end;
	notifyWalkFinished = function(self)
                if (self.distanceToWalk <= 0) then
		        -- Reached his goal, pause and choose new goal.
			self.waitTime = math.random(100) + 10
		else
		        -- Walking to goal, keep walking.
		        self.distanceToWalk = self.distanceToWalk - 1
		        self.pawn:walk(self.pawn.dir)
		end;
	end;

	-- == do shizzle depending on nature, and possibly mood == --

	notifyHearNoise = function(self, loudness, noiseMaker)
		if (self.pawn:distanceTo(noiseMaker) < 8) then self.pawn.tick_time = 1; end;
		if (self.pawn:distanceTo(noiseMaker) >= 8) then self.pawn.tick_time = 150; end;
		if (noiseMaker and noiseMaker:instanceOf(Player)) then
			if (self.nature ~= NEUTRAL) then
				self:setTargetWithNature(self.nature, noiseMaker)
			end;
		end;
	end;
	notifyTakeDamage = function(self, damage, instigator, damageType, momentum, location)
		m_message("Rat: damaged. nature: " .. self.nature)
		if (instigator and instigator:instanceOf(Player)) then
			self:setTargetWithNature(self.nature, instigator);
		end;
	end;
	

	-- == -- == test if we can go in direction, if not go in other direction, but not 'notdir' == -- == --
	willGoInDirection = function(self, direction, notdir)
		local dirs = self.pawn:freeTilesAround()
		return direction
	end;
	
	
	-- timebom
	tick = function(self)
		if (self.pawn.charging > 0) then self.pawn.charging = self.pawn.charging - 1 end
		
                if (self.waitTime > 0) then self.waitTime = self.waitTime - 1; end;

		if (self.nature == MOODY) then
			-- this one is shifting moods... do new mood, and state how long it has that mood
			self.moodTime = self.moodTime -1
			if (self.moodTime <= 0) then
				self.target = nil
				self.scaring = nil
				self.moodTime = 300 + math.random(1000)
				self.nature_tmp = math.random(3)
			end;
		end;
		
		if (self.waitTime <= 0 and self.pawn.bAttacking == false) then
			-- Check for targets and their distances
			if (self.target) then
				playerDist = self.pawn:distanceTo(self.target)
			elseif (self.scaring) then
				playerDist = self.pawn:distanceTo(self.scaring)
			else
				playerDist = 100
			end;
			
			if (playerDist == 1 and self.target) then
				self.pawn.dir = self.pawn:directionTo(self.target)
				self.pawn:attack()
				self.waitTime = 100
			end;

			self.distanceToWalk = 1

			if (self.target and playerDist < 5) then
				-- hot persuit mode
				self.pawn.dir = self.pawn:directionTo(self.target);
			elseif (self.scaring and playerDist < 15) then
				-- scared; will run in opposit direction
				local tmpdir = self.pawn:directionTo(self.scaring)
				self.pawn.dir = self:reverseDirection(tmpdir);
			else
				-- walk around
				self.scaring = nil;
				self.target = nil;
				self.pawn.dir = math.random(4) - 1;
			end;

			self.pawn:walk(self.pawn.dir)
		end
	end;

	defaultproperties = {
		tick_time = 0,
		waitTime = 0,
		distanceToWalk = 0,
		nature = MOODY,
		nature_tmp = NEUTRAL,
		moodTime = 500,
		target = nil,
		scaring = nil,
	};
}
