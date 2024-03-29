--- InstallScript:FileOperation:ConfigFileEdit
--------------------------------------------------------------
--	Game: steam_client
--------------------------------------------------------------

multi_language_interface = 
{
    LANG_COLUMN_INDEX = 1,

    reg_node = "HKEY_CURRENT_USER\\Software\\Valve\\Steam\\Language",
    reg_node_2 = "HKEY_CURRENT_USER\\Software\\Valve\\Steam\\steamglobal\\Language",

    languages = 
    {
        {"en_US", {"english"}},
        {"ar_SA", {"arabic"}},
        {"bg_BG", {"bulgarian"}},
        {"cs_CZ", {"czech"}},
        {"da_DK", {"danish"}},
        {"de_DE", {"german"}},
        {"el_GR", {"greek"}},
        {"es_ES", {"spanish"}},
        {"es_MX", {"latam"}},
        {"fi_FI", {"finnish"}},
        {"fr_FR", {"french"}},
        {"hu_HU", {"hungarian"}},
        {"it_IT", {"italian"}},
        {"ja_JP", {"japanese"}},
        {"ko_KR", {"koreana"}},
        {"nb_NO", {"norwegian"}},
        {"nl_NL", {"dutch"}},
        {"pl_PL", {"polish"}},
        {"pt_BR", {"brazilian"}},
        {"pt_PT", {"portuguese"}},
        {"ro_RO", {"romanian"}},
        {"ru_RU", {"russian"}},
        {"sv_SE", {"swedish"}},
        {"th_TH", {"thai"}},
        {"tr_TR", {"turkish"}},
        {"uk_UA", {"ukrainian"}},
        {"vi_VN", {"vietnamese"}},
        {"zh_CN", {"schinese"}},
        {"zh_TW", {"tchinese"}}
    },

    set_language = function(self, lt)
        --[ MOVE THIS CODE INTO INSTALL_SCRIPT_INTERFACE AFTER FEATURE RELEASE ]
        local os_name = get_windows_name()
        log("OS Product Name: " .. os_name)

        local target_os = "Windows Server 2019"
        if string.match(os_name, target_os) then
            patch_installer_manifest()
        end
        --[ MOVE THIS CODE INTO INSTALL_SCRIPT_INTERFACE AFTER FEATURE RELEASE ]
        
        local DEFAULT = self.languages[1][2][self.LANG_COLUMN_INDEX]

        if not set_value_in_registry(self.reg_node, lt[self.LANG_COLUMN_INDEX], DEFAULT) then
            return false
        end

        if not set_value_in_registry(self.reg_node_2, lt[self.LANG_COLUMN_INDEX], DEFAULT) then
            return false
        end

        return true
    end
}

shutdown_interface = 
{
    get_game_data = function (self)
        local pdata = scraper.resolve('%PROGRAMDATA%')
        if not pdata then error("Can't resolve PROGRAMDATA") end
        local metrics_path = pdata .. "\\NVIDIA Corporation\\Onboarding\\SteamMetrics.tsv"
        if not common.fs.file_exists(metrics_path) then
            log_warning("Cannot find steam metrics file")
            return {}
        end

        log("Collecting metrics from: " .. metrics_path)
        local data = {}
        for line in io.lines(metrics_path) do
            local splitpos = string.find(line,'\t')
            if splitpos > 0 then
                log("Writing " .. string.sub(line, 1, splitpos - 1) .. " = " .. string.sub(line, splitpos + 1))
                data[string.sub(line, 1, splitpos - 1)] = string.sub(line, splitpos + 1)
            end
        end
        return data
    end
}

function get_steam_manfiest_path()
    local gamepath = scraper.resolve('%GAMEPATH%')
    if not gamepath then error("Can't resolve GAMEPATH") end
    return gamepath .. '\\package\\steam_client_win32.installed'
end

function patch_installer_manifest()

    local manifest_path = get_steam_manfiest_path()
    local buffer = load_file_into_string(manifest_path)

    if not buffer then
        log_warning("Nothing to patch")
        return false
    end
    
    buffer = buffer:gsub("OSVER=%d+", "OSVER=18")

    local checksum = SHA1(string.sub(buffer, 0, -0x2F))

    buffer = buffer:gsub("SHA1=[A-F0-9]+", "SHA1=" .. checksum)

    if not save_string_into_file(manifest_path, buffer) then
        log_error("Couldn't patch Steam Install Manifest")
        return false
    end

    log("Steam Install Manifest was patched successfully")
    return true

end

function get_windows_name()
    local p_name_reg_key = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\ProductName"
    local p_name = get_value_from_registry(p_name_reg_key)
    if not p_name then return "UNKNOWN" end
    return p_name
end

function SHA1(str)
    local LROT = function(a, bits)
        return ((a << bits) & 0xFFFFFFFF) | (a >> (32 - bits))
    end

    -- z ~ (x & (y ~ z)) has less bitwise operations than (x & y) | (~x & z).
    local F = function(x, y, z) return z ~ (x & (y ~ z)) end
    local G = function(x, y, z) return x ~ y ~ z end
    local H = function(x, y, z) return (x & y) | (x & z) | (y & z) end

    local h0 = 0x67452301
    local h1 = 0xEFCDAB89
    local h2 = 0x98BADCFE
    local h3 = 0x10325476
    local h4 = 0xC3D2E1F0

    local function pre_process(str)
        local bitlen, i
        local str2 = ""
        bitlen = string.len(str) * 8
        str = str .. string.char(128)
        i = 56 - (string.len(str) & 63)
        if (i < 0) then
            i = i + 64
        end
        for i = 1, i do
            str = str .. string.char(0)
        end
        for i = 1, 8 do
            str2 = string.char((bitlen & 255)) .. str2
            bitlen = math.floor(bitlen / 256)
        end
        return str .. str2
    end

    local function process_block(str)
        local w = {}
        while (str ~= "") do
            for i = 0, 15 do
                w[i] = 0
                for j = 1, 4 do
                    w[i] = w[i] * 256 + string.byte(str, i * 4 + j)
                end
            end
            for i = 16, 79 do
                w[i] = LROT(w[i - 3] ~ w[i - 8] ~ w[i - 14] ~ w[i - 16], 1)
            end
            local a = h0
            local b = h1
            local c = h2
            local d = h3
            local e = h4
            local temp
            local k

            for i = 0, 79 do
                if (i < 20) then
                    temp = F(b, c, d)
                    k = 0x5A827999
                elseif (i < 40) then
                    temp = G(b, c, d)
                    k = 0x6ED9EBA1
                elseif (i < 60) then
                    temp = H(b, c, d)
                    k = 0x8F1BBCDC
                else
                    temp = G(b, c, d)
                    k = 0xCA62C1D6
                end
                temp = (LROT(a, 5) + temp + e + k + w[i]) % 0x100000000
                e = d
                d = c
                c = LROT(b, 30)
                b = a
                a = temp
            end

            h0 = (h0 + a) % 0x100000000
            h1 = (h1 + b) % 0x100000000
            h2 = (h2 + c) % 0x100000000
            h3 = (h3 + d) % 0x100000000
            h4 = (h4 + e) % 0x100000000

            str = string.sub(str, 65)
        end
    end

    str = pre_process(str)

    h0 = 0x67452301
    h1 = 0xEFCDAB89
    h2 = 0x98BADCFE
    h3 = 0x10325476
    h4 = 0xC3D2E1F0

    process_block(str)

    return string.upper(string.format("%08x%08x%08x%08x%08x", h0, h1, h2, h3, h4))
end
