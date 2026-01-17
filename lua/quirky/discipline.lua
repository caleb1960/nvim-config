local M = {}

function M.cowboy()
	---@type table?
	local ok = true
	-- These are the keys we want to "discipline"
	for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
		local count = 0
		local timer = assert(vim.uv.new_timer())
		local map = key

		vim.keymap.set("n", key, function()
			-- If you provide a count (e.g., 10j), the discipline resets
			if vim.v.count > 0 then
				count = 0
			end

			-- If you press the key more than 10 times in 2 seconds...
			if count >= 10 and vim.bo.buftype ~= "nofile" then
				ok = pcall(vim.notify, "Hold it Cowboy! Use Telescope or Search!", vim.log.levels.WARN, {
					icon = "🤠",
					id = "cowboy",
					keep = function()
						return count >= 10
					end,
				})
				if not ok then
					return map
				end
			else
				count = count + 1
				-- Reset the counter after 2 seconds of no activity
				timer:start(2000, 0, function()
					count = 0
				end)
				return map
			end
		end, { expr = true, silent = true })
	end
end

return M
