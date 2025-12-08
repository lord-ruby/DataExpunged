SCP.ui_config = {
    bg_colour = adjust_alpha(G.C.BLACK, 0.95),
    outline_colour = G.C.SCP_DARK_BLACK,
    author_colour = G.C.RED,
    back_colour = G.C.BLACK,
    tab_button_colour = G.C.BLACK,
    colour = G.C.SCP_DARK_BLACK
}

local oldfunc = Game.main_menu
Game.main_menu = function(change_context)
    local ret = oldfunc(change_context)
    G.SPLASH_BACK:define_draw_steps({
        {
            shader = "splash",
            send = {
                { name = "time", ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
                { name = "vort_speed", val = 0.4 },
                { name = "colour_1", ref_table = G.C, ref_value = "BLACK" },
                { name = "colour_2", ref_table = G.C, ref_value = "SCP_DARKER_BLACK" },
            },
        },
    })
    return ret
end

local function wrapText(text, maxChars)
    local wrappedText = {""}
    local curr_line = 1
    local currentLineLength = 0

    for word in text:gmatch("%S+") do
        if currentLineLength + #word <= maxChars then
            wrappedText[curr_line] = wrappedText[curr_line] .. word .. ' '
            currentLineLength = currentLineLength + #word + 1
        else
            wrappedText[curr_line] = string.sub(wrappedText[curr_line], 0, -2)
            curr_line = curr_line + 1
            wrappedText[curr_line] = ""
            wrappedText[curr_line] = wrappedText[curr_line] .. word .. ' '
            currentLineLength = #word + 1
        end
    end

    wrappedText[curr_line] = string.sub(wrappedText[curr_line], 0, -2)
    return wrappedText
end

SCP.credits = {
    {name = "Soulware", works = {"Programmer"}},
    {name = "SleepyG11", works = {"Programmer"}},
    {name = "lord.ruby", works = {"Lead Dev", "Programmer", "Art"}},
    {name = "FireIce", works = {"Programmer"}}
}

SCP.extra_tabs = function(page)
    local _needed_pages = math.ceil(#SCP.credits/6)
    local mod = SCP
    G.E_MANAGER:add_event(Event({
        blockable = false,
        func = function()
            G.REFRESH_ALERTS = nil
            return true
        end
    }))
    if not G.SCP_CREDITS_PAGE then G.SCP_CREDITS_PAGE = 1 end
    if page then G.SCP_CREDITS_PAGE = page end
    local label = localize("k_credits")

    local opts = {}
    for i = 1, _needed_pages do
        table.insert(opts, localize('k_page')..' '..tostring(i)..'/'..tostring(_needed_pages))
    end
    table.sort(SCP.credits, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    return {
        label = label,
        chosen = SMODS.LAST_SELECTED_MOD_TAB == "DataExpunged_1" or false,
        tab_definition_function = function()
            local modNodes = {}
            local scale = 0.75 -- Scale factor for text
            local maxCharsPerLine = 50

            -- Mod description
            modNodes[#modNodes + 1] = {}
            local _vars = {}
            for i = 1, 6 do
                local credit = SCP.credits[i + (G.SCP_CREDITS_PAGE - 1) * 6] or {name = "", works = {}}
                local works = credit.works[1] or ""
                if #credit.works > 1 then
                    for i = 2, #credit.works do works = works ..", "..credit.works[i] end
                end
                _vars[#_vars+1] = credit.name or ""
                _vars[#_vars+1] = credit.name ~= "" and ":" or "" --sinful
                _vars[#_vars+1] = works or ""
            end
            local loc_vars = {
                vars = _vars
            }
            localize { type = 'descriptions', key = "DataExpunged_credits", set = 'Mod', nodes = modNodes[#modNodes], vars = loc_vars.vars, scale = loc_vars.scale, text_colour = loc_vars.text_colour, shadow = loc_vars.shadow }
            modNodes[#modNodes] = desc_from_rows(modNodes[#modNodes])
            modNodes[#modNodes].config.colour = loc_vars.background_colour or modNodes[#modNodes].config.colour
            modNodes[#modNodes].config.minh = 6
            modNodes[#modNodes+1] = create_option_cycle({options = opts, w = 4.5, cycle_shoulders = true, opt_callback = 'SCP_cycle_credits', focus_args = {snap_to = true, nav = 'wide'},current_option = G.SCP_CREDITS_PAGE, colour = G.C.BLACK, no_pips = true})
            return {
                n = G.UIT.ROOT,
                config = {
                    emboss = 0.05,
                    minh = 6,
                    r = 0.1,
                    minw = 6,
                    align = "tm",
                    padding = 0.2,
                    colour = G.C.BLACK
                },
                nodes = modNodes
            }
        end
    }
end

G.FUNCS.SCP_cycle_credits = function(args)
    if not args or not args.cycle_config then return end    
    G.SCP_CREDITS_PAGE = args.cycle_config.current_option
    G.FUNCS.overlay_menu({
        definition = create_UIBox_mods(e)
    })
end