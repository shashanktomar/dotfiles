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
    }
  }
}

M.view = {
	preserve_window_proportions = true,
}

M.sync_root_with_cwd = true
M.respect_buf_cwd = true
M.update_focused_file = {
	enable = true,
	update_root = true,
}

return M
