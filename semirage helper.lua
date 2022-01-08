-- hitsounds folder steamapps\common\Counter-Strike Global Offensive\csgo\sound\ivi_hitsounds
menu.add_slider_float("ivi: the semi-rage helper | ver.", 1.35, 1.35)
-- rage
menu.add_slider_int("Rage features", 0, 0)
menu.add_check_box("Rage on key")
menu.add_key_bind("Ragebot")
menu.add_check_box("Autowall on key")
menu.add_key_bind("Autowall")
-- antiaim
menu.add_slider_int("Anti-aim features", 0, 0)
menu.add_check_box("Legit aa")
menu.add_combo_box("Fakelag", {"Blocked", "Enabled: 6", "Randomized"})
menu.add_combo_box("Legs movement", {"Normal", "Slide", "Randomized"})
-- visuals
menu.add_slider_int("Visuals features", 0, 0)
menu.add_check_box("Indicators")
-- misc
menu.add_slider_int("Misc features", 0, 0)
menu.add_check_box("Hell ragdoll gravity")
menu.add_check_box("Disable resolver")
menu.add_check_box("Enable custom logs")
menu.add_check_box("Clantag")
menu.add_check_box("Kill Say")
menu.add_check_box("Hitsound")

-- FFI
local ffi = require "ffi"
ffi.cdef[[
    typedef void *PVOID;
    typedef PVOID HANDLE;
    typedef unsigned long DWORD;
    typedef bool BOOL;
    typedef unsigned long ULONG_PTR;
    typedef long LONG;
    typedef char CHAR;
    typedef unsigned char BYTE;
    typedef unsigned int SIZE_T;
    typedef const void *LPCVOID;
    typedef int *FARPROC;
    typedef int(__fastcall* clantag_t)(const char*, const char*);
    typedef const char *LPCSTR;
  
    BOOL CreateDirectoryA(LPCSTR lpPathName, PVOID lpSecurityAttributes);
    BOOL DeleteUrlCacheEntryA(LPCSTR lpszUrlName);
  
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
]]

local csgo_sounds_path = './csgo/sound/'
local sounds_path = 'ivi_hitsounds'

ffi.C.CreateDirectoryA(csgo_sounds_path, NULL)
ffi.C.CreateDirectoryA(csgo_sounds_path .. sounds_path, NULL)

local sounds = {
  {
    url = 'https://cdn.discordapp.com/attachments/851463683392929842/851486047053676554/ting.wav',
    title = '[SKEET] Ting',
    file = string.format('%s/ting.wav', sounds_path)
  },
  {
    url = 'https://cdn.discordapp.com/attachments/851463683392929842/851486047846269020/bell.wav',
    title = '[SKEET] Bell',
    file = string.format('%s/bell.wav', sounds_path)
  },
  {
    url = 'https://cdn.discordapp.com/attachments/851463683392929842/851486045236101180/msfrs.wav',
    title = '[ONETAP] Misfires',
    file = string.format('%s/msfrs.wav', sounds_path)
  },
  {
    url = 'https://cdn.discordapp.com/attachments/883648036230819922/929319684157870130/fatality.wav',
    title = '[FATALITY] Stappler',
    file = string.format('%s/fatality.wav', sounds_path)
  },
  {
    url = 'https://cdn.discordapp.com/attachments/883648036230819922/929319684346630174/neverlose.wav',
    title = '[NEVERLOSE] Hit',
    file = string.format('%s/neverlose.wav', sounds_path)
  },
  {
    url = 'https://cdn.discordapp.com/attachments/851463683392929842/851486049561870376/bubble.wav',
    title = '[OTHER] Bubble',
    file = string.format('%s/bubble.wav', sounds_path)
  },
  {
    url = 'https://cdn.discordapp.com/attachments/883648036230819922/929319684564742194/cod.wav',
    title = '[OTHER] Call of duty',
    file = string.format('%s/cod.wav', sounds_path)
  },
  {
    url = 'https://cdn.discordapp.com/attachments/883648036230819922/929319684778635264/custom.wav',
    title = '[OTHER] Gachimuchi',
    file = string.format('%s/custom.wav', sounds_path)
  },
}

