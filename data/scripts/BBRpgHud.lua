
import("Hud.lua")

BBRpgHud = Hud:subclass
{
	name = "BBRpgHud";

	setPlayerSwitcher = function(self, playerSwitcher)
		self.playerSwitcher = playerSwitcher
	end;

	postRender = function(self, canvas)
		local player = self.playerSwitcher:getCurrentHost()
		if (player) then
			if (player.map == sewersMap.map) then
				-- Draw map icon in top right
				guiTheme:drawBox(320 - 50 - 18, 14, 54, 54)
				canvas:setCursor(320 - 50 - 16, 16)
				local a = canvas:setAlpha(128)
				canvas:drawBitmap(self.sewersImg, 50, 50, player.x - 25 - 0.5, player.y - 25 - 0.5, 50, 50)
				canvas:setAlpha(a)
			end
		end

		-- Draw gameover screen stuff
		if (game.game_over and game.game_over_alpha and game.game_over_alpha > 0) then
			canvas:setAlpha(0.25 * game.game_over_alpha)
			canvas:setCursor((self.screen_w - self.go_w)/2 + 6, (self.screen_h - self.go_h)/3 + 4)
			canvas:drawIcon(self.game_over_s)
			canvas:setAlpha(game.game_over_alpha)
			canvas:setCursor((self.screen_w - self.go_w)/2, (self.screen_h - self.go_h)/3)
			canvas:drawIcon(self.game_over)
		end
	end;

	defaultproperties = {
		playerSwitcher = nil,
		sewersImg = m_get_bitmap("sewers_map.bmp"),
	};
}
