
import("Hud.lua")

BBRpgHud = Hud:subclass
{
	name = "BBRpgHud";

	setPlayerSwitcher = function(self, playerSwitcher)
		self.playerSwitcher = playerSwitcher
	end;

	postRender = function(self, canvas)
		Hud.postRender(self, canvas)

		-- What do I plan to do here?
	end;

	defaultproperties = {
		playerSwitcher = nil,
	}
}
