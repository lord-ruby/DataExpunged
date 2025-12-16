SMODS.Joker({
	key = "342",
	pos = {x = 7, y = 0},
    atlas = "customjokers",

	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,

	cost = 8,
	rarity = 2,

	classification = "euclid",

    config = {
        eternal = true
    },

	add_to_deck = function(self, card)
		for k, v in pairs(G.I.CARD) do
			if v.set_cost then
				v:set_cost()
			end
		end
	end,
	remove_from_deck = function(self, card)
		for k, v in pairs(G.I.CARD) do
			if v.set_cost then
				v:set_cost()
			end
		end
	end,

	in_pool = function(self)
		return not next(SMODS.find_card("j_scp_342"))
	end,

	loc_vars = function(self, info_queue, card)
		return {
			vars = { 1 },
		}
	end,
})

local old_set_cost = Card.set_cost
function Card:set_cost(...)
	local result = old_set_cost(self, ...)
	local _, card = next(SMODS.find_card("j_scp_342"))
	if card then
		self.cost = 0
		self.sell_cost = 0
		self.sell_cost_label = self.facing == "back" and "?" or self.sell_cost
	end
	return result
end

local ease_ante_ref = ease_ante
function ease_ante(amount, ...)
	local _, card = next(SMODS.find_card("j_scp_342"))
	if SMODS.ante_end and card and SCP.downside_active(card) then
		amount = amount + 1
	end
	return ease_ante_ref(amount, ...)
end
