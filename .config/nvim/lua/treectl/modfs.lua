local nodes = require("treectl.nodes")
local luautils = require("treectl.luautils")
local nvimutils = require("treectl.nvimutils")

local home_path = nvimutils.home_path()

return function()
local M = {}

local cwd = luautils.path_concat(vim.fn.getcwd(), "")

M._show_hidden = vim.g["treectl#modfs#show_hidden_by_default"] or false
function M.set_show_hidden(value)
    M._show_hidden = value
end
function M.toggle_show_hidden()
    M._show_hidden = not M._show_hidden
end
function M.show_hidden()
    return M._show_hidden
end

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
    local opts = {
        details = {
            path = file.path,
            filename = file.name,
            is_directory = file.resolved_type == "directory",
            resolved_path = file.resolved_path,
            hidden = file.hidden
        }
    }
    return nodes.lazy_node(nil, opts, provider)
end

local function init_file_provider()
    return {
      create_children = function(self, n)
          if not n.details.is_directory then
              return {}
          end
          local files = sort_files_in_display_order(nvimutils.list_directory(n.details.path, {
              omit_hidden = not M.show_hidden()
          }))
          local result = {}
          for i, file in ipairs(files) do
              table.insert(result, node_from_file(self, file))
          end
          return result
      end,

      allows_expand = function(self, n)
          return n.details.is_directory
      end,

      text = function(self, n)
          local result = {}

          local highlight = nil
          if n.details.hidden then
              highlight = "Comment"
          elseif n.details.is_directory then
              highlight = "Directory"
          end

          if n.details.is_directory then
              table.insert(result, { (n.details.filename .. "/"), highlight })
          else
              table.insert(result, { n.details.filename, highlight })
          end

          if n.details.resolved_path ~= n.details.path then
              local displayed_path = n.details.resolved_path
              if n.details.is_directory then
                  displayed_path = luautils.path_concat(displayed_path, "")
              end
              table.insert(result, { (" -> " .. displayed_path), "Comment" })
          end

          return result
      end,

      path = function(self, n)
          return n.details.path
      end,

      refresh_children = function(self, n, current_children)
          local files = sort_files_in_display_order(nvimutils.list_directory(n.details.path, {
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

local function create_directory_node(provider, text, path, help_suffix)
    return nodes.lazy_node(text, {
        hl = "directory",
        help_suffix = help_suffix,
        details = { path = path, filename = nil, is_directory = true }
    }, provider)
end

M._directory_provider = init_file_provider()
function M.directory_provider()
    return M._directory_provider
end

M._root_nodes = {}
function M.root_nodes()
    return M._root_nodes
end

if cwd ~= home_path and cwd ~= "/" then
    local text = nvimutils.try_shorten_path(cwd)
    table.insert(M._root_nodes, create_directory_node(M._directory_provider, text, cwd, "current working directory"))
end

table.insert(M._root_nodes, create_directory_node(M._directory_provider, "~/", home_path, "home directory"))
table.insert(M._root_nodes, create_directory_node(M._directory_provider, "/", "/", "root directory"))

local help_suffix_treectl_dir = "displays contents of ~/.treectl when present"
if nvimutils.resolve_type(home_path .. ".treectl") == "directory" then
    table.insert(M._root_nodes, create_directory_node(M._directory_provider, "t/", home_path .. ".treectl/", help_suffix_treectl_dir))
else
    table.insert(M._root_nodes, nodes.help_node("t/", { help_suffix = help_suffix_treectl_dir }))
end

local help_suffix_zoxide = "displays frequent cd directories when zoxide is on the $PATH"
if not vim.fn.executable("zoxide") == 1 then
    -- TODO implement
    table.insert(M._root_nodes, nodes.node("z/", { hl = "directory", help_suffix = help_suffix_zoxide, path="z" }))
else
    table.insert(M._root_nodes, nodes.help_node("z/", { help_suffix = help_suffix_zoxide }))
end

return M
end

