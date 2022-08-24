local M = {}

M.disabled = {
	n = {
		["<leader>wK"] = "", -- unmap which-key mapped by nvchad
		["<leader>wk"] = "", -- unmap which-key mapped by nvchad
		["<leader>fw"] = "", -- unmap find live_grep mapped by nvchad
		["<leader>fb"] = "", -- unmap find buffers mapped by nvchad
		["<leader>tk"] = "", -- unmap telescope keymaps
		["<leader>gt"] = "", -- unmap git status
		["<leader>cm"] = "", -- unmap git commits
		["<leader>rn"] = "", -- unmap relative line number mapped by nvchad
		["<leader>ra"] = "", -- unmap lsp rename mapped by nvchad
		["<leader>fm"] = "", -- unmap lsp formatting mapped by nvchad
		["<leader>pt"] = "", -- unmap hidden term mapped by nvchad
		["<leader>ls"] = "", -- unmap lsp signature help mapped by nvchad
		["<leader>D"] = "", -- unmap lsp type-definition mapped by nvchad
		["<leader>f"] = "", -- unmap floating diagnostic mapped by nvchad
		["<leader>q"] = "", -- unmap diagnostic setloclist mapped by nvchad
		["[d"] = "", -- unmap lsp goto previous diagnostic mapped by nvchad
		["]d"] = "", -- unmap lsp goto next diagnostic mapped by nvchad
		["d]"] = "", -- unmap lsp goto buggy next diagnostic mapped by nvchad
		["<C-s>"] = "", -- unmap save file mapped by nvchad
	},
}

M.global = {
	n = {
		["<C-M-q>"] = { "<cmd> quitall <CR>", "quit all" },
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

		-- remember that swap lines is `ddp`
		["<M-Down>"] = { "<Esc>:m .+1<CR>", " move line down" },
		["<M-S-Down>"] = { "yyp", " copy line down" },
		["<M-Up>"] = { "<Esc>:m .-2<CR>", " move line up" },
		["<M-S-Up>"] = { "yyP", " copy line up" },
		["<M-o>"] = { "o<Esc>", "↵ insert a new line" },
		["<M-l>"] = { "<cmd> set rnu! <CR>", "toggle relative line numbers" },

		["<leader>s"] = { "<cmd> w <CR>", "save buffer" },
		["<leader>S"] = { "<cmd> wa <CR>", "save all buffers" },
	},
}

M.lsp = {
	n = {
		["<leader>r"] = {
			function()
				require("nvchad_ui.renamer").open()
			end,
			"rename [LSP]",
		},

		["<leader>d"] = {
			function()
				vim.diagnostic.open_float()
			end,
			"floating diagnostic [LSP]",
		},

		["[d"] = {
			function()
				vim.diagnostic.goto_prev()
			end,
			"previous diagnostic [LSP]",
		},

		["]d"] = {
			function()
				vim.diagnostic.goto_next()
			end,
			"next diagnostic [LSP]",
		},

		["<leader>cf"] = {
			function()
				vim.lsp.buf.formatting({})
			end,
			"format [LSP]",
		},

		["<leader>cs"] = {
			function()
				vim.lsp.buf.signature_help()
			end,
			"signature help [LSP]",
		},

		["gt"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			"type definition [LSP]",
		},

		["go"] = {
			function()
				vim.lsp.buf.outgoing_calls()
			end,
			"outgoing calls [LSP]",
		},

		["gp"] = {
			function()
				vim.lsp.buf.incoming_calls()
			end,
			"incoming calls [LSP]",
		},
	},
}

M.find = {
	n = {
		["<leader>fc"] = { "<cmd> Telescope command_history <CR>", "command history" },
		["<leader>fe"] = { "<cmd> Telescope file_browser <CR>", "explore file system" },
		["<leader>fg"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
		["<leader>fp"] = { "<cmd> Telescope projects <CR>", "projects" },
		["<leader>fs"] = { "<cmd> Telescope symbols <CR>", "symbols" },
		["<leader>fw"] = { "<cmd> Telescope grep_string <CR>", "grep word under cursor" },
		["<leader>fxa"] = { "<cmd> Telescope autocommands <CR>", "vim autocommands" },
		["<leader>fxc"] = { "<cmd> Telescope commands <CR>", "vim commands" },
		["<leader>fxe"] = { "<cmd> Telescope env <CR>", "environment vars" },
		["<leader>fxk"] = { "<cmd> Telescope keymaps <CR>", "normal mode keymaps" },
		["<leader>fxo"] = { "<cmd> Telescope vim_options <CR>", "vim options" },

		["<leader>p"] = { "<cmd> Telescope buffers <CR>", "find buffers", { nowait = true } },
	},
}

M.git = {
	n = {
		["<leader>gb"] = { "<cmd> Telescope git_branches <CR>", "branches" },
		["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "commits" },
		["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "status" },
	},
}

M.window = {
	n = {
		["<C-S-Up>"] = { "<cmd> resize -2 <CR>", " increase size up" },
		["<C-S-Down>"] = { "<cmd> resize +2 <CR>", " increase size down" },
		["<C-S-Left>"] = { "<cmd> vertical resize -2 <CR>", " increase size left" },
		["<C-S-Right>"] = { "<cmd> vertical resize +2 <CR>", " increase size right" },

		["<M-s>"] = { "<cmd> SymbolsOutline <CR>", "symbols window" },
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
