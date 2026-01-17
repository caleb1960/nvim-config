-- Diagnostic and Debugging Tools
-- Saves as: lua/quirky/debug.lua

local M = {}

-- Automatically finds where the dump() was called from
function M.get_loc()
	local me = debug.getinfo(1, "S")
	local level = 2
	local info = debug.getinfo(level, "S")
	while info and (info.source == me.source or info.source == "@" .. vim.env.MYVIMRC or info.what ~= "Lua") do
		level = level + 1
		info = debug.getinfo(level, "S")
	end
	info = info or me
	local source = info.source:sub(2)
	source = vim.loop.fs_realpath(source) or source
	return source .. ":" .. info.linedefined
end

---@param value any
---@param opts? {loc:string}
function M._dump(value, opts)
	opts = opts or {}
	opts.loc = opts.loc or M.get_loc()
	if vim.in_fast_event() then
		return vim.schedule(function()
			M._dump(value, opts)
		end)
	end
	opts.loc = vim.fn.fnamemodify(opts.loc, ":~:.")
	local msg = vim.inspect(value)

	-- Uses your Notify/Noice setup to show the data structure
	vim.notify(msg, vim.log.levels.INFO, {
		title = "Debug: " .. opts.loc,
		on_open = function(win)
			vim.wo[win].conceallevel = 3
			vim.wo[win].spell = false
			local buf = vim.api.nvim_win_get_buf(win)
			if not pcall(vim.treesitter.start, buf, "lua") then
				vim.bo[buf].filetype = "lua"
			end
		end,
	})
end

-- The main function you'll use in your code
function M.dump(...)
	local value = { ... }
	if vim.tbl_isempty(value) then
		value = nil
	else
		value = vim.tbl_islist(value) and vim.tbl_count(value) <= 1 and value[1] or value
	end
	M._dump(value)
end

-- Memory Check: Find "leaking" UI marks
function M.extmark_leaks()
	local nsn = vim.api.nvim_get_namespaces()
	local counts = {}

	for name, ns in pairs(nsn) do
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local count = #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
			if count > 0 then
				table.insert(counts, {
					name = name,
					buf = buf,
					count = count,
					ft = vim.bo[buf].ft,
				})
			end
		end
	end
	table.sort(counts, function(a, b)
		return a.count > b.count
	end)
	M.dump(counts)
end

-- Memory Check: Find which Lua modules are eating RAM
function M.module_leaks(filter)
	local function estimateSize(value, visited)
		visited = visited or {}
		if value == nil or visited[value] then
			return 0
		end
		visited[value] = true

		local bytes = 0
		local t = type(value)
		if t == "boolean" then
			bytes = 4
		elseif t == "number" then
			bytes = 8
		elseif t == "string" then
			bytes = #value + 24
		elseif t == "table" then
			bytes = 40
			for k, v in pairs(value) do
				bytes = bytes + estimateSize(k, visited) + estimateSize(v, visited)
			end
		end
		return bytes
	end

	local sizes = {}
	for modname, mod in pairs(package.loaded) do
		if not filter or modname:match(filter) then
			local root = modname:match("^([^%.]+)%..*$") or modname
			sizes[root] = sizes[root] or { mod = root, size = 0 }
			sizes[root].size = sizes[root].size + estimateSize(mod) / 1024 / 1024
		end
	end
	local result = vim.tbl_values(sizes)
	table.sort(result, function(a, b)
		return a.size > b.size
	end)
	M.dump(result)
end

return M
