--
-- The forest map (for testing of Tiled maps)
--

import("Map.lua")

Forest = Map:subclass
{
    name = "Forest";

    init = function(self)
        Map.init(self, "forest.tmx")
    end;

    defaultproperties = {
    }
}
