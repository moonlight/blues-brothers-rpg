
import("Game.lua")
import("MainMenu.lua")
import("IngameMenu.lua")
import("BBRpgConversationWindow.lua")
import("BBRpgGuiTheme.lua")
import("BBRpgHud.lua")


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
		cityMap   = City()
		jailMap   = Jail()
		sewersMap = Sewers()
		leesMap   = LeesPlace()
		jakesMap  = JakesPlace()
		cellsMap  = Cells()
		restMap   = RestPlace()

		-- Links between portals
		cityMap.jakePortal:linkToPortal(jakesMap.doorPortal)
		jakesMap.doorPortal:linkToPortal(cityMap.jakePortal)

		sewersMap.stairsInPortal:linkToPortal(cityMap.sewersInPortal)
		cityMap.sewersInPortal:linkToPortal(sewersMap.stairsInPortal)

		sewersMap.stairsOutPortal:linkToPortal(cellsMap.sewersOutPortal)
		cellsMap.sewersOutPortal:linkToPortal(sewersMap.stairsOutPortal)

		sewersMap.stairsOutPortal2:linkToPortal(restMap.sewerPortal)
		restMap.sewerPortal:linkToPortal(sewersMap.stairsOutPortal2)

		restMap.doorPortal:linkToPortal(cityMap.restPlacePortal)
		cityMap.restPlacePortal:linkToPortal(restMap.doorPortal)

		
		-- Spawn the player
		playerController = PlayerController()

		-- elwood = jailMap:spawn(Elwood, 36, 17)
		jake = cityMap:spawn(Jake, 111, 119)
		elwood = jailMap:spawn(Elwood, 36, 17)
		brian = cellsMap:spawn(Brian,  37, 14)

--		jake = sewersMap:spawn(Jake, 95, 37)
--		brian = cityMap:spawn(Brian, 93, 73)
--		brian = jailMap:spawn(Brian,  25, 37)
		elwood.dir = DIR_UP
		jake.dir = DIR_UP
		brian.dir = DIR_DOWN

		-- Call superfunction
		Game.init(self)

		gameCameraTarget = CameraTarget() -- GLOBAL!?
		self.playerSwitcher = PlayerSwitcher(playerController, gameCameraTarget)
		playerSwitcher = self.playerSwitcher -- Can't do without this global var for the moment
		self.viewPort.target = gameCameraTarget

		self.playerSwitcher:addPlayerHost(elwood)
		self.playerSwitcher:addPlayerHost(jake)
		--self.playerSwitcher:addPlayerHost(brian)

		-- Tell the HUD about the playerSwitcher
		self.hud:setPlayerSwitcher(self.playerSwitcher)


		-- Show startup screen
		show_main_menu = 1
		main_menu_bg = {
			bm = m_get_bitmap("bb_startup.bmp"),
			alpha = 0,
		}

		ActionController:addSequence{
			ActionExModeOn(),
			ActionPlaySong("data/music/3.ogg", 200),
			ActionTweenVariable(main_menu_bg, "alpha", 200, 255),
			ActionPlaySample("bbsfx_hit1.wav"),
			ActionCallFunction(self.interactionMaster.addInteraction, self.interactionMaster, self.playerSwitcher),
			ActionCallFunction(self.interactionMaster.addInteraction, self.interactionMaster, SnowyWeather(cityMap)),
		}
	end;

	event_render = function(self)
		local width, height = m_screen_size()

		if (show_main_menu) then
			self.canvas:setCursor(0,0)
			self.canvas:setAlpha(main_menu_bg.alpha)
			self.canvas:drawIcon(main_menu_bg.bm)
		end

		-- Set HUD to invisible while main menu is shown
		self.playerSwitcher.bVisible = not show_main_menu

		Game.event_render(self)
	end;

	defaultproperties = {
		playerClass = nil,
		mainMenuClass = MainMenu,
		ingameMenuClass = IngameMenu,
		conversationWindowClass = BBRpgConversationWindow,
		guiThemeClass = BBRpgGuiTheme,
		hudClass = BBRpgHud,
	};
}
