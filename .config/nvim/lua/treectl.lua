local Split = require("nui.split")
local NuiTree = require("nui.tree")
local NuiLine = require("nui.line")
local event = require("nui.utils.autocmd").event

-- example provider implementation --------------------------------------------

local empty_provider = {
  get_children = function(n) return {} end,       -- return list of child nodes
  has_children = function(n) return false end,    -- true if node has children
}

-- utils ----------------------------------------------------------------------

math.randomseed(os.time())
local random = math.random

local function uuid()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end)
end

local function create_node_with_id(label, id, children, opts)
    return NuiTree.Node({ text = label, id = id, opts = opts }, children)
end

local function create_node(label, children, opts)
    return create_node_with_id(label, uuid(), children)
end

local function create_lazy_node(label, provider)
    return create_node(label, {}, { lazy = true, provider = provider })
end

local function create_lazy_node_with_id(label, id, provider)
    return create_node_with_id(label, id, {}, {
        lazy = true,
        provider = provider
    })
end

-- lazily supply tree nodes ---------------------------------------------------

local function is_node_lazy(n)
    return n[opts] ~= nil and n[opts][lazy] == true
end

local function lazy_node_get_provider(n)
    if not is_node_lazy(n) then
        return nil
    end
    return n[opts][provider]
end

local function lazy_node_has_children(n)
    local provider = lazy_node_get_provider(n)
    if provider == nil then
        return n:has_children()
    end
    return provider:has_children(n)
end

local function lazy_node_expand(n)
    local provider = lazy_node_get_provider(n)
    if provider == nil then
        n:expand()
    end
    -- TODO: reach out to data provider
    -- TODO: return value? does n:expand have a return value?
    -- TODO: actually call this below?
end

local function lazy_node_collapse(tree, n)
    n:collapse()
    if is_node_lazy(n) then
        -- TODO: remove nodes
    end
    -- TODO: return value? does n:collapse have a return value?
    -- TODO: actually call this below?
end

-- rendering & bindings -------------------------------------------------------

local function show_tree()

    local split = Split({
      relative = "editor",
      position = "bottom",
      size = "40%",
    })

    split:mount()

    -- quit
    split:map("n", "q", function()
      split:unmount()
    end, { noremap = true })

    local tree = NuiTree({
      winid = split.winid,
      nodes = {
        create_node("a"),
        create_node("b", {
          create_node("b-1"),
          create_node("b-2", {
            create_node("b-1-a"),
            create_node("b-2-b"),
          }),
        }),
        create_node("c", {
          create_node("c-1"),
          create_node("c-2"),
        }),
      },
      prepare_node = function(node)
        local line = NuiLine()

        line:append(string.rep("  ", node:get_depth() - 1))

        if lazy_node_has_children(node) then
          line:append(node:is_expanded() and "- " or "+ ", "SpecialChar")
        else
          line:append("  ")
        end

        line:append(node.text)

        return line
      end,
    })

    local map_options = { noremap = true, nowait = true }

    -- print current node
    split:map("n", "<CR>", function()
      local node = tree:get_node()
      print(vim.inspect(node))
    end, map_options)

    -- collapse current node
    split:map("n", "h", function()
      local node = tree:get_node()

      if node:collapse() then
        tree:render()
      end
    end, map_options)

    -- collapse all nodes
    split:map("n", "H", function()
      local updated = false

      for _, node in pairs(tree.nodes.by_id) do
        updated = node:collapse() or updated
      end

      if updated then
        tree:render()
      end
    end, map_options)

    -- expand current node
    split:map("n", "l", function()
      local node = tree:get_node()

      if node:expand() then
        tree:render()
      end
    end, map_options)

    -- expand all nodes
    -- split:map("n", "L", function()
    --   local updated = false
    --
    --   for _, node in pairs(tree.nodes.by_id) do
    --     updated = node:expand() or updated
    --   end
    --
    --   if updated then
    --     tree:render()
    --   end
    -- end, map_options)

    -- add new node under current node
    split:map("n", "a", function()
      local node = tree:get_node()
      tree:add_node(
        create_node("d", {
          create_node("d-1"),
        }),
        node:get_id()
      )
      tree:render()
    end, map_options)

    -- delete current node
    split:map("n", "d", function()
      local node = tree:get_node()
      tree:remove_node(node:get_id())
      tree:render()
    end, map_options)

    tree:render()

end

vim.keymap.set("n", "<leader>n", function()
    show_tree()
end)

