
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
				ActionConversation(lang:getConv("FindMiniRocketEngines")),
				ActionCallFunction(obj.addToInventory, self.engines, self),
				ActionSetVariable(self, "containsEngines", false),
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