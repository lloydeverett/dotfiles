local create_node = require("nodeutils").create_node
local create_lazy_node = require("nodeutils").create_lazy_node

local M = {}

local provider = {
  get_children = function(n) return {} end,
  has_children = function(n) return false end,
}

function M.create_root()
    return create_node("fs", {
      create_node("/"),
      create_node("~/", {
        create_node("b-1-a"),
        create_node("b-2-b"),
      }),
    })
    -- TODO store path in the details field
    -- return create_lazy_node("fs", modfs_provider)
end

return M

