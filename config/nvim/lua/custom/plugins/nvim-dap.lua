local M = {}

M.setup_dap_ui = function()
  local dap, dapui = require('dap'), require('dapui')

  dap.listeners.after.event_initialized['dapui_config'] = function()
    print('event_initialized')
    dapui.open('sidebar')
  end

  dap.listeners.before.event_terminated['dapui_config'] = function()
    print('event_terminated')
    dapui.close()
  end

  dap.listeners.before.event_exited['dapui_config'] = function()
    print('event_terminated')
    dapui.close()
  end

  dapui.setup({
    layouts = {
      {
        elements = {
          -- Elements can be strings or table with id and size keys.
          { id = 'scopes', size = 0.25 },
          'breakpoints',
          'stacks',
          'watches',
        },
        size = 40, -- 40 columns
        position = 'right',
      },
      {
        elements = {
          'repl',
          'console',
        },
        size = 0.25, -- 25% of total lines
        position = 'bottom',
      },
    },
  })
end

return M
