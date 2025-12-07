
-- color reference               everforest   gruvbox-material    evergarden
-- vim.g["terminal_color_0"]        #414b50            #5a524c       #374145
-- vim.g["terminal_color_1"]        #e67e80            #ea6962       #F57F82
-- vim.g["terminal_color_2"]        #a7c080            #a9b665       #CBE3B3
-- vim.g["terminal_color_3"]        #dbbc7f            #d8a657       #F5D098
-- vim.g["terminal_color_4"]        #7fbbb3            #7daea3       #B2CAED
-- vim.g["terminal_color_5"]        #d699b6            #d3869b       #F3C0E5
-- vim.g["terminal_color_6"]        #83c092            #89b482       #B3E3CA
-- vim.g["terminal_color_7"]        #d3c6aa            #d4be98       #96B4AA
-- vim.g["terminal_color_8"]        #414b50            #5a524c       #6F8788
-- vim.g["terminal_color_9"]        #e67e80            #ea6962       #F57F82
-- vim.g["terminal_color_10"]       #a7c080            #a9b665       #CBE3B3
-- vim.g["terminal_color_11"]       #dbbc7f            #d8a657       #F5D098
-- vim.g["terminal_color_12"]       #7fbbb3            #7daea3       #B2CAED
-- vim.g["terminal_color_13"]       #d699b6            #d3869b       #F3C0E5
-- vim.g["terminal_color_14"]       #83c092            #89b482       #B3E3CA
-- vim.g["terminal_color_15"]       #d3c6aa            #d4be98       #ADC9BC

local function apply_custom_highlights()
    local function term_palette_color(index)
        return vim.g["terminal_color_" .. index]
    end

    -- highlight for conceal
    vim.api.nvim_set_hl(0, "Conceal", { fg = term_palette_color(10), force = true })

    -- highlights for checkboxes
    vim.api.nvim_set_hl(0, "todoDone", { link = "VimwikiCheckBoxDone", force = true })
    vim.api.nvim_set_hl(0, "todoCheckbox", { link = "Todo", force = true })

    -- customise vimwiki highlights
    vim.api.nvim_set_hl(0, "VimwikiBold", { fg = term_palette_color(1), bold = true, force = true })
    vim.api.nvim_set_hl(0, "VimwikiItalic", { fg = term_palette_color(5), italic = true, force = true })
    vim.api.nvim_set_hl(0, "VimwikiHeader1", { fg = term_palette_color(2), bold = true, force = true })
    vim.api.nvim_set_hl(0, "VimwikiList", { fg = term_palette_color(10), force = true })
    vim.api.nvim_set_hl(0, "VimwikiListTodo", { fg = term_palette_color(10), force = true })

    -- ensure Underlined is defined correctly
    vim.api.nvim_set_hl(0, "Underlined", { underline = true, force = true })

    -- style todo dates
    vim.cmd('hi def todoUnderlineA cterm=underline gui=underline guisp=' .. term_palette_color(2))
    vim.cmd('hi def todoUnderlineB cterm=underline gui=underline guisp=' .. term_palette_color(2))
    vim.api.nvim_set_hl(0, "TodoDate", { link = "todoUnderlineA", force = true })
    vim.api.nvim_set_hl(0, "TodoDateMonth", { link = "todoUnderlineB", force = true })

    -- make sure trailspace is obvious
    vim.api.nvim_set_hl(0, "MiniTrailspace", { link = "MiniHipatternsFixme", force = true })

    -- patch misc rules dynamically based on other highlights
    local normal_hl_rule = vim.api.nvim_get_hl(0, { name = "Normal" })
    local function_hl_rule = vim.api.nvim_get_hl(0, { name = "Function" })
    local statement_hl_rule = vim.api.nvim_get_hl(0, { name = "Statement" })
    local diffchange_hl_rule = vim.api.nvim_get_hl(0, { name = "DiffChange" })
    local hl_rules = vim.api.nvim_get_hl(0, { })
    for k, v in pairs(hl_rules) do
        if vim.g.colors_name == "thorn" then
            if k == "VimwikiItalic" then
                v.fg = function_hl_rule.fg
                v.ctermfg = function_hl_rule.ctermfg
                v.force = true
                vim.api.nvim_set_hl(0, k, v)
            end
            if k == "VimwikiBold" then
                v.fg = statement_hl_rule.fg
                v.ctermfg = statement_hl_rule.ctermfg
                v.force = true
                vim.api.nvim_set_hl(0, k, v)
            end
            if k == "TabLineSel" then
                v.fg = diffchange_hl_rule.fg
                v.ctermfg = diffchange_hl_rule.ctermfg
                v.bg = diffchange_hl_rule.bg
                v.ctermbg = diffchange_hl_rule.ctermbg
                v.force = true
                vim.api.nvim_set_hl(0, k, v)
            end
        end
        if k == "VimwikiLink" or k == "VimwikiWeblink1" then
            v.fg = normal_hl_rule.fg
            v.ctermfg = normal_hl_rule.ctermfg
            v.underline = true
            v.force = true
            vim.api.nvim_set_hl(0, k, v)
        end
        if k == "VimwikiLink" or k == "VimwikiWeblink1" then
            v.fg = normal_hl_rule.fg
            v.ctermfg = normal_hl_rule.ctermfg
            v.underline = true
            v.force = true
            vim.api.nvim_set_hl(0, k, v)
        end
        if k == "Normal" and vim.g.bgcolor ~= nil then
            v.bg = vim.g.bgcolor
            v.force = true
            vim.api.nvim_set_hl(0, k, v)
        end
    end

    -- additional patch for thorn
    if vim.g.colors_name == "thorn" then
        vim.api.nvim_set_hl(0, "MiniStatusLineModeNormal", { link = "TabLineSel", force = true })
        vim.api.nvim_set_hl(0, "MiniStatusLineModeInsert", { link = "DiffAdd", force = true })
        vim.api.nvim_set_hl(0, "VertSplit", { link = "LineNr", force = true })
        vim.api.nvim_set_hl(0, "WinSeparator", { link = "LineNr", force = true })
    end
end

if os.getenv("TERM") ~= "linux" then
    apply_custom_highlights()

    vim.api.nvim_create_autocmd('ColorScheme', {
        callback = apply_custom_highlights,
    })
end

