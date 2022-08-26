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
		["<leader>n"] = "", -- unmap toggle line numbers mapped by nvchad
		["<leader>h"] = "", -- unmap new horizontal term mapped by nvchad
		["<leader>v"] = "", -- unmap new vertical term mapped by nvchad
		["<leader>ca"] = "", -- unmap lsp code action mapped by nvchad
		["<leader>th"] = "", -- unmap change theme mapped by nvchad
		["<leader>tt"] = "", -- unmap toggle theme mapped by nvchad
		["<leader>uu"] = "", -- unmap update nvchad mapped by nvchad
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
		["kj"] = { "<Esc>", " exit insert mode", { nowait = true } },
		["<Esc>"] = { "<Nop>" },
	},

	n = {
		-- Use space only as leader key
		["<Space>"] = { "<Nop>" },

		["<leader>s"] = { "<cmd> w <CR>", "save buffer" },
		["<leader>S"] = { "<cmd> wa <CR>", "save all buffers" },

		["<A-p>"] = { '"0p', "p from yank register" },
		["<A-P>"] = { '"0P', "P from yank register" },
	},
}

M.movement = {
	n = {
		-- also check treesitter config

		-- remember that swap lines is `ddp`
		["<M-j>"] = { "<Esc>:m .+1<CR>", " move line down" },
		["<M-k>"] = { "<Esc>:m .-2<CR>", " move line up" },
		["<M-J>"] = { "yyp", " copy line down" },
		["<M-K>"] = { "yyP", " copy line up" },
		["<M-o>"] = { "o<Esc>", "↵ insert a new line down" },
		["<M-O>"] = { "O<Esc>", "↵ insert a new line up" },
	},
}

M.lsp = {
	n = {
		["gh"] = { "<cmd> Lspsaga lsp_finder <CR>", "lsp finder [lsp-saga]" },
		["<leader>ca"] = { "<cmd> Lspsaga code_action <CR>", "code action [lsp-saga]" },
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

		["[d"] = { "<cmd> Lspsaga diagnostic_jump_prev <CR>", "previous diagnostic [lsp-saga]" },
		["]d"] = { "<cmd> Lspsaga diagnostic_jump_next <CR>", "next diagnostic [lsp-saga]" },

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
		["<leader>fp"] = { "<cmd> Telescope project <CR>", "projects" },
		["<leader>fs"] = { "<cmd> Telescope symbols <CR>", "symbols" },
		["<leader>fw"] = { "<cmd> Telescope grep_string <CR>", "grep word under cursor" },
		["<leader>fxa"] = { "<cmd> Telescope autocommands <CR>", "vim autocommands" },
		["<leader>fxc"] = { "<cmd> Telescope commands <CR>", "vim commands" },
		["<leader>fxe"] = { "<cmd> Telescope env <CR>", "environment vars" },
		["<leader>fxh"] = { "<cmd> Telescope highlights <CR>", "environment vars" },
		["<leader>fxk"] = { "<cmd> Telescope keymaps <CR>", "normal mode keymaps" },
		["<leader>fxo"] = { "<cmd> Telescope vim_options <CR>", "vim options" },

		["<leader>p"] = { "<cmd> Telescope buffers <CR>", "find buffers", { nowait = true } },
	},
}

M.git = {
	n = {
		["<leader>ga"] = { "<cmd> Gitsigns stage_buffer <CR>", "stage buffer" },
		["<leader>ghs"] = { "<cmd> Gitsigns stage_hunk <CR>", "stage hunk" },
		["<leader>ghS"] = { "<cmd> Gitsigns undo_stage_hunk <CR>", "unstage hunk" },
		["<leader>ghr"] = { "<cmd> Gitsigns reset_hunk <CR>", "reset hunk" },
		["<leader>gx"] = { "<cmd> Gitsigns reset_buffer <CR>", "reset buffer" },
		["<leader>gt"] = { require("custom.plugins.toggleterm").lazygit_toggle, "open lazygit" },
	},
}

M.terminal = {
	n = {
		["<leader>ta"] = { "<cmd> ToggleTermToggleAll <CR>", "toggle all" },
		["<leader>tt"] = { "<cmd> ToggleTerm direction=tab <CR>", "tab" },
		["<leader>to"] = { require("custom.plugins.toggleterm").htop_toggle, "htop" },
	},
	t = {
		["<esc>"] = { [[<C-\><C-n>]], "quit terminal", { buffer = 0 } },
		["jk"] = { [[<C-\><C-n>]], "quit terminal", { buffer = 0 } },
		["<C-h>"] = { [[<Cmd>wincmd h<CR>]], "move to left window", { buffer = 0 } },
		["<C-j>"] = { [[<Cmd>wincmd j<CR>]], "move to bottom window", { buffer = 0 } },
		["<C-k>"] = { [[<Cmd>wincmd k<CR>]], "move to top window", { buffer = 0 } },
		["<C-l>"] = { [[<Cmd>wincmd l<CR>]], "move to right window", { buffer = 0 } },
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

M.toggles = {
	n = {
		["<leader>zl"] = { "<cmd> set rnu! <CR>", "toggle relative line numbers" },
		["<leader>zs"] = { "<cmd> Gitsigns toggle_current_line_blame <CR>", "current git line blame" },
	},
}

M.other = {
	n = {
		["<leader>]t"] = {
			function()
				require("base46").toggle_theme()
			end,
			"toggle theme",
		},
		["<leader>]c"] = { "<cmd> Telescope themes <CR>", "change nvchad themes" },
		["<leader>]u"] = { "<cmd> :NvChadUpdate <CR>", "update nvchad" },
	},
}

return M