local extlib = {
  urlmon = ffi.load 'UrlMon',
  wininet = ffi.load 'WinInet',
  gdi = ffi.load 'Gdi32',
}

local file_helpers = {
  download = function(from_url, to_path)
    extlib.wininet.DeleteUrlCacheEntryA(from_url);
    extlib.urlmon.URLDownloadToFileA(nil, from_url, to_path, 0, 0)
  end,
}

local combo = {}
local files = {}
for _, sound in pairs(sounds) do
  if sound.url then
    local file_path = string.format('%s/%s', csgo_sounds_path, sound.file)

    local file = io.open(file_path, 'r')
    table.insert(files, file)
    if file then
      file:close()
    else
      file_helpers.download(sound.url, file_path)
    end

    table.insert(combo, sound.title)
  end
end

local hitsound = 0.0
menu.add_combo_box('Hitsounds', combo)

client.add_callback('create_move', function()
  hitsound = menu.get_int('Hitsounds')
end)

client.add_callback('unload', function()
  for _, file in pairs(files) do
    file:close()
  end
end)

local font = render.create_font("Segoe UI", 33, 0, false, true, true)
local wpn2tab = {
    ['CDEagle'] = 0.0,
    ['Glock'] = 1.0,
    ['HKP2000'] = 1.0,
    ['P250'] = 1.0,
    ['Elite'] = 1.0,
    ['Tec9'] = 1.0,
    ['FiveSeven'] = 1.0,
    ['SCAR20'] = 2.0,
    ['G3SG1'] = 2.0,
    ['SSG08'] = 3.0,
    ['AWP'] = 4.0,
    ['CAK47'] = 5.0,
    ['M4A1'] = 5.0,
    ['SG556'] = 5.0,
    ['Aug'] = 5.0,
    ['GalilAR'] = 5.0,
    ['Famas'] = 5.0,
    ['MAC10'] = 6.0,
    ['UMP45'] = 6.0,
    ['MP7'] = 6.0,
    ['MP9'] = 6.0,
    ['P90'] = 6.0,
    ['Bizon'] = 6.0,
    ['NOVA'] = 7.0,
    ['XM1014'] = 7.0,
    ['Sawedoff'] = 7.0,
    ['Mag7'] = 7.0,
    ['M249'] = 8.0,
    ['Negev'] = 8.0,
  }

console.execute("clear")
client.log("ivi: the semirage helper v1.35")
client.log("coded by CouZ")

function keys()
    if menu.get_bool("Rage on key") then
        if menu.get_key_bind_state("Ragebot") then
            menu.set_bool("rage.enable", true)
        else
            menu.set_bool("rage.enable", false)
        end
    end

    if menu.get_bool("Autowall on key") then
        if menu.get_key_bind_state("Autowall") then
            menu.set_bool("rage.automatic_wall", true)
        else
            menu.set_bool("rage.automatic_wall", false)
        end
    end
end

local cachetbl = {
    use = false,
    ["anti_aim.enable"] = menu.get_bool("anti_aim.enable"),
    ["anti_aim.desync_type"] = menu.get_int("anti_aim.desync_type"),
    ["anti_aim.yaw_offset"] = menu.get_int("anti_aim.yaw_offset"),
    ["anti_aim.pitch"] = menu.get_int("anti_aim.pitch"),
    ["anti_aim.target_yaw"] = menu.get_int("anti_aim.target_yaw"),
    ["anti_aim.desync_type"] = menu.get_int("anti_aim.desync_type"),
    ["anti_aim.desync_range"] = menu.get_int("anti_aim.desync_range"),
    ["anti_aim.desync_range_inverted"] = menu.get_int("anti_aim.desync_range_inverted"),
}

