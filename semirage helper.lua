--Todo: 
menu.add_slider_float("ivi: the semi-rage helper | ver.", 1.23, 1.23)
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

-- FFI
local ffi = require "ffi"
ffi.cdef[[
    typedef int(__fastcall* clantag_t)(const char*, const char*);
]]

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
client.log("ivi: the semirage helper v1.23")
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
            elseif tick == secon_delay then
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
    "               ",
    "i              ",
    "im             ",
    "ima            ",
    "imag           ",
	"imagi          ",
	"imagin         ",
    "imagine        ",
	"imagine s      ",
    "imagine sp     ",
	"imagine spi    ",
	"imagine spin   ",
    "imagine spini  ",
    "imagine spinin ",
    "imagine spining",
    "imagine spining",
    "imagine spining",
    "imagine spining",
    "imagine spining",
    "imagine spinin ",
    "imagine spini  ",
    "imagine spin   ",
	"imagine spi    ",
	"imagine sp     ",
    "imagine s      ",
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
    local curtime = math.floor(globals.get_curtime() * 2)
    if menu.get_bool("Clantag") and engine.is_in_game() then
        if old_time ~= curtime and (globals.get_tickcount() % 2) == 1 then
            set_clantag(animation[curtime % #animation+1], animation[curtime % #animation+1])
            old_time = curtime
        end
    elseif not menu.get_bool("Clantag") then
        if engine.is_in_game() and old_time ~= curtime and (globals.get_tickcount() % 2) == 1 then
            set_clantag("", "")
            old_time = curtime
        end
    end
end)

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

-- callbacks
client.add_callback("on_paint", keys)
client.add_callback("on_paint", anti_aims_tab)
client.add_callback("on_paint", indicators)
client.add_callback("on_paint", gravity)
client.add_callback("on_shot", logs2)
events.register_event("player_hurt", logs1)
client.add_callback("on_paint", nores)
