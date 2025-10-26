
local augroup = vim.api.nvim_create_augroup('markdown', {})
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.md',
    group = augroup,
    callback = function()
        vim.api.nvim_set_hl(0, 'Conceal', { bg = 'NONE', fg = vim.g['terminal_color_6'] })
        vim.api.nvim_set_hl(0, 'todoCheckbox', { link = 'Todo' })
        vim.opt.conceallevel = 2
        vim.opt.concealcursor = "ncv"

        vim.cmd [[
            syn match todoCheckbox '\v(\s+)?(-|\*)\s\[\s\]'hs=e-4 conceal cchar=
            syn match todoCheckbox '\v(\s+)?(-|\*)\s\[X\]'hs=e-4 conceal cchar=
            syn match todoCheckbox '\v(\s+)?(-|\*)\s\[-\]'hs=e-4 conceal cchar=󰅘
            syn match todoCheckbox '\v(\s+)?(-|\*)\s\[\.\]'hs=e-4 conceal cchar=⊡
            syn match todoCheckbox '\v(\s+)?(-|\*)\s\[o\]'hs=e-4 conceal cchar=⬕
        ]]
    end
})

