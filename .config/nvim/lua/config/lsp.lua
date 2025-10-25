
vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(_)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})
    end,
})

