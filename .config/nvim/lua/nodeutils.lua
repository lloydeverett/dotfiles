local NuiTree = require("nui.tree")
local random = math.random

local M = {}

function M.uuid()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end)
end

function M.create_node_with_id(label, id, children, opts, details)
    return NuiTree.Node({ text = label, id = id, opts = opts, details = details }, children)
end

function M.create_node(label, children, opts, details)
    return M.create_node_with_id(label, M.uuid(), children, opts, details)
end

function M.create_lazy_node(label, provider, details)
    return M.create_node(label, {}, { lazy = true, provider = provider }, details)
end

function M.create_lazy_node_with_id(label, id, provider, details)
    return M.create_node_with_id(label, id, {}, {
        lazy = true,
        provider = provider
    }, details)
end

return M

