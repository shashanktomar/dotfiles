local M = {}

M.nvim_tree = {
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"alpha",
	},
	view = {
		preserve_window_proportions = true,
	},
}

M.treesitter = {
	ensure_installed = {
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
	},

	indent = {
		enable = true,
		disable = { "yaml" },
	},

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			scope_incremental = "<CR>",
			node_incremental = "<TAB>",
			node_decremental = "<S-TAB>",
		},
	},

	playground = {
		enable = true,
	},
}

M.mason = {
	ensure_installed = {
		-- cue
		"cuelsp",

		-- lua stuff
		"lua-language-server",
		"stylua",

		--shell
		"bash-language-server",
		"shfmt",
		"shellcheck",

		--web dev
		"eslint-lsp",
		"eslint_d",
		"prettierd",
		"typescript-language-server",

		--other
		"codespell",
		"dockerfile-language-server",
		"jq",
		"json-lsp",
		"markdownlint",
	},
}

return M
