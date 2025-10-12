
local M = {}

M.Comment = "treectl_Comment"
M.Hidden = "treectl_Hidden"
M.Directory = "treectl_Directory"
M.ErrorMsg = "treectl_ErrorMsg"
M.Number = "treectl_Number"
M.Debug = "treectl_Debug"
M.IndicatorActive = "treectl_IndicatorActive"
M.IndicatorInactive = "treectl_IndicatorInactive"
M.TreeModNvim = "treectl_TreeModNvim"
M.TreeModFs = "treectl_TreeModFs"
M.TreeModBuiltins = "treectl_TreeModBuiltins"
M.TreeModOther = "treectl_TreeModOther"

function M.configure()
    vim.cmd("highlight link treectl_Comment Comment")
    vim.cmd("highlight link treectl_Hidden Comment")
    vim.cmd("highlight link treectl_Directory Directory")
    vim.cmd("highlight link treectl_ErrorMsg ErrorMsg")
    vim.cmd("highlight link treectl_Number Number")
    vim.cmd("highlight link treectl_Debug SpecialChar")
    vim.cmd("highlight link treectl_IndicatorActive SpecialChar")
    vim.cmd("highlight link treectl_IndicatorInactive LineNr")
    vim.cmd("highlight link treectl_TreeModFs markdownH4")
    vim.cmd("highlight link treectl_TreeModNvim markdownH2")
    vim.cmd("highlight link treectl_TreeModBuiltins markdownH5")
    vim.cmd("highlight link treectl_TreeModOther markdownH6")
end

return M

