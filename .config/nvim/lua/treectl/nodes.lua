local NuiTree = require("nui.tree")

local function insert_opts(opts, additions)
    local new_opts = {}
    if opts ~= nil then
        for k, v in pairs(opts) do
            new_opts[k] = v
        end
    end
    for k, v in pairs(additions) do
        new_opts[k] = v
    end
    return new_opts
end

local function insert_lazy_opts(opts, provider)
    return insert_opts(opts, { lazy = true, provider = provider })
end

local function random8()
  return math.random(0, 255)
end

local M = {}

function M.gen_id()
    -- random 128-bit int encoded as a string
    return string.char(
        random8(), random8(), random8(), random8(),
        random8(), random8(), random8(), random8(),
        random8(), random8(), random8(), random8(),
        random8(), random8(), random8(), random8()
    )
end

function M.node_with_id(text, id, children, details, opts)
    if details == nil then
        details = {}
    end
    if opts == nil then
        opts = {}
    end
    return NuiTree.Node({ text = text, id = id, opts = opts, details = details }, children)
end

function M.node(text, children, details, opts)
    return M.node_with_id(text, M.gen_id(), children, details, opts)
end

function M.create_separator_node()
    return M.node(nil, {}, {}, { separator = true })
end

function M.lazy_node(text, provider, details, opts)
    opts = insert_lazy_opts(opts, provider)
    return M.node(text, {}, details, opts)
end

function M.lazy_node_with_id(text, id, provider, details, opts)
    opts = insert_lazy_opts(opts, provider)
    return M.node_with_id(text, id, {}, details, opts)
end

function M.help_node(text, details, opts)
    opts = insert_opts(opts, { help = true })
    return M.node(text, {}, details, opts)
end

function M.bare_help_node(text, details, opts)
    opts = insert_opts(opts, { help = true, indicator = "none" })
    return M.node(text, {}, details, opts)
end

return M

