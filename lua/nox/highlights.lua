-- nox/highlights.lua - Highlight group definitions
local M = {}

function M.setup()
	-- Define highlight groups with the same colors as original
	vim.api.nvim_set_hl(0, "NoxKeyword", { fg = "#ff0080", bold = true })
	vim.api.nvim_set_hl(0, "NoxType", { fg = "#64c8ff" })
	vim.api.nvim_set_hl(0, "NoxString", { fg = "#00ffff" })
	vim.api.nvim_set_hl(0, "NoxNumber", { fg = "#ffd700" })
	vim.api.nvim_set_hl(0, "NoxComment", { fg = "#808080", italic = true })
	vim.api.nvim_set_hl(0, "NoxOperator", { fg = "#ff64ff" })
	vim.api.nvim_set_hl(0, "NoxBoolean", { fg = "#ffa500" })
	vim.api.nvim_set_hl(0, "NoxNull", { fg = "#9370db" })
	vim.api.nvim_set_hl(0, "NoxBuiltin", { fg = "#32cd32" })
	vim.api.nvim_set_hl(0, "NoxFunction", { fg = "#00ff80" })
	vim.api.nvim_set_hl(0, "NoxIdentifier", { fg = "#ffffff" })
	vim.api.nvim_set_hl(0, "NoxDelimiter", { fg = "#888888" })
end

return M
