
import("Game.lua")
import("MainMenu.lua")
import("IngameMenu.lua")
import("BBRpgConversationWindow.lua")
import("BBRpgGuiTheme.lua")


BBRpg = Game:subclass
{
	name = "BBRpg";

	init = function(self)
		-- Create language file
		lang = BBRpgLang()            -- WARNING: Bad design, global variable introduced!

		-- Load tile bitmaps
		m_import_tile_bmp("jail_tiles.bmp", 24, 24, 0)
		m_import_tile_bmp("tiles_subcity.bmp", 24, 24, 0)
		m_import_tile_bmp("tiles_sewers.bmp", 24, 24, 0)

		-- Load the maps
		cityMap = City()
		jailMap = Jail()
		sewersMap = Sewers()
		jakesMap = JakesPlace()

		cityMap.jakePortal:linkToPortal(jakesMap.doorPortal)
		jakesMap.doorPortal:linkToPortal(cityMap.jakePortal)

		-- Spawn the player
		playerController = PlayerController()

		elwood = jailMap:spawn(Elwood, 36, 17)
		elwood.dir = DIR_UP
		jake   = cityMap:spawn(Jake,   111, 119)
		jake.dir = DIR_UP
		brian  = cityMap:spawn(Brian,  85, 75)


		-- Call superfunction
		Game.init(self)

		gameCameraTarget = CameraTarget()
		local playerSwitcher = PlayerSwitcher(playerController, gameCameraTarget)
		self.viewPort.target = gameCameraTarget

		playerSwitcher:addPlayerHost(elwood)
		playerSwitcher:addPlayerHost(jake)
		playerSwitcher:addPlayerHost(brian)


		-- Show startup screen
		show_main_menu = 1
		main_menu_bg = {
			bm = m_get_bitmap("bb_startup.bmp"),
			alpha = 0,
		}
		ActionController:addSequence{
			ActionExModeOn(),
			ActionTweenVariable(main_menu_bg, "alpha", 200, 255),
			ActionCallFunction(interactionMaster.addInteraction, interactionMaster, playerSwitcher),
		}
	end;

	event_render = function(self)
		local width, height = m_screen_size()

		if (show_main_menu) then
			m_set_cursor(0,0)
			m_set_alpha(main_menu_bg.alpha)
			draw_icon(main_menu_bg.bm)
		end

		Game.event_render(self)
	end;

	defaultproperties = {
		playerClass = nil,
		mainMenuClass = MainMenu,
		ingameMenuClass = IngameMenu,
		conversationWindowClass = BBRpgConversationWindow,
		guiThemeClass = BBRpgGuiTheme,
	};
}
