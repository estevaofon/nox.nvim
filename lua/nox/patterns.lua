-- nox/patterns.lua - Pattern definitions and token types
local M = {}

-- Token types
M.keywords = {
  ["struct"] = true,
  ["end"] = true,
  ["let"] = true,
  ["func"] = true,
  ["return"] = true,
  ["if"] = true,
  ["then"] = true,
  ["else"] = true,
  ["while"] = true,
  ["do"] = true,
  ["for"] = true,
  ["in"] = true,
  ["ref"] = true,
  ["void"] = true,
  ["break"] = true,
  ["continue"] = true,
}

M.types = {
  ["int"] = true,
  ["string"] = true,
  ["bool"] = true,
  ["void"] = true,
  ["float"] = true,
  ["double"] = true,
  ["char"] = true,
}

M.builtins = {
  ["print"] = true,
  ["println"] = true,
  ["strlen"] = true,
  ["ord"] = true,
  ["chr"] = true,
  ["to_str"] = true,
  ["to_int"] = true,
  ["str_eq"] = true,
  ["malloc"] = true,
  ["free"] = true,
}

M.booleans = {
  ["true"] = true,
  ["false"] = true,
}

M.nulls = {
  ["null"] = true,
  ["nil"] = true,
}

-- Pattern definitions with priority
M.patterns = {
  -- Comments must be first
  { pattern = "//.*$", hl = "NoxComment", priority = 1 },
  { pattern = "/%*.-%*/", hl = "NoxComment", priority = 1 },
  
  -- Strings
  { pattern = '"[^"]*"', hl = "NoxString", priority = 2 },
  { pattern = "'[^']*'", hl = "NoxString", priority = 2 },
  
  -- Numbers (including floats and hex)
  { pattern = "0x[%da-fA-F]+", hl = "NoxNumber", priority = 3 },
  { pattern = "%-?%d+%.?%d*[eE]?%-?%d*", hl = "NoxNumber", priority = 3 },
  
  -- Multi-character operators
  { pattern = "==", hl = "NoxOperator", priority = 4 },
  { pattern = "!=", hl = "NoxOperator", priority = 4 },
  { pattern = "<=", hl = "NoxOperator", priority = 4 },
  { pattern = ">=", hl = "NoxOperator", priority = 4 },
  { pattern = "&&", hl = "NoxOperator", priority = 4 },
  { pattern = "||", hl = "NoxOperator", priority = 4 },
  { pattern = "<<", hl = "NoxOperator", priority = 4 },
  { pattern = ">>", hl = "NoxOperator", priority = 4 },
  { pattern = "%->", hl = "NoxOperator", priority = 4 },
  { pattern = "%.%.", hl = "NoxOperator", priority = 4 },
  
  -- Single character operators
  { pattern = "[%+%-%*/%%=<>!&|~^]", hl = "NoxOperator", priority = 5 },
  
  -- Delimiters
  { pattern = "[%(%)]", hl = "NoxDelimiter", priority = 6 },
  { pattern = "[%[%]]", hl = "NoxDelimiter", priority = 6 },
  { pattern = "[{}]", hl = "NoxDelimiter", priority = 6 },
  { pattern = "[,;:]", hl = "NoxDelimiter", priority = 6 },
  { pattern = "%.", hl = "NoxDelimiter", priority = 6 },
  
  -- Identifiers (must be last)
  { pattern = "[%a_][%w_]*", hl = "word", priority = 10 },
}

-- Sort patterns by priority
table.sort(M.patterns, function(a, b)
  return a.priority < b.priority
end)

return M
