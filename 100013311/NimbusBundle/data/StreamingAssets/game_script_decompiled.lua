--- InstallScript:Regedit

multi_language_interface = 
{
	LANG_COLUMN_INDEX = 1,

	ini_param = 'Internationalization;Culture',

	languages = 
	{
		{"en_US", {"en"}},
		{"es_ES", {"es"}},
		{"es_MX", {"es-419"}},
		{"fr_FR", {"fr"}},  
		{"it_IT", {"it"}}, 
		{"ja_JP", {"ja"}},
		{"ko_KR", {"ko"}},
		{"pl_PL", {"pl"}},
		{"pt_BR", {"pt-BR"}},
		{"ru_RU", {"ru"}},
		{"tr_TR", {"tr"}},
		{"ar_SA", {"ar"}},
		{"de_DE", {"de"}}
	},

	get_config_path = function()
		local appdata = scraper.resolve('%LOCALAPPDATA%')
		if not appdata then error("Can't resolve LOCALAPPDATA") end
		return appdata .. '\\FortniteGame\\Saved\\Config\\WindowsClient\\GameUserSettings.ini'
	end,

	set_language = function (self, lt)
		local DEFAULT = self.languages[1][2][self.LANG_COLUMN_INDEX]
		if not set_value_in_ini(self.get_config_path(), self.ini_param, lt[self.LANG_COLUMN_INDEX], DEFAULT) then 
			return false 
		end

		return true
	end
}

