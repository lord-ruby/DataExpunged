SMODS.Joker {
    key = "005",
    pos = {x = 0, y = 0},
    config = { extra = { boo = true } },
    classification = "safe",
    cost = 4, -- dummy price, update later
    rarity = 3, --why the fuck was this a common. anyways idk if it should be rare or epic or whatever
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
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
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
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
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
    
    if next(SMODS.find_card("j_modprefix_astronomercopy")) then
        if (self.ability.set == 'Tarot' or (self.ability.set == 'Booster' and self.config.center.kind == 'Arcana')) then
            self.cost = 0
        end
    end
    
    if next(SMODS.find_card("j_modprefix_astronomercopy")) then
        if (self.ability.set == 'Planet' or (self.ability.set == 'Booster' and self.config.center.kind == 'Celestial')) then
            self.cost = 0
        end
    end
    
    if next(SMODS.find_card("j_modprefix_astronomercopy")) then
        if (self.ability.set == 'Spectral' or (self.ability.set == 'Booster' and self.config.center.kind == 'Spectral')) then
            self.cost = 0
        end
    end
    
    if next(SMODS.find_card("j_modprefix_astronomercopy")) then
        if (self.ability.set == 'Enhanced' or (self.ability.set == 'Booster' and self.config.center.kind == 'Standard')) then
            self.cost = 0
        end
    end
    
    self.sell_cost = math.max(1, math.floor(self.cost / 2)) + (self.ability.extra_value or 0)
    self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
end
