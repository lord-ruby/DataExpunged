SMODS.Joker {
    key = "426",
    pos = {x = 0, y = 0},
    atlas = "customjokers",
    config = { },
    classification = "euclid",
    cost = 1,
    rarity = 2,
    calculate = function(self, card, context)
    
    end,
}

SMODS.Enhancement {
    key = "toaster",
    pos = {x = 1, y = 0},
    atlas = "misc",
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    config = {
        bonus = 50,
        extra = {
            used = false,
            scored = false,
        }
    },
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