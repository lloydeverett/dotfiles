
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

function M.lazy_node_has_children(n)
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

function M.lazy_node_expand(tree, n)
    if n:is_expanded() then
        return
    end
    if M.is_node_lazy(n) then
        local provider = M.get_provider(n)
        if provider ~= nil then
            for index, child_node in ipairs(provider:get_children(n)) do
                tree:add_node(child_node, n:get_id())
            end
        end
    end
    n:expand()
end

function M.lazy_node_collapse(tree, n)
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

function M.node_get_text(n)
    if M.is_node_text_dynamic(n) then
        local provider = M.get_provider(n)
        if provider ~= nil then
            return provider:text(n)
        else
            return "nil"
        end
    end
    return n.text
end

return M

