local ok, tt = pcall(require, 'toggleterm')
local utils = require('custom.utils')

if not ok then return end

tt.setup({
  open_mapping = [[<c-\>]],
})

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float', dir = 'git_dir' })
local htop = Terminal:new({ cmd = 'htop', hidden = true, direction = 'float' })
local neofetch = Terminal:new({ cmd = 'neofetch', hidden = true, direction = 'float', close_on_exit = false })
local wtfutil = Terminal:new({ cmd = 'wtfutil', hidden = true, direction = 'float' })
local tz = Terminal:new({
  cmd = 'tz',
  hidden = true,
  direction = 'float',
  env = { TZ_LIST = 'Asia/Kolkata,India ; Canada/Pacific, Canada Pacific' },
})
local glow = function(filePath)
  return Terminal:new({
    cmd = 'glow -p ' .. filePath,
    hidden = true,
    direction = 'float',
    close_on_exit = true,
  })
end

local M = {}

M.lazygit_toggle = function()
  lazygit:toggle()
end

M.htop_toggle = function()
  htop:toggle()
end

M.neofetch_toggle = function()
  neofetch:toggle()
end

M.wtf_toggle = function()
  wtfutil:toggle()
end

M.tz_toggle = function()
  tz:toggle()
end

M.glow_toggle = function()
  if vim.bo.filetype ~= 'markdown' then
    utils.notify('ToggleTerm', 'warn', 'Current buffer is not markdown')
    return
  end
  local currentFilePath = vim.api.nvim_buf_get_name(0)
  glow(currentFilePath):toggle()
end

return M
