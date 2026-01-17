-- Utility for Color Conversion (HSL <-> HEX)
-- Saves as: lua/quirky/hsl.lua

local M = {}

local hexChars = "0123456789abcdef"

-- Converts Hex string to RGB table [0, 1]
function M.hex_to_rgb(hex)
	hex = string.lower(hex)
	local ret = {}
	for i = 0, 2 do
		local char1 = string.sub(hex, i * 2 + 2, i * 2 + 2)
		local char2 = string.sub(hex, i * 2 + 3, i * 2 + 3)
		local digit1 = string.find(hexChars, char1) - 1
		local digit2 = string.find(hexChars, char2) - 1
		ret[i + 1] = (digit1 * 16 + digit2) / 255.0
	end
	return ret
end

-- Converts RGB [0, 1] to HSL [0, 360], [0, 100], [0, 100]
function M.rgbToHsl(r, g, b)
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, l = 0, 0, 0

	l = (max + min) / 2

	if max == min then
		h, s = 0, 0 -- achromatic
	else
		local d = max - min
		s = l > 0.5 and d / (2 - max - min) or d / (max + min)

		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	return h * 360, s * 100, l * 100
end

-- The "Magic" function triggered by <leader>r
function M.replaceHexWithHSL()
	local line_number = vim.api.nvim_win_get_cursor(0)[1]
	local line_content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
	local found = false

	-- Pattern match for #FFFFFF or #fff
	for hex in line_content:gmatch("#[0-9a-fA-F]+") do
		local rgb = M.hex_to_rgb(hex)
		local h, s, l = M.rgbToHsl(rgb[1], rgb[2], rgb[3])
		local hsl = string.format("hsl(%d, %d%%, %d%%)", math.floor(h + 0.5), math.floor(s + 0.5), math.floor(l + 0.5))

		-- Use plain gsub to avoid pattern issues with '#'
		line_content = line_content:gsub(hex, hsl, 1)
		found = true
	end

	if found then
		vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { line_content })
		vim.notify("Converted Hex to HSL 🎨", vim.log.levels.INFO, { title = "Quirky HSL" })
	else
		vim.notify("No Hex color found on this line", vim.log.levels.WARN, { title = "Quirky HSL" })
	end
end

return M
