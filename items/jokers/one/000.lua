SMODS.Joker {
    key = "000",
    pos = {x = 0, y = 0},
    config = { extra = { joker_slots = 1 } },
    classification = "null",
    cost = 6, -- dummy price, update later
    rarity = 1,
    calculate = function(self, card, context)
        if context.buying_card and context.card.config.center.key == self.key and context.cardarea == G.jokers  then
            return {
                func = function()
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(1).." Joker Slot", colour = G.C.DARK_EDITION})
                    G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
                    return true
                end
            }
        end
        if context.selling_self  then
            return {
                func = function()
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "-"..tostring(1).." Joker Slot", colour = G.C.RED})
                    G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - card.ability.extra.joker_slots)
                    return true
                end
            }
        end
    end
}