function anti_aims_tab()
    if menu.get_bool("Legit aa") then
        menu.set_bool("anti_aim.enable", true)
        menu.set_int("anti_aim.pitch", 0)
        menu.set_int("anti_aim.target_yaw", 0)
        menu.set_int("anti_aim.yaw_offset", 180)
        menu.set_int("anti_aim.desync_type", 1)
        menu.set_int("anti_aim.desync_range", 60)
        menu.set_int("anti_aim.desync_range_inverted", 60)
        cachetbl.use = true
    else
        if cachetbl.use then
            menu.set_bool("anti_aim.enable", cachetbl["anti_aim.enable"])
            menu.set_int("anti_aim.desync_type", cachetbl["anti_aim.desync_type"])
            menu.set_int("anti_aim.yaw_offset", cachetbl["anti_aim.yaw_offset"])
            menu.set_int("anti_aim.pitch", cachetbl["anti_aim.pitch"])
            menu.set_int("anti_aim.target_yaw", cachetbl["anti_aim.target_yaw"])
            menu.set_int("anti_aim.desync_type", cachetbl["anti_aim.desync_type"])
            menu.set_int("anti_aim.desync_range", cachetbl["anti_aim.desync_range"])
            menu.set_int("anti_aim.desync_range_inverted", cachetbl["anti_aim.desync_range_inverted"])
            cachetbl.use = false
        else
            cachetbl["anti_aim.enable"] = menu.get_bool("anti_aim.enable")
            cachetbl["anti_aim.desync_type"] = menu.get_int("anti_aim.desync_type")
            cachetbl["anti_aim.yaw_offset"] = menu.get_int("anti_aim.yaw_offset")
            cachetbl["anti_aim.pitch"] = menu.get_int("anti_aim.pitch")
            cachetbl["anti_aim.target_yaw"] = menu.get_int("anti_aim.target_yaw")
            cachetbl["anti_aim.desync_type"] = menu.get_int("anti_aim.desync_type")
            cachetbl["anti_aim.desync_range"] = menu.get_int("anti_aim.desync_range")
            cachetbl["anti_aim.desync_range_inverted"] = menu.get_int("anti_aim.desync_range_inverted")
        end
    end

    if menu.get_int("Fakelag") == 0 then
        menu.set_bool("anti_aim.enable_fake_lag", false)
        menu.set_int("anti_aim.fake_lag_limit", 0)
    elseif menu.get_int("Fakelag") == 1 then
        menu.set_bool("anti_aim.enable_fake_lag", true)
        menu.set_int("anti_aim.fake_lag_limit", 6)
    elseif menu.get_int("Fakelag") == 2 then
        menu.set_bool("anti_aim.enable_fake_lag", true)
        menu.set_int("anti_aim.fake_lag_limit", math.random(1,6))
    end

    if menu.get_int("Legs movement") == 0 then
        menu.set_int("misc.leg_movement", 0)
    elseif menu.get_int("Legs movement") == 1 then
        menu.set_int("misc.leg_movement", 2)
    elseif menu.get_int("Legs movement") == 2 then
        menu.set_int("misc.leg_movement", math.random(1,2))
    end
end

