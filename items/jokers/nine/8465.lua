SCP.NOISE_FRAMES = 0

SMODS.Joker {
    key = "8465",
    pos = { x = 0, y = 0 },
    atlas = "customjokers",

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    cost = 8,
    rarity = 1,
    config = {
        extra = {
            roll = false,
            numerator = 1,
            denominator = 2
        }
    },

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator,
            card.ability.extra.denominator,
            'j_scp_8465')
        return { vars = { new_numerator, new_denominator } }
    end,

    classification = "safe",
    calculate = function(self, card, context)
        if context.press_play then
            card.ability.extra.roll = SMODS.pseudorandom_probability(card, 'oohimdupingit', card.ability.extra.numerator,
                card.ability.extra.denominator, 'j_scp_8465')
        end
        if #G.play.cards == 1 then
            if card.ability.extra.roll then
                if context.individual and context.cardarea == G.play and not context.end_of_round then
                    local orig_card = context.other_card
                    return {
                        func = function()
                            local _card
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    _card = copy_card(orig_card)
                                    G.play:emplace(_card)
                                    _card.ability.dataexpunged_flipped = true
                                    return true
                                end
                            }))
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SCP.NOISE_FRAMES = 50
                                    table.insert(G.playing_cards, _card)
                                    draw_card(G.play, G.discard, 100, 'down', false, _card)
                                    return true
                                end
                            }))
                        end,
                    }
                end
            else
                if SCP.downside_active(card) and context.destroy_card and context.destroy_card == context.scoring_hand[1] then
                    return {
                        --remove = true,
                         func = function()
                            local _card = context.scoring_hand[1]
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SCP.NOISE_FRAMES = 50
                                    _card:start_dissolve({G.C.RED}, true, 0, true)
                                    return true
                                end
                            }))
                        end,
                    }
                end
            end
        end
    end
}

function SCP.update()
    SCP.NOISE_FRAMES = SCP.NOISE_FRAMES - 1
end

function SCP.draw()
    if SCP.NOISE_FRAMES > 0 then
        love.graphics.setCanvas(G.CANVAS)
        love.graphics.scale(G.CANV_SCALE)

        local wid, hei = love.graphics.getDimensions()

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            G.ASSET_ATLAS["scp_noise"].image,
            love.graphics.newQuad(0, 0, 1, 1, 1, 1),
            0,
            0,
            0,
            wid,
            hei,
            0, 0
        )
    end
end
