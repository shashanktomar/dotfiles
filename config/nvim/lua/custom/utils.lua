P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function (...)
  return require("plenary.reload").reload_module(...)
end

R = function (name)
  RELOAD(name)
  return require(name)
end

local M = {}

M.notify = function(message, level, title)
  local notify_options = {
    title = title,
    timeout = 2000,
  }
  require("notify")(message, level, notify_options)
end

M.create_dir = function (path)
  local present = vim.fn.isdirectory(path)
  if present == 1 then
    return
  end

  vim.fn.mkdir(path)
end

return M
