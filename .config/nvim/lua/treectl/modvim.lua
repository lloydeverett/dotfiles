local nodes = require("treectl.nodes")
local providers = require("treectl.providers")
local luautils = require("treectl.luautils")

local node = nodes.node
local lazy_node = nodes.lazy_node

return function()
local M = {}

M._root_nodes = {}
function M.root_nodes()
    return M._root_nodes
end

table.insert(M._root_nodes, lazy_node(
    "buffer",
    providers.simple_provider(function()
        return luautils.map(luautils.list_open_buffers(), function(b)
            local display_name = b.name
            if display_name == "" then
                display_name = "[No Name]"
            end
            return node("" .. b.bufnr, {}, {}, {
                label = { display_name, " ", { "" .. b.bufnr, "Number" } }
            })
        end)
    end),
    {},
    { hl = "DiagnosticInfo" })
)

table.insert(M._root_nodes, node("recent", {}, {}, { hl = "DiagnosticInfo" }))

table.insert(M._root_nodes, node("vim", {
    node("buffer"),
    node("window"),
    node("hi"),
    node("tab"),
    node("register"),
    node("symbol"),
    node("mark"),
    node("plugin"),
}))

return M
end

