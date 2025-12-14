SMODS.Joker {
    key = "7176",
    pos = { x = 1, y = 0 },
    atlas = 'customjokers',
    config = { extra = {
        numerator = 1,
        denominator = 3
    } },
    classification = "euclid",
    cost = 7, -- dummy price, update later
    rarity = 2,
    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator,
            card.ability.extra.denominator,
            'j_scp_7176')
        return { vars = { new_numerator, new_denominator } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and context.main_eval then
            if G.GAME.chips / G.GAME.blind.chips <= 0.25 then
                local roll = SMODS.pseudorandom_probability(card, 'breaching!', card.ability.extra.numerator,
                    card.ability.extra.denominator, 'j_scp_7176')
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        if roll then
                            SCP.containment_breach(card, "j_scp_7176-A")
                        else
                            card:juice_up()
                        end
                        return true
                    end
                }))
                return {
                    message = localize('k_saved_ex'),
                    saved = roll and 'ph_scp_7176_alt' or 'ph_scp_7176',
                    colour = G.C.MONEY
                }
            end
        end
    end,
}

SMODS.Joker {
    key = "7176-A",
    pos = { x = 2, y = 0 },
    atlas = 'customjokers',
    config = {
        eternal = true,
        extra = {
        } },
    classification = "thaumiel",
    cost = 0,
    eternal_compat = true,
    perishable_compat = false,
    rarity = SCP.thaumiel_rarity,
    loc_vars = function(self, info_queue, card)
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and SMODS.last_hand_oneshot then
            if G.GAME.chips / G.GAME.blind.chips >= 2.0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        SCP.clean_swap(card, "j_scp_7176")
                        return true
                    end
                }))
            end
        end
    end,
}

local get_blind_amount_orig = get_blind_amount
function get_blind_amount(ante)
    local normal_amount = get_blind_amount_orig(ante)
    if not G.jokers or not G.jokers.cards then return end
    return next(SMODS.find_card("j_scp_7176-A")) and (normal_amount * 3) or normal_amount
end
