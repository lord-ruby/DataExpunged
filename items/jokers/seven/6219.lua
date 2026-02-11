SMODS.Joker {
    key = "6219",
    pos = {x = 4, y = 1},
    atlas = "customjokers",
    config = { extra = {
        mult = 0,
        xmult = 1,
        chips = 0,
        xmult_inc = 1,
        mult_inc = 5,
        chips_inc = 50,
        numerator = 1,
        denominator = 4,
        busy = false
    }},
    classification = "pending",
    cost = 7,
    rarity = 1,

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator,
            card.ability.extra.denominator,
            'j_scp_6219')
        return { vars = { new_numerator, new_denominator, card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)

        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult,
            }
        end

        if context.final_scoring_step then
            card.ability.extra.mult = 0
            card.ability.extra.xmult = 1
            card.ability.extra.chips = 0
            for i,v in ipairs(G.jokers.cards) do
                SMODS.debuff_card(v, false, "SCP-6219")
            end
        end

    end,

    can_use_scp = function(self, card)
        if SCP.Shadervars.blackout.runtime > 0 then
            return false
        end
        return true
    end,

    use_scp = function(self, card)
        G.E_MANAGER:add_event(Event({
            blockable = false,
            func = function()
                if not SMODS.pseudorandom_probability(card, 'applysilverrodtofae', card.ability.extra.numerator,
                    card.ability.extra.denominator, 'j_scp_6219')
                then
                    local var = pseudorandom_element({"mult", "xmult", "chips", "mult", "chips", "mult", "chips"}, "skinburns") or "chips"
                    card.ability.extra[var] = card.ability.extra[var] + card.ability.extra[var .. "_inc"]
                    card:juice_up()
                    play_sound(var == "chips" and "chips1" or var == "mult" and "multhit1" or var == "xmult" and "multhit2")
                else

                    SCP.Shadervars.blackout.runtime = 250

                    local list = {}
                    for i,v in ipairs(G.jokers.cards) do
                        if (((not SCP.downside_active(card)) and (not next(v.ability.debuff_sources))) or SCP.downside_active(card)) and v ~= card then
                            table.insert(list, v)
                        end
                        if #G.jokers.cards == 1 then
                            table.insert(list, card)
                        end
                    end
                    local to_kill = pseudorandom_element(list, "employeemissing")
                    if SCP.downside_active(card) and to_kill then
                        G.E_MANAGER:add_event(Event({
                            blockable = false,
                            func = (function()
                                play_sound('whoosh2', math.random()*0.2 + 0.9,0.5)
                                play_sound('crumple'..math.random(1, 5), math.random()*0.2 + 0.9,0.5)
                            return true end)
                        }))
                        SMODS.destroy_cards(to_kill, false, true, true)
                    elseif to_kill then
                        SMODS.debuff_card(to_kill, true, "SCP-6219")
                    end
                end
                return true
            end
        }))
        local _card = card
        G.E_MANAGER:add_event(Event({
            blockable = false,
            blocking = false,
            delay = 5,
            func = function()
                
                if SCP.Shadervars.blackout.runtime <= 0 and not SCP.Shadervars.blackout.shown then
                    if _card then _card.states.hover.can = true end
                    if _card then _card.states.click.can = true end
                    if _card then _card.states.drag.can = true end
                    return true
                end
                _card.states.hover.can = false
                _card.states.click.can = false
                _card.states.drag.can = false
                return false
            end
        }))
    end,
}