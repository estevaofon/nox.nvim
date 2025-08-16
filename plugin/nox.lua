-- plugin/nox.lua - Auto-loading setup for nox.nvim
if vim.g.loaded_nox then
	return
end
vim.g.loaded_nox = 1

-- Setup the plugin automatically
require("nox").setup()
