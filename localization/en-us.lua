return {
    descriptions = {
        Joker = {
            j_scp_code_name_lily = {
                name = {
                    "CODE NAME: Lily",
                    "{C:red,s:0.8}The World's Gone Beautiful"
                },
                text = {
                    {
                        "{s:0.9}Item {E:scp_hash}1{s:0.8}: SCP-001",
                        "{s:0.9}Object Class{s:0.8}: Unnecessary",
                        "{s:0.9}Special Containment Procedures:",
                        "{s:0.8}SCP-001 Does not need to be contained.",
                        "{s:0.9}Description:",
                    },
                    {
                        "Removes the {C:attention}negative effects{}",
                        "of all {C:spectral}Spectral{} cards and other {C:attention}SCPs{}"
                    }
                }
            },
            j_scp_code_name_wjs = {
                name = {
                    "CODE NAME: WJS",
                    "{C:red,s:0.8}Normalcy"
                },
                text = {
                    {
                        "{s:0.9}Item {E:scp_hash}1{s:0.8}: SCP-001",
                        "{s:0.9}Object Class{s:0.8}: Non-Anomalous",
                        "{s:0.9}Special Containment Procedures:",
                        "{s:0.8}SCP-001 is kept on a dedicated server or library",
                        "{s:0.8}located in a place of the O5 Council's choosing.",
                        "{s:0.9}Description:",
                    },
                    {
                        "All {C:attention}Jokers{} are {C:blue}Common{}",
                        "{C:inactive}(Excludes {C:purple}Legendary{C:inactive} or higher)"
                    }
                }
            },
            j_scp_code_name_dr_mann = {
                name = {
                    "CODE NAME: Dr. Mann",
                    "{C:red,s:0.8}The Spiral Path"
                },
                text = {
                    {
                        "{s:0.9}Item {E:scp_hash}1{s:0.8}: SCP-001",
                        "{s:0.9}Object Class{s:0.8}: Embla",
                        "{s:0.9}Special Containment Procedures:",
                        "{s:0.8}SCP-001 is contained on the grounds of",
                        "{s:0.8}Site 0 in upstate {X:black,C:black,s:0.8}[REDACTED].{}",
                        "{s:0.9}Description:",
                    },
                    {
                        "{C:attention}Rescore{} all scored cards",
                        "once for every {C:attention}previous{}",
                        "card in scored hand"
                    }
                }
            },
            j_scp_914 = {
                name = {
                    "SCP-914",
                    "{C:red,s:0.8}The Clockworks"
                },
                text = {
                    {
                        "{s:0.9}Item {E:scp_hash}1{s:0.8}: SCP-914",
                        "{s:0.9}Object Class{s:0.8}: Safe",
                        "{s:0.9}Special Containment Procedures:",
                        "{s:0.8}SCP-914 is to be kept in research cell 109-B",
                        "{s:0.8}with two guard personnel on duty at all times.{}",
                        "{s:0.9}Description:",
                    },
                    {
                        "{C:attention}Input{} the Joker",
                        "to the left and {C:attention}output a Joker",
                        "that's a rarity below, same, or above",
                        "{C:inactive}(Can't output {C:purple}Legendary{C:inactive} or higher)"
                    }
                }
            },
            j_scp_914_nodownside = {
                name = {
                    "SCP-914",
                    "{C:red,s:0.8}The Clockworks"
                },
                text = {
                    {
                        "{s:0.9}Item {E:scp_hash}1{s:0.8}: SCP-914",
                        "{s:0.9}Object Class{s:0.8}: Safe",
                        "{s:0.9}Special Containment Procedures:",
                        "{s:0.8}SCP-914 is to be kept in research cell 109-B",
                        "{s:0.8}with two guard personnel on duty at all times.{}",
                        "{s:0.9}Description:",
                    },
                    {
                        "{C:attention}Input{} the Joker",
                        "to the left and {C:attention}output a Joker",
                        "that's a rarity same or above",
                        "{C:inactive}(Can't output {C:purple}Legendary{C:inactive} or higher)"
                    }
                }
            },
            j_scp_914_below_common = {
                -- referencing how the destroy animation burns up the card
                name = {
                    "Pile of Ash",
                },
                text = {
                    {
                    -- hardcoded on purpose
                        "{C:chips}+0.5{} Chips",
                        "{C:inactive, s:0.85}Look at what you've done."
                    }
                }
            },
            j_scp_000 = {
                name = {
                    "SCP-000",
                },
                text = {
                    {
                        "{s:0.9}Item {E:scp_hash}1{s:0.8}: SCP-000",
                        "{s:0.9}Object Class{s:0.8}: {E:scp_hash,C:mult}1{C:mult}NULL",
                        "{s:0.9}Special Containment Prodecures{s:0.8}: Field does not exist.",
                        "{s:0.9}Description{s:0.8}:",
                    },
                    {
                        "Internal system error: Field undefined. Please contact system administrator.",
                        "Internal system error: Field undefined. Please contact system administrator.",
                        "InteRиαl Sуѕtєм ERяяσя: FïëlÐ ünÐëƒïnëÐ. ρĿєДšє ςόЛţДςţ šΫšţєΜMM-",
                    },
                }
            },
        },
        Spectral = {
            c_familiar_nodownside = {
                name = "Familiar",
                text = {
                    "Add {C:attention}#2#{} random",
                    "{C:attention}Enhanced face cards{}",
                    "to your hand"
                }
            },
            c_grim_nodownside = {
                name = "Grim",
                text = {
                    "Add {C:attention}#2#{} random",
                    "{C:attention}Enhanced Aces{}",
                    "to your hand"
                }
            },
            c_incantation_nodownside = {
                name = "Incantation",
                text = {
                    "Add {C:attention}#2#{} random",
                    "{C:attention}Enhanced numbered cards{}",
                    "to your hand"
                }
            },
            c_wraith_nodownside = {
                name = "Wraith",
                text = {
                    "Create a random",
                    "{C:red}Rare {C:attention}Joker"
                }
            },
            c_ouija_nodownside = {
                name = "Ouija",
                text = {
                    "Converts all cards",
                    "in hand into a single",
                    "random {C:attention}rank"
                }
            },
            c_ectoplasm_nodownside = {
                name = "Ectoplasm",
                text = {
                    "Add {C:dark_edition}Negative{} to",
                    "a random {C:attention}Joker{}"
                }
            },
            c_ankh_nodownside = {
                name = "Ankh",
                text = {
                    "Create a copy of a",
                    "random {C:attention}Joker",
                    "{C:inactive,s:0.8}(Removes {C:dark_edition,s:0.8}Negative {C:inactive,S:0.8}from copy)"
                }
            },
            c_hex_nodownside = {
                name = "Hex",
                text = {
                    "Add {C:dark_edition}Polychrome{} to a",
                    "random {C:attention}Joker{}"
                }
            },
        },
        Mod = {
            DataExpunged = {
                name = "{C:black,X:black}[DATA EXPUNGED]{}",
                text = {
                    "THE FOLLOWING FILES HAVE BEEN CLASSIFIED",
                    "{C:red,s:2}TOP SECRET{}",
                    "BY ORDER OF THE ADMINISTRATOR",
                    " ",
                    " ",
                    " ",
                    "{C:red,s:2}WARNING:{}",
                    "ANY NON-AUTHORIZED PERSONNEL ACCESSING THIS FILE WILL BE IMMEDIATELY TERMINATED",
                    "THROUGH BERRYMAN-LANGFORD MEMETIC KILL AGENT. READING FURTHER WITHOUT PROPER",
                    "MEMETIC INOCULATION WILL RESULT IN IMMEDIATE CARDIAC ARREST FOLLOWED BY DEATH.",
                    "{C:red,s:2}YOU HAVE BEEN WARNED.",
                    " ",
                    " ",
                    " ",
                    "{s:1.5}Item {E:scp_hash,s:1.5}1{s:1.5}: {}SCP-{C:black,X:black}XXXX{}",
                    "{s:1.5}Object Class: {}Apollyon",
                    "{s:1.5}Special Containment Procedures: {}Containment of SCP-{C:black,X:black}XXXX{} is impossible.",
                    "{s:1.5}Description: {}SCP-{C:black,X:black}XXXX{} is a Balatro Mod themed around The SCP Foundation",
                    "adding Jokers based around many SCPs and various other cards and mechanics",
                    "{C:inactive,s:0.9}For Authors see Credits page"
                }
            },
            DataExpunged_credits_1 = {
                name = "Credits",
                text = {
                    "{C:red}WELCOME TO THE SCP FOUNDATION{}",
                    "{C:red,s:2}CONTRIBUTOR PAGE REPOSITORY{}",
                    " ",
                    " ",
                    "{C:red,s:1.5}lord.ruby{s:1.5}: {C:red}Lead Dev{}, {C:red}Artist{}, {C:red}Programmer",
                    "{C:red,s:1.5}SleepyG11{s:1.5}: {C:red}Programmer",
                    "{C:red,s:1.5}Soulware{s:1.5}: {C:red}Programmer",
                }
            },
        }
    },
    misc = {
        dictionary = {
            --Some of these are probably unnecessary but easier to do now than later
            k_scp_proposal = "SCP-001",
            k_scp_safe = "Safe",
            k_scp_ticonderoga = "Ticonderoga",
            k_scp_euclid = "Euclid",
            k_scp_cerunnos = "Cerunnos",
            k_scp_keter = "Keter",
            k_scp_archon = "Archon",
            k_scp_thaumiel = "Thaumiel",
            k_scp_apollyon = "Apollyon",
            -- not actually a class, SCP-914 just uses this for a special joker
            k_scp_junk = "Junk",
            k_scp_null = "#NULL", -- only used for scp-000, dont use it anywhere else kthx -fireice
            
            k_scp_914_processed = "Proccessed",
            k_rescore_ex = "Again!?",

            k_credits = "Credits",
            k_contributors_1 = "WELCOME TO THE SCP FOUNDATION",
            k_contributors_2 = "CONTRIBUTOR PAGE REPOSITORY"
        }
    }
}