SMODS.Joker {
    key = "9020",
    pos = {x = 5, y = 1},
    atlas = "customjokers",
    config = { extra = {upgrade_chance = 1, upgrade_total = 20}},
    classification = "thaumiel",
    cost = 10,
    rarity = SCP.thaumiel_rarity,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.upgrade_chance = card.ability.extra.upgrade_chance + 1
            card.ability.extra.upgrade_total = card.ability.extra.upgrade_total + 1
        end
        if context.modify_shop_card then
            if context.card.ability.set == "Joker" then
                if pseudorandom('apotheosis', 1, card.ability.extra.upgrade_total) <= card.ability.extra.upgrade_chance then

                    local orig_rarity = context.card.config.center.rarity
                    local _rarity
                    local _pool
                    if type(orig_rarity) == "string" then
                        _rarity = SMODS.deepfind(SMODS.ObjectTypes['Joker'].rarities, orig_rarity, "v", true)[1].tree[1]
                        _rarity = (_rarity) < #SMODS.ObjectTypes['Joker'].rarities and _rarity + 1 or _rarity
                        _pool = SMODS.get_clean_pool('Joker', SMODS.ObjectTypes['Joker'].rarities[_rarity].key, nil, pseudoseed('apotheosis'))
                    else
                        _rarity = (orig_rarity) < #SMODS.ObjectTypes['Joker'].rarities and orig_rarity + 1 or orig_rarity
                        _pool = SMODS.get_clean_pool('Joker', SMODS.ObjectTypes['Joker'].rarities[_rarity].key, nil, pseudoseed('apotheosis'))
                    end

                    local _key = pseudorandom_element(_pool, pseudoseed('upgrades'))

                    SCP.clean_swap(context.card, _key or 'j_joker')

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blocking = false;
                        delay = 2.25,
                        func = function()
                            context.card:set_cost()
                            return true
                        end
                    }))
                end
            end
        end
        if context.SCP_modify_booster_card then
            local _card = context.card_to_create
                if _card.ability.set == "Joker" then
                    if pseudorandom('apotheosis', 1, card.ability.extra.upgrade_total) <= card.ability.extra.upgrade_chance then
                        local orig_rarity = _card.config.center.rarity
                        local _rarity
                        local _pool
                        if type(orig_rarity) == "string" then
                            _rarity = SMODS.deepfind(SMODS.ObjectTypes['Joker'].rarities, orig_rarity, "v", true)[1].tree[1]
                            _rarity = (_rarity) < #SMODS.ObjectTypes['Joker'].rarities and _rarity + 1 or _rarity
                            _pool = SMODS.get_clean_pool('Joker', SMODS.ObjectTypes['Joker'].rarities[_rarity].key, nil, pseudoseed('apotheosis'))
                        else
                            _rarity = (orig_rarity) < #SMODS.ObjectTypes['Joker'].rarities and orig_rarity + 1 or orig_rarity
                            _pool = SMODS.get_clean_pool('Joker', SMODS.ObjectTypes['Joker'].rarities[_rarity].key, nil, pseudoseed('apotheosis'))
                        end

                    local _key = pseudorandom_element(_pool, pseudoseed('upgrades'))
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            blocking = false;
                            func = function()
                                SCP.clean_swap(_card, _key or 'j_joker')
                                return true
                            end
                        }))
                        
                    end
                end
        end
    end,
}

