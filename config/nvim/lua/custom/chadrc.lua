-- Just an example, supposed to be placed in /lua/custom/
local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
M.plugins = {

    user = require "custom.plugins",

    remove = {"goolord/alpha-nvim"}
}

M.ui = {
    theme = "chadracula"
}

M.mappings = require "custom.mappings"

return M
