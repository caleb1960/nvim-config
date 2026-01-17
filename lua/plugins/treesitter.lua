return {
	-- 1. Treesitter Playground (Essential for debugging syntax)
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

	-- 2. Treesitter Core Configuration
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			-- Optimized for your 6 basic languages + others you had
			ensure_installed = {
				"elixir", -- Fixed spelling
				"ruby",
				"rust",
				"commonlisp", -- Specific parser for Lisp
				"gdscript",
				"lua",
				"vim",
				"vimdoc",
				"markdown",
				"markdown_inline",
				"astro",
				"css",
				"scss",
				"sql",
				"typescript",
				"javascript",
				"gitignore",

				"python",
			},

			-- Highlighting logic
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			-- Smart indentation based on Treesitter
			indent = { enable = true },

			-- Query Linter for playground
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},

			-- Playground settings (Muscle memory preserved)
			playground = {
				enable = true,
				disable = {},
				updatetime = 25,
				persist_queries = true,
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
		},
		config = function(_, opts)
			-- Setup Treesitter
			require("nvim-treesitter.config").setup(opts)

			-- 3. Custom Filetype Registration (The "Quirky" Way)
			vim.filetype.add({
				extension = {
					mdx = "mdx",
				},
			})
			vim.treesitter.language.register("markdown", "mdx")
		end,
	},
}
