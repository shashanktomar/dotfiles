local M = {}

M.register = function()
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

		["<M-n>"] = { "next usage of word under cursor" }, -- powered by illuminate
		["<M-p>"] = { "previous usage of word under cursor" }, -- powered by illuminate

		["["] = { "previous" },
		["]"] = { "next" },

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
		},
    g = {
      D = { "declaration [LSP]" },
      d = { "definition [LSP]" },
      i = { "implementation [LSP]" },
      r = { "references [LSP]" },
    }
	})
end

M .options = function()
	local opt = {}
	opt.icons = {
		group = "",
	}
	return opt
end

return M
