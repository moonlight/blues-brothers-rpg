--
-- A general portal class, for transporting players from one map to another.
--

import("Actor.lua")

Portal = Actor:subclass
{
	name = "Portal";

	event_bumped_into = function(self, actor)
		if (not self.linkedPortal) then return end

		if (actor:instanceOf(Player)) then
			actor:walk(actor.dir, true)

			ActionController:addSequence{
				ActionExModeOn(),
				ActionParallel{
					ActionWalk(actor, actor.dir, 1, false),
					ActionFadeOutMap(100 / actor.speed),
				},
				ActionCallFunction(actor.setMap, actor, self.linkedPortal.myMap),
				ActionSetPosition(actor, self.linkedPortal.x, self.linkedPortal.y),
				ActionParallel{
					ActionFadeInMap(100 / actor.speed),
					ActionSequence{
						ActionCallFunction(actor.walk, actor, self.linkedPortal.outDir),
						ActionCallFunction(actor.walk, actor, self.linkedPortal.outDir, true),
					}
				},
				ActionShowMapName(self.linkedPortal.myMap.mapNameBitmap),
				ActionExModeOff(),
			}
		end
	end;

	setOutDir = function(self, outDir)
		self.outDir = outDir or self.outDir
	end;

	linkToPortal = function(self, portal)
		if (portal:instanceOf(Portal)) then
			self.linkedPortal = portal
		else
			error("Type error, expected object of type Portal.")
		end
	end;

	defaultproperties = {
		linkedPortal = nil,
		bitmap = m_get_bitmap("target.tga"),
		draw_mode = DM_ALPHA,
		w = 1,
		h = 1,
		obstacle = 1,
		outDir = DIR_NONE,
	};
}
