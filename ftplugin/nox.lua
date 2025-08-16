-- ftplugin/nox.lua - Filetype-specific settings

-- Check if already loaded
if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

-- Set local options
vim.bo.commentstring = "// %s"
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.cindent = true

-- Set fold method if desired
vim.wo.foldmethod = "syntax"
vim.wo.foldlevel = 99

-- Apply highlighting
local has_nox, nox = pcall(require, "nox")
if has_nox then
  vim.defer_fn(function()
    nox.attach(vim.api.nvim_get_current_buf())
  end, 10)
end

-- Setup buffer-local keymaps
vim.keymap.set("n", "<localleader>r", ":NoxRefresh<CR>", {
  buffer = true,
  desc = "Refresh Nox highlighting"
})

vim.keymap.set("n", "<localleader>h", ":NoxHighlight<CR>", {
  buffer = true,
  desc = "Force Nox highlighting"
})
