local M = {}

-- Most of the keymaps are defined under whichkey config

M.unregister = {
	n = {
		["<leader>wK"] = { "<Nop>" }, -- unmap which-key mapped by nvchad
		["<leader>wk"] = { "<Nop>" }, -- unmap which-key mapped by nvchad
		["<leader>fw"] = { "<Nop>" }, -- unmap find live_grep mapped by nvchad
		["<leader>tk"] = { "<Nop>" }, -- unmap telescope keymaps
		["<leader>gt"] = { "<Nop>" }, -- unmap git status
		["<leader>cm"] = { "<Nop>" }, -- unmap git commits
		["<leader>rn"] = { "<Nop>" }, -- unmap relative line number mapped by nvchad
		["<leader>ra"] = { "<Nop>" }, -- unmap lsp rename mapped by nvchad
		["<leader>fm"] = { "<Nop>" }, -- unmap lsp formatting mapped by nvchad
		["<C-s>"] = { "<Nop>" }, -- unmap save file mapped by nvchad
	},
}

M.editing = {
	i = {
		-- Press jj fast to exit insert mode
		["jk"] = { "<Esc>", " exit insert mode", { nowait = true } },
		["<Esc>"] = { "<Nop>" },
	},

	n = {
		-- Use space only as leader key
		["<Space>"] = { "<Nop>" },
		-- Move text
		["<A-Down>"] = { "<Esc>:m .+1<CR>", " move line down" },
		["<A-Up>"] = { "<Esc>:m .-2<CR>", " move line up" },
		-- remember that swap lines is `ddp`

		-- Duplicate lines
		["<A-S-Down>"] = { "yyp", " copy line down" },
		["<A-S-Up>"] = { "yyP", " copy line up" },

		-- Enter a new line without entering insert mode
		["<A-o>"] = { "o<Esc>", "- insert a new line" },
	},
}

M.window = {
	n = {
		["<C-S-Up>"] = { ":resize -2<CR>", " increase size up" },
		["<C-S-Down>"] = { ":resize +2<CR>", " increase size down" },
		["<C-S-Left>"] = { ":vertical resize -2<CR>", " increase size left" },
		["<C-S-Right>"] = { ":vertical resize +2<CR>", " increase size right" },
	},
}

M.nvterm = {
	plugin = true,
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

return M
