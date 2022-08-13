local M = {}

M.editing = {
	i = {
		-- Press jj fast to exit insert mode
		["jj"] = { "<Esc>", " exit insert mode" },
	},

	n = {
		-- Use space only as leader key
		["<Space>"] = { "<Nop>" },

		-- Move text
		["<A-Down>"] = { "<Esc>:m .+1<CR>", " move line down" },
		["<A-Up>"] = { "<Esc>:m .-2<CR>", " move line up" },

		-- Duplicate lines
		["<A-S-Down>"] = { "yyp", " copy line down" },
		["<A-S-Up>"] = { "yyP", " copy line up" },
	},
}

M.window = {
   n = {
        ["<C-S-Up>"] = { ":resize -2<CR>", " increase size up" },
        ["<C-S-Down>"] = { ":resize +2<CR>", " increase size down" },
        ["<C-S-Left>"] = { ":vertical resize -2<CR>", " increase size left" },
        ["<C-S-Right>"] = { ":vertical resize +2<CR>", " increase size right" },
    }
}

M.nvterm = {
	n = {
		["<C-`>"] = {
			function()
				require("nvterm.terminal").toggle("horizontal")
			end,
			"   toggle horizontal term",
		},
		["<C-~>"] = {
			function()
				require("nvterm.terminal").toggle("vertical")
			end,
			"   toggle vertical term",
		},
	},

	t = {
		["<C-`>"] = {
			function()
				require("nvterm.terminal").toggle("horizontal")
			end,
			"   toggle horizontal term",
		},
		["<C-~>"] = {
			function()
				require("nvterm.terminal").toggle("vertical")
			end,
			"   toggle vertical term",
		},
	},
}

M.windows = {
	n = {
		["<leader>s"] = { "<Esc>:SymbolsOutline<CR>" },
	},
}

return M
