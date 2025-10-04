local nodes = require("treectl.nodes")

local create_node = nodes.create_node

local M = {}

-- interface reference and sample implementations ---------------------------------------

M.empty_provider = {
    -- will be called to supply children when opts.lazy == true:
    create_children = function(self, n) return {} end, -- return list of child nodes
    allows_expand = function(self, n) return false end,  -- true to show expand toggle
    refresh_children = function(self, n, current_children) return nil end,
            -- function used for niche case when we wish to (e.g. in a keybinding) update
            -- the immediate rendered children without triggering a collapse + expand
            -- note that:
            --     * may simply return nil if unused to make this a no-op
            --     * the implementation is not expected to recurse down the tree;
            --       this is the responsibility of the caller if necessary
            --     * expected to return a subset or superset of current_children
            --     * implementation may assume node is currently expanded
    -- will be called if text == nil:
    text = function(self, n) return "" end,             -- text to display
    slug = function(self, n) return "" end,             -- contribution to node path
    is_stable = function(self, n) return "" end,        -- node has deterministic path?
}

M.dummy_provider = {
    create_children = function(self, n) return {
      create_node("foo"),
      create_node("bar"),
    } end,
    allows_expand = function(self, n) return true end,
    refresh_children = function(self, n, current_children) return nil end,
    text = function(self, n) return "dummy_node" end,
    slug = function(self, n) return "dummy_node" end,
    is_stable = function(self, n) return true end,
}

M.stress_test_provider = {
    create_children = function(self, n)
        local result = {}
        for i = 1, 20000 do
            table.insert(result, create_node("foo." .. i))
        end
        return result
    end,
    allows_expand = function(self, n) return true end,
    refresh_children = function(self, n, current_children) return nil end,
    text = function(self, n) return "stress_test_node" end,
    slug = function(self, n) return "stress_test_node" end,
    is_stable = function(self, n) return true end,
}

-- helpers to define new providers ------------------------------------------------------

function M.simple_provider(create_children_fn)
    return {
        create_children = function(self, n)
            return create_children_fn(n)
        end,
        allows_expand = function(self, n) return true end,
        refresh_children = function(self, n, current_children) return nil end,
        text = function(self, n) return n.text end,
        slug = function(self, n) return n.text end,
        is_stable = function(self, n) return false end, -- safer to assume not, caller can override if need be
    }
end

return M

