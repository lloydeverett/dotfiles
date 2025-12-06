
-- color reference          everforest   gruvbox-material         thorn
-- terminal_color_0            #414b50            #5a524c       #252530
-- terminal_color_1            #e67e80            #ea6962       #d8647e
-- terminal_color_2            #a7c080            #a9b665       #7fa563
-- terminal_color_3            #dbbc7f            #d8a657       #f3be7c
-- terminal_color_4            #7fbbb3            #7daea3       #6e94b2
-- terminal_color_5            #d699b6            #d3869b       #bb9dbd
-- terminal_color_6            #83c092            #89b482       #aeaed1
-- terminal_color_7            #d3c6aa            #d4be98       #cdcdcd
-- terminal_color_8            #414b50            #5a524c       #606079
-- terminal_color_9            #e67e80            #ea6962       #e08398
-- terminal_color_10           #a7c080            #a9b665       #99b782
-- terminal_color_11           #dbbc7f            #d8a657       #f5cb96
-- terminal_color_12           #7fbbb3            #7daea3       #8ba9c1
-- terminal_color_13           #d699b6            #d3869b       #c9b1ca
-- terminal_color_14           #83c092            #89b482       #bebeda
-- terminal_color_15           #d3c6aa            #d4be98       #d7d7d7

local function apply_custom_highlights()
    local color_scheme = MiniColors.get_colorscheme()
    color_scheme:add_terminal_colors({ force = false }) -- force = false prevents overwriting if already present
    local function term_palette_color(index)
        return color_scheme.terminal[index]
    end

    -- highlight for conceal
    vim.cmd('hi Conceal guifg='                   .. term_palette_color(10))

    -- highlights for checkboxes
    vim.cmd('hi link todoDone VimwikiCheckBoxDone')
    vim.cmd('hi link todoCheckbox Todo')

    -- customise vimwiki highlights
    vim.cmd('hi VimwikiBold gui=bold guifg='      .. term_palette_color(1))
    vim.cmd('hi VimwikiItalic gui=italic guifg='  .. term_palette_color(5))
    vim.cmd('hi VimwikiHeader1 gui=bold guifg='   .. term_palette_color(2))
    vim.cmd('hi VimwikiList guifg='               .. term_palette_color(10))
    vim.cmd('hi VimwikiListTodo guifg='           .. term_palette_color(10))

    -- ensure Underlined is defined correctly
    vim.cmd('hi def Underlined cterm=underline gui=underline')

    -- style todo dates
    vim.cmd('hi def todoUnderlineA cterm=underline gui=underline guisp=' .. term_palette_color(2))
    vim.cmd('hi def todoUnderlineB cterm=underline gui=underline guisp=' .. term_palette_color(2))
    vim.cmd('hi link TodoDate todoUnderlineA')
    vim.cmd('hi link TodoDateMonth todoUnderlineB')

    -- make sure trailspace is obvious
    vim.cmd('hi link MiniTrailspace MiniHipatternsFixme')

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
    end

    -- additional patch for thorn
    if vim.g.colors_name == "thorn" then
        vim.cmd("hi! link MiniStatusLineModeNormal TabLineSel")
        vim.cmd("hi! link MiniStatusLineModeInsert DiffAdd")
        vim.cmd("hi! link VertSplit LineNr")
        vim.cmd("hi! link WinSeparator LineNr")
    end
end

if os.getenv("TERM") ~= "linux" then
    apply_custom_highlights()

    vim.api.nvim_create_autocmd('ColorScheme', {
        callback = apply_custom_highlights,
    })
end

