-- noxy/highlights.lua - Highlight group definitions
local M = {}

function M.setup()
	-- Define highlight groups with the same colors as original
	vim.api.nvim_set_hl(0, "NoxyKeyword", { fg = "#ff0080", bold = true })
	vim.api.nvim_set_hl(0, "NoxyType", { fg = "#64c8ff" })
	vim.api.nvim_set_hl(0, "NoxyString", { fg = "#00ffff" })
	vim.api.nvim_set_hl(0, "NoxyNumber", { fg = "#ffd700" })
	vim.api.nvim_set_hl(0, "NoxyComment", { fg = "#808080", italic = true })
	vim.api.nvim_set_hl(0, "NoxyOperator", { fg = "#ff64ff" })
	vim.api.nvim_set_hl(0, "NoxyBoolean", { fg = "#ffa500" })
	vim.api.nvim_set_hl(0, "NoxyNull", { fg = "#9370db" })
	vim.api.nvim_set_hl(0, "NoxyBuiltin", { fg = "#32cd32" })
	vim.api.nvim_set_hl(0, "NoxyFunction", { fg = "#00ff80" })
	vim.api.nvim_set_hl(0, "NoxyIdentifier", { fg = "#ffffff" })
	vim.api.nvim_set_hl(0, "NoxyDelimiter", { fg = "#888888" })
end

return M
