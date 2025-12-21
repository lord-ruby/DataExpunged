SCP = SMODS.current_mod

SMODS.load_file("lib/utils.lua")()
SMODS.load_file("lib/colours.lua")()
SMODS.load_file("lib/rarities.lua")()

local tbl= {
    "lib/atlases",
    "lib/misc",
    "lib/take_ownership",
    "lib/calculation_keys",
    "lib/config",
    "lib/sounds",
    "lib/frame_dependent",
    "lib/shaders",
    "lib/drawsteps",

    "items/jokers/one/000",

    "items/jokers/proposals/code_name_dr_mann",
    "items/jokers/proposals/code_name_s_d_locke",
    "items/jokers/proposals/code_name_wjs",
    "items/jokers/proposals/code_name_lily",

    "items/jokers/one/005",
    "items/jokers/one/055",
    "items/jokers/one/342",
    "items/jokers/one/914",

    "items/jokers/two/1546",

    "items/jokers/three/2521",

    "items/jokers/seven/6219",
    "items/jokers/seven/6747",

    "items/jokers/eight/7176",

    "items/jokers/nine/8465",
}
SCP.load_table(tbl)

SCP.optional_features = {
    cardareas = {
		deck = true,
		discard = true,
	},
}