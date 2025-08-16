-- nox/commands.lua - Command definitions
local M = {}

local config = require("nox.config")
local parser = require("nox.parser")
local highlights = require("nox.highlights")

function M.refresh_all_buffers()
  local count = 0
  
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local filename = vim.api.nvim_buf_get_name(buf)
      local is_nox = filename:match("%.nx$") or vim.bo[buf].filetype == "nox"
      
      if is_nox then
        vim.bo[buf].filetype = "nox"
        parser.highlight_buffer(buf)
        count = count + 1
      end
    end
  end
  
  vim.notify(string.format("nox.nvim: Refreshed %d buffer(s)", count), vim.log.levels.INFO)
  return count
end

function M.show_status()
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buf)
  local ft = vim.bo.filetype
  
  local status = {
    "=== Nox Status ===",
    "Plugin version: " .. require("nox").version,
    "Buffer: " .. buf,
    "File: " .. (filename ~= "" and filename or "unnamed"),
    "Filetype: " .. ft,
    "Is Nox file: " .. (filename:match("%.nx$") and "Yes" or "No"),
    "Debug mode: " .. (config.get().debug and "On" or "Off"),
    "",
    "Features:",
    "  Auto-highlight: " .. (config.get().features.auto_highlight and "On" or "Off"),
    "  Indent guides: " .. (config.get().features.indent_guides and "On" or "Off"),
    "  Completion: " .. (config.get().features.completion and "On" or "Off"),
  }
  
  vim.notify(table.concat(status, "\n"), vim.log.levels.INFO)
end

function M.toggle_debug()
  local current = config.get().debug
  config.set_debug(not current)
  vim.notify("nox.nvim: Debug mode " .. (config.get().debug and "enabled" or "disabled"))
end

function M.setup()
  -- NoxHighlight - Force highlighting
  vim.api.nvim_create_user_command("NoxHighlight", function()
    parser.highlight_buffer()
  end, { desc = "Force Nox syntax highlighting" })
  
  -- NoxRefresh - Refresh all buffers
  vim.api.nvim_create_user_command("NoxRefresh", function()
    M.refresh_all_buffers()
  end, { desc = "Refresh all Nox buffers" })
  
  -- NoxStatus - Show status
  vim.api.nvim_create_user_command("NoxStatus", function()
    M.show_status()
  end, { desc = "Show Nox plugin status" })
  
  -- NoxDebug - Toggle debug mode
  vim.api.nvim_create_user_command("NoxDebug", function()
    M.toggle_debug()
  end, { desc = "Toggle Nox debug mode" })
  
  -- NoxTest - Create test buffer
  vim.api.nvim_create_user_command("NoxTest", function()
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    
    local test_code = {
      "// Nox Language Test File",
      "",
      "struct Person",
      "    name: string,",
      "    age: int,",
      "    active: bool",
      "end",
      "",
      "func greet(p: ref Person) -> void",
      "    if p.active then",
      '        print("Hello, " + p.name)',
      '        println("You are " + to_str(p.age) + " years old")',
      "    else",
      '        print("User inactive")',
      "    end",
      "end",
      "",
      "let person: Person = {",
      '    name: "Alice",',
      "    age: 30,",
      "    active: true",
      "}",
      "",
      "// Call the function",
      "greet(person)",
      "",
      "// Loop example",
      "for i in 0..10 do",
      "    if i % 2 == 0 then",
      '        println("Even: " + to_str(i))',
      "    end",
      "end",
    }
    
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, test_code)
    vim.bo[buf].filetype = "nox"
    
    vim.notify("nox.nvim: Test buffer created", vim.log.levels.INFO)
  end, { desc = "Create Nox test buffer" })
end

return M
