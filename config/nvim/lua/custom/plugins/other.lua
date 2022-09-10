local M = {}

M.blankline = function()
  local opts = {}
  opts.show_current_context_start = false
  return opts
end

M.autopairs = function()
  local opts = {}

  opts.check_ts = true -- use treesitter to check for a pair.
  opts.ts_config = {
    lua = { 'string' }, -- it will not add pair on that treesitter node
    javascript = { 'template_string' },
  }

  return opts
end

M.tmux = function()
  require('tmux').setup({
    -- overwrite default configuration
    -- here, e.g. to enable default bindings
    copy_sync = {
      -- enables copy sync and overwrites all register actions to
      -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
      enable = false,
    },
    navigation = {
      -- enables default keybindings (C-hjkl) for normal mode
      enable_default_keybindings = true,
    },
    resize = {
      -- enables default keybindings (A-hjkl) for normal mode
      enable_default_keybindings = true,
    },
  })
end

return M
