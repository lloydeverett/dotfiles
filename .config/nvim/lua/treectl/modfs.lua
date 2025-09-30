local nodeutils = require("treectl.nodeutils")
local luautils = require("treectl.luautils")

local function sort_files_in_display_order(files)
    local result = {}
    for i, file in ipairs(files) do
        if file.resolved_type == "directory" then
            table.insert(result, file)
        end
    end
    for i, file in ipairs(files) do
        if file.resolved_type ~= "directory" then
            table.insert(result, file)
        end
    end
    return result
end

local function node_from_file(provider, file)
    return nodeutils.create_lazy_node(nil, provider, {
        path = file.path,
        filename = file.name,
        is_directory = file.resolved_type == "directory",
        hidden = file.hidden
    })
end

local function init_provider(M)
    return {
      create_children = function(self, n)
          if not n.details.is_directory then
              return {}
          end
          local files = sort_files_in_display_order(luautils.list_directory(n.details.path, {
              omit_hidden = not M.show_hidden()
          }))
          local result = {}
          for i, file in ipairs(files) do
              table.insert(result, node_from_file(self, file))
          end
          return result
      end,

      has_children = function(self, n)
          return n.details.is_directory
      end,

      text = function(self, n)
          local highlight = nil
          if n.details.hidden then
              highlight = "Comment"
          elseif n.details.is_directory then
              highlight = "Directory"
          end

          if n.details.is_directory then
              return (n.details.filename .. "/"), highlight
          end
          return n.details.filename, highlight
      end,

      slug = function(self, n)
          return n.details.filename
      end,

      is_stable = function(self, n)
          return true
      end,

      refresh_children = function(self, n, current_children)
          local files = sort_files_in_display_order(luautils.list_directory(n.details.path, {
              omit_hidden = not M.show_hidden()
          }))

          local current_children_kv = {}
          for i, v in ipairs(current_children) do
              current_children_kv[v.details.filename] = v
          end

          local result = {}
          for i, file in ipairs(files) do
              local existing = current_children_kv[file.name]
              if existing ~= nil then
                  table.insert(result, existing)
              else
                  table.insert(result, node_from_file(self, file))
              end
          end
          return result
      end,
    }
end

local function create_directory_node(provider, label, path)
    return nodeutils.create_lazy_node(
        label,
        provider,
        { path = path, filename = nil, is_directory = true },
        { hl = "directory" })
end

return function()
    local home_path = luautils.path_concat(os.getenv("HOME"), "")
    local cwd = luautils.path_concat(vim.fn.getcwd(), "")

    local M = {}

    M._show_hidden = vim.g["treectl#modfs#show_hidden_by_default"] or false
    function M.set_show_hidden(value)
        M._show_hidden = value
    end
    function M.toggle_show_hidden()
        M.set_show_hidden(not M._show_hidden)
    end
    function M.show_hidden()
        return M._show_hidden
    end

    M._provider = init_provider(M)
    function M.provider()
        return M._provider
    end

    M._root_nodes = {}
    if cwd ~= home_path and cwd ~= "/" then
        local text = cwd
        if cwd:sub(1, #home_path) == home_path then
            text = "~/" .. cwd:sub(#home_path + 1)
        end
        table.insert(M._root_nodes, create_directory_node(M._provider, text, cwd))
    end
    table.insert(M._root_nodes, create_directory_node(M._provider, "~/", home_path))
    table.insert(M._root_nodes, create_directory_node(M._provider, "/", "/"))

    if luautils.resolve_type(home_path .. ".treectl") == "directory" then
        table.insert(M._root_nodes, create_directory_node(M._provider, "t/", home_path .. ".treectl"))
    end

    if vim.fn.executable("zoxide") == 1 then
        -- TODO implement
        table.insert(M._root_nodes, nodeutils.create_node("z/", {}, {}, { hl = "directory" }))
    end

    function M.root_nodes()
        return M._root_nodes
    end

    return M
end

