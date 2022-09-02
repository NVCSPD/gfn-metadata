
multi_language_interface = 
{	
	LANG_COLUMN_INDEX = 1,
	
	ini_param = '/Script/DeadByDaylight.DBDGameUserSettings;Language',
	
	languages = 
	{
		{"en_US", {"en"}},
  		{"fr_FR", {"fr"}},  
  		{"it_IT", {"it"}}, 
  		{"de_DE", {"de"}},  
		{"es_ES", {"es"}},
		{"es_MX", {"es"}},     
  		{"ru_RU", {"ru"}},
  		{"zh_CN", {"zh-Hans"}},
  		{"pt_BR", {"pt-BR"}},
  		{"th_TH", {"th"}},
  		{"zh_TW", {"zh-Hant"}},
  		{"ja_JP", {"ja"}},
  		{"ko_KR", {"ko"}},
  		{"pl_PL", {"pl"}}
	},

	get_config_path = function()
		local appdata = scraper.resolve('%LOCALAPPDATA%')
		if not appdata then error("Can't resolve LOCALAPPDATA") end
		return appdata .. '\\DeadByDaylight\\Saved\\Config\\WindowsNoEditor\\GameUserSettings.ini'
	end,

	set_language = function (self, lt)
		local DEFAULT = self.languages[1][2][self.LANG_COLUMN_INDEX]
		if not set_value_in_ini(self.get_config_path(), self.ini_param, lt[self.LANG_COLUMN_INDEX], DEFAULT) then 
			return false 
		end
		
		return true
	end
}