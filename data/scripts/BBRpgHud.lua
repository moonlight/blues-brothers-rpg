
import("Hud.lua")

BBRpgHud = Hud:subclass
{
	name = "BBRpgHud";

	setPlayerSwitcher = function(self, playerSwitcher)
		self.playerSwitcher = playerSwitcher
	end;

	defaultproperties = {
		playerSwitcher = nil,
	}
}
