return {
	-- 1. Flash (Disabled as per your preference, but kept for the toggle)
	{
		"folke/flash.nvim",
		enabled = false,
		opts = {
			search = {
				forward = true,
				multi_window = false,
				wrap = false,
				incremental = true,
			},
		},
	},

	-- 2. Color Highlighter (Essential for CSS/Tailwind)
	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre",
		opts = {
			render = "background",
			enable_tailwind = true,
		},
	},

	-- 3. Simple Git integration
	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				blame = "<Leader>gb",
				browse = "<Leader>go",
			},
		},
	},

	-- 4. THE TELESCOPE SETUP (The "Quirky" Search Engine)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			-- Standard devaslife muscle memory
			{
				";f",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				desc = "Find Files",
			},
			{
				";r",
				function()
					require("telescope.builtin").live_grep({ additional_args = { "--hidden" } })
				end,
				desc = "Live Grep",
			},
			{
				"\\\\",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				";t",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help Tags",
			},
			{
				";;",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Resume Last Search",
			},
			{
				";e",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				";s",
				function()
					require("telescope.builtin").treesitter()
				end,
				desc = "Treesitter Symbols",
			},
			{
				"sf",
				function()
					require("telescope").extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = vim.fn.expand("%:p:h"),
						respect_gitignore = false,
						hidden = true,
						grouped = true,
						previewer = false,
						initial_mode = "normal",
						layout_config = { height = 40 },
					})
				end,
				desc = "File Browser",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = telescope.extensions.file_browser.actions

			opts.defaults = {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0, -- Set to 0 for true transparency
				mappings = {
					n = {
						["q"] = actions.close,
					},
				},
			}
			opts.pickers = {
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = { preview_cutoff = 9999 },
				},
			}
			opts.extensions = {
				file_browser = {
					theme = "dropdown",
					hijack_netrw = true,
					mappings = {
						["n"] = {
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
						},
					},
				},
			}
			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
		end,
	},

	-- 5. Close Buffers (Utility)
	{
		"kazhala/close-buffers.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>th",
				function()
					require("close_buffers").delete({ type = "hidden" })
				end,
				desc = "Close Hidden Buffers",
			},
			{
				"<leader>tu",
				function()
					require("close_buffers").delete({ type = "nameless" })
				end,
				desc = "Close Nameless Buffers",
			},
		},
	},

	-- 6. Blink.cmp (Lightning fast completion)
	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				menu = { winblend = 0 }, -- Transparency fix
				draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } } },
			},
			signature = { window = { winblend = 0 } }, -- Transparency fix
		},
	},
}
