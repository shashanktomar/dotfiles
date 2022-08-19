local M = {}

M.ignore_ft_on_setup = {
	"startify",
	"dashboard",
	"alpha",
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
