--- InstallScript:mklink 
install_script_interface =
{
    get_launcher_config_path = function()
        local local_appdata = scraper.resolve('%LOCALAPPDATA%')
        if not local_appdata then error("Can't resolve LOCALAPPDATA") end
        return local_appdata .. '\\EpicGamesLauncher\\Saved\\Config\\Windows\\GameUserSettings.ini'
    end,

    install = function(self, metadata_path)
        local config_path = self.get_launcher_config_path()
        if not common.fs.file_exists(config_path) then
            log_error('Cannot open file ' .. tostring(config_path) .. " for reading")
            return false
        end

        local t = {}
        local config_text = load_file_into_string(config_path)
        for key in string.gmatch(config_text, '[0-9a-z]+_General') do 
            t[key .. ';SystemTray'] = 'True' 
        end

        for k,v in pairs(t) do
            if not set_value_in_ini(config_path, k, v) then
                log_error("Failed to save LauncherConfig file with " .. k .. " = " .. v)
                return false
            end
        end

        if get_value_from_ini(config_path, "RememberMe;Enable") == "False" then
            if not set_value_in_ini(config_path, "RememberMe;Data", "") then
                log_error("Failed to drop RememberMe;Data value")
                return false
            end
        end
		
		WinSet = get_value_from_ini(config_path, "WindowSettings;MainLauncherWindow")
		WinSet = WinSet:gsub('(IsMaximised=")%a+"', '%1true"')
		if not set_value_in_ini(config_path, "WindowSettings;MainLauncherWindow", WinSet) then
			log_error("Failed to drop WindowSettings;MainLauncherWindow value")
			return false
		end
		
		if not set_value_in_ini(config_path, "Portal.RunningAppService;LastSeenShutdownDelay", 0, 0) then
			log_error("Failed to set Portal.RunningAppService;LastSeenShutdownDelay=0")
			return false
		end

        return true
    end
}

multi_language_interface =
{
	LANG_COLUMN_INDEX = 1,

	ini_param = 'Internationalization;Culture',

    languages =
    {
        {"en_US", {"en"}},
        {"fr_FR", {"fr"}},
        {"de_DE", {"de"}},
        {"es_MX", {"es-MX"}},
        {"es_ES", {"es-ES"}},
        {"ko_KR", {"ko"}},
        {"ja_JP", {"ja"}},
        {"zh_CN", {"zh-Hans"}},
        {"zh_TW", {"zh-Hant"}},
        {"it_IT", {"it"}},
        {"ru_RU", {"ru"}},
        {"ar_SA", {"ar"}},
        {"pt_BR", {"pt-BR"}},
        {"pl_PL", {"pl"}},
        {"tr_TR", {"tr"}},
        {"th_TH", {"th"}}
    },

	get_config_path = function()
		local appdata = scraper.resolve('%LOCALAPPDATA%')
		if not appdata then error("Can't resolve LOCALAPPDATA") end
		return appdata .. '\\EpicGamesLauncher\\Saved\\Config\\Windows\\GameUserSettings.ini'
	end,

	set_language = function (self, lt)
		local DEFAULT = self.languages[1][2][self.LANG_COLUMN_INDEX]
		if not set_value_in_ini(self.get_config_path(), self.ini_param, lt[self.LANG_COLUMN_INDEX], DEFAULT) then
			return false
		end

		return true
	end
}