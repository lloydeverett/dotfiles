math.randomseed(os.time())

local NuiTree = require("nui.tree")
local luautils = require("treectl.luautils")
local nodes = require("treectl.nodes")
local uiutils = require("treectl.uiutils")
local modfs_init = require("treectl.modfs")
local modnvim_init = require("treectl.modnvim")

local function init_nodes()
    local modules = {
        modfs = modfs_init(),
        modnvim = modnvim_init(),
    }

    local root = {}
    table.insert(root, nodes.help_node("? = toggle help      Shift-H = collapse   Shift-L = expand              . = toggle                     ", { indicator = "none" }))
    table.insert(root, nodes.help_node("} = next top-level   { = prev top-level   ]] = next open top-level      [[ = up or prev open top-level ", { indicator = "none" }))
    table.insert(root, nodes.help_node("g. = toggle hidden   ⏎ = default action   Shift+⏎ = actions & preview   _ = zoom into                  ", { indicator = "none" }))
    table.insert(root, nodes.help_node("- = zoom up                                                                                            ", { indicator = "none" }))
    luautils.insert_all(root, modules.modfs.root_nodes())
    luautils.insert_all(root, modules.modnvim.root_nodes())
    table.insert(root, nodes.node("pin", { hl = "GruvboxPurple" }, {
      nodes.node("pin nodes from other subtrees here"),
    }))
    table.insert(root, nodes.node("note", { hl = "GruvboxPurple" }, {
      nodes.node("make your own notes here"),
      nodes.node("can be based on files in ~/.treenote"),
      nodes.node("and then each file in there looks like an expanded tree"),
    }))
    table.insert(root, nodes.node("task", { hl = "GruvboxPurple" }))
    table.insert(root, nodes.node("calendar", { hl = "GruvboxPurple" }, {
      nodes.node("2024"),
      nodes.node("2025", {
        nodes.node("01 [January]", {
            nodes.node("events"),
            nodes.node("days")
        }),
      }),
      nodes.node("2026"),
    }))
    table.insert(root, nodes.node("timer", { hl = "GruvboxPurple" }, {
        nodes.node("Start 5min", { hl = "GruvboxPurple", indicator = "action" }),
        nodes.node("Start 15min", { hl = "GruvboxPurple", indicator = "action" }),
        nodes.node("Start...", { hl = "GruvboxPurple", indicator = "action" }),
    }))
    table.insert(root, nodes.node("todo", {}, {
        nodes.node("clearlist gradients as part of note function?"),
        nodes.node("maybe also ties in with pomodoro / calendar?"),
        nodes.node("todo: scratch buffers that display as text with refs in insert mode, but in normal mode refs resolve to tree nodes and render as tree nodes"),
        nodes.node("build git support into fs module"),
        nodes.node("shift + enter to zoom if current node has stable path -- although it'd be nice to zoom into a folder without it necessarily having a fixed placement in the tree, so work that out too"),
        nodes.node("maybe uri syntax along the lines of: provider-name://arbitrary/path/defined/by/provider; where provdier can return path for node or resolve a path"),
        nodes.node("and, if the provider wants, it can use its parent node to help it figure out the path when asked to return a path, but it might not need to in the filesystem case"),
        nodes.node("popup for node preview + keybindings on enter"),
        nodes.node("optionally display preview + keybindings in a split too"),
        nodes.node("allow searching by opening a scratch buffer filled with cached fully expanded node contents that links back to the real tree " ..
                    "(although some nodes you don't need to use a cache, e.g. calendar, because you can just expand all the data anyway)"),
    }))
    table.insert(root, nodes.node("www", {}, {
      nodes.node("tab"),
      nodes.node("bookmark"),
    }))
    table.insert(root, nodes.node("llm"))
    table.insert(root, nodes.node("steampipe"))
    table.insert(root, nodes.node("matrix", {}, {
        nodes.node("slack"),
        nodes.node("whatsapp"),
    }))
    table.insert(root, nodes.node("man"))
    table.insert(root, nodes.node("email"))
    table.insert(root, nodes.node("shell", {}, {
      nodes.node("env"),
      nodes.node("alias"),
      nodes.node("bin"),
      nodes.node("path"),
      nodes.node("job"),
    }))
    table.insert(root, nodes.node("music"))
    table.insert(root, nodes.node("git"))
    table.insert(root, nodes.node("gh"))
    table.insert(root, nodes.node("raycast"))
    table.insert(root, nodes.node("kubectl"))
    table.insert(root, nodes.node("window"))
    table.insert(root, nodes.node("systemd"))
    table.insert(root, nodes.node("os", {}, {
      nodes.node("details", {}, {
        nodes.node("battery: xx%"),
      }),
      nodes.node("storage"),
      nodes.node("process"),
      nodes.node("netstat"),
      nodes.node("application")
    }))
    table.insert(root, nodes.node("brew"))
    table.insert(root, nodes.node("db", {}, {
      nodes.node("sqlite"),
      nodes.node("postgres"),
      nodes.node("mysql"),
    }))
    table.insert(root, nodes.node("takeout"))
    table.insert(root, nodes.node("docker"))
    table.insert(root, nodes.node("podman"))
    table.insert(root, nodes.node("reference", {}, {
        nodes.node("palette"),
        nodes.node("gradient"),
        nodes.node("treectl"),
        nodes.node("unicode"),
        nodes.node("english"),
        nodes.node("tz"),
        nodes.node("wikipedia"),
        nodes.node("syntax", {}, {
            nodes.node("C"),
            nodes.node("C++"),
            nodes.node("Swift"),
        }),
    }))
    table.insert(root, nodes.node("youtube"))

    return root, modules
