
import("Interaction.lua")

PlayerSwitcher = Interaction:subclass
{
	name = "PlayerSwitcher";

	init = function(self, playerController, cameraTarget)
		self.playerHosts = {}
		self.playerController = playerController
		self.cameraTarget = cameraTarget
	end;

	addPlayerHost = function(self, playerHost)
		if (not playerHost) then
			error("Attempt to add non-existing player host!")
		end

		table.insert(self.playerHosts, playerHost)

		if (self.currentHost == 0) then
			self:selectPlayerHost(playerHost)
		end
	end;

	removePlayerHost = function(self, playerHost)
		local iIndex = self:hostIndex(playerHost)

		if (iIndex < 0) then
			m_message("Attempt to remove non-existing player host.")
		else
			table.remove(self.playerHosts, iIndex)
			if (iIndex == self.currentHost) then
				if (self.currentHost > table.getn(self.playerHosts)) then
					self.currentHost = 1
				end

				if (table.getn(self.playerHosts) > 0) then
					self:selectPlayerHost(self.playerHosts[self.currentHost])
				else
					self.playerController:unPossess()
					self.currentHost = 0
				end
			end
		end
	end;

	selectPlayerHost = function(self, playerHost)
		local iIndex = self:hostIndex(playerHost)

		if (iIndex < 0) then
			m_message("Attempt to select non-existing player host.")
		else
			self.playerController:possess(playerHost)
			self.currentHost = iIndex
			self.cameraTarget:setTarget(playerHost)
		end
	end;

	getCurrentHost = function(self)
		if (self.currentHost > 0) then
			return self.playerHosts[self.currentHost]
		end;
	end;

	hostIndex = function(self, playerHost)
		local iIndex

		-- Search for the Interaction
		iIndex = -1;
		for i = 1, table.getn(self.playerHosts) do
			if (self.playerHosts[i] == playerHost) then
				iIndex = i
			end
		end

		return iIndex
	end;

	keyType = function(self, key)
		if (key == "tab" and table.getn(self.playerHosts) > 0 and m_get_ex_mode() == 0) then
			local prevHost = self:getCurrentHost()

			if (m_get_shift()) then
				self.currentHost = self.currentHost - 1
				if (self.currentHost < 1) then
					self.currentHost = table.getn(self.playerHosts)
				end
			else
				self.currentHost = self.currentHost + 1
				if (self.currentHost > table.getn(self.playerHosts)) then
					self.currentHost = 1
				end
			end

			local nextHost = self:getCurrentHost()

			if (prevHost.map == nextHost.map) then
				-- Switch player instantly
				self:selectPlayerHost(self.playerHosts[self.currentHost])
			else
				-- Switch player after fading out and fade in afterwards
				ActionController:addSequence{
					ActionSetVariable(self, "bActive", false),
					ActionFadeOutMap(50),
					ActionCallFunction(self.selectPlayerHost, self, self.playerHosts[self.currentHost]),
					ActionFadeInMap(50),
					ActionSetVariable(self, "bActive", true),
				}
			end

			return true;
		end;
	end;


	tick = function(self)
		self.cameraTarget:tick()
	end;

	preRender = function(self)
		self.cameraTarget:preRender()
	end;

	defaultproperties = {
		playerHosts = {},
		cameraTarget = nil,
		playerController = nil,
		currentHost = 0,
		bRequiresTick = true,
		bVisible = true,
	}
}
