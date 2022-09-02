--------------------------------------------------------------
--	Game: eve_online_gfn_pc
--------------------------------------------------------------

multi_language_interface = 
{
	LAUNCHER_INDEX = 1,
	GAME_INDEX = 2,
	
	REGISTRY_PATH = "HKEY_CURRENT_USER\\Software\\CCP\\EVE\\LauncherLanguage",
	FILE_PATH = "%LOCALAPPDATA%\\CCP\\EVE\\c_eve_sharedcache_tq_tranquility\\settings_Default\\prefs.ini",

	languages = 
	{
		{"en_US", {"en", "EN"}},
		{"fr_FR", {"fr", "FR"}}, 
		{"de_DE", {"de", "DE"}},   
		{"ru_RU", {"ru", "RU"}}, 
		{"ko_KR", {"ko", "KO"}},
		{"ja_JP", {"ja", "JA"}}
	},
	
	set_language = function (self, lt)
		local Lang = lt
		print(lt[self.GAME_INDEX])
		if (Lang == nil) then
			log_warning("Language not found, setting to default")
			Lang = self.languages[1][2]
		else
			log("Settings language to " .. Lang[self.GAME_INDEX])
		end
		if not scraper.reg.write_string(self.REGISTRY_PATH, Lang[self.LAUNCHER_INDEX]) then
			log_error("registry write fail to " .. self.REGISTRY_PATH)
			return false
		end
		local FilePath = scraper.resolve(self.FILE_PATH)
		if not FilePath then
			log_error("Cannot resolve user local APPDATA")
			return false
		end
		if not set_value_in_cfg(FilePath,"languageID=(%a+)","languageID="..Lang[self.GAME_INDEX],"EN") then
			log_error("Prefs.ini write fail to " .. FilePath)
			return false
		end
		return true
	end
}
