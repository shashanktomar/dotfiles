local M = {}

M.blankline = function()
	local opts = {}
	opts.show_current_context_start = false
	return opts
end

M.autopairs = function()
	local opts = {}

	opts.check_ts = true -- use treesitter to check for a pair.
	opts.ts_config = {
		lua = { "string" }, -- it will not add pair on that treesitter node
		javascript = { "template_string" },
	}

	return opts
end

return M
