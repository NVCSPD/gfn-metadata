--- InstallScript:Regedit

multi_language_interface = 
{
	INDEX_VOICEOVER = 1,
	INDEX_SUB = 2, 
	INDEX_ONSCREEN = 3,
	INDEX_LANG_SHORT = 4,
	INDEX_LANG_LONG = 5,
	GROUP_NAME = "/language",

	languages = 
	{
		{"en_US", {"en-us@1", "en-us@1", "en-us@1", "en-US", "English"}},
		{"es_ES", {"es-es@2", "es-es@2", "es-es@2", "es-ES", "Spanish"}},
		{"fr_FR", {"fr-fr@3", "fr-fr@3", "fr-fr@3", "fr-FR", "French"}},
		{"it_IT", {"it-it@4", "it-it@4", "it-it@4", "it-IT", "Italian"}},
		{"de_DE", {"de-de@5", "de-de@5", "de-de@5", "de-DE", "German"}},
		{"ko_KR", {"kr-kr@6", "kr-kr@7", "kr-kr@7", "ko-KR", "Korean"}},
		{"zh_CN", {"zh-cn@7", "zh-cn@8", "zh-cn@8", "zh-Hans", "Chinese Simplified"}},
		{"ru_RU", {"ru-ru@8", "ru-ru@9", "ru-ru@9", "ru-RU", "Russian"}},
		{"pt_BR", {"pt-br@9", "pt-br@10", "pt-br@10", "pt-BR", "Portuguese-brazilian"}},
		{"ja_JP", {"jp-jp@10", "jp-jp@11", "jp-jp@11", "ja-JP", "Japanese"}},
		{"pl_PL", {"pl-pl@0", "pl-pl@0", "pl-pl@0", "pl-PL", "Polish"}},
		{"es_MX", {"es-es@2", "es-mx@6", "es-mx@6", "es-MX", "Latin American Spanish (Mexico)"}},
		{"zh_TW", {nil, "zh-tw@12", "zh-tw@12", "zh-Hant", "Chinese Traditional (used in Taiwan)"}},
		{"ar_SA", {nil, "ar-ar@13", "ar-ar@13", "ar", "Arabic"}},
		{"cs_CZ", {nil, "cz-cz@14", "cz-cz@14", "cs-CZ", "Czech"}},
		{"hu_HU", {nil, "hu-hu@15", "hu-hu@15", "hu-HU", "Hungarian"}},
		{"tr_TR", {nil, "tr-tr@16", "tr-tr@16", "tr-TR", "Turkish"}},
		{"th_TH", {nil, "th-th@17", "th-th@17", "th-TH", "Thai"}}
	},

	split = function(pString, pPattern)
   		local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   		local fpat = "(.-)" .. pPattern
   		local last_end = 1
   		local s, e, cap = pString:find(fpat, 1)
   		while s do
      		if s ~= 1 or cap ~= "" then
     			table.insert(Table,cap)
      		end
      		last_end = e+1
      		s, e, cap = pString:find(fpat, last_end)
   		end
   		if last_end <= #pString then
      		cap = pString:sub(last_end)
      		table.insert(Table, cap)
   		end
   		return Table
	end,

	get_config_path = function(self)
        local appdatapath = scraper.resolve('%LOCALAPPDATA%')
	  	if not appdatapath then error("Can't resolve APPDATA") end
        local game_config = appdatapath .. '\\CD Projekt Red\\Cyberpunk 2077\\UserSettings.json'
	  	return game_config
	end,
	
	get_gog_config_path = function(self)
        local game_config = 'C:\\Program Files (x86)\\NVIDIA_Grid_Bundle\\cyberpunk_2077_gog_gfn_pc\\Cyberpunk 2077\\goggame-1423049311.info'
	  	return game_config
	end,	

	set_language = function(self, lt)

		local language_table_index = 0 

		local config_file = self.get_config_path()


		local param_table = split(tostring(lt[1]), '@')


		local DEFAULT_LANGUAGE_VOIVEOVER = self.languages[1][2][self.INDEX_VOICEOVER]
		local DEFAULT_LANGUAGE_SUB = self.languages[1][2][self.INDEX_SUB]
		local DEFAULT_LANGUAGE_ONSCREEN = self.languages[1][2][self.INDEX_ONSCREEN]
		local DEFAULT_LANGUAGE_SHORT = self.languages[1][2][self.INDEX_LANG_SHORT]
		local DEFAULT_LANGUAGE_LONG = self.languages[1][2][self.INDEX_LANG_LONG]

		--check if one of the lt parameters nill and setting default
		if lt[self.INDEX_VOICEOVER] == nil then
			lt[self.INDEX_VOICEOVER] = DEFAULT_LANGUAGE_VOIVEOVER
		end

		if lt[self.INDEX_SUB] == nil then
			lt[self.INDEX_SUB] = DEFAULT_LANGUAGE_SUB
		end

		if lt[self.INDEX_ONSCREEN] == nil then
			lt[self.INDEX_ONSCREEN] =DEFAULT_LANGUAGE_ONSCREEN
		end

		if lt[self.INDEX_LANG_SHORT] == nil then
			lt[self.INDEX_LANG_SHORT] =DEFAULT_LANGUAGE_SHORT
		end

		if lt[self.INDEX_LANG_LONG] == nil then
			lt[self.INDEX_LANG_LONG] =DEFAULT_LANGUAGE_LONG
		end

		local json_gog_str = load_file_into_string(self.get_gog_config_path())
		local json_gog_tab = document.json.decode(json_gog_str)

		json_gog_tab["language"] = lt[self.INDEX_LANG_LONG]
		json_gog_tab["languages"] = document.json.decode('["' .. lt[self.INDEX_LANG_SHORT] .. '"]')
		json_gog_str = document.json.pretty_print(json_gog_tab)
		save_string_into_file(self.get_gog_config_path(), json_gog_str)


		local json_str = load_file_into_string(config_file)
        local json_tab = document.json.decode(json_str)

        --determine language section index in json
        local n = table_length(json_tab["data"])
		for i = 1, n do
      		if json_tab["data"][i]["group_name"] == self.GROUP_NAME then
      			language_table_index = i
      		end
    	end
    	
    	--splitting language names 
    	voiceover_table = split(tostring(lt[1]),'@')
    	sub_table = split(tostring(lt[2]),'@')
    	onscreen_table = split(tostring(lt[3]),'@')

    	--set new values in json

    	json_tab["data"][language_table_index]["options"][1]["value"] = tostring(voiceover_table[1])
    	json_tab["data"][language_table_index]["options"][1]["index"] = tonumber(voiceover_table[2])
    	json_tab["data"][language_table_index]["options"][2]["value"] = tostring(sub_table[1])
    	json_tab["data"][language_table_index]["options"][2]["index"] = tonumber(sub_table[2])
    	json_tab["data"][language_table_index]["options"][3]["value"] = tostring(onscreen_table[1])
    	json_tab["data"][language_table_index]["options"][3]["index"] = tonumber(onscreen_table[2])

    	print(json_tab["data"][language_table_index]["options"][1]["value"])
    	print(json_tab["data"][language_table_index]["options"][1]["index"])

 		json_updated_str = document.json.encode(json_tab)
		save_string_into_file (config_file, json_updated_str)



		return true
	end
}

install_script_interface = 
{
    regkey_path = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Display\\EnablePerProcessSystemDPIForProcesses",
    regkey_value = "Cyberpunk2077.exe",

    install = function(self, metadata_path)
        if not scraper.reg.write_string(self.regkey_path, self.regkey_value) then
            return false
        end
        return true
    end
}
