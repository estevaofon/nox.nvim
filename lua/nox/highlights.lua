-- nox/highlights.lua - Highlight group management
local M = {}

local config = require("nox.config")

-- Namespace for highlights
M.ns_id = vim.api.nvim_create_namespace("nox_highlight")

function M.setup()
  local highlights = config.get().highlights
  
  -- Apply each highlight group
  for name, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, opts)
  end
  
  -- Link additional groups for compatibility
  vim.api.nvim_set_hl(0, "noxKeyword", { link = "NoxKeyword" })
  vim.api.nvim_set_hl(0, "noxType", { link = "NoxType" })
  vim.api.nvim_set_hl(0, "noxString", { link = "NoxString" })
  vim.api.nvim_set_hl(0, "noxComment", { link = "NoxComment" })
end

function M.clear_buffer(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, M.ns_id, 0, -1)
end

function M.apply(bufnr, line_num, col_start, col_end, hl_group)
  vim.api.nvim_buf_add_highlight(
    bufnr,
    M.ns_id,
    hl_group,
    line_num,
    col_start,
    col_end
  )
end

return M
