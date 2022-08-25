local config = require("custom.config").nvim_tree

local M = {}

M.ignore_ft_on_setup = {
	"startify",
	"dashboard",
	"alpha",
}

M.git = {
  enable = config.enable_git_icons
}

M.renderer = {
  icons = {
    show = {
      git = config.enable_git_icons
    },
    glyphs = {
      git = {
        unstaged = ""
      }
    }
  }
}

M.view = {
	preserve_window_proportions = true,
}

return M
