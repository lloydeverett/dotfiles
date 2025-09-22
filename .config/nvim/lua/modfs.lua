local create_node = require("nodeutils").create_node
local create_lazy_node = require("nodeutils").create_lazy_node

local M = {}

local function path_concat(base, suffix)
    if base:sub(-1) == "/" then
        return base .. suffix
    else
        return base .. "/" .. suffix
    end
end

local function filename_of(path)
    return vim.fn.fnamemodify(path, ':t')
end

local provider = {
  get_children = function(self, n)
      local files = vim.fn.glob(path_concat(n.details.path, "*"), false, true)
      local result = {}
      local add_node = function(path, is_directory)
          table.insert(result, create_lazy_node(nil, self, {
              path = path,
              filename = filename_of(path),
              is_directory = is_directory
          }))
      end
      local is_directory = {}
      for _, path in ipairs(files) do
          table.insert(is_directory, vim.fn.isdirectory(path) ~= 0)
      end
      for i, path in ipairs(files) do
          if is_directory[i] == true then
              add_node(path, true)
          end
      end
      for i, path in ipairs(files) do
          if is_directory[i] == false then
              add_node(path, false)
          end
      end
      return result
  end,
  has_children = function(self, n)
      return #self:get_children(n) ~= 0
  end,
  text = function(self, n)
      if n.details.is_directory then
          return "📁 " .. n.details.filename
      end
      return "📄 " .. n.details.filename
  end,
  slug = function(self, n)
      return n.details.filename
  end,
  is_stable = function(self, n)
      return true
  end,
}

local function create_directory_node(label, path)
    return create_lazy_node(label, provider, { path = path, filename = filename_of(path) })
end

function M.create_root()
    return create_node("fs", {
        create_directory_node("/", "/"),
        create_directory_node("~/", os.getenv("HOME") .. "/"),
    })
end

return M

