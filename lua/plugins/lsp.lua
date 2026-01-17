return {
	-- 1. Mason (The Installer)
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"elixir-ls",
				"solargraph", -- Ruby
				"rust-analyzer",
				"clojure-lsp", -- Lisp
				"lua-language-server",
				"typescript-language-server",
				"tailwindcss-language-server",
				"css-lsp",
			})
		end,
	},

	-- 2. The LSP "Brain" (Deep Configuration)
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.inlay_hints = { enabled = true } -- Enable Inlay Hints globally

			opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
				-- ELIXIR: Deep Dialyzer integration and suggestions
				elixirls = {
					settings = {
						elixirLS = {
							dialyzerEnabled = true,
							fetchDeps = true,
							enableTestLenses = true,
							suggestSpecs = true, -- Suggests @spec attributes
						},
					},
				},

				-- RUST: The "Gold Standard" for diagnostics
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							checkOnSave = { command = "clippy" }, -- Professional grade linting
							diagnostics = { enable = true },
							inlayHints = {
								chainingHints = true,
								parameterHints = true,
								typeHints = true,
							},
							hover = { actions = { enable = true } },
						},
					},
				},

				-- RUBY: Using Solargraph for autocompletion
				solargraph = {
					settings = {
						solargraph = {
							diagnostics = true,
							completion = true,
							hover = true,
							formatting = true,
							symbols = true,
						},
					},
				},

				-- LISP (CLOJURE): Structural editing and linting
				clojure_lsp = {
					settings = {
						["clojure-lsp"] = {
							["show-diagnostics-details"] = true,
							["keep-project-on-close"] = false,
						},
					},
				},

				-- LUA: High-performance workspace analysis
				lua_ls = {
					settings = {
						Lua = {
							hint = { enable = true, arrayIndex = "Disable", setType = true },
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							completion = { callSnippet = "Both" },
						},
					},
				},

				ts_ls = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
							},
						},
					},
				},

				-- TAILWIND CSS
				tailwindcss = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^'\"`]*)(?:'|\"|`)" },
									{ "twMerge\\(([^)]*)\\)", "(?:'|\"|`)([^'\"`]*)(?:'|\"|`)" },
								},
							},
						},
					},
				},

				-- GDSCRIPT (GODOT): Connects directly to Godot Engine
				gdscript = {
					name = "godot",
					cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
				},
			})

			-- Custom Keymaps (Goto Definition fix)
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			vim.list_extend(keys, {
				{
					"gd",
					function()
						require("telescope.builtin").lsp_definitions({ reuse_win = false })
					end,
					desc = "Goto Definition",
				},
			})
		end,
	},
}
