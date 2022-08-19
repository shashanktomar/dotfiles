-- Just an example, supposed to be placed in /lua/custom/
local M = {}
local customPlugins = require "custom.plugins"
-- make sure you maintain the structure of `core/default_config.lua` here,
M.plugins = {
    user = customPlugins.user,
    remove = customPlugins.remove,
    override = customPlugins.override,
}

M.ui = {
    theme = "everforest"
}

M.mappings = require "custom.mappings"

return M
