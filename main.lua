SCP = SMODS.current_mod

SMODS.load_file("lib/utils.lua")()
SMODS.load_file("lib/colours.lua")()
SMODS.load_file("lib/rarities.lua")()

local tbl= {
    lib = {
        "atlases",
        "misc",
        "take_ownership",
        "calculation_keys",
        "config"
    },
    items = {
        jokers = {
            proposals = {
                "code_name_dr_mann",
                "code_name_wjs",
                "code_name_lily",
            },
            one = {
                "000",
                "342",
                "914",
            },
            nine = {
                "8465"
            },
            order = {
                "proposals"
            }
        }
    }
}
SCP.load_table(tbl)
