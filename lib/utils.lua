-- local {
--     items = {
--         jokers = {
--             ...
--         }
--     }
-- }

function SCP.load_table(table)
    for i, v in pairs(SCP.get_paths(table)) do
        local f, err = SMODS.load_file(v)
        if err then error(err); return end
        if f then f() end
    end
end

function SCP.get_paths(_table, name)
    local paths = {}
    local root = name or ""
    if _table.order then
        table.sort(_table, function(a, b)
            return _table.order[a] > _table.order[b]
        end)
    end
    for i, v in pairs(_table) do
        if i ~= "order" then
            if type(v) == "table" then
                for i2, v2 in pairs(SCP.get_paths(v, root.."/"..i)) do
                    paths[#paths+1] = v2
                end
            else
                if root[1] == "/" then root = string.sub(root, 2) end
                local sep = "/"
                if root == "" then sep = "" end
                paths[#paths+1] = root..sep..v..".lua"
            end
        end
    end
    table.sort(paths)
    return paths
end

function SCP.downside_active(card)
    if ((card.ability.set == "Joker" and card.config.center.original_mod and card.config.center.original_mod.id == SCP.id) or card.ability.set == "Spectral") and next(SMODS.find_card("j_scp_code_name_lily")) then
        return false
    end
    return true
end

SCP.rarity_blacklist = {
    [4] = true,
    Legendary = true,
    cry_exotic = true,
    entr_entropic = true,
    valk_exquisite = true
}

function SCP.localize_classification(center, rarity)
    if center and center.classification then
        local class = center.classification
        if not SCP.rarity_blacklist[center.rarity] and next(SMODS.find_card("j_scp_code_name_wjs")) then
            class = "safe"
        end
        return localize("k_scp_"..class)
    end
    local vanilla_rarity_keys = {localize('k_common'), localize('k_uncommon'), localize('k_rare'), localize('k_legendary')}
    if center and not SCP.rarity_blacklist[center.rarity] and next(SMODS.find_card("j_scp_code_name_wjs")) then
        rarity = 1
    end
    if (vanilla_rarity_keys)[rarity] then
        return vanilla_rarity_keys[rarity] --compat layer in case function gets the int of the rarity
    else
        return localize("k_"..rarity:lower())
    end
end

function SCP.get_rarity_colour(rarity, card, _c)
    if not SCP.rarity_blacklist[rarity] and next(SMODS.find_card("j_scp_code_name_wjs")) then
        return G.C.RARITY.Common
    end
    if card.config and card.config.center and card.config.center.key == "j_scp_914_below_common" then
        return G.C.RARITY.Junk
    end
    return G.C.RARITY[rarity]
end

function SCP.merge_tables(tbl1, tbl2)
    for i, v in pairs(tbl2) do
        tbl1[#tbl1+1]=v
    end
end

function SCP.generate_description_localization(args, loc_target)
    if not args.card then args.card = G._loc_card end
    if not loc_target then return end
    local target = args.card and not SCP.downside_active(args.card) and "no_downsides_text" or "text"
    if not loc_target[target] then target = "text" end
    if type(loc_target[target]) == 'table' and loc_target.info then
        args.AUT.multi_box = args.AUT.multi_box or {} 
        local boxes = {}
        if type(loc_target.info[1]) == "table" then
            for i, v in pairs(loc_target.info_parsed) do
                boxes[#boxes+1] = v
            end
        else
            boxes[#boxes+1] = loc_target.info_parsed
        end
        if type(loc_target[target][1]) == "table" then
            for i, v in pairs(loc_target[target.."_parsed"]) do
                boxes[#boxes+1] = v
            end
        else
            boxes[#boxes+1] = loc_target[target.."_parsed"]
        end
        for i, box in ipairs(boxes) do
            for j, line in ipairs(box) do
                local final_line = SMODS.localize_box(line, args)
                if i == 1 or next(args.AUT.info) then
                    args.nodes[#args.nodes+1] = final_line -- Sends main box to AUT.main
                    if not next(args.AUT.info) then args.nodes.main_box_flag = true end
                elseif not next(args.AUT.info) then 
                    args.AUT.multi_box[i-1] = args.AUT.multi_box[i-1] or {}
                    args.AUT.multi_box[i-1][#args.AUT.multi_box[i-1]+1] = final_line
                end
                if not next(args.AUT.info) then args.AUT.box_colours[i] = args.vars.box_colours and args.vars.box_colours[i] or G.C.UI.BACKGROUND_WHITE end
            end
        end
        return true
    end
end

local generate_ui_ref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
    G._loc_card = card
    local ret = generate_ui_ref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
    G._loc_card = nil
    return ret
end