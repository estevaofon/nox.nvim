-- nox/parser.lua - Parsing and highlighting logic
local M = {}

local patterns = require("nox.patterns")
local highlights = require("nox.highlights")
local config = require("nox.config")

-- Cache for performance
local cache = {}

-- Debounce timer
local debounce_timer = nil

-- Check if buffer should be processed
local function should_process(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  
  local byte_size = vim.api.nvim_buf_get_offset(
    bufnr,
    vim.api.nvim_buf_line_count(bufnr)
  )
  
  if byte_size > config.get().performance.max_file_size then
    if config.get().debug then
      vim.notify("nox.nvim: File too large, skipping highlight", vim.log.levels.WARN)
    end
    return false
  end
  
  return true
end

-- Highlight a single line
function M.highlight_line(bufnr, line_num, line_content)
  local col = 0
  local remaining = line_content
  
  while #remaining > 0 do
    local matched = false
    
    -- Try each pattern
    for _, p in ipairs(patterns.patterns) do
      local start_pos, end_pos = string.find(remaining, "^" .. p.pattern)
      
      if start_pos then
        local matched_text = string.sub(remaining, start_pos, end_pos)
        local hl_group = p.hl
        
        -- Check if it's a word that needs classification
        if p.hl == "word" then
          if patterns.keywords[matched_text] then
            hl_group = "NoxKeyword"
          elseif patterns.types[matched_text] then
            hl_group = "NoxType"
          elseif patterns.builtins[matched_text] then
            hl_group = "NoxBuiltin"
          elseif patterns.booleans[matched_text] then
            hl_group = "NoxBoolean"
          elseif patterns.nulls[matched_text] then
            hl_group = "NoxNull"
          else
            -- Check if it's a function (followed by '(')
            local next_chars = string.sub(remaining, end_pos + 1, end_pos + 10)
            if next_chars:match("^%s*%(") then
              hl_group = "NoxFunction"
            else
              -- Check if it's a struct field (preceded by '.')
              if col > 0 and string.sub(line_content, col, col) == "." then
                hl_group = "NoxField"
              else
                hl_group = "NoxIdentifier"
              end
            end
          end
        end
        
        -- Apply highlight (skip normal identifiers)
        if hl_group ~= "NoxIdentifier" then
          highlights.apply(bufnr, line_num, col, col + #matched_text, hl_group)
        end
        
        col = col + #matched_text
        remaining = string.sub(remaining, end_pos + 1)
        matched = true
        break
      end
    end
    
    -- If no pattern matched, advance one character
    if not matched then
      col = col + 1
      remaining = string.sub(remaining, 2)
    end
  end
end

-- Highlight entire buffer
function M.highlight_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  
  if not should_process(bufnr) then
    return
  end
  
  -- Clear existing highlights
  highlights.clear_buffer(bufnr)
  
  -- Get all lines
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  -- Process each line
  for i, line in ipairs(lines) do
    M.highlight_line(bufnr, i - 1, line)
  end
end

-- Debounced highlight
function M.highlight_buffer_debounced(bufnr)
  if debounce_timer then
    vim.fn.timer_stop(debounce_timer)
  end
  
  local debounce_ms = config.get().performance.debounce_ms
  
  debounce_timer = vim.fn.timer_start(debounce_ms, function()
    vim.schedule(function()
      M.highlight_buffer(bufnr)
    end)
  end)
end

return M