function indicators()
    local player = entitylist.get_local_player()
    if not player then return end
    local weapon = entitylist.get_weapon_by_player(player)
    local x, y = 10, engine.get_screen_height() / 2 + 13
    local ragefov = menu.get_int("rage.field_of_view")
    -- getting text width
    local textf = render.get_text_width( font, "Rage")
    local texts = render.get_text_width( font, "Autowall")
    local ragefove = render.get_text_width( font, "Fov: " .. ragefov ..".0°")
    local dmg = render.get_text_width( font, "Force")
    local fd = render.get_text_width( font, "Fakeduck")
    local legitleft = render.get_text_width( font, "Legit aa: left")
    local legitright = render.get_text_width( font, "Legit aa: right")
    --
    local size = 0
    if menu.get_bool("Indicators") and engine.is_in_game() then
        if menu.get_bool("Rage on key") then
            render.draw_rect_filled(0, y + 4, textf + 14, 30, color.new(40, 40, 47, 150))
            render.draw_text( font, x, y + size, menu.get_key_bind_state("Ragebot") and color.new(0, 255, 0) or color.new(255, 0, 0), "Rage")
            size = size + 40
        end

        if menu.get_bool("Autowall on key") then
            render.draw_rect_filled(0, y + size + 4, texts + 14, 30, color.new(40, 40, 47, 150))
            render.draw_text( font, x, y + size, menu.get_key_bind_state("Autowall") and color.new(0, 255, 0) or color.new(255, 0, 0), "Autowall")
            size = size + 40
        end

        if menu.get_bool("rage.enable") then
            render.draw_rect_filled(0, y + size + 4, ragefove + 14, 30, color.new(40, 40, 47, 150))
            render.draw_text(font, x, y + size, color.new(255, 255, 255), string.format('Fov: %.1f°', ragefov))
            size = size + 40
        elseif menu.get_bool("legit.enable") then
            if weapon then
                weapon = weapon:get_class_name():gsub('CWeapon', '')
                weapon = wpn2tab[weapon] or nil
                if weapon then
                    local fov = menu.get_float(string.format('legit.weapon[%s].field_of_view', weapon)) or nil
                    if fov then
                        local textt = render.get_text_width( font, string.format('Fov: %.1f°', fov))
                        render.draw_rect_filled(0, y + size + 4, textt + 14, 30, color.new(40, 40, 47, 150))
                        render.draw_text(font, x, y + size, color.new(255, 255, 255), string.format('Fov: %.1f°', fov))
                        size = size + 40
                    end
                end
            end
        end

        if menu.get_bool("Legit aa") then
            if not menu.get_key_bind_state("anti_aim.invert_desync_key") then
                render.draw_rect_filled(0, y + size + 4, legitleft + 14, 30, color.new(40, 40, 47, 150))
                render.draw_text(font, x, y + size, color.new(255, 69, 0), "Legit aa: left")
                size = size + 40
            else
                render.draw_rect_filled(0, y + size + 4, legitright + 14, 30, color.new(40, 40, 47, 150))
                render.draw_text(font, x, y + size, color.new(255, 69, 0), "Legit aa: right")
                size = size + 40
            end
        end

        if menu.get_bool("rage.enable") then
            if menu.get_key_bind_state("rage.force_damage_key") then
                render.draw_rect_filled(0, y + size + 4, dmg + 14, 30, color.new(40, 40, 47, 150))
                render.draw_text(font, x, y + size, color.new(255, 255, 255), "Force")
                size = size + 40
            end
        end
        -- misc keybinds
        if menu.get_key_bind_state("anti_aim.fake_duck_key") then
            render.draw_rect_filled(0, y + size + 4, fd + 14, 30, color.new(40, 40, 47, 150))
            render.draw_text(font, x, y + size, color.new(255, 255, 255), "Fakeduck")
            size = size + 40
        end
    end
end

local tick        = 0
local first_delay = 200
local secon_delay = 400
function gravity()
    if menu.get_bool("Hell ragdoll gravity") then
        -- Timer
        if math.random(1,2) > 0 and engine.is_in_game() then
            tick = tick + 1
        end
        -- Main
        if engine.is_in_game() then
            if tick == first_delay then
                console.set_int("cl_ragdoll_gravity", -500)
            elseif tick >= secon_delay then
                console.set_int("cl_ragdoll_gravity", 600)
                tick = 0
            end
        end
    else
        console.set_int("cl_ragdoll_gravity", 800)
    end
end

