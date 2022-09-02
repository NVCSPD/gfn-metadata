multi_language_interface = 
{	
	LANG_COLUMN_INDEX_TEXT = 1,
	LANG_COLUMN_INDEX_AUDIO = 2,
	node = "HKEY_CURRENT_USER\\Software\\miHoYo\\Genshin Impact\\GENERAL_DATA_h2389025596",
	T_LANGUAGE = '"deviceLanguageType":(%d+)',
	V_LANGUAGE = '"deviceVoiceLanguageType":(%d)',
	languages = 
	{
		{"en_US", {'1','1'}},
		{"fr_FR", {'4','1'}},
		{"de_DE", {'5','1'}},
		{"es_ES", {'6','1'}},
		{"ja_JP", {'9','2'}},
		{"ko_KR", {'10','3'}},
		{"pt_PT", {'7','1'}},
		{"ru_RU", {'8','1'}},
		{"zh_CN", {'2','0'}},
		{"zh_TW", {'3','0'}},
		{"th_TH", {'11','1'}}
	},
	get_config = function()
		local node = "HKEY_CURRENT_USER\\Software\\miHoYo\\Genshin Impact\\GENERAL_DATA_h2389025596"
		local config = get_value_from_registry(node)
		if not config then error("Can't get config") end
		return config
	end,
	
	set_value_in_str = function(str, pattern, value, default)
		local _, _, curlang = string.find(str, pattern)
		if not curlang then 
			log_error("Can't read value from file! set_value_in_cfg() failed")
		return false
		else
			log("Value in config: " .. curlang)
		r = string.gsub(str, pattern, value)
		end
		return r
	end,
	
	set_language = function (self, lt)
		local default = self.get_config()
		local DEFAULT_T_LANGUAGE = self.languages[1][2][self.LANG_COLUMN_INDEX_TEXT]
		local DEFAULT_A_LANGUAGE = self.languages[1][2][self.LANG_COLUMN_INDEX_AUDIO]
		log("Setting text language")
		config_text = self.set_value_in_str(default, self.T_LANGUAGE, '"deviceLanguageType":' .. lt[self.LANG_COLUMN_INDEX_TEXT], '"deviceLanguageType":' .. DEFAULT_T_LANGUAGE)
		log("Setting Audio language")
		config_final = self.set_value_in_str(config_text, self.V_LANGUAGE, '"deviceVoiceLanguageType":' .. lt[self.LANG_COLUMN_INDEX_AUDIO], '"deviceVoiceLanguageType":' .. DEFAULT_A_LANGUAGE)
		set = scraper.reg.write_binary(self.node, config_final)
		if set then 
			log("set_value_in_registry() has completed successfully!")
			return true
		else
			log_error("set_value_in_registry() failed!")
		return false
		end
		return true
	end
}