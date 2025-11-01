
local M = {}

function M.mktab(rows)
    vim.cmd(":tabnew")
    for _ = 1, #rows - 1 do
        vim.cmd(":split")
    end
    for _, filenames in ipairs(rows) do
        for i = #filenames, 1, -1 do
            local filename = filenames[i]
            if i == #filenames then
                vim.cmd(":e " .. filename)
            else
                vim.cmd(":vsplit " .. filename)
            end
        end
        vim.cmd(":wincmd j")
    end
    for _ = 1, #rows - 1 do
        vim.cmd(":wincmd k")
    end
end

return M


