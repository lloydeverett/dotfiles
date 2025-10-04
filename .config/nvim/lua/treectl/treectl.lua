math.randomseed(os.time())

local NuiTree = require("nui.tree")
local luautils = require("treectl.luautils")
local nodes = require("treectl.nodes")
local uiutils = require("treectl.uiutils")
local modfs_init = require("treectl.modfs")
local modvim_init = require("treectl.modvim")

local create_node = nodes.create_node

local function init_nodes()
    local modules = {
        modfs = modfs_init(),
        modvim = modvim_init(),
    }

    local root = {}
    luautils.insert_all(root, modules.modfs.root_nodes())
    luautils.insert_all(root, modules.modvim.root_nodes())
    table.insert(root, create_node("todo", {
        create_node("help mode that unhides nodes that have been marked with an opt that designates them as help-only"),
        create_node("you could also have an opt for 'comment' label suffixes that are only rendered when in help mode"),
        create_node("shift + enter to zoom if current node has stable path -- although it'd be nice to zoom into a folder without it necessarily having a fixed placement in the tree, so work that out too"),
        create_node("maybe uri syntax along the lines of: provider-name://arbitrary/path/defined/by/provider; where provdier can return path for node or resolve a path"),
        create_node("and, if the provider wants, it can use its parent node to help it figure out the path when asked to return a path, but it might not need to in the filesystem case"),
        create_node("popup for node preview + keybindings on enter"),
        create_node("optionally display preview + keybindings in a split too"),
        create_node("allow searching by opening a scratch buffer filled with cached fully expanded node contents that links back to the real tree " ..
                    "(although some nodes you don't need to use a cache, e.g. calendar, because you can just expand all the data anyway)"),
    }))
    table.insert(root, create_node("note", {
      create_node("make your own notes here"),
      create_node("can be based on files in ~/.treenote"),
      create_node("and then each file in there looks like an expanded tree"),
    }))
    table.insert(root, create_node("application"))
    table.insert(root, create_node("task"))
    table.insert(root, create_node("www", {
      create_node("tab"),
      create_node("bookmark"),
    }))
    table.insert(root, create_node("llm"))
    table.insert(root, create_node("steampipe"))
    table.insert(root, create_node("matrix", {
        create_node("slack"),
        create_node("whatsapp"),
    }))
    table.insert(root, create_node("man"))
    table.insert(root, create_node("email"))
    table.insert(root, create_node("shell", {
      create_node("env"),
      create_node("alias"),
      create_node("bin"),
      create_node("path"),
      create_node("job"),
    }))
    table.insert(root, create_node("music"))
    table.insert(root, create_node("git"))
    table.insert(root, create_node("gh"))
    table.insert(root, create_node("raycast"))
    table.insert(root, create_node("kubectl"))
    table.insert(root, create_node("window"))
    table.insert(root, create_node("calendar", {
      create_node("2024"),
      create_node("2025", {
        create_node("01 [January]", {
            create_node("events"),
            create_node("days")
        }),
      }),
      create_node("2026"),
    }))
    table.insert(root, create_node("systemd"))
    table.insert(root, create_node("os", {
      create_node("details", {
        create_node("battery: xx%"),
      }),
      create_node("storage"),
      create_node("process"),
      create_node("netstat"),
    }))
    table.insert(root, create_node("brew"))
    table.insert(root, create_node("db", {
      create_node("sqlite"),
      create_node("postgres"),
      create_node("mysql"),
    }))
    table.insert(root, create_node("treectl"))
    table.insert(root, create_node("weather"))
    table.insert(root, create_node("takeout"))
    table.insert(root, create_node("places"))
    table.insert(root, create_node("docker"))
    table.insert(root, create_node("podman"))
    table.insert(root, create_node("reference", {
        create_node("palette"),
        create_node("gradient"),
        create_node("unicode"),
        create_node("english"),
        create_node("tz"),
        create_node("syntax", {
            create_node("C"),
            create_node("C++"),
            create_node("Swift"),
        }),
    }))
    table.insert(root, create_node("youtube"))
    table.insert(root, create_node("wikipedia"))

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
    --     create_node("d", {
    --       create_node("d-1"),
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

