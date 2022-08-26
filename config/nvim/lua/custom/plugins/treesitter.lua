local M = {}

M.ensure_installed = {
	"bash",
	"comment",
	"css",
	"dockerfile",
	"go",
	"gomod",
	"gowork",
	"graphql",
	"help",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"json5",
	"kotlin",
	"lua",
	"make",
	"markdown",
	"pug",
	"python",
	"r",
	"regex",
	"rego",
	"rust",
	"scss",
	"sql",
	"toml",
	"typescript",
	"vim",
	"yaml",
}

M.indent = {
	enable = true,
	disable = { "yaml" },
}

M.autopairs = {
	enable = true,
}

M.incremental_selection = {
	enable = true,
	keymaps = {
		init_selection = "<CR>",
		scope_incremental = "<CR>",
		node_incremental = "<TAB>",
		node_decremental = "<S-TAB>",
	},
}

M.playground = {
	enable = true,
}

M.endwise = {
	enable = true,
}

M.textobjects = {
	select = {
		enable = true,
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		keymaps = {
			-- You can use the capture groups defined in textobjects.scm
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
			["al"] = "@loop.outer",
			["il"] = "@loop.inner",
			["io"] = "@block.inner",
			["ao"] = "@block.outer",
			["ir"] = "@parameter.inner",
			["ar"] = "@parameter.outer",
			["ii"] = "@conditional.inner",
			["ai"] = "@conditional.outer",
			["iq"] = "@comment.outer", -- only outer comments are supported
			["aq"] = "@comment.outer", -- only outer comments are supported
			["ig"] = "@call.outer",
			["ag"] = "@call.outer",
			["iu"] = "@statement.outer",
			["au"] = "@statement.outer",
			-- @scopename.inner
			-- @frame
			-- @attribute
		},

		-- TODO: Understand what is this
		-- You can choose the select mode (default is charwise 'v')
		-- selection_modes = {
		-- 	["@parameter.outer"] = "v", -- charwise
		-- 	["@function.outer"] = "V", -- linewise
		-- 	["@class.outer"] = "<c-v>", -- blockwise
		-- },
	},

	swap = {
		enable = true,
		swap_next = {
			["<leader>mr"] = "@parameter.inner",
			["<leader>mf"] = "@function.outer",
		},
		swap_previous = {
			["<leader>mR"] = "@parameter.inner",
			["<leader>mF"] = "@function.outer",
		},
	},

	move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
		goto_next_start = {
			["]f"] = "@function.outer",
			["]c"] = "@class.outer",
		},
		goto_next_end = {
			["]F"] = "@function.outer",
			["]C"] = "@class.outer",
		},
		goto_previous_start = {
			["[f"] = "@function.outer",
			["[c"] = "@class.outer",
		},
		goto_previous_end = {
			["[F"] = "@function.outer",
			["[C"] = "@class.outer",
		},
	},
}

M.refactor = {
	highlight_definitions = {
		enable = true,
		-- Set to false if you have an `updatetime` of ~100.
		clear_on_cursor_move = true,
	},
	highlight_current_scope = { enable = false },
}

return M
