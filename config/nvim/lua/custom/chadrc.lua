-- Just an example, supposed to be placed in /lua/custom/
local M = {}
-- make sure you maintain the structure of `core/default_config.lua` here,
M.plugins = require('custom.plugins')

M.ui = {
  theme = "catppuccin",
  hl_override = require('custom.ui').hl_override,
  hl_add = require('custom.ui').hl_add,
}

M.mappings = require('custom.mappings')

return M
