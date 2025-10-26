
local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " "
}

for name, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

vim.diagnostic.config({
    virtual_text = true,
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(_)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})
    end,
})

