return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false, -- Load this immediately to prevent "flashing" on startup
		priority = 1000,
		opts = function()
			return {
				transparent = true, -- Your preferred transparent loo
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
				-- This ensures the background stays truly transparent
				-- even when you open floating windows or sidebars
				on_colors = function(colors)
					colors.bg = ""
				end,
			}
		end,
	},
}
