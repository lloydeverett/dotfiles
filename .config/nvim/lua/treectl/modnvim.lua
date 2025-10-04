local nodes = require("treectl.nodes")
local providers = require("treectl.providers")
local luautils = require("treectl.luautils")
local nvimutils = require("treectl.nvimutils")

local node = nodes.node
local lazy_node = nodes.lazy_node

return function()
local M = {}

M._max_recents = vim.g["treectl#nvim#max_recents"] or 20

M._root_nodes = {}
function M.root_nodes()
    return M._root_nodes
end

table.insert(M._root_nodes, lazy_node(
    "buffer",
    providers.simple_provider(function()
        return luautils.map(nvimutils.list_open_buffers(), function(b)
            local display_name = b.name
            if display_name == "" then
                display_name = "[No Name]"
            end
            return node({ { "" .. b.bufnr, "Number" }, " ", display_name }, {})
        end)
    end),
    {},
    { hl = "DiagnosticInfo", help_suffix = " - lists open buffers" })
)

table.insert(M._root_nodes, lazy_node(
    "recent",
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
            return node({ { "" .. (i - 1), "Number" }, " ", shortened_path }, {})
        end)
    end),
    {},
    { hl = "DiagnosticInfo", help_suffix = " - nvim oldfiles" })
)

local function styled_node(str, children, help_suffix)
    if children == nil then
        children = {}
    end
    return node(str, children, {}, { hl = "DiagnosticInfo", help_suffix = help_suffix })
end

table.insert(M._root_nodes, styled_node("neovim", {
    styled_node("window"),
    styled_node("highlight"),
    styled_node("tab"),
    styled_node("register"),
    styled_node("symbol"),
    styled_node("mark"),
    styled_node("colorscheme"),
    styled_node("plugin"),
}, " - more neovim trees"))

return M
end

