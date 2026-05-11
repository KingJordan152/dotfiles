local user_command = vim.api.nvim_create_user_command

---Returns all plugins that match the current search query.
---Can be used to provide autocompletion to `Pack-` user commands.
---@param match string Search query to match plugins against.
---@return table
local function plugin_autocompletion(match)
	return vim.iter(vim.pack.get())
		:map(function(pack)
			return pack.spec.name
		end)
		:filter(function(pack)
			return pack:find(match)
		end)
		:totable()
end

---Returns a list of plugins that are currently *active*.
---@return table
local function get_active_plugins()
	return vim.iter(vim.pack.get())
		:filter(function(pack)
			return pack.active
		end)
		:map(function(pack)
			return pack.spec.name
		end)
		:totable()
end

--- Returns a list of plugins that are currently *inactive*.
---@return table
local function get_inactive_plugins()
	return vim.iter(vim.pack.get())
		:filter(function(pack)
			return not pack.active
		end)
		:map(function(pack)
			return pack.spec.name
		end)
		:totable()
end

user_command("PackUpdate", function(args)
	if #args.fargs ~= 0 then
		vim.pack.update(args.fargs, { force = args.bang })
	else
		vim.pack.update(nil, { force = args.bang })
	end
end, {
	desc = "Update plugins",
	nargs = "*",
	bang = true,
	complete = plugin_autocompletion,
})

user_command("PackDelete", function(args)
	vim.pack.del(args.fargs, { force = args.bang })
end, {
	desc = "Delete plugins",
	nargs = "+",
	bang = true,
	complete = plugin_autocompletion,
})

user_command("PackRestore", function()
	vim.pack.update(nil, { target = "lockfile" })
end, {
	desc = "Restore plugins according to the lockfile",
})

-- Adapted from https://github.com/Sin-cy/dotfiles/blob/ca13116138957d7a87a1f946fde36f5e9cf7a1cb/nvim-nightly/.config/nvim-nightly/lua/sethy/pack.lua#L108
user_command("PackClean", function()
	local inactive = get_inactive_plugins()
	local inactive_list_string = ""

	if #inactive == 0 then
		vim.notify("No inactive plugins found!", vim.log.levels.INFO)
		return
	end

	for i, name in ipairs(inactive) do
		inactive_list_string = inactive_list_string .. name

		if i < #inactive then
			inactive_list_string = inactive_list_string .. "\n"
		end
	end

	local confirmation_message = string.format(
		[[󰒲  Inactive Plugins:
%s

Delete ALL inactive plugins from disk?]],
		inactive_list_string
	)

	local choice = vim.fn.confirm(
		confirmation_message,
		"&Yes\n&No",
		2 -- default = No
	)

	if choice == 1 then
		vim.pack.del(inactive)
		vim.notify("Deleted " .. #inactive .. " inactive plugin(s)", vim.log.levels.INFO)
	else
		vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
	end
end, { desc = "List all inactive plugins with the option to delete them" })

user_command("PackCount", function()
	local active = get_active_plugins()
	local inactive = get_inactive_plugins()

	vim.notify(
		string.format("%d total plugins are installed (%d are inactive)", #active + #inactive, #inactive),
		vim.log.levels.INFO
	)
end, { desc = "List the number of plugins that are currently installed" })
