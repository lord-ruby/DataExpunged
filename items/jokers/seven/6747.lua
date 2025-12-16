SMODS.Joker {
    key = "6747",
    pos = {x = 0, y = 0},
    config = { extra = { active = false } },
    classification = "thaumiel",
    cost = 14,
    rarity = SCP.thaumiel_rarity,
    eternal_compat = false,
    perishable_compat = true,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if SCP.end_of_round(context) and SCP.downside_active(card) and not card.ability.extra.active then
            card.ability.extra.active = true
            local eval = function() return not card.ability.triggered and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
            return {
                message = localize("k_active_ex"),
                colour = G.C.SCP_THAUMIEL
            }
        end
        if context.selling_self and (card.ability.extra.active or not SCP.downside_active(card)) then
            if SCP.area_has_room("joker") then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 2
                G.E_MANAGER:add_event(Event{
                    func = function()
                        local c = SMODS.add_card{
                            key = "j_scp_6747-A3",
                            area = G.jokers
                        }
                        c.ability.eternal = true
                        return true
                    end
                })
                G.E_MANAGER:add_event(Event{
                    func = function()
                        local c = SMODS.add_card{
                            key = "j_scp_6747-B",
                            area = G.jokers,
                            eternal = true
                        }
                        c.ability.eternal = true
                        G.GAME.joker_buffer = 0
                        return true
                    end
                })
            end
        end
    end,
    loc_vars = function(self, q, card)
        return {
            vars = {
                card.ability.extra.active and localize("k_active") or localize("k_inactive")
            }
        }
    end,
}

--Does nothing just -1 Joker slots until 6747-B is fufilled
SMODS.Joker {
    key = "6747-A3",
    pos = {x = 0, y = 0},
    config = { },
    classification = "thaumiel",
    cost = 14,
    rarity = SCP.thaumiel_rarity,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = false,
    no_collection = true,
    in_pool = function() return false end
}

SMODS.Joker {
    key = "6747-B",
    pos = {x = 0, y = 0},
    config = { extra = {needed_sacrifices = 3, sacrifices = 0} },
    classification = "thaumiel",
    cost = 14,
    rarity = SCP.thaumiel_rarity,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.setting_blind then
            local jokers = {}
            local jokers_pure = {}
            for i, v in pairs(G.jokers.cards) do
                if v.config.center_key ~= "j_scp_6747-A3" and v.config.center_key ~= "j_scp_6747-B" and v.config.center_key ~= "j_scp_6747-C" and not SMODS.is_eternal(v) then
                    jokers[#jokers+1] = v
                    if not v.ability.perishable and not v.ability.rental then
                        jokers_pure[#jokers_pure +1] = v
                    end
                end
            end
            local trig
            if #jokers_pure > 0 then jokers = jokers_pure end
            if #jokers > 0 or not SCP.downside_active(card) then
                card.ability.extra.sacrifices = card.ability.extra.sacrifices + 1
                trig = true
            end
            if SCP.downside_active(card) then
                local joker = pseudorandom_element(jokers, pseudoseed("j_scp_6747-B"))
                if joker then
                    local key = joker.config.center_key
                    joker:start_dissolve()
                    local joker2 = SMODS.add_card{
                        key = key,
                        area = G.jokers
                    }
                    --bypass compatibility
                    if pseudorandom("j_scp_6747-B2") < 0.5 then
                        joker2.ability.perish_tally = 3
                        joker2.ability.perishable = true
                    else
                        joker2.ability.rental = true
                    end
                end
            end
            if trig then
                if card.ability.extra.sacrifices < card.ability.extra.needed_sacrifices then
                    return {
                        message = number_format(card.ability.extra.sacrifices).."/"..number_format(card.ability.extra.needed_sacrifices),
                        colour = G.C.SCP_THAUMIEL
                    }
                else
                    for i, v in pairs(G.jokers.cards) do
                        if v.config.center.key == "j_scp_6747-A3" or v.config.center.key == "j_scp_6747-B" then
                            v:start_dissolve()
                        end
                    end
                    SMODS.add_card{
                        key = "j_scp_6747-C",
                        area = G.jokers
                    }
                end
            end
        end
    end,
    loc_vars = function(self, q, card)
        return {
            vars = {
                card.ability.extra.needed_sacrifices,
                card.ability.extra.sacrifices
            }
        }
    end,
    no_collection = true,
    in_pool = function() return false end
}

SMODS.Joker {
    key = "6747-C",
    pos = {x = 0, y = 0},
    config = {  },
    classification = "thaumiel",
    cost = 14,
    rarity = SCP.thaumiel_rarity,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.consumeable.config.center.hidden then
            if not G.GAME.scp_ante_consumables then G.GAME.scp_ante_consumables = {} end
            if not G.GAME.scp_ante_consumables[context.consumeable.config.center_key] then
                if SCP.area_has_room("consumeable") then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                     G.E_MANAGER:add_event(Event{
                        func = function()
                            local cons = context.consumeable
                            local copy = copy_card(cons)
                            copy:add_to_deck()
                            G.consumeables:emplace(copy)
                            G.GAME.scp_ante_consumables[context.consumeable.config.center_key] = true
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    })
                    return {
                        message = localize("k_copied_ex"),
                        colour = G.C.SCP_THAUMIEL
                    }
                end
            end
        end
        if context.ante_end then
            G.GAME.scp_ante_consumables = {}
        end
    end,
    no_collection = true,
    in_pool = function() return false end
}