-- nox.nvim - Syntax highlighting for Nox language
local M = {}

-- Namespace for highlights
local ns_id = vim.api.nvim_create_namespace("nox_highlight")

-- Keywords and types
local keywords = {
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
}

local types = {
	["int"] = true,
	["string"] = true,
	["bool"] = true,
	["void"] = true,
}

local builtins = {
	["print"] = true,
	["strlen"] = true,
	["ord"] = true,
	["to_str"] = true,
}

local booleans = {
	["true"] = true,
	["false"] = true,
}

local nulls = {
	["null"] = true,
}

-- Pattern definitions
local patterns = {
	{ pattern = "//.*$", hl = "NoxComment" },
	{ pattern = '"[^"]*"', hl = "NoxString" },
	{ pattern = "'[^']*'", hl = "NoxString" },
	{ pattern = "%-?%d+%.?%d*", hl = "NoxNumber" },
	{ pattern = "==", hl = "NoxOperator" },
	{ pattern = "!=", hl = "NoxOperator" },
	{ pattern = "<=", hl = "NoxOperator" },
	{ pattern = ">=", hl = "NoxOperator" },
	{ pattern = "%->", hl = "NoxOperator" },
	{ pattern = "%.%.", hl = "NoxOperator" },
	{ pattern = "[%+%-%*/%%=<>!]", hl = "NoxOperator" },
	{ pattern = "[%(%)]", hl = "NoxDelimiter" },
	{ pattern = "[%[%]]", hl = "NoxDelimiter" },
	{ pattern = "[{}]", hl = "NoxDelimiter" },
	{ pattern = "[,;:]", hl = "NoxDelimiter" },
	{ pattern = "%.", hl = "NoxDelimiter" },
	{ pattern = "[%a_][%w_]*", hl = "word" },
}

-- Highlight a single line
local function highlight_line(bufnr, line_num, line_content)
	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, line_num, line_num + 1)

	local col = 0
	local remaining = line_content

	while #remaining > 0 do
		local matched = false

		for _, p in ipairs(patterns) do
			local start_pos, end_pos = string.find(remaining, "^" .. p.pattern)

			if start_pos then
				local matched_text = string.sub(remaining, start_pos, end_pos)
				local hl_group = p.hl

				if p.hl == "word" then
					if keywords[matched_text] then
						hl_group = "NoxKeyword"
					elseif types[matched_text] then
						hl_group = "NoxType"
					elseif builtins[matched_text] then
						hl_group = "NoxBuiltin"
					elseif booleans[matched_text] then
						hl_group = "NoxBoolean"
					elseif nulls[matched_text] then
						hl_group = "NoxNull"
					else
						local next_char = string.sub(remaining, end_pos + 1, end_pos + 1)
						local has_space = string.match(string.sub(remaining, end_pos + 1), "^%s*%(")
						if next_char == "(" or has_space then
							hl_group = "NoxFunction"
						else
							hl_group = "NoxIdentifier"
						end
					end
				end

				if hl_group ~= "NoxIdentifier" then
					vim.api.nvim_buf_add_highlight(bufnr, ns_id, hl_group, line_num, col, col + #matched_text)
				end

				col = col + #matched_text
				remaining = string.sub(remaining, end_pos + 1)
				matched = true
				break
			end
		end

		if not matched then
			col = col + 1
			remaining = string.sub(remaining, 2)
		end
	end
end

-- Highlight entire buffer
function M.highlight_buffer(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for i, line in ipairs(lines) do
		highlight_line(bufnr, i - 1, line)
	end
end

-- Attach to buffer
function M.attach(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local group_name = "NoxHighlight_" .. bufnr
	local success, autocmds = pcall(vim.api.nvim_get_autocmds, { group = group_name, buffer = bufnr })
	if success and autocmds and #autocmds > 0 then
		return
	end

	M.highlight_buffer(bufnr)

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter", "InsertLeave" }, {
		buffer = bufnr,
		callback = function()
			if vim.api.nvim_buf_is_valid(bufnr) then
				M.highlight_buffer(bufnr)
			end
		end,
		group = vim.api.nvim_create_augroup(group_name, { clear = true }),
	})
end

-- Setup function
function M.setup(opts)
	opts = opts or {}

	-- Load highlights
	require("nox.highlights").setup()

	-- User commands
	vim.api.nvim_create_user_command("NoxHighlight", function()
		M.highlight_buffer()
	end, { desc = "Force Nox syntax highlighting" })

	vim.api.nvim_create_user_command("NoxRefresh", function()
		local count = 0
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
				local filename = vim.api.nvim_buf_get_name(buf)
				local is_nox = filename:match("%.nx$") or vim.bo[buf].filetype == "nox"

				if is_nox then
					vim.bo[buf].filetype = "nox"
					M.attach(buf)
					count = count + 1
				end
			end
		end
		print("Nox highlighting applied to " .. count .. " buffer(s)")
	end, { desc = "Refresh Nox highlighting for all .nx buffers" })
end

return M
