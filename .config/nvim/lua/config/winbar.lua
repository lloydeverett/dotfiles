
vim.api.nvim_create_autocmd("FileType", {
    pattern = "vimwiki",
    callback = function()
        local function component_dt()
            local path = vim.fn.expand("%")
            local day_pattern = "/(20%d%d)%-(%d%d)%-(%d%d)%.md$"
            local year, month, day = string.match(path, day_pattern)
            if year ~= nil and month ~= nil and day ~= nil then
                local timestamp = os.time({ year = year, month = month, day = day })
                return " " .. os.date("%A, %d %B %Y", timestamp)
            end

            year = nil; month = nil; day = nil
            local month_pattern = "/(20%d%d)%-(%d%d)%.md$"
            year, month = string.match(path, month_pattern)
            if year ~= nil and month ~= nil then
                local timestamp = os.time({ year = year, month = month, day = 1 })
                return " " .. os.date("%B %Y", timestamp)
            end

            return nil
        end

        local dt = component_dt()
        if dt ~= nil then
            vim.wo.winbar = dt
        end
    end,
})

