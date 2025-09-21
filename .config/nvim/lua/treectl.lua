local NuiTree = require("nui.tree")
local NuiLine = require("nui.line")
local event = require("nui.utils.autocmd").event

-- sample provider implementation ---------------------------------------------

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
    -- TODO: sanity check for leaking memory, by seeing if memory accumulates
    --       when toggling a huge list
end

local function lazy_node_collapse(tree, n)
    n:collapse()
    if is_node_lazy(n) then
        -- TODO: remove nodes
    end
    -- TODO: return value? does n:collapse have a return value?
    -- TODO: actually call this below?
    -- TODO: sanity check for leaking memory, by seeing if memory accumulates
    --       when toggling a huge list
end

-- TODO: function for labels, defaulting to just the label field
--       but using a label function on the provider if one exists

-- node init ------------------------------------------------------------------

local function init_nodes()
  return {
    create_node("note", {
      create_node("make your own notes here"),
      create_node("can be based on files in ~/.treenote"),
      create_node("and then each file in there looks like an expanded tree"),
    }),
    create_node("fs", {
      create_node("/"),
      create_node("~/", {
        create_node("b-1-a"),
        create_node("b-2-b"),
      }),
    }),
    create_node("application"),
    create_node("task"),
    create_node("www", {
      create_node("tab"),
      create_node("bookmark"),
    }),
    create_node("llm"),
    create_node("steampipe"),
    create_node("zoxide"),
    create_node("slack"),
    create_node("email"),
    create_node("shell", {
      create_node("~/.bin"),
      create_node("env"),
      create_node("alias"),
      create_node("bin"),
      create_node("path"),
      create_node("job"),
    }),
    create_node("music"),
    create_node("git"),
    create_node("vim", {
      create_node("buffer"),
      create_node("window"),
      create_node("tab"),
      create_node("register"),
      create_node("symbol"),
      create_node("mark"),
      create_node("plugin"),
    }),
    create_node("raycast"),
    create_node("kubectl"),
    create_node("window"),
    create_node("calendar", {
      create_node("2024"),
      create_node("2025", {
        create_node("01 [January]", {
            create_node("events"),
            create_node("days")
        }),
      }),
      create_node("2026"),
    }),
    create_node("systemd"),
    create_node("os", {
      create_node("details", {
        create_node("battery: xx%"),
      }),
      create_node("storage"),
      create_node("process"),
      create_node("netstat"),
    }),
    create_node("brew"),
    create_node("db", {
      create_node("sqlite"),
      create_node("postgres"),
      create_node("mysql"),
    }),
    create_node("dictionary", {
      create_node("english"),
    }),
    create_node("treectl"),
    create_node("tz"),
    create_node("wikipedia")
  }
end

-- rendering & bindings -------------------------------------------------------

vim.g.buf_suffix = 0

local function show_tree()
    local winid = vim.api.nvim_get_current_win()

    local bufnr = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(bufnr, "treectl#" .. vim.g.buf_suffix)
    vim.g.buf_suffix = vim.g.buf_suffix + 1
    vim.api.nvim_win_set_buf(winid, bufnr)

    local tree = NuiTree({
      winid = winid,
      nodes = init_nodes(),
      prepare_node = function(node)
        local line = NuiLine()

        line:append(string.rep("  ", node:get_depth() - 1))

        if lazy_node_has_children(node) then
          line:append(node:is_expanded() and "- " or "+ ", "SpecialChar")
        else
          line:append("- ", "LineNr")
        end

        line:append(node.text)

        return line
      end,
    })

    local map_options = { noremap = true, nowait = true, buffer = true }

    -- print current node
    vim.keymap.set("n", "<CR>", function()
      local node = tree:get_node()
      print(vim.inspect(node))
    end, map_options)

    -- collapse current node
    vim.keymap.set("n", "H", function()
      local node = tree:get_node()

      if node:collapse() then
        tree:render()
      end
    end, map_options)

    -- expand current node
    vim.keymap.set("n", "L", function()
      local node = tree:get_node()

      if node:expand() then
        tree:render()
      end
    end, map_options)

    -- add new node under current node
    vim.keymap.set("n", "a", function()
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
    vim.keymap.set("n", "d", function()
      local node = tree:get_node()
      tree:remove_node(node:get_id())
      tree:render()
    end, map_options)

    tree:render()

end

vim.keymap.set("n", "<leader>n", function()
    show_tree()
end)

