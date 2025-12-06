SMODS.Joker {
    key = "code_name_dr_mann",
    pos = {x = 0, y = 0},
    --atlas = "jokers",

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    cost = 10,
    rarity = 4,

    classification = "proposal",

    calculate = function(self, card, context)
        if context.add_scoring_cards_check then
            local cards = {}
            for j = 2, #context.scoring_hand do
                for i, v in pairs(context.scoring_hand) do
                    if j <= i then
                        cards[#cards+1] = v
                    end
                end
            end
            return {
                scoring_hand = cards,
            }
        end
    end
}

local calc_main_scoring = SMODS.calculate_main_scoring
function SMODS.calculate_main_scoring(context, scoring_hand)
    local cards, messages = SCP.get_scored_cards(context.scoring_hand)
    G.rescore_messages = messages or {}
    if context.cardarea ~= G.play or not cards then
	    calc_main_scoring(context, context.scoring_hand)
    end
	if context.cardarea == G.play and cards then
        if not G.rescore_cards or #G.rescore_cards.cards == 0 then
            G.rescore_cards = {cards = cards}
        end
		context.cardarea = G.rescore_cards
        context.scoring_hand = G.rescore_cards.cards
		calc_main_scoring(context, G.rescore_cards.cards)
		context.cardarea = G.play
        G.rescore_cards = nil
	end
    G.rescore_messages = {}
	return
end

function SCP.get_scored_cards(scored_cards)
    local messages = {}
    local cards 
    local first = true
    for i, v in pairs(SMODS.get_card_areas("jokers")) do
        for _, card in pairs(v.cards) do
            local ret = card:calculate_joker({set_scoring_cards_check = true, scoring_hand = scored_cards, first = first})
            if ret and ret.scoring_hand then
                cards = cards or {}
                SCP.merge_tables(cards, ret.scoring_hand)
            end

            local ret2 = card:calculate_joker({add_scoring_cards_check = true, scoring_hand = scored_cards, first = first})
            first = false
            if ret2 and ret2.scoring_hand then
                if not cards then
                    cards = {}
                    for i, v in pairs(scored_cards) do 
                        cards[#cards+1] = v 
                    end
                end
                for i, v in pairs(ret2.scoring_hand) do
                    cards[#cards+1] = v 
                    messages[#cards] = {message = ret2.message or localize("k_rescore_ex"), card = ret2.card or card}
                end
            end
        end
    end
    return cards, messages
end
