SMODS.Joker {
    key = "005",
    pos = {x = 0, y = 0},
    config = { extra = { boo = true } },
    classification = "safe",
    cost = 4, -- dummy price, update later
    rarity = 1,
    calculate = function(self, card, context)

    end,
    
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end
} 
      
local card_set_cost_ref = Card.set_cost
function Card:set_cost()
    card_set_cost_ref(self)
    
    if next(SMODS.find_card("j_scp_005")) then
        if self.ability.set == 'Booster' then
            self.cost = 0
            self.sell_cost = 0
            self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
        end
    end
end