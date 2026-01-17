local discipline = require("quirky.discipline")

discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"-1p')
keymap.set("n", "<Leader>P", '"-1P')
keymap.set("v", "<Leader>p", '"-1p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-------------------------------------------------------------------------------
-- TAB / BUFFER MANAGEMENT
-------------------------------------------------------------------------------
keymap.set("n", "te", ":tabedit", { desc = "Edit new tab" })
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-------------i------------------------------------------------------------------
-- WINDOW / SPLIT MANAGEMENT
-------------------------------------------------------------------------------
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- NEW: Close current split window
keymap.set("n", "sx", "<cmd>close<cr>", { desc = "Close split window" })

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-------------------------------------------------------------------------------
-- DIAGNOSTICS & CUSTOM TOOLS
-------------------------------------------------------------------------------
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>r", function()
	require("quirky.hsl").replaceHexWithHSL()
end, { desc = "Hex to HSL" })

keymap.set("n", "<leader>i", function()
	require("quirky.lsp").toggleInlayHints()
end, { desc = "Toggle Inlay Hints" })

vim.api.nvim_create_user_command("ToggleAutoformat", function()
	require("quirky.lsp").toggleAutoformat()
end, {})
