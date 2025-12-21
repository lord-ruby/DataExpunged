-- local {
--     items = {
--         jokers = {
--             ...
--         }
--     }
-- }

function SCP.load_table(table)
    for i, v in pairs(table) do
        local f, err = SMODS.load_file(v .. ".lua")
        if err then
            error(err); return
        end
        if f then f() end
    end
end

function SCP.downside_active(card)
    if ((card.ability.set == "Joker" and card.config.center.original_mod and card.config.center.original_mod.id == SCP.id) or card.ability.set == "Spectral") and next(SMODS.find_card("j_scp_code_name_lily")) then
        return false
    end
    return true
end

SCP.rarity_blacklist = {
    [4] = true,
    Legendary = true,
    cry_exotic = true,
    entr_entropic = true,
    valk_exquisite = true
}

function SCP.localize_classification(center, rarity)
    if center and center.classification then
        local class = center.classification
        if not SCP.rarity_blacklist[center.rarity] and next(SMODS.find_card("j_scp_code_name_wjs")) then
            class = "safe"
        end
        return localize("k_scp_" .. class)
    end
    local vanilla_rarity_keys = { localize('k_common'), localize('k_uncommon'), localize('k_rare'), localize(
        'k_legendary') }
    if center and not SCP.rarity_blacklist[center.rarity] and next(SMODS.find_card("j_scp_code_name_wjs")) then
        rarity = 1
    end
    if (vanilla_rarity_keys)[rarity] then
        return vanilla_rarity_keys[rarity] --compat layer in case function gets the int of the rarity
    else
        return localize("k_" .. rarity:lower())
    end
end

function SCP.get_rarity_colour(rarity, card, _c)
    if _c.classification == "null" or _c.classification == "pending" then return G.C.BLACK end
    if not SCP.rarity_blacklist[rarity] and next(SMODS.find_card("j_scp_code_name_wjs")) then
        return G.C.RARITY.Common
    end
    if card.config and card.config.center and card.config.center.key == "j_scp_914_below_common" then
        return G.C.RARITY.Junk
    end
    return G.C.RARITY[rarity]
end

