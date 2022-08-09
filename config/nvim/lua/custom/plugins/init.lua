local M = {}

M.user = {
  ["shashanktomar/vim-myhelp"] = {},
  ["mhinz/vim-startify"] = {},

  -- LSP Related Plugins
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },
}

M.remove = {
  "goolord/alpha-nvim"
}

M.override = {
  ["williamboman/mason.nvim"] = {
    ensure_installed = require("custom.plugins.mason").ensure_installed
  },
}

return M
