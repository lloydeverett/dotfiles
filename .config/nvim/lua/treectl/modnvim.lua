local nodes = require("treectl.nodes")
local providers = require("treectl.providers")
local luautils = require("treectl.luautils")
local nvimutils = require("treectl.nvimutils")

return function()
local M = {}

M._max_recents = vim.g["treectl#nvim#max_recents"] or 20

M._root_nodes = {}
function M.root_nodes()
    return M._root_nodes
end

table.insert(M._root_nodes, nodes.lazy_node(
    "buffer",
    { hl = "DiagnosticInfo", help_suffix = "lists open buffers", path = "neovim/buffer" },
    providers.simple_provider(function()
        return luautils.map(nvimutils.list_open_buffers(), function(b)
            local display_name = b.name
            if display_name == "" then
                display_name = "[No Name]"
            end
            return nodes.node(
                { { "" .. b.bufnr, "Number" }, " ", display_name },
                { path = "neovim/buffer/" .. b.bufnr }
            )
        end)
    end))
)

table.insert(M._root_nodes, nodes.lazy_node(
    "recent",
    { hl = "DiagnosticInfo", help_suffix = "nvim oldfiles", path = "neovim/recent" },
    providers.simple_provider(function()
        local files = luautils.filter(vim.v.oldfiles, function(f)
            if f:sub(1, #"term://") == "term://" then
                return false
            end
            return true
        end)

        files = { unpack(files, 1, M._max_recents) }

        return luautils.map(files, function(f, i)
            local shortened_path = nvimutils.try_shorten_path(f)
            return nodes.node(
                { { "" .. (i - 1), "Number" }, " ", shortened_path },
                { path = { "neovim/recent/", f } }
            )
        end)
    end))
)

table.insert(M._root_nodes, nodes.node("neovim", { hl = "DiagnosticInfo", path = "neovim", help_suffix = "more neovim trees" }, {
        nodes.node("window",       { hl = "DiagnosticInfo", path = "neovim/window" }),
        nodes.node("highlight",    { hl = "DiagnosticInfo", path = "neovim/highlight" }),
        nodes.node("tab",          { hl = "DiagnosticInfo", path = "neovim/tab" }),
        nodes.node("register",     { hl = "DiagnosticInfo", path = "neovim/register" }),
        nodes.node("symbol",       { hl = "DiagnosticInfo", path = "neovim/symbol" }),
        nodes.node("mark",         { hl = "DiagnosticInfo", path = "neovim/mark" }),
        nodes.node("colorscheme",  { hl = "DiagnosticInfo", path = "neovim/colorscheme" }),
        nodes.node("plugin",       { hl = "DiagnosticInfo", path = "neovim/plugin" }),
        nodes.node("see what telescope offers?"),
    }))

return M
end

