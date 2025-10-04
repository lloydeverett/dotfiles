local nodes = require("treectl.nodes")
local providers = require("treectl.providers")
local luautils = require("treectl.luautils")

local create_node = nodes.create_node
local create_lazy_node = nodes.create_lazy_node

return function()
local M = {}

M._root_nodes = {}
function M.root_nodes()
    return M._root_nodes
end

table.insert(M._root_nodes, create_lazy_node(
    "buffer",
    providers.simple_provider(function()
        return luautils.map(luautils.list_open_buffers(), function(b)
            local display_name = b.name
            if display_name == "" then
                display_name = "[No Name]"
            end
            return create_node("" .. b.bufnr, {}, {}, {
                label = { display_name, " ", { "" .. b.bufnr, "Number" } }
            })
        end)
    end),
    {},
    { hl = "DiagnosticInfo" })
)

table.insert(M._root_nodes, create_node("recent", {}, {}, { hl = "DiagnosticInfo" }))

table.insert(M._root_nodes, create_node("vim", {
    create_node("buffer"),
    create_node("window"),
    create_node("hi"),
    create_node("tab"),
    create_node("register"),
    create_node("symbol"),
    create_node("mark"),
    create_node("plugin"),
}))

return M
end