function logs1(event)
    local me     = engine.get_local_player_index()
    local hurted = event:get_int("userid")
    local target = engine.get_player_for_user_id(hurted)
    local targetname = engine.get_player_info(target).name

    local attacker     = event:get_int("attacker")
    local attacker_id = engine.get_player_for_user_id(attacker)
    local from         = engine.get_player_info(attacker_id).name
    local dmg = event:get_int("dmg_health")
    local hitgroup   = event:get_int("hitgroup")
    local remaining  = event:get_int("health")
    if menu.get_bool("Hitsound") then
        if attacker_id == me and target ~= me then
          local file = sounds[hitsound + 1.0].file
          console.execute(string.format('play %s', file))
        end
    end

    if menu.get_bool("Enable custom logs") then
        if attacker_id == me and target ~= me then
            if hitgroup == 1 then
                client.log(string.format("[ OwO ] Hit %s in the head for %s damage (%s health remaining).", targetname, dmg, remaining))
            elseif hitgroup == 2 then
                client.log(string.format("[ OwO ] Hit %s in the chest for %s damage (%s health remaining).", targetname, dmg, remaining))
            elseif hitgroup == 3 then
                client.log(string.format("[ OwO ] Hit %s in the stomach for %s damage (%s health remaining).", targetname, dmg, remaining))
            elseif hitgroup == 4 then
                client.log(string.format("[ OwO ] Hit %s in the left arm for %s damage (%s health remaining).", targetname, dmg, remaining))
            elseif hitgroup == 5 then
                client.log(string.format("[ OwO ] Hit %s in the right arm for %s damage (%s health remaining).", targetname, dmg, remaining))
            elseif hitgroup == 6 then
                client.log(string.format("[ OwO ] Hit %s in the right leg for %s damage (%s health remaining).", targetname, dmg, remaining))
            elseif hitgroup == 7 then
                client.log(string.format("[ OwO ] Hit %s in the left leg for %s damage (%s health remaining).", targetname, dmg, remaining))
            elseif hitgroup == 0 then
                client.log(string.format("[ OwO ] Hit %s in the generic for %s damage (%s health remaining).", targetname, dmg, remaining))
            end
        end

        if target == me then
            if hitgroup == 1 then
                client.log(string.format("[ OwO ] Take %s damage in the head from %s (%s health remaining).", dmg, from, remaining))
            elseif hitgroup == 2 then
                client.log(string.format("[ OwO ] Take %s damage in the chest from %s (%s health remaining).", dmg, from, remaining))
            elseif hitgroup == 3 then
                client.log(string.format("[ OwO ] Take %s damage in the stomach from %s (%s health remaining).", dmg, from, remaining))
            elseif hitgroup == 4 then
                client.log(string.format("[ OwO ] Take %s damage in the left arm from %s (%s health remaining).", dmg, from, remaining))
            elseif hitgroup == 5 then
                client.log(string.format("[ OwO ] Take %s damage in the right arm from %s (%s health remaining).", dmg, from, remaining))
            elseif hitgroup == 6 then
                client.log(string.format("[ OwO ] Take %s damage in the right leg from %s (%s health remaining).", dmg, from, remaining))
            elseif hitgroup == 7 then
                client.log(string.format("[ OwO ] Take %s damage in the left leg from %s (%s health remaining).", dmg, from, remaining))
            elseif hitgroup == 0 then
                client.log(string.format("[ OwO ] Take %s damage in the generic from %s (%s health remaining).", dmg, from, remaining))
            end
        end
    end
end
function logs2(shot_info)
        local target       = shot_info.target_index
        local nickname     = engine.get_player_info(target).name
        local result       = shot_info.result
    if menu.get_bool("Enable custom logs") then
        if shot_info.result == "Resolver" and not menu.get_bool("Disable resolver") then
            client.log("[ OwO ] Missed shot due to disabled resolver.")
        elseif shot_info.result == "Resolver" and menu.get_bool("Disable resolver") then
            client.log("[ OwO ] Missed shot due to playerlist.")
        elseif shot_info.result == "Spread" then
            client.log("[ OwO ] Missed shot due to config issue.")
        end
    end
end
-- clantag
local fn_change_clantag = utils.find_signature("engine.dll", "53 56 57 8B DA 8B F9 FF 15")
local set_clantag = ffi.cast("clantag_t", fn_change_clantag)
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
local animation = {
    "                ",
    "1               ",
    "i               ",
    "im              ",
    "im@             ",
    "ima             ",
    "imag            ",
    "imag1           ",
    "imagi           ",
    "imagin          ",
    "imagin€         ",
    "imagine         ",
    "imagine s       ",
    "imagine sp      ",
    "imagine sp1     ",
    "imagine spi     ",
    "imagine spin    ",
    "imagine spinn   ",
    "imagine spinn1  ",
    "imagine spinni  ",
    "imagine spinnin ",
    "imagine spinning",
    "imagine spinning",
    "imagine spinning",
    "imagine spinning",
    "imagine spinning",
    "imagine spinnin ",
    "imagine spinni  ",
    "imagine spinn   ",
    "imagine spin    ",
    "imagine spi     ",
    "imagine sp      ",
    "imagine        ",
    "imagin         ",
    "imagi          ",	
    "imag           ",
    "ima            ",
    "im             ",
    "i              ",
    "               ",
}

