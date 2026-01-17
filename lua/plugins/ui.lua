return {
	-- 1. Noice: Messages, cmdline and popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			-- System Notification Focus Logic
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})

			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send", -- Sends to system tray when Neovim isn't focused
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}
			opts.presets.lsp_doc_border = true
		end,
	},

	-- 2. Notify: Toast notifications
	{
		"rcarriga/nvim-notify",
		opts = { timeout = 3000, background_colour = "#000000" },
	},

	-- 3. Bufferline: Modern tabs
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = "thin",
			},
		},
	},

	-- 4. Incline: Floating filenames in the top right
	{
		"b0o/incline.nvim",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("solarized-osaka.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = { cursorline = true },
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end
					if vim.bo[props.buf].modified then
						filename = "󰷉 " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
			})
		end,
	},

	-- 5. Lualine: Custom statusline with Quirky branding
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
			-- Branded Section
			opts.sections.lualine_a =
				{ {
					"mode",
					fmt = function(str)
						return "󰭟 " .. str .. " | QUIRKY"
					end,
				} }
			-- Pretty Path
			opts.sections.lualine_c[4] = {
				LazyVim.lualine.pretty_path({
					length = 0,
					relative = "cwd",
					modified_hl = "MatchParen",
					directory_hl = "",
					filename_hl = "Bold",
					modified_sign = "",
					readonly_icon = " 󰌾 ",
				}),
			}
		end,
	},

	-- 6. Snacks: The Dashboard & Smooth Scrolling
	{
		"folke/snacks.nvim",
		opts = {
			scroll = { enabled = false }, -- Better performance
			dashboard = {
				preset = {
					header = [[
 ██████╗ ██╗   ██╗██╗██████╗ ██╗ ██╗██╗   ██╗
██╔═══██╗██║   ██║██║██╔══██╗██║██╔╝╚██╗ ██╔╝
██║   ██║██║   ██║██║██████╔╝█████╔╝  ╚████╔╝ 
██║▄▄ ██║██║   ██║██║██╔══██╗██╔═██╗   ╚██╔╝  
╚██████╔╝╚██████╔╝██║██║  ██║██║  ██╗   ██║   
 ╚══▀▀═╝  ╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ]],
				},
			},
		},
	},

	-- 7. Zen Mode
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},
}
