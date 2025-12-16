
local rarities = {
    [0] = "Junk",
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = SCP.thaumiel_rarity,
    [5] = "Legendary"
}

SMODS.Joker {
    key = "914",
    pos = {x = 8, y = 0},
    atlas = "customjokers",

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    cost = 4,
    rarity = 1,

    classification = "safe",

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local jokers = G.jokers.cards
            for i = 1, #jokers do
                if jokers[i] == card then
                    local joker_to_fucking_kill_oh_my_god = jokers[i-1]
                    if joker_to_fucking_kill_oh_my_god then
                        local rarity = joker_to_fucking_kill_oh_my_god.config.center.rarity
                        local min = -1
                        local max = 1
                        -- checking if probablity got tampered with
                        local numerator = SMODS.get_probability_vars(card, 1, 4,'J_SCP_914')
                        -- chance set to zero
                        if numerator <= 0 then
                            max = 0
                        end
                        -- chance was doubled
                        if numerator == 2 or not SCP.downside_active(card) then
                            min = 0
                        end
                        -- chance was beyond doubled
                        if numerator <= 3 then
                            min = 1
                        end
                        local which_way = pseudorandom("scp_914", min, max)
                        -- just hardcode d4
                        for _ = 1, #SMODS.find_card("j_entr_d4") do
                            local reroll = pseudorandom("scp_914", min, max)
                            which_way = math.max(which_way, reroll)
                        end
                        local created_card
                        -- hardcode the epic analog case, then the junk "rarity"
                        if joker_to_fucking_kill_oh_my_god.config.center.key == "j_scp_914_below_common" then
                            if not SCP.downside_active(card) or which_way == 1 then
                                created_card = SMODS.add_card{
                                    set = "Joker",
                                    key_append = "Common"
                                }
                            else
                                created_card = SMODS.add_card{
                                    key = "j_scp_914_below_common"
                                }
                            end
                        end
                        -- destroy AFTER the junk check
                        SMODS.destroy_cards(joker_to_fucking_kill_oh_my_god)
                        if rarity == "valk_renowned" or rarity == "cry_epic" or rarity == "scp_thaumiel" and not created_card then
                            if not SCP.downside_active(card) or which_way == 1 or which_way == 0 then
                                created_card = SMODS.add_card{
                                    set = "Joker",
                                    key_append = SCP.thaumiel_rarity
                                }
                            else
                                created_card = SMODS.add_card{
                                    set = "Joker",
                                    key_append = "Rare"
                                }
                            end
                        end
                        if not created_card and type(rarity) == "number" then
                            rarity = rarity+which_way
                        end
                        -- create the junk... if zero of course
                        if rarity == 0 and not created_card then
                            created_card = SMODS.add_card{
                                key = "j_scp_914_below_common"
                            }
                        else
                            created_card = SMODS.add_card{
                                set = "Joker",
                                key_append = rarities[rarity]
                            }
                        end
                        -- yo dawg i heard you liked loops so i put a loop in your loop so you can loop while looping
                        for j = 1, #jokers do
                            if jokers[j] == created_card then
                                if jokers[i+1] then
                                    jokers[i+1], jokers[j] = jokers[j], jokers[i+1]
                                end
                            end
                        end
                        
                        return {
                            message = localize('k_scp_914_processed')
                        }
                    end
                end
            end
        end
    end
}
SMODS.Joker {
    key = "914_below_common",
    pos = {x = 0, y = 0},
    --atlas = "jokers",

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    no_collection = true,
    in_pool = function()
        return false
    end,

    cost = 0,
    rarity = 1,

    classification = "junk",

    calculate = function(self, card, context)
        if context.joker_main then
            -- hardcoded on purpose
           return {
            chips = 0.5
           }
        end
    end
}