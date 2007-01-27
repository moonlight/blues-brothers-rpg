
import("Decoration.lua")


MessPile = Decoration:subclass
{
	name = "MessPile";
	bPlaceable = true;
	defaultproperties = {
		offset_x = -6,
		offset_y = 4,
		w = 2,
		h = 2,
		obstacle = 1,
		draw_mode = DM_ALPHA,
		bCenterBitmap = false,
		bCenterOnTile = false,
		bitmap = m_get_bitmap("mess_pile.tga"),
		convTableKeyword = "MessPile",
	}
}

MessPile2 = Decoration:subclass
{
	name = "MessPile2";
	bPlaceable = true;
	activatedBy = function(self, obj)
		if (self.containsEngines) then
			if (#obj.inventory >= 3) then
				ActionController:addSequence{
					ActionConversation(lang:getConv("InventoryFullAtRockets")),
				}
				return
			end

			ActionController:addSequence{
				ActionExModeOn(),
				ActionSetVariable(obj, "bWalkieTalkie", true),
				ActionConversation(lang:getConv("FindMiniRocketEngines")),
				ActionSetVariable(obj, "bWalkieTalkie", false),
				ActionCallFunction(obj.addToInventory, obj, cityMap.engines),
				ActionSetVariable(self, "containsEngines", false),
				ActionWait(100),
				ActionFadeOutMap(100),
				ActionSetPosition(brian, 30, 19, DIR_RIGHT, leesMap),
				ActionSetPosition(jake, 31, 20, DIR_UP, leesMap),
				ActionSetPosition(elwood, 32, 20, DIR_UP, leesMap),
				ActionCallFunction(jake.setSleeping, jake, false),
				ActionCallFunction(elwood.setSleeping, elwood, false),
				ActionCallFunction(brian.setSleeping, brian, false),
				ActionFadeInMap(100),
				ActionShowMapName(m_get_bitmap("leesplace.tga")),
				ActionWait(250),
				ActionConversation(lang:getConv("Ending1")),
				ActionCallFunction(obj.removeFromInventory, obj, cityMap.engines),
				ActionConversation(lang:getConv("Ending2")),
				ActionWait(100),
				ActionFadeOutMusic(200),
				ActionFadeOutMap(200),
				ActionSetVariable(_G, "show_main_menu", true),
				ActionSetVariable(main_menu_bg, "drawMode", DM_ALPHA),
				ActionSetVariable(main_menu_bg, "bm", m_get_bitmap("theend.tga")),
				ActionPlaySong("data/music/enddemo.ogg", 10),
			}
		else
			ActionController:addSequence{
				ActionConversation(lang:getConv("MessPileNoEngines")),
			}
		end
	end;

	defaultproperties = {
		bCanActivate = true,
		containsEngines = true,
		offset_x = -6,
		offset_y = 6,
		w = 2,
		h = 2,
		obstacle = 1,
		draw_mode = DM_ALPHA,
		bCenterBitmap = false,
		bCenterOnTile = false,
		bitmap = m_get_bitmap("mess_pile.tga"),
	}
}
