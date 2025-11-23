
vim.api.nvim_create_autocmd("FileType", {
    pattern = "vimwiki",
    callback = function()
        local path = vim.fn.expand("%")
        local day_pattern = "/(20%d%d)%-(%d%d)%-(%d%d)%.md$"
        local year, month, day = string.match(path, day_pattern)
        if year ~= nil and month ~= nil and day ~= nil then
            local timestamp = os.time({ year = year, month = month, day = day })
            vim.wo.winbar = " " .. os.date("%A, %d %B %Y", timestamp)
            return
        end

        year = nil; month = nil; day = nil
        local month_pattern = "/(20%d%d)%-(%d%d)%.md$"
        year, month = string.match(path, month_pattern)
        if year ~= nil and month ~= nil then
            local timestamp = os.time({ year = year, month = month, day = 1 })
            vim.wo.winbar = " " .. os.date("%B %Y", timestamp)
            return
        end
    end,
})

