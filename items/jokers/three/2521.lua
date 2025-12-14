--haha funny 2521 but please keep the code organised
SMODS.Joker {
    key = "2521",
    pos = {x = 3, y = 0},
    atlas = "customjokers",
    config = { extra = { cards = 3 } },
    classification = "keter",
    cost = 6, -- dummy price, update later
    rarity = 3,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
          for i = 1, card.ability.extra.cards do  
              local _card = SMODS.create_card { key = "m_scp_tendril", area = G.discard }
              G.playing_card = (G.playing_card and G.playing_card + 1) or 1
              _card.playing_card = G.playing_card
              table.insert(G.playing_cards, _card)

              G.E_MANAGER:add_event(Event({
                  func = function()
                      G.hand:emplace(_card)
                      _card:start_materialize()
                      G.GAME.blind:debuff_card(_card)
                      G.hand:sort()
                      if context.blueprint_card then
                          context.blueprint_card:juice_up()
                      else
                          card:juice_up()
                      end
                      SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                      save_run()
                      return true
                  end
              }))
            end
            return nil, true
        end
    end,
    loc_vars = function(self, q, card)
      if SCP.config.accessibility_mode then
        q[#q+1] = G.P_CENTERS.m_scp_tendril
      end
      return {
        vars = {
          card.ability.extra.cards
        },
        key = SCP.config.accessibility_mode and "j_scp_2521_accessibility" or nil
      }
    end
}

SMODS.Font {
  key = "2521",
  path = "2521.ttf"
}

local eval_card_ref = eval_card
function eval_card(card, ...)
    if card and not card.getting_sucked then
        return eval_card_ref(card, ...)
    end
end


SMODS.Enhancement {
    key = "tendril",
    pos = {x = 0, y = 0},
    atlas = "misc",
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    scp_temporary = true,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
			local index
			local cond
			local cards = {}
			for i, v in pairs(G.play.cards) do
				if not v.getting_sucked then
					cards[#cards+1] = v
				end
			end
			for i, v in pairs(cards) do if v == card then index = i end end
			if cards[index - 1] then
				cond = true
				local c = cards[index-1]
				if c and not c.getting_sucked and c ~= card then
					c.getting_sucked = true
					SMODS.destroy_cards(c)
				end
			end
			if cards[index + 1] then
				cond = true
				local c = cards[index+1]
				if c and not c.getting_sucked and c ~= card then
					c.getting_sucked = true
					SMODS.destroy_cards(c)
				end
			end
			if cond then
				return {
				message = "X"
				}
			end
        end
    end,
    loc_vars = function(self, q, card)
      return {
        key = SCP.config.accessibility_mode and "m_scp_tendril_accessibility" or nil
      }
    end
}

local end_round_ref = end_round
function end_round(...)
    end_round_ref(...)
    local temp = {}
    for i, v in pairs(G.playing_cards) do
        if v.config.center.scp_temporary then
            temp[#temp+1] = v
        end
    end
    SMODS.destroy_cards(temp)
end