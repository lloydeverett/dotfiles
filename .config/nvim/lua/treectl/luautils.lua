local uv = vim.loop

local M = {}

function M.insert_all(tbl, elements)
    for i, v in ipairs(elements) do
        table.insert(tbl, v)
    end
end

function M.filter(array, predicate)
    local result = {}
    for i, v in ipairs(array) do
        if predicate(v) then
            table.insert(result, v)
        end
    end
    return result
end

function M.map(array, transformation)
    local result = {}
    for i, v in ipairs(array) do
        result[i] = transformation(v)
    end
    return result
end

function M.path_concat(base, suffix)
    if base:sub(-1) == "/" then
        return base .. suffix
    else
        return base .. "/" .. suffix
    end
end

function M.resolve_type(path)
    local stat = uv.fs_stat(path)
    if stat == nil then
        return nil
    end
    return stat.type
end

function M.list_directory(path, opts)
    local omit_hidden = opts ~= nil and opts.omit_hidden

    local fd = uv.fs_scandir(path)
    local results = {}

    if not fd then
        print("Failed to open directory:", path)
        return {}
    end

    while true do
        local name, type = uv.fs_scandir_next(fd)
        if not name then break end

        local hidden = string.sub(name, 1, 1) == "."

        if not omit_hidden or not hidden then
            local subpath = M.path_concat(path, name)
            local resolved_type = type

            if type == "link" then
                local stat = uv.fs_stat(subpath)
                if stat ~= nil then
                    resolved_type = stat.type
                end
            end

            table.insert(results, {
                name = name,
                path = subpath,
                type = type,
                hidden = hidden,
                resolved_type = resolved_type
            })
        end
    end

    return results
end

function M.list_open_buffers()
    local buffers = vim.api.nvim_list_bufs()
    local result = {}

    for _, bufnr in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            local name = vim.api.nvim_buf_get_name(bufnr)
            table.insert(result, { bufnr = bufnr, name = name })
        end
    end

    return result
end


return M

