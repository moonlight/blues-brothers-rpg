--
-- Het hoofdmenu
-- By Bjørn Lindeijer

import("GuiMenu.lua")

MainMenu = GuiMenu:subclass
{
	name = "MainMenu";

	init = function(self)
		GuiMenu.init(self)

		local oldspeed = elwood.speed
		local dummy = cityMap:spawn(Dummy, 113.5, 109.5)
		
		local startSequence = {
			ActionFadeOutMap(50),
			ActionSetVariable(_G, "show_main_menu", nil),
			ActionCallFunction(elwood.setMap, elwood, sewersMap),
			ActionSetPosition(elwood, 57, 22, DIR_DOWN),
			ActionSetPosition(jake, 95, 37, DIR_DOWN),
			ActionFadeInMap(50),
			ActionExModeOff(),
		}

--[[		local startSequence = {
			ActionFadeOutMap(50),
			ActionSetVariable(_G, "show_main_menu", nil),
			ActionFadeInMap(100),
			--ActionConversation(lang:getConv("Intro1")),
			ActionWalkPath(guard, "DLD"),
			ActionSetVariable(elwood, "dir", DIR_DOWN),
			ActionWait(25),
			ActionSetVariable(guard, "dir", DIR_UP),
			--ActionConversation(lang:getConv("Intro2")),
			ActionWalkPath(guard, "D2"),
			ActionCallFunction(door1.event_bumped_into, door1),
			ActionWait(door1.period * 100),
			ActionWalkPath(elwood, "D"),			
			ActionAddSequence{
				ActionSetVariable(elwood, "speed", guard.speed),
				ActionWalkPath(elwood, "D6R9D13L19D14R9"),
				ActionSetVariable(elwood, "speed", oldspeed),
			},
			ActionWalkPath(guard,"D3R9D13L19D14R11"),
			ActionSetVariable(guard, "dir", DIR_LEFT),
			ActionWait(50),
			--ActionConversation(lang:getConv("Intro3")),
			ActionWalkPath(elwood, "D5"),
			ActionAddSequence{
				ActionFadeOutMap(50),
			},
			ActionWalkPath(elwood, "D3"),
			ActionCallFunction(elwood.setMap, elwood, cityMap),
			ActionSetPosition(elwood, 113, 107, DIR_DOWN),
			ActionAddSequence{
				ActionFadeInMap(50),
			},
			ActionWalkPath(elwood, "D3"),
			--ActionConversation(lang:getConv("Intro4")),
			ActionSetCameraTarget(dummy, false),
			ActionTweenVariable(dummy, "y", 200, 114.5),
			ActionWait(50),
			ActionWalkPath(elwood, "D5"),
			ActionSetCameraTarget(elwood, false),
			ActionWalkPath(elwood, "D3"),
			ActionSetVariable(jake, "dir", DIR_RIGHT),
			ActionWalkPath(elwood, "D"),
			ActionSetVariable(elwood, "dir", DIR_LEFT),
			--ActionConversation(lang:getConv("Intro5")),
			ActionAddSequence{
				ActionWalkPath(elwood, "D5L5"),
				ActionSetVariable(elwood, "dir", DIR_RIGHT),
				ActionWait(15),
				ActionSetPosition(dummy, 108.5, 123),
				ActionSetCameraTarget(dummy, false),				
				ActionSetPosition(elwood, 113, 108, DIR_DOWN),
			},
			ActionWalkPath(jake, "D3L3"),
			ActionSetVariable(jake, "dir", DIR_RIGHT),
			ActionWait(15),
			ActionSetPosition(jake, 114, 108, DIR_DOWN),
			ActionWait(180),
			--ActionConversation(lang:getConv("Intro6")),
			ActionTweenVariable(copcar, "x", 250, 118, function(from, to, perc)
				perc = 1 - math.sin(perc * 0.5 * math.pi + 0.5 * math.pi)
				return from + (to - from) * perc
			end),
			ActionFadeOutMap(50),
			ActionSetPosition(dummy, 90.5, 75.5),
			ActionFadeInMap(50),
			ActionSetPosition(copcar, 76, 77),
			ActionTweenVariable(copcar, "x", 250, 88, function(from, to, perc)
				perc = math.sin(perc * 0.5 * math.pi)
				return from + (to - from) * perc
			end),
			ActionWait(50),

			ActionSetPosition(elwood, 90, 78, DIR_DOWN),			
			ActionWait(10),
			ActionSetPosition(elwood, 90, 78, DIR_RIGHT),
			ActionWait(30),
			ActionSetPosition(jake, 90, 76, DIR_UP),
			ActionWait(10),
			ActionSetPosition(jake, 90, 76, DIR_RIGHT),
			ActionConversation(lang:getConv("Intro7")),
			ActionSetCameraTarget(jake, false),
			ActionParallel{
				ActionSequence{
					ActionWait(30),
					ActionWalkPath(jake, "R3U3"),
				},
				ActionWalkPath(elwood, "R4U5"),
			},
			ActionWait(150),
			ActionSetVariable(jake, "dir", DIR_RIGHT),
			ActionWait(30),
			ActionSetVariable(elwood, "dir", DIR_LEFT),
			ActionConversation(lang:getConv("WhereKeys")),
			ActionSetPosition(dummy, 93.5, 72.5),
			ActionSetCameraTarget(dummy, false),
			ActionTweenVariable(dummy, "x", 50, 94.5),
			ActionSetCameraTarget(elwood, false),
			ActionExModeOff(),
		}
]]
		self:addMenuItem(GuiMenuItem(lang:getVar("PLAY"),    function() self.master:removeInteraction(self); ActionController:addSequence(startSequence); end))
		self:addMenuItem(GuiMenuItem(lang:getVar("CREDITS"), function() self.master:removeInteraction(self); m_quit_game() end))
		self:addMenuItem(GuiMenuItem(lang:getVar("QUIT"),    function() self.master:removeInteraction(self); m_quit_game() end))
	end;

	keyType = function(self, key)
		if (GuiMenu.keyType(self, key)) then return true end

		if (key == "esc") then
			-- Capture escape to prevent closing the menu
			return true
		end
	end;

	defaultproperties = {
	};
}
