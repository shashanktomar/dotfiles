local M = {}

M.register = function()
	local ok, wk = pcall(require, "which-key")

	if not ok then
		return
	end

	wk.register({
		["<M-n>"] = { "next usage of word under cursor" }, -- powered by illuminate
		["<M-p>"] = { "previous usage of word under cursor" }, -- powered by illuminate
		["<leader>"] = {
			name = "|____|",
			c = {
				name = "code",
				f = {
					function()
						vim.lsp.buf.formatting({})
					end,
					"format [LSP]",
				},
				r = {
					function()
						require("nvchad_ui.renamer").open()
					end,
					"rename [LSP]",
				},
				s = {
					function()
						vim.lsp.buf.signature_help()
					end,
					"signature help [LSP]",
				},
			},
			f = {
				name = "find",
				a = { "all files in project" },
				b = { "open buffers" },
				c = { "<cmd>Telescope command_history<cr>", "command history" },
				e = { "<cmd>Telescope file_browser<cr>", "explore file system" },
				f = { "files in project" },
				g = { "<cmd>Telescope live_grep<cr>", "live grep" },
				h = { "help pages" },
				o = { "old files" },
				p = { "<cmd>Telescope projects<cr>", "projects" },
				s = { "<cmd>Telescope symbols<cr>", "symbols" },
				w = { "<cmd>Telescope grep_string<cr>", "grep word under cursor" },
				x = {
					name = "other",
					a = { "<cmd>Telescope autocommands<cr>", "vim autocommands" },
					c = { "<cmd>Telescope commands<cr>", "vim commands" },
					e = { "<cmd>Telescope env<cr>", "environment vars" },
					k = { "<cmd>Telescope keymaps<cr>", "normal mode keymaps" },
					o = { "<cmd>Telescope vim_options<cr>", "vim options" },
				},
			},
			g = {
				name = "git",
				b = { "<cmd> Telescope git_branches <CR>", "branches" },
				c = { "<cmd> Telescope git_commits <CR>", "commits" },
				s = { "<cmd> Telescope git_status <CR>", "status" },
			},
			o = {
				name = "open",
				s = { "<cmd> SymbolsOutline <CR>", "symbols window" },
			},
			s = { "<cmd> w <CR>", "save buffer" },
			S = { "<cmd> wa <CR>", "save all buffers" },
			w = {
				name = "workspace",
			},
			["?"] = {
				function()
					vim.cmd("WhichKey")
				end,
				"show all keymaps",
			},
		},
	})
end

M.options = function()
	local opt = {}
	opt.icons = {
		group = "",
	}
	return opt
end

return M
