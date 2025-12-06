SMODS.Joker {
    key = "code_name_wjs",
    pos = {x = 0, y = 0},
    --atlas = "jokers",

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    cost = 10,
    rarity = 4,

    classification = "proposal",
}

local is_rarity_ref = Card.is_rarity
function Card:is_rarity(rarity, ...)
    if next(SMODS.find_card("j_scp_code_name_wjs")) then
        if not SCP.rarity_blacklist[self.config.center.rarity] then
            local no_downside = false
            for i, v in pairs(SMODS.find_card("j_scp_code_name_wjs")) do
                if not SCP.downside_active(v) then no_downside = true end
            end
            if (no_downside and not  SCP.rarity_blacklist[rarity]) or rarity == "Common" then return true end
        end
    end
    return is_rarity_ref(self, rarity, ...)
end

local poll_rarity_ref = SMODS.poll_rarity
function SMODS.poll_rarity(t, key, ...)
    if next(SMODS.find_card("j_scp_code_name_wjs")) then
        return 1
    end
    return poll_rarity_ref(t, key, ...)
end

function SCP.get_normalcy_pool()
    local pool = {}
    for i, v in pairs(G.P_JOKER_RARITY_POOLS) do
        if not SCP.rarity_blacklist[i] then
            SCP.merge_tables(pool, v)
        end
    end
    return pool
end

local gcp = get_current_pool
function get_current_pool(_type, _rarity, ...)
    if _type == "Joker" and next(SMODS.find_card("j_scp_code_name_wjs")) and not SCP.rarity_blacklist[_rarity] then
        G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
        local _pool, _starting_pool, _pool_key, _pool_size = G.ARGS.TEMP_POOL, nil, '', 0
        _rarity = (_legendary and 4) or (type(_rarity) == "number" and ((_rarity > 0.95 and 3) or (_rarity > 0.7 and 2) or 1)) or _rarity
        _rarity = ({Common = 1, Uncommon = 2, Rare = 3, Legendary = 4})[_rarity] or _rarity
        local rarity = _rarity or SMODS.poll_rarity("Joker", 'rarity'..G.GAME.round_resets.ante..(_append or ''))
        _starting_pool, _pool_key = SCP.get_normalcy_pool(), 'Joker'..rarity..((not _legendary and _append) or '')
        for k, v in ipairs(_starting_pool) do
            local add = nil
            local in_pool, pool_opts = SMODS.add_to_pool(v, { source = _append })
            pool_opts = pool_opts or {}
            if not (G.GAME.used_jokers[v.key] and not pool_opts.allow_duplicates and not SMODS.showman(v.key)) and
                (v.unlocked ~= false or v.rarity == 4) then
                add = true
                if v.hidden then
                    add = false
                end
            end

            if v.no_pool_flag and G.GAME.pool_flags[v.no_pool_flag] then add = nil end
            if v.yes_pool_flag and not G.GAME.pool_flags[v.yes_pool_flag] then add = nil end
            
            add = in_pool and (add or pool_opts.override_base_checks)
            if add and not G.GAME.banned_keys[v.key] then 
                _pool[#_pool + 1] = v.key
                _pool_size = _pool_size + 1
            else
                _pool[#_pool + 1] = 'UNAVAILABLE'
            end
        end

        --if pool is empty
        if _pool_size == 0 then
            _pool = EMPTY(G.ARGS.TEMP_POOL)
            _pool[#_pool + 1] = "j_joker"
        end

        return _pool, _pool_key..(not _legendary and G.GAME.round_resets.ante or '')
    end
    return gcp(_type, _rarity, ...)
end