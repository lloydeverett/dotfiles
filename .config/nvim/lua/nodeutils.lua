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

function M.create_node_with_id(text, id, children, opts, details)
    return NuiTree.Node({ text = text, id = id, opts = opts, details = details }, children)
end

function M.create_node(text, children, opts, details)
    return M.create_node_with_id(text, M.uuid(), children, opts, details)
end

function M.create_lazy_node(text, provider, details)
    return M.create_node(text, {}, { lazy = true, provider = provider }, details)
end

function M.create_lazy_node_with_id(text, id, provider, details)
    return M.create_node_with_id(text, id, {}, {
        lazy = true,
        provider = provider
    }, details)
end

return M

