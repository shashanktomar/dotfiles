return function()
	local actions = require("telescope.actions")

	return {
		defaults = {
			prompt_prefix = " ",
			selection_caret = " ",
			file_ignore_patterns = { "node_modules", ".git", ".terraform", "%.jpg", "%.png" },
			mappings = {
				i = {
					["<esc>"] = actions.close,
				},
			},
		},
	}
end
