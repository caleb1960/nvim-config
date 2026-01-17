return {
	-- 1. Incremental rename (Live preview as you type :IncRename)
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- 2. Mini.bracketed (Smart navigation with [ and ])
	{
		"mini-nvim/mini.bracketed", -- Fixed the plugin name (echasnovski)
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	-- 3. Dial.nvim (Better increase/decrease)
	-- This allows you to toggle true/false, let/const, and dates with <C-a>
	{
		"monaqa/dial.nvim",
		-- stylua: ignore
		keys = {
			{ "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
			{ "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
		},
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool, -- Cycle through true/false
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }), -- Cycle through let/const
				},
			})
		end,
	},
}
