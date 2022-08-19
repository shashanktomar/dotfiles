return function()
	local actions = require("telescope.actions")
	return {
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		},
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
		extensions_list = { "themes", "terms", "projects", "file_browser", "ui-select", "fzf" },
	}
end
