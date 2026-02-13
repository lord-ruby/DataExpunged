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
        scp_toaster = true,
        scp_toaster_areas = {'hand'},
        extra = {
            used = false,
            scored = false,
        }
    },
    calculate = function(self, card, context)

    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'scp_impersonate', set = 'Other'}
        return { vars = { card.ability.bonus } }
    end,
}

SCP.custom_card_areas = function(game)
    game.toaster = CardArea(
        nil, nil, nil, nil, {type = "scp_toaster", no_card_count = true, }
    )
    game.toaster.states.visible = false
end

function SCP.toaster_init()
    --Jesse we need to cook
    local g_play_metatable = getmetatable(G.play)
    local g_toaster_metatable = getmetatable(G.toaster)

    local equals_function = function(a,b)
        if (rawequal(a, G.play) or rawequal(a, G.toaster)) and
        (rawequal(b, G.play) or rawequal(b, G.toaster)) then
            return true
        end
        return rawequal(a, b)
    end

    g_play_metatable.__eq = equals_function
    g_toaster_metatable.__eq = equals_function

    setmetatable(G.play, g_play_metatable)
    setmetatable(G.toaster, g_play_metatable)
end

SCP.id_to_toaster_old = {}
function SCP.toaster_round_prep(scoring_hand)
    local toasters = {}
    for _, area in ipairs(SMODS.get_card_areas('playing_cards')) do
        for i,v in ipairs(area.cards) do
            if v.ability.scp_toaster and v.ability.scp_toaster_areas then
                for __, allowed in ipairs(v.ability.scp_toaster_areas) do
                    if G[allowed] == area then
                        table.insert(toasters, v)
                    end
                end
            end
        end
    end
    
    local new_full_hand = {}
    local new_scoring_hand = {}
    if next(toasters) then
        local scoring_index = 1
        for i,v in ipairs(G.play.cards) do
            if v == scoring_hand[scoring_index] and next(toasters) then
                SCP.id_to_toaster_old[toasters[1].ID] = {
                    center = SMODS.shallow_copy(toasters[1].config.center),
                    card = SMODS.shallow_copy(toasters[1].config.card),
                    ability = SMODS.shallow_copy(toasters[1].ability),
                    edition = toasters[1].edition and SMODS.shallow_copy(toasters[1].edition) or nil,
                    seal = toasters[1].seal,
                    suit = toasters[1].config.card.suit,
                    rank = toasters[1].config.card.value,
                    played_ability = SMODS.shallow_copy(v.ability)
                }
                toasters[1].config.center = SMODS.shallow_copy(v.config.center)
                toasters[1].config.card = SMODS.shallow_copy(v.config.card)
                toasters[1].ability = SMODS.shallow_copy(v.ability)
                toasters[1].edition = v.edition and SMODS.shallow_copy(v.edition) or nil
                toasters[1].seal = v.seal
                toasters[1].ability.scp_toaster = true
                toasters[1].ability.scp_toaster_areas = SMODS.shallow_copy(SCP.id_to_toaster_old[toasters[1].ID].ability.scp_toaster_areas)
                assert(SMODS.change_base(toasters[1], v.config.card.suit, v.config.card.value))
                new_full_hand[#new_full_hand+1] = toasters[1]
                new_scoring_hand[#new_scoring_hand+1] = toasters[1]
                table.remove(toasters, 1)
                scoring_index = scoring_index + 1
            elseif v == scoring_hand[scoring_index] and not next(toasters) then
                new_full_hand[#new_full_hand+1] = v
                new_scoring_hand[#new_scoring_hand+1] = v
                scoring_index = scoring_index + 1
            else
                new_full_hand[#new_full_hand+1] = v
            end
        end
        return new_full_hand, new_scoring_hand
    end

    return {}, scoring_hand

end

function SCP.toaster_round_cleanup()
    for i,v in ipairs(G.toaster.cards) do
        if v.ability.scp_toaster and SCP.id_to_toaster_old[v.ID] then
            local old = SCP.id_to_toaster_old[v.ID]
            v.config.center = SMODS.shallow_copy(old.center)
            v.config.card = SMODS.shallow_copy(old.card)
            v.edition = old.edition and SMODS.shallow_copy(old.edition) or nil
            v.seal = old.seal
            assert(SMODS.change_base(v, old.suit, old.rank))
            for j, abil in pairs(v.ability) do
                if type(abil) == 'number' then
                        v.ability[j] =  (abil - (old.played_ability[j] or 0)) + (old.ability[j] or 0)
                else
                    v.ability[j] = old.ability[j]
                end
            end
        end
    end
    SCP.id_to_toaster_old = {}
    G.toaster.cards = {}
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