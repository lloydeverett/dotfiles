
-- color reference          everforest   gruvbox-material         thorn
-- g:terminal_color_0          #414b50            #5a524c       #252530
-- g:terminal_color_1          #e67e80            #ea6962       #d8647e
-- g:terminal_color_2          #a7c080            #a9b665       #7fa563
-- g:terminal_color_3          #dbbc7f            #d8a657       #f3be7c
-- g:terminal_color_4          #7fbbb3            #7daea3       #6e94b2
-- g:terminal_color_5          #d699b6            #d3869b       #bb9dbd
-- g:terminal_color_6          #83c092            #89b482       #aeaed1
-- g:terminal_color_7          #d3c6aa            #d4be98       #cdcdcd
-- g:terminal_color_8          #414b50            #5a524c       #606079
-- g:terminal_color_9          #e67e80            #ea6962       #e08398
-- g:terminal_color_10         #a7c080            #a9b665       #99b782
-- g:terminal_color_11         #dbbc7f            #d8a657       #f5cb96
-- g:terminal_color_12         #7fbbb3            #7daea3       #8ba9c1
-- g:terminal_color_13         #d699b6            #d3869b       #c9b1ca
-- g:terminal_color_14         #83c092            #89b482       #bebeda
-- g:terminal_color_15         #d3c6aa            #d4be98       #d7d7d7
-- markdownH1                  #e67e80            #ea6962       #d9add4
-- markdownH2                  #e69875            #e78a4e       #86bfd0
-- markdownH3                  #dbbc7f            #d8a657       #86bfd0
-- markdownH4                  #a7c080            #a9b665       #86bfd0
-- markdownH5                  #7fbbb3            #7daea3       #86bfd0
-- markdownH6                  #d699b6            #d3869b       #86bfd0

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function apply_custom_highlights()
    -- highlight for conceal
    vim.cmd('hi Conceal guifg='                   .. vim.g['terminal_color_10'])

    -- highlights for checkboxes
    vim.cmd('hi link todoDone VimwikiCheckBoxDone')
    vim.cmd('hi link todoCheckbox Todo')

    -- customise vimwiki highlights
    vim.cmd('hi VimwikiBold gui=bold guifg='      .. vim.g['terminal_color_1'])
    vim.cmd('hi VimwikiItalic gui=italic guifg='  .. vim.g['terminal_color_5'])
    vim.cmd('hi VimwikiHeader1 gui=bold guifg='   .. vim.g['terminal_color_2'])
    vim.cmd('hi VimwikiList guifg='               .. vim.g['terminal_color_10'])
    vim.cmd('hi VimwikiListTodo guifg='           .. vim.g['terminal_color_10'])

    -- style todo dates as comments
    vim.cmd('hi def todoUnderline cterm=underline gui=underline guisp=' .. vim.g['terminal_color_2'])
    vim.cmd('hi link TodoDate todoUnderline')

    -- make sure trailspace is obvious
    vim.cmd('hi link MiniTrailspace MiniHipatternsFixme')

    -- patch misc rules dynamically based on other highlights
    local cursorline_hl_rule = vim.api.nvim_get_hl(0, { name = "CursorLine" })
    local winbarnc_hl_rule = vim.api.nvim_get_hl(0, { name = "WinBarNC" })
    local normal_hl_rule = vim.api.nvim_get_hl(0, { name = "Normal" })
    local function_hl_rule = vim.api.nvim_get_hl(0, { name = "Function" })
    local statement_hl_rule = vim.api.nvim_get_hl(0, { name = "Statement" })
    local hl_rules = vim.api.nvim_get_hl(0, { })
    for k, v in pairs(hl_rules) do
        if starts_with(k, "BufferLine") then
            v.bg = cursorline_hl_rule.bg
            v.ctermbg = cursorline_hl_rule.ctermbg
            v.force = true
            vim.api.nvim_set_hl(0, k, v)
        end
        if k == "WinBar" then
            v.bg = winbarnc_hl_rule.bg
            v.ctermbg = winbarnc_hl_rule.ctermbg
            v.force = true
            vim.api.nvim_set_hl(0, k, v)
        end
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
        end
        if k == "VimwikiLink" then
            v.fg = normal_hl_rule.fg
            v.ctermfg = normal_hl_rule.ctermfg
            v.underline = true
            v.force = true
            vim.api.nvim_set_hl(0, k, v)
        end
    end
end

apply_custom_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = apply_custom_highlights,
})

