-- Control Panel for LSP features
-- Saves as: lua/quirky/utils.lua

local M = {}

-- Toggle LSP Inlay Hints (The ghost text for types)
function M.toggleInlayHints()
	local filter = { bufnr = 0 }
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)

	local state = vim.lsp.inlay_hint.is_enabled(filter) and "Enabled" or "Disabled"
	vim.notify("Inlay Hints " .. state, vim.log.levels.INFO, { title = "Quirky LSP" })
end

-- Toggle Autoformat on Save
function M.toggleAutoformat()
	local util = require("lazyvim.util")
	util.format.toggle()
	-- LazyVim's internal toggle already sends a nice notification
end

return M
