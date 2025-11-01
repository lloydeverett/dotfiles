
-- color reference          everforest   gruvbox-material
-- g:terminal_color_0          #414b50            #5a524c
-- g:terminal_color_1          #e67e80            #ea6962
-- g:terminal_color_2          #a7c080            #a9b665
-- g:terminal_color_3          #dbbc7f            #d8a657
-- g:terminal_color_4          #7fbbb3            #7daea3
-- g:terminal_color_5          #d699b6            #d3869b
-- g:terminal_color_6          #83c092            #89b482
-- g:terminal_color_7          #d3c6aa            #d4be98
-- g:terminal_color_8          #414b50            #5a524c
-- g:terminal_color_9          #e67e80            #ea6962
-- g:terminal_color_10         #a7c080            #a9b665
-- g:terminal_color_11         #dbbc7f            #d8a657
-- g:terminal_color_12         #7fbbb3            #7daea3
-- g:terminal_color_13         #d699b6            #d3869b
-- g:terminal_color_14         #83c092            #89b482
-- g:terminal_color_15         #d3c6aa            #d4be98
-- markdownH1                  #e67e80            #ea6962
-- markdownH2                  #e69875            #e78a4e
-- markdownH3                  #dbbc7f            #d8a657
-- markdownH4                  #a7c080            #a9b665
-- markdownH5                  #7fbbb3            #7daea3
-- markdownH6                  #d699b6            #d3869b

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function apply_custom_highlights()
    -- highlight group for trailing whitespace
    vim.cmd('hi link TrailingWhitespace CursorLine')

    -- customise vimwiki highlights
    vim.cmd('hi VimwikiBold gui=bold guifg='      .. vim.g['terminal_color_1'])
    vim.cmd('hi VimwikiItalic gui=italic guifg='  .. vim.g['terminal_color_5'])
    vim.cmd('hi VimwikiHeader1 gui=bold guifg='   .. vim.g['terminal_color_2'])
    vim.cmd('hi VimwikiList guifg='               .. vim.g['terminal_color_6'])
    vim.cmd('hi VimwikiListTodo guifg='           .. vim.g['terminal_color_6'])

    local cursorline_hl_rule = vim.api.nvim_get_hl(0, { name = "CursorLine" })
    local hl_rules = vim.api.nvim_get_hl(0, { })
    for k, v in pairs(hl_rules) do
        -- patch bufferline highlights
        if starts_with(k, "BufferLine") then
            -- patch background
            if v.bg ~= nil then v.bg = cursorline_hl_rule.bg end
            if v.ctermbg ~= nil then v.ctermbg = cursorline_hl_rule.ctermbg end

            -- apply
            v.force = true
            vim.api.nvim_set_hl(0, k, v)
        end
    end
end

apply_custom_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = apply_custom_highlights,
})

vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter", "BufEnter" }, {
  callback = function()
    vim.o.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave", "BufLeave" }, {
  callback = function()
    vim.o.cursorline = false
  end,
})

