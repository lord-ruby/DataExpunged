SMODS.Joker {
    key = "code_name_s_d_locke",
    pos = {x = 0, y = 0},
    soul_pos = {x = 0, y = 1},
    atlas = "proposals",

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    cost = 10,
    rarity = 4,

    classification = "proposal",

    calculate = function(self, card, context)
        if context.after and #context.full_hand == 2 then
            local c = context.full_hand[1]
            local c2= context.full_hand[2]
            G.E_MANAGER:add_event(Event{
                func = function()
                    c:flip()
                    return true
                end
            })
            delay(0.75)
            G.E_MANAGER:add_event(Event{
                func = function()
                    if c.config.center_key ~= "m_scp_dissolved" then
                        c:set_ability(G.P_CENTERS.m_scp_dissolved)
                    end
                    local key1 = c.config.center_key
                    local key2 = c2.config.center_key
                    if key1 == "c_base" or key1 == "m_scp_dissolved" then key1 = nil end
                    if key2 == "c_base" or key2 == "m_scp_dissolved" then key2 = nil end
                    c.ability.merged_cards = c.ability.merged_cards or {
                        cards = 1,
                        seals = {c.seal},
                        enhancements = {key1},
                        editions = {c.edition and c.edition.key}
                    }
                    if c2.config.center_key == "m_scp_dissolved" then
                        c.ability.merged_cards.cards = c.ability.merged_cards.cards + c2.ability.merged_cards.cards
                        --SCP.merge_tables(c.ability.merged_cards.seals, c2.ability.merged_cards.seals)
                        --SCP.merge_tables(c.ability.merged_cards.enhancements, c2.ability.merged_cards.enhancements)
                        --SCP.merge_tables(c.ability.merged_cards.editions, c2.ability.merged_cards.editions)
                        local alr = {}
                        for i, v in pairs(c2.ability.merged_cards.seals) do
                            if not alr[v] then
                                alr[v] = true
                                c.ability.merged_cards.seals[#c.ability.merged_cards.seals+1] = v
                            end
                        end
                        for i, v in pairs(c2.ability.merged_cards.enhancements) do
                            if not alr[v] then
                                alr[v] = true
                                c.ability.merged_cards.enhancements[#c.ability.merged_cards.enhancements+1] = v
                            end
                        end
                        for i, v in pairs(c2.ability.merged_cards.editions) do
                            if not alr[v] then
                                alr[v] = true
                                c.ability.merged_cards.editions[#c.ability.merged_cards.editions+1] = v
                            end
                        end
                    end
                    c.base.nominal = c.base.nominal + c2.base.nominal
                    if c2.ability.bonus > 0 then
                        c.ability.bonus = c.ability.bonus + c2.ability.bonus
                    end
                    c.bypass_modif_locks = true
                    c:set_edition()
                    c:set_seal()
                    c.bypass_modif_locks = false
                    return true
                end
            })
            delay(0.75)
            G.E_MANAGER:add_event(Event{
                func = function()
                    c:flip()
                    return true
                end
            })
            SMODS.destroy_cards(context.full_hand[2])
            return {
                message = "Merged!"
            }
        end
    end
}

SMODS.Enhancement {
    key = "dissolved",
    pos = {x = 0, y = 0},
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    in_pool = function() return false end,

    loc_vars = function(self, q, card)
        if card.ability.merged_cards then
            local keys = {}
            for i, v in pairs(card.ability.merged_cards.seals) do
                keys[v] = (keys[v] or 0) + 1
            end
            for i, v in pairs(card.ability.merged_cards.enhancements) do
                keys[v] = (keys[v] or 0) + 1
            end
            for i, v in pairs(card.ability.merged_cards.editions) do
                keys[v] = (keys[v] or 0) + 1
            end
            G.infoqueue_modifiers = {}
            for i, v in pairs(keys) do
                q[#q+1] = G.P_CENTERS[i]
                G.infoqueue_modifiers[i] = {stack = v}
            end
        end
        return {
            vars = {
                card.ability.merged_cards and card.ability.merged_cards.cards or 0
            },
        }
    end,

    calculate = function(self, card, context)
        if context.repetition and context.other_card == card then
            local extra_reps = 0
            for i, v in pairs(card.ability.merged_cards.seals) do
                local ret = SCP.calc_seal_from_key(v, context, card)
                if ret and ret.repetitions then extra_reps = extra_reps + ret.repetitions end
                for i, v in pairs(ret or {}) do
                    SMODS.calculate_individual_effect(ret, card, i, v, false)
                end
            end
            return {
                repetitions = card.ability.merged_cards.cards + extra_reps
            }
        else
            if context.cardarea == G.hand and context.final_scoring_step then
                for i, v in pairs(card.ability.merged_cards.enhancements) do
                    local center = G.P_CENTERS[v]
                    local dummy = SCP.get_dummy(center, card.area, card)
                    local ret = eval_card(dummy, context)
                    ret.playing_card = {}
                    local h_mult = dummy:get_chip_h_mult()
                    if h_mult ~= 0 then
                        ret.mult = h_mult
                    end
                
                    local h_x_mult = dummy:get_chip_h_x_mult()
                    if h_x_mult > 0 then
                        ret.x_mult = h_x_mult
                    end
                
                    local h_chips = dummy:get_chip_h_bonus()
                    if h_chips ~= 0 then
                        ret._chips = h_chips
                    end
                
                    local h_x_chips = dummy:get_chip_h_x_bonus()
                    if h_x_chips > 0 then
                        ret.x_chips = h_x_chips
                    end
                    for i, v in pairs(ret or {}) do
                        SMODS.calculate_individual_effect(ret, card, i, v, false)
                    end
                end
            else
                for i, v in pairs(card.ability.merged_cards.editions) do
                    local edition = G.P_CENTERS[v] 
                    local ret
                    local dummy_card = SCP.get_dummy(card.config.center, card.area, card)
                    dummy_card.edition = {}
                    for k, v in pairs(edition.config) do
                        if type(v) == 'table' then
                            dummy_card.edition[k] = copy_table(v)
                        else
                            dummy_card.edition[k] = v
                        end
                    end
                    dummy_card.edition[string.sub(v, 3)] = true
                    dummy_card.edition.key = v
                    local ret
                    if context.end_of_round and context.cardarea == G.hand and context.playing_card_end_of_round then
                        ret = card:get_end_of_round_effect(context)
                        if ret then
                            ret.end_of_round = ret
                        end
                    else
                        if edition.calculate and type(edition.calculate) == 'function' then
                            local o = edition:calculate(dummy_card, context)
                            if o then
                                if not o.card then o.card = dummy_card end
                                ret = o
                            end
                        end
                    end
                    for i, v in pairs(ret or {}) do
                        SMODS.calculate_individual_effect(ret, card, i, v, false)
                    end 
                end
                for i, v in pairs(card.ability.merged_cards.seals) do
                    local ret
                    if context.end_of_round and context.cardarea == G.hand and context.playing_card_end_of_round then
                        ret = card:get_end_of_round_effect(context)
                        if ret then
                            ret.end_of_round = ret
                        end
                    else
                        ret = SCP.calc_seal_from_key(v, context, card)
                    end
                    local ret = SCP.calc_seal_from_key(v, context, card)
                    for i, v in pairs(ret or {}) do
                        SMODS.calculate_individual_effect(ret, card, i, v, false)
                    end
                end
                for i, v in pairs(card.ability.merged_cards.enhancements) do
                    local center = G.P_CENTERS[v]
                    local dummy = SCP.get_dummy(center, card.area, card)
                    local ret
                    if context.end_of_round and context.cardarea == G.hand and context.playing_card_end_of_round then
                        ret = card:get_end_of_round_effect(context)
                        if ret then
                            ret.end_of_round = ret
                        end
                    else
                        ret = eval_card(dummy, context)
                    end
                    if context.cardarea == G.play and context.main_scoring then
                        local mult = dummy:get_chip_mult()
                        ret = ret or {}
                        if mult > 0 then
                            ret.mult = mult
                        end
                        local x_mult = dummy:get_chip_x_mult(context)
                        if x_mult > 0 then
                            ret.x_mult = x_mult
                        end
                        local p_dollars = dummy:get_p_dollars()
                        if p_dollars > 0 then
                            ret.p_dollars = p_dollars
                        end
                    end
                    for i, v in pairs(ret or {}) do
                        SMODS.calculate_individual_effect(ret, card, i, v, false)
                    end
                end
            end
        end
    end
}

function SCP.calc_seal_from_key(key, context, card)
    local obj = G.P_SEALS[key] or {}
    if obj.calculate and type(obj.calculate) == 'function' then
    	local o = obj:calculate(card, context)
    	if o then
            if not o.card then o.card = card end
            return o
        end
    end
    if context.repetition then
        if key == 'Red' then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card
                }
        end
    end
    if context.discard and context.other_card == card then
        if key == 'Purple' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                    return true
                end)}))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            return nil, true
        end
    end
end

function SMODS.info_queue_desc_from_rows(desc_nodes, empty, maxw, key)
    local t = {}
    for k, v in ipairs(desc_nodes) do
        if k == 1 then
            if G.infoqueue_modifiers and G.infoqueue_modifiers[key] then
                local modif = G.infoqueue_modifiers[key]
                if modif.stack and modif.stack > 1 then
                    v[#v+1] = {
                        n = G.UIT.O,
                        config = {
                            object = DynaText({
                                string = " (X"..number_format(modif.stack)..")",
                                colours = { G.C.WHITE },
                                shadow = true,
                                scale = 0.3,
                            }),
                        },
                    }
                end
                G.infoqueue_modifiers[key] = nil
            end
        end
        t[#t+1] = {n=G.UIT.R, config={align = "cm", maxw = maxw}, nodes=v}
    end
    return {n=G.UIT.R, config={align = "cm", colour = desc_nodes.background_colour or empty and G.C.CLEAR or G.C.UI.BACKGROUND_WHITE, r = 0.1, emboss = not empty and 0.05 or nil, filler = true, main_box_flag = desc_nodes.main_box_flag and true or nil}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes=t}
    }}
end