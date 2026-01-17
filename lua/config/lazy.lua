local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- 1. Load the core LazyVim framework
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				colorscheme = "solarized-osaka", -- Your signature look
				news = {
					lazyvim = true,
					neovim = true,
				},
			},
		},
		-- 2. Import Language Extras (Optimized for Web Dev)
		{ import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.rust" },
		{ import = "lazyvim.plugins.extras.lang.tailwind" },
		{ import = "lazyvim.plugins.extras.util.mini-hipatterns" },

		-- 3. Load your custom "Quirky" overrides from the /lua/plugins folder
		{ import = "plugins" },
	},
	defaults = {
		lazy = false, -- Custom plugins load on startup for speed
		version = false,
	},
	dev = {
		-- Change this if you keep your local dev plugins elsewhere
		path = "~/.ghq/github.com",
	},
	checker = { enabled = true }, -- Keep your plugins updated automatically
	performance = {
		cache = { enabled = true },
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"rplugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		-- This is the custom key you had for debugging plugins in the Lazy UI
		custom_keys = {
			["<localleader>d"] = function(plugin)
				print(vim.inspect(plugin)) -- A simple 'dd' replacement if not defined elsewhere
			end,
		},
	},
	debug = false,
})
