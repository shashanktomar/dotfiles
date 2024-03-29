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

local M = {

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

  -- ================ Telescope Related Plugins =================

  ['nvim-telescope/telescope.nvim'] = {
    module = 'telescope',
    override_options = require('custom.plugins.telescope'),
  },
  ['nvim-telescope/telescope-file-browser.nvim'] = {},
  ['nvim-telescope/telescope-symbols.nvim'] = {},
  ['nvim-telescope/telescope-ui-select.nvim'] = {},
  ['nvim-telescope/telescope-project.nvim'] = {},
  ['nvim-telescope/telescope-dap.nvim'] = {},
  ['LinArcX/telescope-env.nvim'] = {},
  ['nvim-telescope/telescope-fzf-native.nvim'] = { run = 'make' },

  -- ================ LSP Related Plugins =================

  ['neovim/nvim-lspconfig'] = {
    config = function()
      require('plugins.configs.lspconfig')
      require('custom.plugins.lspconfig')
    end,
  },

  ['b0o/schemastore.nvim'] = {},

  ['jose-elias-alvarez/null-ls.nvim'] = {
    config = function()
      require('custom.plugins.null_ls')
    end,
  },

  ['simrat39/symbols-outline.nvim'] = {
    after = 'nvim-lspconfig',
    config = function()
      require('custom.plugins.symbols-outline')
    end,
  },

  ['glepnir/lspsaga.nvim'] = {
    config = function()
      require('custom.plugins.lspsaga')
    end,
  },

  ['williamboman/mason.nvim'] = {
    override_options = require('custom.plugins.mason'),
  },

  -- ================ Treesitter Related Plugins =================

  ['nvim-treesitter/nvim-treesitter'] = {
    override_options = require('custom.plugins.treesitter'),
  },

  ['nvim-treesitter/playground'] = {
    after = 'nvim-treesitter',
  },
  ['RRethy/nvim-treesitter-endwise'] = {
    after = 'nvim-treesitter',
  },
  ['nvim-treesitter/nvim-treesitter-textobjects'] = {
    after = 'nvim-treesitter',
  },
  ['nvim-treesitter/nvim-treesitter-refactor'] = {
    after = 'nvim-treesitter',
  },
  ['nvim-treesitter/nvim-treesitter-context'] = {
    after = 'nvim-treesitter',
    config = function()
      require('treesitter-context').setup({})
    end,
  },

  -- ================ Cmp Plugins =================

  ['hrsh7th/cmp-cmdline'] = {
    after = 'cmp-buffer',
  },

  ['lukas-reineke/cmp-rg'] = {
    after = 'cmp-cmdline',
  },

  ['hrsh7th/nvim-cmp'] = {
    override_options = require('custom.plugins.cmp-config'),
  },

  -- ================ DAP Plugins =================

  ['mfussenegger/nvim-dap'] = {
    config = function() end,
  },

  ['rcarriga/nvim-dap-ui'] = {
    after = 'nvim-dap',
    requires = { 'mfussenegger/nvim-dap' },
    config = require('custom.plugins.nvim-dap').setup_dap_ui,
  },
  ['theHamsta/nvim-dap-virtual-text'] = {
    after = 'nvim-dap',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  },
  ['mxsdev/nvim-dap-vscode-js'] = {
    after = 'nvim-dap',
    requires = { 'mfussenegger/nvim-dap' },
    config = function()
      require('custom.plugins.nvim-dap-js')
    end,
  },
  ['microsoft/vscode-js-debug'] = {
    after = 'nvim-dap',
    opt = true,
    run = 'npm install --legacy-peer-deps && npm run compile',
  },

  -- ================ Language Specific Plugins =================

  -- Golang
  ['leoluz/nvim-dap-go'] = {
    config = function()
      require('dap-go').setup()
    end,
  },

  ['ray-x/go.nvim'] = {
    config = function()
      require('go').setup()
    end,
  },

  ['ray-x/guihua.lua'] = {},

  -- Rust
  -- ['simrat39/rust-tools.nvim'] = {
  --   config = function()
  --     require('custom.plugins.rust_tools')
  --   end,
  -- },

  -- ================ Other Plugins =================

  ['kkharji/sqlite.lua'] = {
    config = function()
      require('custom.utils').create_dir(vim.fn.stdpath('data') .. '/databases') -- create databases directory if missing
    end,
  },

  ['shashanktomar/vim-myhelp'] = {},

  ['mhinz/vim-startify'] = {
    config = function()
      require('custom.plugins.startify')
    end,
  },

  ['editorconfig/editorconfig-vim'] = {},

  -- ['rcarriga/nvim-notify'] = {
  --   config = function()
  --     require('custom.plugins.notify-config')
  --   end,
  -- },

  ['folke/which-key.nvim'] = {
    disable = false,

    config = function()
      require('plugins.configs.whichkey')
      require('custom.plugins.whichkey').setup()
    end,

    override_options = {
      icons = {
        group = ' ',
      },
    },
  },

  ['akinsho/toggleterm.nvim'] = {
    tag = 'v2.*',
    config = function()
      require('custom.plugins.toggleterm')
    end,
  },

  ['echasnovski/mini.nvim'] = {
    eranch = 'stable',
    config = function()
      require('custom.plugins.mini')
    end,
  },

  ['ggandor/lightspeed.nvim'] = {},

  ['L3MON4D3/LuaSnip'] = {
    config = function()
      require('plugins.configs.others').luasnip()
      require('custom.plugins.snip')
    end,
  },

  ['aserowy/tmux.nvim'] = {
    config = function()
      require('custom.plugins.other').tmux()
    end,
  },

  ['nvim-tree/nvim-tree.lua'] = {
    override_options = require('custom.plugins.nvim_tree'),
  },

  ['windwp/nvim-autopairs'] = {
    override_options = require('custom.plugins.other').autopairs(),
  },

  ['lukas-reineke/indent-blankline.nvim'] = {
    override_options = require('custom.plugins.other').blankline(),
  },

  ['lewis6991/gitsigns.nvim'] = {
    override_options = require('custom.plugins.gitsigns'),
  },

  ['nvim-neotest/neotest'] = {
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-go',
      'haydenmeade/neotest-jest',
    },
    config = function()
      require('custom.plugins.neotest')
    end,
  },

  -- ================ Remove Plugins =================

  ['goolord/alpha-nvim'] = false,
  ['NvChad/nvterm'] = false,
  -- ['NvChad/base46'] = false,
}

return M
