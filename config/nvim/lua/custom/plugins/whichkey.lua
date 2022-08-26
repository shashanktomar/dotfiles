local M = {}

M.setup = function()
	local ok, wk = pcall(require, "which-key")

	if not ok then
		return
	end

	wk.register({
		j = { "which_key_ignore" },
		k = { "which_key_ignore" },
		h = { "which_key_ignore" },
		l = { "which_key_ignore" },
		["<C-H>"] = { "which_key_ignore" },
		["<C-K>"] = { "which_key_ignore" },
		["<C-L>"] = { "which_key_ignore" },
		["<Up>"] = { "which_key_ignore" },
		["<Down>"] = { "which_key_ignore" },

		["<C-\\>"] = { "toggle terminal" },

		["["] = { "previous" },
		["]"] = { "next" },
    ["<CR>"] = { "start selection" },

		K = { "hover [LSP]" },

		["Bslash"] = { "select buffer by number" },

		["<leader>"] = {
			name = "|____|",
			c = {
				name = "code",
			},
			f = {
				name = "find",
				a = { "all files in project" },
				f = { "files in project" },
				h = { "help pages" },
				o = { "old files" },
				x = {
					name = "other",
				},
			},
			g = {
				name = "git",
				h = {
					name = "hunk",
				},
			},
			m = {
				name = "move",
			},
			t = {
				name = "terminals",
			},
			w = {
				name = "workspace",
			},
			["?"] = {
				function()
					vim.cmd("WhichKey")
				end,
				"show all keymaps",
			},
      z = {
        name = "toggles",
      },
			["]"] = {
				name = "other",
			},
		},
		g = {
			D = { "declaration [LSP]" },
			d = { "definition [LSP]" },
			i = { "implementation [LSP]" },
			r = { "references [LSP]" },
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
