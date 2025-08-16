-- nox/config.lua - Configuration management
local M = {}

-- Default configuration
local defaults = {
  debug = false,
  
  highlights = {
    NoxKeyword = { fg = "#ff0080", bold = true },
    NoxType = { fg = "#64c8ff" },
    NoxString = { fg = "#00ffff" },
    NoxNumber = { fg = "#ffd700" },
    NoxComment = { fg = "#808080", italic = true },
    NoxOperator = { fg = "#ff64ff" },
    NoxBoolean = { fg = "#ffa500" },
    NoxNull = { fg = "#9370db" },
    NoxBuiltin = { fg = "#32cd32" },
    NoxFunction = { fg = "#00ff80" },
    NoxIdentifier = { fg = "#ffffff" },
    NoxDelimiter = { fg = "#888888" },
    NoxStruct = { fg = "#ff0080", bold = true },
    NoxField = { fg = "#87ceeb" },
  },
  
  features = {
    auto_highlight = true,
    indent_guides = false,
    completion = false,
    diagnostics = false,
  },
  
  performance = {
    debounce_ms = 50,
    max_file_size = 1024 * 1024, -- 1MB
  }
}

local current_config = vim.deepcopy(defaults)

function M.setup(opts)
  current_config = vim.tbl_deep_extend("force", current_config, opts or {})
  
  -- Validate configuration
  M.validate()
  
  return current_config
end

function M.get()
  return current_config
end

function M.set_debug(enabled)
  current_config.debug = enabled
  vim.g.nox_debug = enabled
end

function M.validate()
  -- Validate highlight groups
  for name, hl in pairs(current_config.highlights) do
    if type(hl) ~= "table" then
      vim.notify("nox.nvim: Invalid highlight group " .. name, vim.log.levels.WARN)
      current_config.highlights[name] = defaults.highlights[name]
    end
  end
  
  -- Validate performance settings
  if current_config.performance.debounce_ms < 0 then
    current_config.performance.debounce_ms = defaults.performance.debounce_ms
  end
  
  if current_config.performance.max_file_size < 0 then
    current_config.performance.max_file_size = defaults.performance.max_file_size
  end
end

return M
