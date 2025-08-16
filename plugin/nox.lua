-- plugin/nox.lua - Global plugin initialization

-- Prevent double loading
if vim.g.loaded_nox then
  return
end
vim.g.loaded_nox = true

-- Defer setup to ensure all modules are loaded
vim.defer_fn(function()
  -- Auto-setup with defaults if user hasn't called setup
  if not vim.g.nox_setup_complete then
    require("nox").setup({})
  end
end, 0)
