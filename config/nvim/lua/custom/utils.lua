P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return require('plenary.reload').reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

local M = {}

M.notify = function(title, level, message)
  local notify_options = {
    title = title,
    timeout = 2000,
  }
  require('notify')(message, level, notify_options)
end

M.create_notify = function(title, level)
  return function(message)
    M.notify(title, level, message)
  end
end

M.create_dir = function(path)
  local present = vim.fn.isdirectory(path)
  if present == 1 then return end

  vim.fn.mkdir(path)
end

M.is_ts_lsp_attached = function()
  local lsp_clients = vim.lsp.buf_get_clients()
  for _, value in ipairs(lsp_clients) do
    if value.name == 'tsserver' then return true end
  end
  return false
end

return M
