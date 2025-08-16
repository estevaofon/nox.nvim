-- nox.nvim - Main module
local M = {}

local config = require("nox.config")
local highlights = require("nox.highlights")
local parser = require("nox.parser")
local commands = require("nox.commands")

-- Plugin version
M.version = "1.0.0"

-- Setup function
function M.setup(opts)
  -- Mark setup as complete
  vim.g.nox_setup_complete = true
  
  -- Setup configuration
  config.setup(opts)
  
  -- Setup highlights
  highlights.setup()
  
  -- Setup commands
  commands.setup()
  
  -- Register filetype
  vim.filetype.add({
    extension = {
      nx = "nox",
    },
    pattern = {
      [".*%.nx$"] = "nox",
    },
  })
  
  -- Create autocommand for new Nox files
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.nx",
    callback = function(ev)
      vim.bo[ev.buf].filetype = "nox"
      M.attach(ev.buf)
    end,
    group = vim.api.nvim_create_augroup("NoxFiletype", { clear = true }),
  })
  
  -- Log setup completion
  if config.get().debug then
    vim.notify("nox.nvim: Setup completed v" .. M.version, vim.log.levels.INFO)
  end
end

-- Attach to buffer
function M.attach(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  
  -- Check if already attached
  local group_name = "NoxHighlight_" .. bufnr
  local success, autocmds = pcall(vim.api.nvim_get_autocmds, { 
    group = group_name, 
    buffer = bufnr 
  })
  
  if success and autocmds and #autocmds > 0 then
    return -- Already attached
  end
  
  -- Apply initial highlighting
  parser.highlight_buffer(bufnr)
  
  -- Setup autocmds for live updates
  if config.get().features.auto_highlight then
    vim.api.nvim_create_autocmd(
      {"TextChanged", "TextChangedI", "BufEnter", "InsertLeave"},
      {
        buffer = bufnr,
        callback = function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            parser.highlight_buffer(bufnr)
          end
        end,
        group = vim.api.nvim_create_augroup(group_name, { clear = true }),
      }
    )
  end
  
  if config.get().debug then
    vim.notify("nox.nvim: Attached to buffer " .. bufnr, vim.log.levels.INFO)
  end
end

-- Public API
M.highlight_buffer = parser.highlight_buffer
M.get_config = config.get
M.refresh_all = commands.refresh_all_buffers

return M