shutdown_interface = 
{

    get_log_path = function()
        local appdata = scraper.resolve('%LOCALAPPDATA%')
        if not appdata then error("Can't resolve LOCALAPPDATA") end
        return appdata .. "\\FortniteGame\\Saved\\Logs\\FortniteGame.log"
    end,

    -- #8(I)[2020-03-11 21:50:42,754]=22:50:42={3364}<VideoStreamer>    Server sent the first video frame to client for stream:0
    get_first_frame_timestamp = function()
        local pdata = scraper.resolve('%PROGRAMDATA%')
        if not pdata then error("Can't resolve PROGRAMDATA") end
        local gs_log_path = pdata .. "\\NVIDIA Corporation\\NvStream\\NvStreamerCurrent.log"
        if not common.fs.file_exists(gs_log_path) then
            log_error("File not found: ".. gs_log_path)
            return 0
        end
        for line in io.lines (gs_log_path) do
            if string.match(line, "Server sent the first video frame to client for stream:0") then
                local Y,M,D,h,m,s = string.match(line, "%[(%d+)-(%d+)-(%d+) (%d+)%:(%d+):(%d+),%d+%]")
                local t = {
                    ["year"] = tonumber(Y),
                    ["month"] = tonumber(M),
                    ["day"] = tonumber(D),
                    ["hour"] = tonumber(h),
                    ["min"] = tonumber(m),
                    ["sec"] = tonumber(s),
                }
                return os.time(t)
            end
        end

        log_error("First video frame timestamp is missing")
        return 0
    end,

    -- [2020.02.07-13.17.18:170][  0]LogD3D11RHI: Creating new Direct3DDevice
    get_splash_screen_timestamp = function(fortnite_log_path)
        if fortnite_log_path == nil then
            return 0
        end
        for line in io.lines(fortnite_log_path) do
            if string.match(line, "Creating new Direct3DDevice") then
                local Y,M,D,h,m,s = string.match(line, "%[(%d+).(%d+).(%d+)-(%d+).(%d+).(%d+):%d+%]")
                local t = {
                    ["year"] = tonumber(Y),
                    ["month"] = tonumber(M),
                    ["day"] = tonumber(D),
                    ["hour"] = tonumber(h),
                    ["min"] = tonumber(m),
                    ["sec"] = tonumber(s),
                }
                return os.time(t)
            end
        end 

        log_error("Splash screen timestamp is missing")
        return 0
    end,

    -- [2020.04.01-07.30.56:879][596]LogOnlineParty: Verbose: MCP: SENDING ANALYTICS FOR TASK [UpdateParty] -> EVENT [PartyUpdated] 0.746714 seconds
    get_game_menu_timestamp = function(fortnite_log_path)
        if fortnite_log_path == nil then
            return 0
        end
        for line in io.lines(fortnite_log_path) do
            if string.match(line, "SENDING ANALYTICS FOR TASK") then
                local Y,M,D,h,m,s = string.match(line, "%[(%d+).(%d+).(%d+)-(%d+).(%d+).(%d+):%d+%]")
                local t = {
                    ["year"] = tonumber(Y),
                    ["month"] = tonumber(M),
                    ["day"] = tonumber(D),
                    ["hour"] = tonumber(h),
                    ["min"] = tonumber(m),
                    ["sec"] = tonumber(s),
                }
                return os.time(t)
            end
        end 

        log_error("Splash screen timestamp is missing")
        return 0
    end,

    get_hitchhunter_stats = function(fortnite_log_path)
        if fortnite_log_path == nil then
            return {}
        end

        local stats = {}
        local hitch_durations = {}
        local loading_screen = true

        for line in io.lines(fortnite_log_path) do
            -- [2022.06.01-18.14.52:759][979]LogFortLoadingScreen: Showing loading screen when 'IsShowingInitialLoadingScreen()' is false.
            if string.match(line, "LogFortLoadingScreen: Showing loading screen") then
                loading_screen = true
            -- [2022.06.01-18.04.09:927][762]LogFortLoadingScreen: LoadingScreen was visible for 14.51s
            elseif string.match(line, "LogFortLoadingScreen: LoadingScreen was visible") then
                loading_screen = false
            end
            -- [2020.04.11-06.54.05:574][921]LogFortHitches: HITCHHUNTER: Hitch in GameThread of 65.8 ms has been detected this frame. Number of Draw Calls this Frame: 1254
            if (loading_screen == false) then
            if string.match(line, "HITCHHUNTER") then
                local thread,ms = string.match(line, ".+Hitch in (%a+) of (%d+)")
                ms = tonumber(ms)
                hitch_durations[#hitch_durations+1] = ms
                if stats["HITCHHUNTER_" .. thread .. "_Count"] == nil then
                   stats["HITCHHUNTER_" .. thread .. "_Count"] = 0
                   stats["HITCHHUNTER_" .. thread .. "_Sum_ms"] = 0
                   stats["HITCHHUNTER_" .. thread .. "_Max_ms"] = 0
                end
                stats["HITCHHUNTER_" .. thread .. "_Count"] = stats["HITCHHUNTER_" .. thread .. "_Count"] + 1
                if stats["HITCHHUNTER_" .. thread .. "_Max_ms"] < ms then
                    stats["HITCHHUNTER_" .. thread .. "_Max_ms"] = ms
                end
                stats["HITCHHUNTER_" .. thread .. "_Sum_ms"] = stats["HITCHHUNTER_" .. thread .. "_Sum_ms"] + ms
                stats["HITCHHUNTER_" .. thread .. "_Avg_ms"] = math.floor(stats["HITCHHUNTER_" .. thread .. "_Sum_ms"]/stats["HITCHHUNTER_" .. thread .. "_Count"]+0.5)
            end
        end
        end

        if #hitch_durations > 0 then
            table.sort(hitch_durations)
            stats["HITCHHUNTER_Hitch_95ptile_ms"] = hitch_durations[math.floor(#hitch_durations*0.95)]
        end

        return stats

    end,

    -- [2021.08.28-23.12.18:217][808]LogNet: NetworkFailure: FailureReceived, Error: 'Outgoing reliable buffer overflow'
    get_network_error_stats = function(fortnite_log_path)
        local stats = {}

        for line in io.lines(fortnite_log_path) do
            if string.match(line, " NetworkFailure:") then
                local error = string.match(line, ".+ NetworkFailure: (%w+)")
                local stat_name = "FNNetworkFailure_" .. error .. "_Count"
                local cnt = stats[stat_name]
                if cnt == nil then
                    stats[stat_name] = 1
                else
                    stats[stat_name] = cnt + 1
                end
            end
        end
        return stats
    end,

    get_game_data = function (self)
        local data = {}

        local fortnite_log_path = self.get_log_path()
        if not common.fs.file_exists(fortnite_log_path) then
            log_error("File not found: ".. fortnite_log_path)
            fortnite_log_path = nil
        end

        data = self.get_hitchhunter_stats(fortnite_log_path)

        for k,v in pairs(data) do
            data[k]=tostring(v)
        end

        local network_stats = self.get_network_error_stats(fortnite_log_path)
        for k,v in pairs(network_stats) do
            data[k]=tostring(v)
        end

        local first_frame_timestamp = self.get_first_frame_timestamp()
        local splash_screen_timestamp = self.get_splash_screen_timestamp(fortnite_log_path)
        local game_menu_timestamp = self.get_game_menu_timestamp(fortnite_log_path)

        data["T5_PlatformLogon"] = "0"

        if first_frame_timestamp > 0 and splash_screen_timestamp > 0 then
            data["T6_GamePixel"] = tostring((splash_screen_timestamp - first_frame_timestamp)*1000)
        end

        data["T7_FullScreen"] = "0"

        if game_menu_timestamp > 0 and splash_screen_timestamp > 0 then
            data["T8_GameMenu"] = tostring((game_menu_timestamp - splash_screen_timestamp)*1000)
        end

        return data
    end
}