local old_time = 0
client.add_callback("on_paint", function()
    local player = entitylist.get_local_player()
    local curtime = math.floor(globals.get_curtime() * 2)
    if menu.get_bool("Clantag") and engine.is_in_game() then
        if player:get_team() ~= 2 and player:get_team() ~= 3 then return end
        if old_time ~= curtime and (globals.get_tickcount() % 2) == 1 then
            set_clantag(animation[curtime % #animation+1], animation[curtime % #animation+1])
            old_time = curtime
        end
    elseif not menu.get_bool("Clantag") then
        if engine.is_in_game() and old_time ~= curtime and (globals.get_tickcount() % 2) == 1 then
            if player:get_team() ~= 2 and player:get_team() ~= 3 then return end
            set_clantag("", "")
            old_time = curtime
        end
    end
end)

-- disable resolver by forcing enemy body yaw
function nores()
    if menu.get_bool("Disable resolver") then
        for number = 0, globals.get_maxclients() do
            menu.set_bool("player_list.player_settings[" .. number .. "].force_body_yaw", true)
            menu.set_int("player_list.player_settings[" .. number .. "].body_yaw", 0)
        end
    else 
        for number = 0, globals.get_maxclients() do menu.set_bool("player_list.player_settings[" .. number .. "].force_body_yaw", false) end
    end
end

-- killsay

local killchat = {
    "ez",
    "lmao, look at ur playstyle..",
    "little kid captured",
    "1",
    "did you know that csgo is free to uninstall?",
    "1 idiot, iq?",
    "where iq?",
    "oww, u died? i didn't see it, sorry.",
    "get back to work",
    "nice iq retard",
    "oops, sorry i didn't see you",
    "rest in spaghetti never forgetti",
    "how'd you hit the ACCEPT button with that aim? ah, yes... autoaccept",
    "FYI: warmup is over already.",
    "protip: using a mouse is recommended.",
    "atleast hitler knew when to kill himself.",
    "you have a reaction time slower than coastal erosion.",
    "stop buying an awp you $4750 decoy...",
    "mad cuz bad",
    "is your monitor on?",
    "i thought I put bots on hard, why are they on easy?",
    "Options -> How To Play",
    "is this casual? I have 16k...",
    "oops, I must have chosen easy bots by accident...",
    "the only thing you can throw are rounds.",
    "if we learn from our mistakes, your parents must be geniuses now.",
    "you define autism",
    "if you were a CSGO match, your mother would have a 7day cooldown all the time, because she kept abandoning you.",
    "your nans like my ak vulcan, battle-scarred.",
    "isn't it uncomfortable playing csgo in the kitchen?",
    "my knife is well-worn, just like your mother.",
}

function killsay(event)
    if menu.get_bool("Kill Say") then
    local attacker = engine.get_player_for_user_id(event:get_int("attacker"))
    local dead = engine.get_player_for_user_id(event:get_int("userid"))
    local me = engine.get_local_player_index()
        
        if attacker == me and dead ~= me then
          console.execute ("say " .. killchat[math.random(1,#killchat)])
        end
    end
end

function refresh_tabelements()
    menu.get_bool("Kill Say")
    menu.get_bool("Hitsound")
    menu.get_bool("Enable custom logs")
end

-- callbacks
client.add_callback("on_paint", refresh_tabelements)
events.register_event("player_death", killsay)
client.add_callback("on_paint", keys)
client.add_callback("on_paint", anti_aims_tab)
client.add_callback("on_paint", indicators)
client.add_callback("on_paint", gravity)
client.add_callback("on_paint", nores)
client.add_callback("on_shot", logs2)
events.register_event("player_hurt", logs1)
events.register_event("player_death", killsay)
