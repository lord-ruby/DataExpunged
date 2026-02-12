SMODS.Joker {
    key = "426",
    pos = {x = 0, y = 0},
    atlas = "customjokers",
    config = { },
    classification = "euclid",
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.blind:get_type() == 'Boss' then
            return {
                func = function()
                    SMODS.add_card({set = 'Enhanced', enhancement = 'm_scp_toaster', area = G.hand})
                end
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue +1] = G.P_CENTERS.m_scp_toaster
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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'scp_impersonate', set = 'Other'}
        return { vars = { card.ability.bonus } }
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

local old_cardareas_shuffle = CardArea.shuffle

function CardArea:shuffle(...)
    old_cardareas_shuffle(self, ...)
    if self == G.deck then
        local toasters = {}
        for i,v in ipairs(self.cards) do
            if SMODS.has_enhancement(v, 'm_scp_toaster') then
                table.insert(toasters, v)
                table.remove(self.cards, i)
            end
        end
        for i,v in ipairs(toasters) do
            table.insert(self.cards, v)
        end
        self:set_ranks()
    end
end