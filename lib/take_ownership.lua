local Spectrals = {
    c_familiar = {
        use = function(self, card)
            local used_tarot = copier or card
            local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_tarot:juice_up(0.3, 0.5)
                    return true
                end
            }))
            if SCP.downside_active(card) then
                SMODS.destroy_cards(card_to_destroy)
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    local cards = {}
                    for i = 1, card.ability.extra do
                        local faces = {}
                        for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
                            local rank = SMODS.Ranks[rank_key]
                            if rank.face then table.insert(faces, rank) end
                        end
                        local _rank = pseudorandom_element(faces, 'familiar_create').card_key
                        local cen_pool = {}
                        for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                                cen_pool[#cen_pool + 1] = enhancement_center
                            end
                        end
                        local enhancement = pseudorandom_element(cen_pool, 'spe_card')
                        cards[i] = SMODS.add_card { set = "Base", rank = _rank, enhancement = enhancement.key }
                    end
                    SMODS.calculate_context({ playing_card_added = true, cards = cards })
                    return true
                end
            }))
            delay(0.3)
        end,
        loc_vars = function(self, q, card)
            return {
                vars = {
                    card.ability.extra
                },
                key = not SCP.downside_active(card) and (self.key.."_nodownside") or nil
            }
        end,
    },
    c_grim = {
        use = function(self, card)
            local used_tarot = copier or card
            local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_tarot:juice_up(0.3, 0.5)
                    return true
                end
            }))
            if SCP.downside_active(card) then
                SMODS.destroy_cards(card_to_destroy)
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    local cards = {}
                    for i = 1, card.ability.extra do
                        local cen_pool = {}
                        for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                                cen_pool[#cen_pool + 1] = enhancement_center
                            end
                        end
                        local enhancement = pseudorandom_element(cen_pool, 'spe_card')
                        cards[i] = SMODS.add_card { set = "Base", rank = 'Ace', enhancement = enhancement.key }
                    end
                    SMODS.calculate_context({ playing_card_added = true, cards = cards })
                    return true
                end
            }))
            delay(0.3)
        end,
        loc_vars = function(self, q, card)
            return {
                vars = {
                    card.ability.extra
                },
                key = not SCP.downside_active(card) and (self.key.."_nodownside") or nil
            }
        end,
    },
    c_incantation = {
        use = function(self, card)
            local used_tarot = copier or card
            local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_tarot:juice_up(0.3, 0.5)
                    return true
                end
            }))
            if SCP.downside_active(card) then
                SMODS.destroy_cards(card_to_destroy)
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    local cards = {}
                    for i = 1, card.ability.extra do
                        local numbers = {}
                        for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
                            local rank = SMODS.Ranks[rank_key]
                            if rank_key ~= 'Ace' and not rank.face then table.insert(numbers, rank) end
                        end
                        local _rank = pseudorandom_element(numbers, 'incantation_create').card_key
                        local cen_pool = {}
                        for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                                cen_pool[#cen_pool + 1] = enhancement_center
                            end
                        end
                        local enhancement = pseudorandom_element(cen_pool, 'spe_card')
                        cards[i] = SMODS.add_card { set = "Base", rank = _rank, enhancement = enhancement.key }
                    end
                    SMODS.calculate_context({ playing_card_added = true, cards = cards })
                    return true
                end
            }))
            delay(0.3)
        end,
        loc_vars = function(self, q, card)
            return {
                vars = {
                    card.ability.extra
                },
                key = not SCP.downside_active(card) and (self.key.."_nodownside") or nil
            }
        end,
    },
    c_wraith = {
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Joker', rarity = 'Rare' })
                    card:juice_up(0.3, 0.5)
                    if G.GAME.dollars ~= 0 and SCP.downside_active(card) then
                        ease_dollars(-G.GAME.dollars, true)
                    end
                    return true
                end
            }))
            delay(0.6)
        end,
        loc_vars = function(self, q, card)
            return {
                key = not SCP.downside_active(card) and (self.key.."_nodownside") or nil
            }
        end,
    },
    c_ouija = {
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_tarot:juice_up(0.3, 0.5)
                    return true
                end
            }))
            for i = 1, #G.hand.cards do
                local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip()
                        play_sound('card1', percent)
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end
            local _rank = pseudorandom_element(SMODS.Ranks, 'ouija')
            for i = 1, #G.hand.cards do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local _card = G.hand.cards[i]
                        assert(SMODS.change_base(_card, nil, _rank.key))
                        return true
                    end
                }))
            end
            if SCP.downside_active(card) then
                G.hand:change_size(-1)
            end
            for i = 1, #G.hand.cards do
                local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip()
                        play_sound('tarot2', percent, 0.6)
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end
            delay(0.5)
        end,
        loc_vars = function(self, q, card)
            return {
                key = not SCP.downside_active(card) and (self.key.."_nodownside") or nil
            }
        end,
    },
    c_ectoplasm = {
        use = function(self, card, area, copier)
        local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local eligible_card = pseudorandom_element(editionless_jokers, 'ectoplasm')
                    eligible_card:set_edition({ negative = true })

                    if SCP.downside_active(card) then
                        G.GAME.ecto_minus = G.GAME.ecto_minus or 1
                        G.hand:change_size(-G.GAME.ecto_minus)
                        G.GAME.ecto_minus = G.GAME.ecto_minus + 1
                    end
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end,
        loc_vars = function(self, q, card)
            return {
                vars = {
                    G.GAME.ecto_minus
                },
                key = not SCP.downside_active(card) and (self.key.."_nodownside") or nil
            }
        end,
    },
    c_ankh = {
        use = function(self, card, area, copier)
            local deletable_jokers = {}
            for _, joker in pairs(G.jokers.cards) do
                if not SMODS.is_eternal(joker, card) then deletable_jokers[#deletable_jokers + 1] = joker end
            end

            local chosen_joker = pseudorandom_element(G.jokers.cards, 'ankh_choice')
            local _first_dissolve = nil
            if SCP.downside_active(card) then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.75,
                    func = function()
                        for _, joker in pairs(deletable_jokers) do
                            if joker ~= chosen_joker then
                                joker:start_dissolve(nil, _first_dissolve)
                                _first_dissolve = true
                            end
                        end
                        return true
                    end
                }))
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.4,
                func = function()
                    local copied_joker = copy_card(chosen_joker, nil, nil, nil,
                        chosen_joker.edition and chosen_joker.edition.negative)
                    copied_joker:start_materialize()
                    copied_joker:add_to_deck()
                    if copied_joker.edition and copied_joker.edition.negative then
                        copied_joker:set_edition(nil, true)
                    end
                    G.jokers:emplace(copied_joker)
                    return true
                end
            }))
        end,
        loc_vars = function(self, q, card)
            return {
                key = not SCP.downside_active(card) and (self.key.."_nodownside") or nil
            }
        end,
    },
    c_hex = {
        use = function(self, card, area, copier)
            local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local eligible_card = pseudorandom_element(editionless_jokers, 'hex')
                    eligible_card:set_edition({ polychrome = true })
                    if SCP.downside_active(card) then
                        local _first_dissolve = nil
                        for _, joker in pairs(G.jokers.cards) do
                            if joker ~= eligible_card and not SMODS.is_eternal(joker, card) then
                                joker:start_dissolve(nil, _first_dissolve)
                                _first_dissolve = true
                            end
                        end
                    end
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end,
        loc_vars = function(self, q, card)
            return {
                key = not SCP.downside_active(card) and (self.key.."_nodownside") or nil
            }
        end,
    },
}

for i, v in pairs(Spectrals) do
    SMODS.Consumable:take_ownership(i, v, true)
end