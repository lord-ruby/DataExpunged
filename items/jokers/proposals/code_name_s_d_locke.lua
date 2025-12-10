SMODS.Joker {
    key = "code_name_s_d_locke",
    pos = {x = 0, y = 0},
    --atlas = "jokers",

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    cost = 10,
    rarity = 4,

    classification = "proposal",

    calculate = function(self, card, context)
        if context.after and #G.play.cards == 2 then
            local c = G.play.cards[1]
            local c2= G.play.cards[2]
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
                        seals = {c.seal, c2.seal},
                        enhancements = {key1, key2},
                        editions = {c.edition and c.edition.key, c2.edition and c2.edition.key}
                    }
                    if c2.config.center_key == "m_scp_dissolved" then
                        c.ability.merged_cards.cards = c.ability.merged_cards.cards + c2.ability.merged_cards.cards
                        SCP.merge_tables(c.ability.merged_cards.seals, c2.ability.merged_cards.seals)
                        SCP.merge_tables(c.ability.merged_cards.enhancements, c2.ability.merged_cards.enhancements)
                        SCP.merge_tables(c.ability.merged_cards.editions, c2.ability.merged_cards.editions)
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
            SMODS.destroy_cards(G.play.cards[2])
            return {
                message = "Merged!"
            }
        end
    end
}

SMODS.Enhancement {
    key = "dissolved",
    pos = {x = 0, y = 0},
    --atlas = "jokers",
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, q, card)
        if card.ability.merged_cards then
            for i, v in pairs(card.ability.merged_cards.seals) do
                q[#q+1] = G.P_SEALS[v]
            end
            for i, v in pairs(card.ability.merged_cards.enhancements) do
                q[#q+1] = G.P_CENTERS[v]
            end
            for i, v in pairs(card.ability.merged_cards.editions) do
                q[#q+1] = G.P_CENTERS[v]
            end
        end
        return {
            vars = {
                card.ability.merged_cards and card.ability.merged_cards.cards or 0
            }
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
                if edition.calculate and type(edition.calculate) == 'function' then
                    local o = edition:calculate(dummy_card, context)
                    if o then
                        if not o.card then o.card = dummy_card end
                        ret = o
                    end
                end
                for i, v in pairs(ret or {}) do
                    SMODS.calculate_individual_effect(ret, card, i, v, false)
                end 
            end
            for i, v in pairs(card.ability.merged_cards.seals) do
                local ret = SCP.calc_seal_from_key(v, context, card)
                for i, v in pairs(ret or {}) do
                    SMODS.calculate_individual_effect(ret, card, i, v, false)
                end
            end
            for i, v in pairs(card.ability.merged_cards.enhancements) do
                local center = G.P_CENTERS[v]
                if center.set ~= 'Enhanced' then return nil end
                local dummy = SCP.get_dummy(center, card.area, card)
                local ret = eval_card(dummy, context)
                for i, v in pairs(ret or {}) do
                    SMODS.calculate_individual_effect(ret, card, i, v, false)
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