SCP.custom_card_areas = function(game)
    game.toaster = CardArea(
        nil, nil, nil, nil, {type = "scp_toaster", no_card_count = true, }
    )
    game.toaster.states.visible = false
end