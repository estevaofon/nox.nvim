-- ftplugin/nox.lua - Settings for Nox files
-- This file is executed automatically when filetype is set to 'nox'

-- Buffer options
vim.bo.commentstring = "// %s"
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

-- Apply highlighting
local has_nox, nox = pcall(require, "nox")
if has_nox then
	local buf = vim.api.nvim_get_current_buf()
	vim.defer_fn(function()
		if vim.api.nvim_buf_is_valid(buf) then
			nox.attach(buf)
		end
	end, 10)
end
