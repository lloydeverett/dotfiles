math.randomseed(os.time())

local NuiTree = require("nui.tree")
local NuiLine = require("nui.line")
local event = require("nui.utils.autocmd").event
local create_node = require("nodeutils").create_node
local create_lazy_node = require("nodeutils").create_lazy_node
local modfs = require("modfs")

-- sample provider implementations --------------------------------------------

local empty_provider = {
  get_children = function(n) return {} end,       -- return list of child nodes
  has_children = function(n) return false end,    -- true if node has children
}

local dummy_provider = {
  get_children = function(n) return {
    create_node("foo"),
    create_node("bar"),
  } end,
  has_children = function(n) return true end,
}

-- lazily supply tree nodes ---------------------------------------------------

local function is_node_lazy(n)
    return n.opts ~= nil and n.opts.lazy == true
end

local function lazy_node_get_provider(n)
    if not is_node_lazy(n) then
        return nil
    end
    return n.opts.provider
end

local function lazy_node_has_children(n)
    local provider = lazy_node_get_provider(n)
    if provider == nil then
        return n:has_children()
    end
    return provider:has_children(n)
end

local function lazy_node_expand(tree, n)
    local provider = lazy_node_get_provider(n)
    if provider ~= nil then
        for index, child_node in ipairs(provider:get_children(n)) do
            tree:add_node(child_node, n:get_id())
        end
    end
    n:expand()
    -- TODO: sanity check for leaking memory, by seeing if memory accumulates
    --       when toggling a huge list
    -- TODO: node path tracking + notion of stable paths
end

local function lazy_node_collapse(tree, n)
    n:collapse()
    if is_node_lazy(n) then
        for index, child_id in ipairs(n:get_child_ids()) do
            tree:remove_node(child_id)
        end
    end
    -- TODO: sanity check for leaking memory, by seeing if memory accumulates
    --       when toggling a huge list
    -- TODO: node path tracking + notion of stable paths
end

-- TODO: function for labels, defaulting to just the label field
--       but using a label function on the provider if one exists
--       maybe check if label is nil, and if so then use that function

-- node init ------------------------------------------------------------------

local function init_nodes()
  return {
    create_lazy_node("testing", dummy_provider),
    create_node("note", {
      create_node("make your own notes here"),
      create_node("can be based on files in ~/.treenote"),
      create_node("and then each file in there looks like an expanded tree"),
    }),
    modfs.create_root(),
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
    create_node("weather"),
    create_node("unicode"),
    create_node("places"),
    create_node("palette"),
    create_node("gradient"),
    create_node("syntax", {
      create_node("C"),
      create_node("C++"),
      create_node("Swift"),
    }),
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

    -- focus current node
    vim.keymap.set("n", "<CR>", function()
      local node = tree:get_node()
      print(vim.inspect(node))
    end, map_options)

    -- print current node
    vim.keymap.set("n", "<leader><CR>", function()
      local node = tree:get_node()
      print(vim.inspect(node))
    end, map_options)

    -- collapse current node
    vim.keymap.set("n", "H", function()
      local node = tree:get_node()
      lazy_node_collapse(tree, node)
      tree:render()
    end, map_options)

    -- expand current node
    vim.keymap.set("n", "L", function()
      local node = tree:get_node()
      lazy_node_expand(tree, node)
      tree:render()
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

