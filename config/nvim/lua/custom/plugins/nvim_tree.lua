return function()
  local config = require('custom.config').nvim_tree

  local opt = {}

  -- opt.ignore_ft_on_setup = {
  --   'startify',
  --   'dashboard',
  --   'alpha',
  -- }

  opt.git = {
    enable = true,
    ignore = true,
    timeout = 400,
  }

  opt.renderer = {
    icons = {
      show = {
        git = config.enable_git_icons,
      },
      glyphs = {
        git = {
          unstaged = '',
        },
      },
    },
  }

  opt.update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = { '.git', '.cache', 'help' },
  }

  opt.trash = { cmd = 'trash-put', require_confirm = true }

  opt.diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = { hint = '', info = '', warning = '', error = '' },
  }

  opt.view = {
    preserve_window_proportions = true,
  }

  opt.filters = {
    custom = { '\\.null-ls.*' },
  }

  return opt
end
