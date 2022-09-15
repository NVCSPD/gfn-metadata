
multi_language_interface = 
{	
    LT_CODE_INDEX = 1,

	LANG_PATTERN = 'language:%s+code:%s+([a-zA-Z-]+)',
    
    languages = 
    {
        {"en_US", {"en-US"}},
        {"ar_SA", {"ar-SA"}},
        {"cs_CZ", {"cs-CZ"}},
        {"da_DK", {"da-DK"}},
        {"de_DE", {"de-DE"}},
        {"en_CA", {"en-CA"}},
        {"es_ES", {"es-ES"}},
        {"es_MX", {"es-MX"}},
        {"fi_FI", {"fi-FI"}},
        {"fr_FR", {"fr-FR"}},
        {"hu_HU", {"hu-HU"}},
        {"it_IT", {"it-IT"}},
        {"ja_JP", {"ja-JP"}},
        {"ko_KR", {"ko-KO"}},
        {"nb_NO", {"nb-NO"}},
        {"nl_NL", {"nl-NL"}},
        {"pl_PL", {"pl-PL"}},
        {"pt_BR", {"pt-BR"}},
        {"pt_PT", {"pt-PT"}},
        {"ru_RU", {"ru-RU"}},
        {"sv_SE", {"sv-SE"}},
        {"tr_TR", {"tr-TR"}},
        {"zh_CN", {"zh-CN"}},
        {"zh_TW", {"zh-TW"}}
    },
    
    get_config_path = function()
        local appdata = scraper.resolve('%LOCALAPPDATA%\\Ubisoft Game Launcher\\settings.yaml')
        if not appdata then error("Can't resolve LOCALAPPDATA") end
        return appdata
    end,

    set_language = function(self, lt)
        local DEFAULT_CODE = 'language:\n  code: ' .. self.languages[1][2][self.LT_CODE_INDEX]
        local value = 'language:\n  code: ' .. lt[self.LT_CODE_INDEX]
        if not set_value_in_cfg(self.get_config_path(), self.LANG_PATTERN, value, DEFAULT_CODE) then
            return false 
        end
        return true
    end
}
