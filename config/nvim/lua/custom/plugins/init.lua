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
-- cmp-nvim-lsp -> check the explaination here https://github.com/hrsh7th/cmp-nvim-lsp
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
  -- LSP Related Plugins
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },
  
  -- cmp related plugins
  ["hrsh7th/cmp-cmdline"] = {
    after = "cmp-buffer"
  },

  -- Other
  ["shashanktomar/vim-myhelp"] = {},
  ["mhinz/vim-startify"] = {},
}

M.remove = {
  "goolord/alpha-nvim"
}

M.override = {
  ["williamboman/mason.nvim"] = {
    ensure_installed = require("custom.plugins.mason").ensure_installed
  },
  ['hrsh7th/nvim-cmp'] = function()
    local cmp = require 'cmp'
    return require('custom.plugins.cmp')(cmp)
  end
}

return M
