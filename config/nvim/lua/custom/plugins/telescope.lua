local M = {}

M.setup_options = function()
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
		extensions = {
			--    projects = {
			--      theme = "abc"
			-- },
		},
	}
end

M.setup_extensions = function()
	local telescope = require("telescope")
	telescope.load_extension("projects")
end

return M
