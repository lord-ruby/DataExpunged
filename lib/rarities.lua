--Common - Safe / Ticonderoga
--Uncommon - Euclid / Cernunnos
--Rare - Keter / Archon
--Epic/Epic Analog - Thaumiel / Apollyon

--Legendary - 001 Proposal

if (SMODS.Mods["Cryptid"] or {}).can_load then
    SCP.thaumiel_rarity = "cry_epic"

elseif (SMODS.Mods["vallkarri"] or {}).can_load then
    SCP.thaumiel_rarity = "valk_renowned"
else    
    SCP.thaumiel_rarity = "scp_thaumiel"
    SMODS.Rarity {
        key = 'thaumiel',
        badge_colour = G.C.SCP_THAUMIEL,
        pools = { ["Joker"] = true },
        default_weight = 0.01,
        --approx 3x more common than a cryptid epic joker
    }
end

SMODS.Rarity {
    key = "scp000rarity",
    badge_colour = G.C.BLACK,
    badge_text_colour = G.C.RED,
    default_weight = 0,
} -- made to facilitate scp-000 aka...... idk bros a pattern screamer what do you want me to say -fireice