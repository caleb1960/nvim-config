vim.g.mapleader = " "

-- 1. Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- 2. UI Aesthetics
vim.opt.number = true
vim.opt.title = true
vim.opt.hlsearch = true
vim.opt.showcmd = true
vim.opt.scrolloff = 10 -- Keep 10 lines visible when scrolling
vim.opt.wrap = false -- No line wrap (Devaslife style)
vim.opt.inccommand = "split" -- Preview substitutions in a split window
vim.opt.mouse = "a" -- Enable mouse (useful for resizing splits)

-- 3. The "Global Status" Hack
-- Since you are using Neovim 0.8+, this makes the UI look very clean
vim.opt.laststatus = 3 -- Global statusline at the bottom
if vim.fn.has("nvim-0.8") == 1 then
	vim.opt.cmdheight = 0 -- Hide command line when not in use
end

-- 4. Indentation (Quirky Web-Dev Defaults)
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.breakindent = true

-- 5. Search & Files
vim.opt.ignorecase = true
vim.opt.smartcase = true -- If you use a capital letter, it becomes case-sensitive
vim.opt.path:append({ "**" }) -- Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*", "*/.git/*" })

-- 6. Splits
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right
vim.opt.splitkeep = "cursor" -- Keeps cursor position when splitting

-- 7. Backups & Undo
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true -- Permanent undo even after closing Neovim
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.backspace = { "start", "eol", "indent" }

-- 8. Formatting & Undercurl (Terminal support)
-- Fix for undercurls in Tmux/Kitty/Alacritty
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
vim.opt.formatoptions:append({ "r" }) -- Auto-add asterisks in block comments

-- 9. Filetypes & Extensions
vim.filetype.add({
	extension = {
		mdx = "mdx",
		astro = "astro",
	},
	filename = {
		["Podfile"] = "ruby",
	},
})

-- 10. LazyVim Global Variables
vim.g.lazyvim_prettier_needs_config = true -- Only format if prettier config exists
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp" -- Optimized for the new Blink completion engine
