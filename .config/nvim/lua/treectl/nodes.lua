local NuiTree = require("nui.tree")

local M = {}

local function random8()
  return math.random(0, 255)
end

function M.gen_id()
    -- random 128-bit int encoded as a string
    return string.char(
        random8(), random8(), random8(), random8(),
        random8(), random8(), random8(), random8(),
        random8(), random8(), random8(), random8(),
        random8(), random8(), random8(), random8()
    )
end

function M.create_node_with_id(text, id, children, details, opts)
    return NuiTree.Node({ text = text, id = id, opts = opts, details = details }, children)
end

function M.create_node(text, children, details, opts)
    return M.create_node_with_id(text, M.gen_id(), children, details, opts)
end

function M.create_separator_line_node()
    return M.create_node(nil, {}, {}, { separator = true })
end

function M.insert_lazy_opts(provider, opts)
    local new_opts = {}
    if opts ~= nil then
        for k, v in pairs(opts) do
            new_opts[k] = v
        end
    end
    new_opts.lazy = true
    new_opts.provider = provider
    return new_opts
end

function M.create_lazy_node(text, provider, details, opts)
    opts = M.insert_lazy_opts(provider, opts)
    return M.create_node(text, {}, details, opts)
end

function M.create_lazy_node_with_id(text, id, provider, details, opts)
    opts = M.insert_lazy_opts(provider, opts)
    return M.create_node_with_id(text, id, {}, details, opts)
end

return M

