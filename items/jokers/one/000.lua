SMODS.Joker {
    key = "000",
    pos = {x = 6, y = 0},
    atlas = "customjokers",
    config = { extra = { joker_slots = 1 } },
    classification = "null",
    cost = 6, -- dummy price, update later
    rarity = 1,
    calculate = function(self, card, context)

    end,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
    end
}