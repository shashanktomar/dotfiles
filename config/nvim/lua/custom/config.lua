local M = {}

-- enable mouse see :h mouse
M.mouse = "nv"

M.list = {
  enable = false, -- enable or disable listchars
  chars = "eol:↵,tab:>·,trail:~,extends:>,precedes:<" -- which list chars to schow
}

M.nvim_tree = {
  enable_git_icons = true
}

return M
