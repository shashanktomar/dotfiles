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
	-- local plugins
	-- ["~/Documents/projects/nvim/nvchad/base46"] = {
	--   config = function()
	--     local ok, base46 = pcall(require, "base46")
	--
	--     if ok then
	--       base46.load_theme()
	--     end
	--   end,
	-- },

	-- plugins used by other plugins
	["kkharji/sqlite.lua"] = {
		config = function()
			require("custom.utils").create_dir(vim.fn.stdpath("data") .. "/databases") -- create databases directory if missing
		end,
	},

	-- telescope related plugins
	-- see this https://github.com/NvChad/NvChad/issues/1255
	["nvim-telescope/telescope.nvim"] = {
		module = "telescope",
	},
	["nvim-telescope/telescope-file-browser.nvim"] = {},
	["nvim-telescope/telescope-symbols.nvim"] = {},
	["nvim-telescope/telescope-ui-select.nvim"] = {},
	["nvim-telescope/telescope-project.nvim"] = {},
	["LinArcX/telescope-env.nvim"] = {},
	["nvim-telescope/telescope-fzf-native.nvim"] = { run = "make" },

	-- LSP Related Plugins
	["neovim/nvim-lspconfig"] = {
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.plugins.lspconfig")
		end,
	},

	["b0o/schemastore.nvim"] = {},

	["jose-elias-alvarez/null-ls.nvim"] = {
		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.null_ls")
		end,
	},

	["simrat39/symbols-outline.nvim"] = {
		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.symbols-outline")
		end,
	},

	["glepnir/lspsaga.nvim"] = {
		config = function()
			require("custom.plugins.lspsaga")
		end,
	},

	-- treesitter related plugins
	["nvim-treesitter/playground"] = {
		after = "nvim-treesitter",
	},
	["RRethy/nvim-treesitter-endwise"] = {
		after = "nvim-treesitter",
	},
	["nvim-treesitter/nvim-treesitter-textobjects"] = {
		after = "nvim-treesitter",
	},
	["nvim-treesitter/nvim-treesitter-refactor"] = {
		after = "nvim-treesitter",
	},

	-- cmp related plugins
	["hrsh7th/cmp-cmdline"] = {
		after = "cmp-buffer",
	},

	["lukas-reineke/cmp-rg"] = {
		after = "cmp-cmdline",
	},

	-- Other
	["shashanktomar/vim-myhelp"] = {},
	["mhinz/vim-startify"] = {
		config = function()
			require("custom.plugins.startify")
		end,
	},
	["editorconfig/editorconfig-vim"] = {},
	["rcarriga/nvim-notify"] = {
		config = function()
			require("custom.plugins.notify-config")
		end,
	},

	["folke/which-key.nvim"] = {
		disable = false,
		config = function()
			require("plugins.configs.whichkey")
			require("custom.plugins.whichkey").setup()
		end,
	},

	["akinsho/toggleterm.nvim"] = {
		tag = "v2.*",
    config = function ()
      require("custom.plugins.toggleterm")
    end
	},
}

M.remove = {
	"goolord/alpha-nvim",
  "NvChad/nvterm"
	-- "NvChad/base46"
}

M.override = {
	["kyazdani42/nvim-tree.lua"] = require("custom.plugins.nvim_tree"),
	["nvim-treesitter/nvim-treesitter"] = require("custom.plugins.treesitter"),
	["williamboman/mason.nvim"] = require("custom.plugins.mason"),
	["nvim-telescope/telescope.nvim"] = require("custom.plugins.telescope"),
	["folke/which-key.nvim"] = require("custom.plugins.whichkey").options(),
	["windwp/nvim-autopairs"] = require("custom.plugins.other").autopairs(),
	["lukas-reineke/indent-blankline.nvim"] = require("custom.plugins.other").blankline(),
	["lewis6991/gitsigns.nvim"] = require("custom.plugins.gitsigns"),

	["hrsh7th/nvim-cmp"] = function()
		local cmp = require("cmp")
		return require("custom.plugins.cmp")(cmp)
	end,
}

return M
