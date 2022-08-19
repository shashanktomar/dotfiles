-- Plugins added by nvchad

-- ======= Core Plugins =======
-- Packer
-- Telescope
-- Treesitter
-- nvim-tree

-- ======= LSP =======
-- nvim-lspconfig -> core client for lsp servers
-- mason -> provides a ui for download and mange lsp servers, lint, format and debug plugins

-- ======= Code Completion =======
-- nvim-cmp -> code completion plugin
-- cmp-nvim-lua -> completions for nvim lua api
-- cmp-nvim-lsp -> check the explanation here https://github.com/hrsh7th/cmp-nvim-lsp
-- cmp-buffer -> buffer completions
-- cmp-path -> path completions
-- cmp-luasnip -> snippet completions

-- ======= Snippets =======
-- luasnip -> snippet engine
-- friendly-snippets -> a library of snippets

-- ======= NvChad Plugins =======
-- NvChad Extensions
-- NvChad UI
-- NvChad NvTerm
-- NvChad Colorizer

-- ======= Git =======
-- gitsigns -> git changes marked on buffer lines

-- ======= Other =======
-- nvim-autopairs
-- whichKey -> shortcut keys help
-- alpha-nvim -> dashboard
-- comment-nvim -> enable shortcut for comments
-- base46 -> themes
-- nvim-web-devicons
-- indent-blankline -> the lines which apper to show indentation

local M = {}

M.user = {
	-- telescope related plugins
	-- see this https://github.com/NvChad/NvChad/issues/1255
	["nvim-telescope/telescope.nvim"] = {
		module = "telescope",
		config = function()
			require("plugins.configs.telescope")
			require("custom.plugins.telescope").setup_extensions()
		end,
	},

	["ahmedkhalf/project.nvim"] = {
	  config = function()
	    require("custom.plugins.project")
	  end
	},

	-- LSP Related Plugins
	["neovim/nvim-lspconfig"] = {
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.plugins.lspconfig")
		end,
	},

	["jose-elias-alvarez/null-ls.nvim"] = {
		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.null_ls")
		end,
	},

	["simrat39/symbols-outline.nvim"] = {
		after = "nvim-lspconfig",
    config = function ()
      require("custom.plugins.symbols-outline")
    end
	},

	-- ["tamago324/nlsp-settings.nvim"] = {
	-- after = "nvim-lspconfig"
	-- },

	-- treesitter related plugins
	["nvim-treesitter/playground"] = {
		after = "nvim-treesitter",
	},

	-- cmp related plugins
	["hrsh7th/cmp-cmdline"] = {
		after = "cmp-buffer",
	},

	-- Other
	["shashanktomar/vim-myhelp"] = {},
	["mhinz/vim-startify"] = {},
	["rcarriga/nvim-notify"] = {
		config = function()
			require("custom.plugins.notify")
		end,
	},

	["folke/which-key.nvim"] = {
		disable = false,
	},
}

M.remove = {
	"goolord/alpha-nvim",
}

M.override = {
	["kyazdani42/nvim-tree.lua"] = require("custom.plugins.nvim_tree"),
	["nvim-treesitter/nvim-treesitter"] = require("custom.plugins.treesitter"),
	["williamboman/mason.nvim"] = require("custom.plugins.mason"),
	["nvim-telescope/telescope.nvim"] = require("custom.plugins.telescope").setup_options,

	["hrsh7th/nvim-cmp"] = function()
		local cmp = require("cmp")
		return require("custom.plugins.cmp")(cmp)
	end,
}

return M
