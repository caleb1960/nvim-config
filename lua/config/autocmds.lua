-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	callback = function()
		vim.opt.paste = false
	end,
})

-- Disable concealing for specific filetypes (makes editing JSON/Markdown much easier)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- NEW: Highlight text briefly when yanking (copying)
-- This adds a nice "premium" feel to your setup
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("quirky-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