end

local g_buf_suffix = "treectl#state#current_buf_suffix"
local g_main_bufnr = "treectl#state#main_bufnr"
vim.g[g_buf_suffix] = 1
vim.g[g_main_bufnr] = nil

local function show_tree()

    local show_help = vim.g["treectl#show_help_by_default"] or false

    local winid = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_win_set_buf(winid, bufnr)
    if vim.g[g_main_bufnr] == nil then
        vim.api.nvim_buf_set_name(bufnr, "treectl#0")
        vim.g[g_main_bufnr] = bufnr
    else
        vim.api.nvim_buf_set_name(bufnr, "treectl#" .. vim.g[g_buf_suffix])
        vim.g[g_buf_suffix] = vim.g[g_buf_suffix] + 1
    end

    local nodes, modules = init_nodes()

    local tree = NuiTree({
      winid = winid,
      nodes = nodes,
      prepare_node = function(node)
          return uiutils.node_get_nui_line(node, { show_help = show_help })
      end,
    })

    local map_options = { noremap = true, nowait = true, buffer = true }

    -- focus current node
    vim.keymap.set("n", "<CR>", function()
        local node = uiutils.current_node(tree)
        print(vim.inspect(node))
    end, map_options)

    -- toggle modfs hidden files
    vim.keymap.set("n", "g.", function()
        uiutils.preserve_cursor_selection(tree, function()
            modules.modfs.toggle_show_hidden()
            uiutils.node_refresh_all_children_for_provider(tree, modules.modfs.directory_provider())
            tree:render()
        end)
    end, map_options)

    -- toggle help
    vim.keymap.set("n", "?", function()
        uiutils.preserve_cursor_selection(tree, function()
            show_help = not show_help
            tree:render()
        end)
    end, map_options)

    -- print current node
    vim.keymap.set("n", "<leader><CR>", function()
        local node = uiutils.current_node(tree)
        print(vim.inspect(node))
    end, map_options)

    -- collapse current node
    vim.keymap.set("n", "H", function()
        local node = uiutils.current_node(tree)
        uiutils.node_collapse(tree, node)
        tree:render()
    end, map_options)

    -- expand current node
    vim.keymap.set("n", "L", function()
        local node = uiutils.current_node(tree)
        uiutils.node_expand(tree, node)
        tree:render()
    end, map_options)

    -- toggle current node
    vim.keymap.set("n", ".", function()
        local node = uiutils.current_node(tree)
        if node:is_expanded() then
            uiutils.node_collapse(tree, node)
        else
            uiutils.node_expand(tree, node)
        end
        tree:render()
    end, map_options)

    -- next top-level node
    vim.keymap.set("n", "}", function()
        uiutils.place_cursor_on_next_top_level_node(tree)
    end, map_options)

    -- previous top-level node
    vim.keymap.set("n", "{", function()
        uiutils.place_cursor_on_prev_top_level_node(tree)
    end, map_options)

    -- parent, or previous open top level node if at top level
    vim.keymap.set("n", "[[", function()
        uiutils.place_cursor_on_parent_or_prev_open_top_level_node(tree)
    end, map_options)

    -- next open top level node
    vim.keymap.set("n", "]]", function()
        uiutils.place_cursor_on_next_open_top_level_node(tree)
    end, map_options)

    -- add new node under current node
    -- vim.keymap.set("n", "a", function()
    --   local node = uiutils.current_node(tree)
    --   tree:add_node(
    --     node("d", {
    --       node("d-1"),
    --     }),
    --     node:get_id()
    --   )
    --   tree:render()
    -- end, map_options)

    -- delete current node
    -- vim.keymap.set("n", "d", function()
    --   local node = uiutils.current_node(tree)
    --   tree:remove_node(node:get_id())
    --   tree:render()
    -- end, map_options)

    tree:render()

end

vim.keymap.set("n", "<leader>n", function()
    if vim.g[g_main_bufnr] ~= nil and vim.api.nvim_buf_is_loaded(vim.g[g_main_bufnr]) then
        local winid = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(winid, vim.g[g_main_bufnr])
    else
        vim.g[g_main_bufnr] = nil
        show_tree()
    end
end)

vim.keymap.set("n", "<leader>m", function()
    show_tree()
end)

