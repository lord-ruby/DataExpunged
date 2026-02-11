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

SMODS.Enhancement {
    key = "toaster",
    pos = {x = 0, y = 0},
    atlas = "misc",
    always_scores = true,
    config = { extra = {
        used = false,
        scored = false,
    }   },
    calculate = function(self, card, context)

        if context.press_play then
            card.ability.extra.used = false
            card.ability.extra.scored = false
            
            for i,v in ipairs (G.hand.cards) do
                if v == card then
                    if type(G.toaster) == 'table' then G.toaster[#G.toaster+1] = v else G.toaster = {}; G.toaster[#G.toaster+1] = v end
                    if type(G.toasterCopy) == 'table' then 
                        G.toasterCopy[#G.toasterCopy+1] = {
                            center = SMODS.shallow_copy(v.config.center),
                            card = SMODS.shallow_copy(v.config.card),
                            suit = v.config.card.suit,
                            rank = v.config.card.value
                        }
                    else
                        G.toasterCopy = {} 
                        G.toasterCopy[#G.toasterCopy+1] = {
                            center = SMODS.shallow_copy(v.config.center),
                            card = SMODS.shallow_copy(v.config.card),
                            suit = v.config.card.suit,
                            rank = v.config.card.value
                        }
                    end
                end
            end
        end
    end,
}

local old_in_scoring = SMODS.in_scoring
function SMODS.in_scoring(card, area, ...)
    if G.beforetoastscoringhand then
        for i,v in ipairs(G.beforetoastscoringhand) do
            if v == card then
                return true
            end
        end
    end
    
    return old_in_scoring(card, area, ...)
end

local old_evaluate_play = G.FUNCS.evaluate_play

G.FUNCS.evaluate_play = function(...)
    old_evaluate_play(...)
    for i,v in ipairs(G.toaster) do
        v.config.center = SMODS.shallow_copy(G.toasterCopy[i].center)
        v.config.card = SMODS.shallow_copy(G.toasterCopy[i].card)
        assert(SMODS.change_base(v, G.toasterCopy[i].suit, G.toasterCopy[i].rank))
    end
    G.toaster = nil
    G.toasterCopy = nil
end