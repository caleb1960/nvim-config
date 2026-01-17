-- 1. Performance: Enable the experimental Lua loader for faster startup
if vim.loader then
	vim.loader.enable()
end

-- 2. Global Debugger: The "Quirky" way to inspect variables
-- This allows you to call dd(my_variable) anywhere in your config or plugins.
_G.dd = function(...)
	-- We use pcall to ensure it doesn't crash if the file isn't found yet
	local status, debug = pcall(require, "quirky.debug")
	if status then
		debug.dump(...)
	else
		print(...) -- Fallback to standard print if quirky.debug is missing
	end
end

-- Upgrade the default vim.print to use your beautiful new UI
vim.print = _G.dd

-- 3. Load LazyVim Core
-- This points to lua/config/lazy.lua which handles plugin loading
require("config.lazy")

-- 4. Enable Custom Discipline (Optional)
-- If you want "Cowboy Mode" to be active by default, uncomment the line below:
-- require("quirky.discipline").cowboy()
