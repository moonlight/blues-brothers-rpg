-- A menu to choose your language

LanguageMenu = GuiMenu:subclass
{
	name = "LanguageMenu";

	init = function(self)
		GuiMenu.init(self)

		self:addMenuItem(GuiMenuItem(BBRpgLang.defaultproperties.languageName, function()
			lang = BBRpgLang()
			self.master:addInteraction(MainMenu())
			self.master:removeInteraction(self)
		end))
		self:addMenuItem(GuiMenuItem(BBRpgLangDutch.defaultproperties.languageName, function()
			lang = BBRpgLangDutch()
			self.master:addInteraction(MainMenu())
			self.master:removeInteraction(self)
		end))
	end;


	keyType = function(self, key)
		if (GuiMenu.keyType(self, key)) then return true end

		if (key == "esc") then
			-- Return without switching language
			self.master:addInteraction(MainMenu())
			self.master:removeInteraction(self)
			return true
		end
	end;

	defaultproperties = {
	};
}