local ok, tt = pcall(require, "toggleterm")

if not ok then
	return
end

tt.setup({
	open_mapping = [[<c-\>]],
})


local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float", dir = "git_dir" })
local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "float", close_on_exit = true })

local M = {}
M.lazygit_toggle = function()
	lazygit:toggle()
end

M.htop_toggle = function()
	htop:toggle()
end

return M
