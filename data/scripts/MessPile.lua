
import("Decoration.lua")


MessPile = Decoration:subclass
{
	name = "MessPile";
	bPlaceable = true;
	defaultproperties = {
		offset_x = -6,
		offset_y = 6,
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
		if self.containsEngines then
			ActionController:addSequence{
				ActionSetVariable(obj, "bWalkieTalkie", true),
				ActionConversation(lang:getConv("FindMiniRocketEngines")),
				ActionSetVariable(obj, "bWalkieTalkie", false),
				ActionCallFunction(obj.addToInventory, obj, cityMap.engines),
				ActionSetVariable(self, "containsEngines", false),
				ActionWait(100),
				ActionFadeOutMap(100),
				ActionCallFunction(elwood.setMap, elwood, leesMap),
				ActionCallFunction(jake.setMap  ,   jake, leesMap),
				ActionCallFunction(brian.setMap ,  brian, leesMap),
				ActionSetPosition(brian, 30, 19, DIR_RIGHT),
				ActionSetPosition(jake, 31, 20, DIR_UP),
				ActionSetPosition(elwood, 32, 20, DIR_UP),
				ActionFadeInMap(100),
				ActionShowMapName(m_get_bitmap("leesplace.tga")),
				ActionConversation(lang:getConv("Ending1")),
				ActionCallFunction(obj.removeFromInventory, obj, cityMap.engines),
				ActionConversation(lang:getConv("Ending2")),
				ActionFadeOutMap(250),
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