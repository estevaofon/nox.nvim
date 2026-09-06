-- plugin/noxy.lua - Auto-loading setup for noxy.nvim
if vim.g.loaded_noxy then
	return
end
vim.g.loaded_noxy = 1

-- Setup the plugin automatically
require("noxy").setup()
