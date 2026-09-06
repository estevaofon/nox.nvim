-- ftplugin/noxy.lua - Settings for Noxy files
-- This file is executed automatically when filetype is set to 'noxy'

-- Buffer options
vim.bo.commentstring = "// %s"
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

-- Apply highlighting
local has_noxy, noxy = pcall(require, "noxy")
if has_noxy then
	local buf = vim.api.nvim_get_current_buf()
	vim.defer_fn(function()
		if vim.api.nvim_buf_is_valid(buf) then
			noxy.attach(buf)
		end
	end, 10)
end
