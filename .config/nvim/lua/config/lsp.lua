
vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = "Error",
            [vim.diagnostic.severity.WARN]  = "Warn",
            [vim.diagnostic.severity.HINT]  = "Hint",
            [vim.diagnostic.severity.INFO]  = "Info",
        },
    },
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(_)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
    end,
})