function SCP.merge_tables(tbl1, tbl2)
    for i, v in pairs(tbl2) do
        tbl1[#tbl1 + 1] = v
    end
end

local card_click_ref = Card.click
function Card:click(...)
    if G.SETTINGS.paused then
        local center = self.config.center
        if ((center.set == "Joker" and center.original_mod and center.original_mod.id == SCP.id) or (center.has_info)) then
            self.ability.show_info = not self.ability.show_info
            G.show_info = G.show_info or {}
            G.show_info[self.config.center_key] = self.ability.show_info
            self:juice_up()
            return
        end
    end
    return card_click_ref(self, ...)
end

function SCP.generate_description_localization(args, loc_target)
    if not args.card then args.card = G._loc_card end
    if not loc_target then return end
    if args.card and args.card.ability.show_info == nil and ((SCP.config.default_info and not G.SETTINGS.paused) or (G.SETTINGS.paused and SCP.config.info_in_collection)) then
        args.card.ability.show_info = true
    end
    if args.card and G.show_info and G.show_info[args.card.config.center_key] ~= nil and G.SETTINGS.paused then
        args.card.ability.show_info = G.show_info[args.card.config.center_key]
    end
    local target = args.card and not SCP.downside_active(args.card) and "no_downsides_text" or "text"
    if not loc_target[target] then target = "text" end
    if type(loc_target[target]) == 'table' and loc_target.info then
        args.AUT.multi_box = args.AUT.multi_box or {} 
        local boxes = {}
        if (args.card and args.card.ability.show_info) then  
            if type(loc_target.info[1]) == "table" then
                for i, v in pairs(loc_target.info_parsed) do
                    boxes[#boxes+1] = v
                end
            else
                boxes[#boxes+1] = loc_target.info_parsed
            end
        end
        if type(loc_target[target][1]) == "table" then
            for i, v in pairs(loc_target[target .. "_parsed"]) do
                boxes[#boxes + 1] = v
            end
        else
            boxes[#boxes + 1] = loc_target[target .. "_parsed"]
        end
        for i, box in ipairs(boxes) do
            for j, line in ipairs(box) do
                local final_line = SMODS.localize_box(line, args)
                if i == 1 or next(args.AUT.info) then
                    args.nodes[#args.nodes + 1] = final_line -- Sends main box to AUT.main
                    if not next(args.AUT.info) then args.nodes.main_box_flag = true end
                elseif not next(args.AUT.info) then
                    args.AUT.multi_box[i - 1] = args.AUT.multi_box[i - 1] or {}
                    args.AUT.multi_box[i - 1][#args.AUT.multi_box[i - 1] + 1] = final_line
                end
                if not next(args.AUT.info) then
                    args.AUT.box_colours[i] = args.vars.box_colours and
                        args.vars.box_colours[i] or G.C.UI.BACKGROUND_WHITE
                end
            end
        end
        return true
    end
end

local generate_ui_ref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
    G._loc_card = card
    local ret = generate_ui_ref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,
        card, ...)
    G._loc_card = nil
    return ret
end

--stolen from entropy
SCP.get_dummy = function(center, area, self)
    local abil = copy_table(center.config) or {}
    abil.consumeable = copy_table(abil)
    abil.name = center.name or center.key
    abil.set = "Joker"
    abil.t_mult = abil.t_mult or 0
    abil.t_chips = abil.t_chips or 0
    abil.x_mult = abil.x_mult or abil.Xmult or 1
    abil.extra_value = abil.extra_value or 0
    abil.d_size = abil.d_size or 0
    abil.mult = abil.mult or 0
    abil.effect = center.effect
    abil.h_size = abil.h_size or 0
    abil.card_limit = abil.card_limit or 1
    abil.extra_slots_used = abil.extra_slots_used or 0
    local eligible_editionless_jokers = {}
    for i, v in pairs(G.jokers and G.jokers.cards or {}) do
        if not v.edition then
            eligible_editionless_jokers[#eligible_editionless_jokers + 1] = v
        end
    end
    local tbl = {
        ability = abil,
        config = {
            center = center,
            center_key = center.key
        },
        juice_up = function(_, ...)
            return self:juice_up(...)
        end,
        start_dissolve = function(_, ...)
            return self:start_dissolve(...)
        end,
        remove = function(_, ...)
            return self:remove(...)
        end,
        flip = function(_, ...)
            return self:flip(...)
        end,
        use_consumeable = function(self, ...)
            self.bypass_echo = true
            local ret = Card.use_consumeable(self, ...)
            self.bypass_echo = nil
        end,
        can_use_consumeable = function(self, ...)
            return Card.can_use_consumeable(self, ...)
        end,
        calculate_joker = function(self, ...)
            return Card.calculate_joker(self, ...)
        end,
        can_calculate = function(self, ...)
            return Card.can_calculate(self, ...)
        end,
        set_cost = function(self, ...)
            Card.set_cost(self, ...)
        end,
        calculate_sticker = function(self, ...)
            Card.calculate_sticker(self, ...)
        end,
        base_cost = 1,
        extra_cost = 0,
        original_card = self,
        area = area,
        added_to_deck = added_to_deck,
        cost = self.cost,
        sell_cost = self.sell_cost,
        eligible_strength_jokers = eligible_editionless_jokers,
        eligible_editionless_jokers = eligible_editionless_jokers,
        T = self.t,
        VT = self.VT
    }
    for i, v in pairs(Card) do
        if type(v) == "function" and i ~= "flip_side" then
            tbl[i] = function(_, ...)
                return v(self, ...)
            end
        end
    end
    tbl.set_edition = function(s, ed, ...)
        Card.set_edition(s, ed, ...)
    end
    tbl.get_chip_h_x_mult = function(s, ...)
        local ret = SMODS.multiplicative_stacking(s.ability.h_x_mult or 1,
            (not s.ability.extra_enhancement and s.ability.perma_h_x_mult) or 0)
        return ret
    end
    tbl.get_chip_x_mult = function(s, ...)
        local ret = SMODS.multiplicative_stacking(s.ability.x_mult or 1,
            (not s.ability.extra_enhancement and s.ability.perma_x_mult) or 0)
        return ret
    end
    return tbl
end

function SCP.end_of_round(context)
    return context.end_of_round and not context.individual and not context.repetition and not context.blueprint
end

function SCP.area_has_room(area, num)
    if not num then num = 1 end
    if area == "joker" or area == "consumeable" then
        return G.GAME[area .. "_buffer"] + #G[area .. "s"].cards < G[area .. "s"].config.card_limit
    else
        return #G[area].cards < G[area].config.card_limit
    end
end

---Modified `change_background_colour()` to allow passing timer types
---@param args table
function SCP.ease_background_colour_timer(args)
    for k, v in pairs(G.C.BACKGROUND) do
        if args.new_colour and (k == 'C' or k == 'L' or k == 'D') then
            if args.special_colour and args.tertiary_colour then
                local col_key = k == 'L' and 'new_colour' or k == 'C' and 'special_colour' or
                    k == 'D' and 'tertiary_colour'
                ease_value(v, 1, args[col_key][1] - v[1], false, args.timer or nil, true, 0.6)
                ease_value(v, 2, args[col_key][2] - v[2], false, args.timer or nil, true, 0.6)
                ease_value(v, 3, args[col_key][3] - v[3], false, args.timer or nil, true, 0.6)
            else
                local brightness = k == 'L' and 1.3 or k == 'D' and (args.special_colour and 0.4 or 0.7) or 0.9
                if k == 'C' and args.special_colour then
                    ease_value(v, 1, args.special_colour[1] - v[1], false, args.timer or nil, true, 0.6)
                    ease_value(v, 2, args.special_colour[2] - v[2], false, args.timer or nil, true, 0.6)
                    ease_value(v, 3, args.special_colour[3] - v[3], false, args.timer or nil, true, 0.6)
                else
                    ease_value(v, 1, args.new_colour[1] * brightness - v[1], false, args.timer or nil, true, 0.6)
                    ease_value(v, 2, args.new_colour[2] * brightness - v[2], false, args.timer or nil, true, 0.6)
                    ease_value(v, 3, args.new_colour[3] * brightness - v[3], false, args.timer or nil, true, 0.6)
                end
            end
        end
    end
    if args.contrast then
        ease_value(G.C.BACKGROUND, 'contrast', args.contrast - G.C.BACKGROUND.contrast, false, nil, true, 0.6)
    end
end

---Modified `change_backgorund_colour_blind() to reset background, allows timer type to be passed through
---@param state balatro.Game.StateEnum
---@param timer balatro.TimerType
function SCP.reset_background_color(state, timer)
    local blindname = ((G.GAME.blind and G.GAME.blind.name ~= '' and G.GAME.blind.name) or 'Small Blind')
    local blindname = (blindname == '' and 'Small Blind' or blindname)

    if state == G.STATES.TAROT_PACK then
        SCP.ease_background_colour_timer { new_colour = G.C.PURPLE, special_colour = darken(G.C.BLACK, 0.2), contrast = 1.5, timer = timer or nil }
    elseif state == G.STATES.SPECTRAL_PACK then
        SCP.ease_background_colour_timer { new_colour = G.C.SECONDARY_SET.Spectral, special_colour = darken(G.C.BLACK, 0.2), contrast = 2, timer = timer or nil }
    elseif state == G.STATES.STANDARD_PACK then
        SCP.ease_background_colour_timer { new_colour = darken(G.C.BLACK, 0.2), special_colour = G.C.RED, contrast = 3, timer = timer or nil }
    elseif state == G.STATES.BUFFOON_PACK then
        SCP.ease_background_colour_timer { new_colour = G.C.FILTER, special_colour = G.C.BLACK, contrast = 2, timer = timer or nil }
    elseif state == G.STATES.PLANET_PACK then
        SCP.ease_background_colour_timer { new_colour = G.C.BLACK, contrast = 3, timer = timer or nil }
    elseif G.GAME.won then
        SCP.ease_background_colour_timer { new_colour = G.C.BLIND.won, contrast = 1, timer = timer or nil }
    elseif blindname == 'Small Blind' or blindname == 'Big Blind' or blindname == '' then
        SCP.ease_background_colour_timer { new_colour = G.C.BLIND['Small'], contrast = 1, timer = timer or nil }
    else
        local boss_col = G.C.BLACK
        for k, v in pairs(G.P_BLINDS) do
            if v.name == blindname then
                if v.boss.showdown then
                    SCP.ease_background_colour_timer { new_colour = G.C.BLUE, special_colour = G.C.RED, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3, timer = timer or nil }
                    return
                end
                boss_col = v.boss_colour or G.C.BLACK
            end
        end
        SCP.ease_background_colour_timer { new_colour = lighten(mix_colours(boss_col, G.C.BLACK, 0.3), 0.1), special_colour = boss_col, contrast = 2, timer = timer or nil }
    end
end

--- Imitates `Card:start_dissolve()` but doesn't destroy the card
---@param dissolve_colours? ColorHex|ColorHexRgb
---@param silent? boolean
---@param dissolve_time_fac? number
---@param no_juice? boolean
---@param reverse? boolean
function Card:SCP_fake_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice, reverse)
    dissolve_colours = dissolve_colours or (type(self.destroyed) == 'table' and self.destroyed.colours) or nil
    dissolve_time_fac = dissolve_time_fac or (type(self.destroyed) == 'table' and self.destroyed.time) or nil
    local dissolve_time = 0.7 * (dissolve_time_fac or 1)
    self.dissolve = 0
    self.dissolve_colours = dissolve_colours
        or { G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.JOKER_GREY }
    if not no_juice then self:juice_up() end
    local childParts = Particles(0, 0, 0, 0, {
        timer_type = 'TOTAL',
        timer = 0.01 * dissolve_time,
        scale = 0.1,
        speed = 2,
        lifespan = 0.7 * dissolve_time,
        attach = self,
        colours = self.dissolve_colours,
        fill = true
    })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay = 0.7 * dissolve_time,
        func = (function()
            childParts:fade(0.3 * dissolve_time)
            return true
        end)
    }))
    if not silent then
        G.E_MANAGER:add_event(Event({
            blockable = false,
            func = (function()
                play_sound('whoosh2', math.random() * 0.2 + 0.9, 0.5)
                play_sound('crumple' .. math.random(1, 5), math.random() * 0.2 + 0.9, 0.5)
                return true
            end)
        }))
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = false,
        ref_table = self,
        ref_value = 'dissolve',
        ease_to = 1,
        delay = 1 * dissolve_time,
        func = (function(t) return reverse and 1 - t or t end)
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay = 1.051 * dissolve_time,
    }))
end

--- Transform a given `orig_card` into an instance of `new_card_id` with some extra flair
---@param orig_card Card|table
---@param new_card_id string
function SCP.containment_breach(orig_card, new_card_id)
    orig_card.scp_breach_started = true
    for i = 0, 1, 0.01 do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blocking = false,
            delay = 0.25 * (i * 100),
            func = function()
                orig_card:juice_up(0, i)
                return true
            end
        }))
    end
    for ii = 0, 3, 1 do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 3,
            func = function()
                SCP.ease_background_colour_timer({
                    new_colour = mix_colours(G.C.BACKGROUND.C, HEX("FF0000"), 0.75),
                    timer =
                    'REAL'
                })
                play_sound("scp_alarm")
                return true
            end
        }))

        if ii == 2 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    orig_card:SCP_fake_dissolve(nil, nil, 3)
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 3,
            func = function()
                SCP.reset_background_color(G.STATE, 'REAL')
                return true
            end
        }))
    end
    local _card
    G.E_MANAGER:add_event(Event({
        blocking = true,
        func = function()
            local area = orig_card.area or G.jokers
            local place = 0

            for k, v in ipairs(area.cards) do
                if v == orig_card then
                    place = k
                end
            end

            orig_card:start_dissolve(nil, true, 0, true)
            _card = SMODS.create_card({ key = new_card_id, skip_materialize = true, area = orig_card.area, no_edition = true })

            _card.scp_breach_started = true
            _card:add_to_deck()
            area:emplace(_card, place)
            _card.dissolve = 1

            _card:SCP_fake_dissolve(nil, nil, 3, nil, true)

            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1.5,
        func = function()
            _card.scp_breach_started = false
            return true
        end
    }))
end

--- Transform a given `orig_card` into an instance of `new_card_id` with no flair
---@param orig_card Card|table
---@param new_card_id string
function SCP.clean_swap(orig_card, new_card_id)
    local _card
    orig_card.scp_breach_started = true
    G.E_MANAGER:add_event(Event({
        blocking = true;
        func = function()
            orig_card:SCP_fake_dissolve(nil, nil, 3)
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        blocking = true,
        func = function()
            orig_card.scp_breach_started = true
            local area = orig_card.area or G.jokers
            local place = 0

            for k, v in ipairs(area.cards) do
                if v == orig_card then
                    place = k
                end
            end

            orig_card:start_dissolve(nil, true, 0, true)
            _card = SMODS.create_card({ key = new_card_id, skip_materialize = true, area = orig_card.area, no_edition = true })

            _card.scp_breach_started = true
            _card:add_to_deck()
            area:emplace(_card, place)
            _card.dissolve = 1

            _card:SCP_fake_dissolve(nil, nil, 3, nil, true)

            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1.5,
        func = function()
            _card.scp_breach_started = false
            return true
        end
    }))
end
local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	local abc = G_UIDEF_use_and_sell_buttons_ref(card)
    local center = card.config.center
    if card.area == G.jokers and ((center.set == "Joker" and center.original_mod and center.original_mod.id == SCP.id) or (center.has_info)) then
        sell = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card', handy_insta_action = 'sell'}, nodes={
              {n=G.UIT.B, config = {w=0.1,h=0.6}},
              {n=G.UIT.C, config={align = "tm"}, nodes={
                {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                  {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
                }},
                {n=G.UIT.R, config={align = "cm"}, nodes={
                  {n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
                  {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
                }}
              }}
            }},
        }}
        info = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cm",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'show_info', func = 'can_show_info'}, nodes={
              {n=G.UIT.B, config = {w=0.1,h=0.3}},
              {n=G.UIT.C, config={align = "tm"}, nodes={
                {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                  {n=G.UIT.T, config={text = localize("k_show_info"),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
                }},
              }}
            }},
        }}
        return {
            n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
              {n=G.UIT.C, config={padding = 0, align = 'cl'}, nodes={
                {n=G.UIT.R, config={align = 'cl'}, nodes={
                  sell
                }},
                {n=G.UIT.R, config={align = 'cl'}, nodes={
                  info
                }},
            }},
        }}
    end
    return abc
end

G.FUNCS.can_show_info = function(e)
    local center = e.config.ref_table.config.center
    if
        not G.CONTROLLER.locked
    then
        e.config.colour = G.C.SCP_THAUMIEL
        e.config.button = "show_info"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end
G.FUNCS.show_info = function(e)
    e.config.ref_table.ability.show_info = not e.config.ref_table.ability.show_info
    e.config.ref_table:juice_up()
end

function SCP.use_lock()
    return G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0)
end

local G_UIDEF_use_and_sell_buttons_ref2 = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local orig = G_UIDEF_use_and_sell_buttons_ref2(card)
    local center = card.config.center
    if card.area == G.jokers and center.use_scp and type(center.use_scp) == "function" then
        scp_use = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cm",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'use_scp', func = 'can_use_scp'}, nodes={
              {n=G.UIT.B, config = {w=0.3,h=0.3}},
              {n=G.UIT.C, config={align = "tm"}, nodes={
                {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                  {n=G.UIT.T, config={text = localize("k_scp_use"),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
                }},
              }}
            }},
        }}
        table.insert(orig.nodes[1].nodes, 3, {n=G.UIT.R, config={align = 'cl'}, nodes={scp_use}})
    end
    return orig
    
end

G.FUNCS.can_use_scp = function(e)
    local center = e.config.ref_table.config.center
    local card = e.config.ref_table
if
    not SCP.use_lock() and (center.can_use_scp and (center:can_use_scp(card) and 1) or 0) > 0
    then
        e.config.colour = G.C.IMPORTANT
        e.config.button = "use_scp"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.use_scp = function(e)
    local center = e.config.ref_table.config.center
    local card = e.config.ref_table
    G.E_MANAGER:add_event(Event({
            blocking = true,
            func = function()
                center:use_scp(card)
                G.CONTROLLER.locks.use = true
                card.states.hover.can = false
                card.states.drag.can = false
                card.states.click.can = false
                return true
            end
    }))
    G.E_MANAGER:add_event(Event({
        blockable = true,
        trigger = 'after',
        delay = 1,
            func = function()
                G.CONTROLLER.locks.use = false
                card.states.hover.can = true
                card.states.drag.can = true
                card.states.click.can = true
                return true
            end
    }))
end