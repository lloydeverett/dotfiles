local NuiLine = require("nui.line")

local M = {}

function M.is_node_lazy(n)
    return n.opts ~= nil and n.opts.lazy == true
end

function M.is_node_text_dynamic(n)
    return n.text == nil
end

function M.get_provider(n)
    if n.opts == nil then
        return nil
    end

    return n.opts.provider
end

function M.node_has_children(n)
    if M.is_node_lazy(n) then
        local provider = M.get_provider(n)
        if provider ~= nil then
            return provider:has_children(n)
        else
            return false
        end
    end

    return n:has_children()
end

function M.node_expand(tree, n)
    if n:is_expanded() then
        return
    end

    if M.is_node_lazy(n) then
        local provider = M.get_provider(n)
        if provider ~= nil then
            for index, child_node in ipairs(provider:create_children(n)) do
                tree:add_node(child_node, n:get_id())
            end
        end
    end
    n:expand()

    -- auto-expand subtree if there is only one child node
    local child_ids = n:get_child_ids()
    if #child_ids == 1 then
        M.node_expand(tree, tree:get_node(child_ids[1]))
    end
end

function M.node_collapse(tree, n)
    if not n:is_expanded() then
        return
    end

    n:collapse()
    if M.is_node_lazy(n) then
        for index, child_id in ipairs(n:get_child_ids()) do
            tree:remove_node(child_id)
        end
    end
end

function M.node_refresh_children(tree, n)
    if not n:is_expanded() or not M.is_node_lazy(n) then
        return
    end

    local provider = M.get_provider(n)
    if not provider:has_children(n) then
        return
    end

    local current_children = {}
    for index, child_id in ipairs(n:get_child_ids()) do
        local node = tree:get_node(child_id)
        table.insert(current_children, node)
    end

    local new_children = provider:refresh_children(n, current_children)
    if new_children == nil then
        return
    end

    tree:set_nodes(new_children, n:get_id())
end

function M.node_refresh_all_children_for_provider(tree, provider)
    local refresh_recursively
    refresh_recursively = function(node_id)
        local n = tree:get_node(node_id)

        if M.get_provider(n) == provider then
            M.node_refresh_children(tree, n)
        end

        for index, child_id in ipairs(n:get_child_ids()) do
            refresh_recursively(child_id)
        end
    end
    for index, top_level_node in ipairs(tree:get_nodes()) do
        refresh_recursively(top_level_node:get_id())
    end
end

function M.node_get_text(n)
    if M.is_node_text_dynamic(n) then
        local provider = M.get_provider(n)
        if provider ~= nil then
            return provider:text(n)
        else
            return "nil", "ErrorMsg"
        end
    end

    if n.opts ~= nil and n.opts.hl ~= nil then
        return n.text, n.opts.hl
    elseif n:get_parent_id() == nil then
        return n.text, "Define"
    end

    return n.text
end

function M.node_get_nui_line(n)
    local line = NuiLine()

    if n.opts ~= nil and n.opts.separator then
        return line
    end

    line:append(string.rep("  ", n:get_depth() - 1))

    if M.node_has_children(n) then
      line:append(n:is_expanded() and "- " or "+ ", "SpecialChar")
    else
      line:append("- ", "LineNr")
    end

    text, text_color = M.node_get_text(n)
    line:append(text, text_color)

    return line
end

function M.current_cursor_pos()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    return row, col
end

function M.set_cursor_row(new_row)
    local row, col = M.current_cursor_pos()
    vim.api.nvim_win_set_cursor(0, {new_row, col})
end

function M.place_cursor_on_node(tree, node)
    local n, line_start, line_end = tree:get_node(node:get_id())
    M.set_cursor_row(line_start)
end

function M.current_node(tree)
    local row, col = M.current_cursor_pos()
    local node, line_start, line_end = tree:get_node(row)
    return node
end

function M.place_cursor_on_prev_top_level_node(tree)
    local ancestors = M.node_ancestors(tree, M.current_node(tree))
    local row, col = M.current_cursor_pos()
    local toplevel_node_id = ancestors[#ancestors]
    local toplevel_node, toplevel_node_start, toplevel_node_end = tree:get_node(toplevel_node_id)

    if row ~= toplevel_node_start then
        M.set_cursor_row(toplevel_node_start)
        return
    end

    local toplevel_nodes = tree:get_nodes()
    local index = nil
    for i, node in ipairs(toplevel_nodes) do
        if node:get_id() == toplevel_node_id then
            index = i
            break
        end
    end

    if index == nil then
        return
    end
    index = index - 1
    if index < 1 then
        return
    end

    M.place_cursor_on_node(tree, toplevel_nodes[index])
end

function M.place_cursor_on_next_top_level_node(tree)
    local ancestors = M.node_ancestors(tree, M.current_node(tree))
    local row, col = M.current_cursor_pos()
    local toplevel_node_id = ancestors[#ancestors]
    local toplevel_node, toplevel_node_start, toplevel_node_end = tree:get_node(toplevel_node_id)

    local toplevel_nodes = tree:get_nodes()
    local index = nil
    for i, node in ipairs(toplevel_nodes) do
        if node:get_id() == toplevel_node_id then
            index = i
            break
        end
    end

    if index == nil then
        return
    end
    index = index + 1
    if index > #toplevel_nodes then
        return
    end

    M.place_cursor_on_node(tree, toplevel_nodes[index])
end

function M.node_ancestors(tree, node)
    local node_id = node:get_id()
    local node_ancestor_ids = { node_id }
    local current_ancestor = node
    while current_ancestor:get_parent_id() ~= nil do
        table.insert(node_ancestor_ids, current_ancestor:get_parent_id())
        current_ancestor = tree:get_node(current_ancestor:get_parent_id())
    end
    return node_ancestor_ids
end

function M.preserve_cursor_selection(tree, callback)
    selection_ancestor_ids  = M.node_ancestors(tree, M.current_node(tree))

    -- do some work that may disrupt cursor position
    -- typically this would involve a call to tree:render()
    callback()

    -- try to place cursor on the node on which it was previously placed
    -- if no longer present, try to find the nearest ancestor
    for index, ancestor_id in ipairs(selection_ancestor_ids) do
        local node, line_start, line_end = tree:get_node(ancestor_id)
        if line_start ~= nil then
            M.set_cursor_row(line_start)
            break
        end
    end
end

return M

