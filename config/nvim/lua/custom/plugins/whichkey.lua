local M = {}

M.setup = function()
  local ok, wk = pcall(require, 'which-key')

  if not ok then return end

  wk.register({
    j = { 'which_key_ignore' },
    k = { 'which_key_ignore' },
    h = { 'which_key_ignore' },
    l = { 'which_key_ignore' },
    ['<C-H>'] = { 'which_key_ignore' },
    ['<C-K>'] = { 'which_key_ignore' },
    ['<C-L>'] = { 'which_key_ignore' },
    ['<Up>'] = { 'which_key_ignore' },
    ['<Down>'] = { 'which_key_ignore' },

    ['<C-\\>'] = { 'toggle terminal' },

    ['['] = {
      name = 'previous',
      f = { 'function start' },
      F = { 'function end' },
      u = { 'class start' },
      U = { 'class end' },
    },
    [']'] = {
      name = 'next',
      f = { 'function start' },
      F = { 'function end' },
      u = { 'class start' },
      U = { 'class end' },
    },

    ['<CR>'] = { 'start selection' },

    K = { 'hover [LSP]' },

    ['Bslash'] = { 'select buffer by number' },

    ['<leader>'] = {
      name = '|____|',
      c = {
        name = 'code',
      },
      f = {
        name = 'find',
        a = { 'all files in project' },
        f = { 'files in project' },
        h = { 'help pages' },
        o = { 'old files' },
        x = {
          name = 'other',
        },
      },
      g = {
        name = 'git',
        h = {
          name = 'hunk',
        },
      },
      m = {
        name = 'move',
      },
      t = {
        name = 'terminals',
      },
      w = {
        name = 'workspace',
      },
      ['?'] = {
        function()
          vim.cmd('WhichKey')
        end,
        'show all keymaps',
      },
      z = {
        name = 'toggles',
      },
      [']'] = {
        name = 'other',
      },
    },
    g = {
      c = {
        name = 'comment',
      },
      b = {
        name = 'block comment',
      },
      D = { 'declaration [LSP]' },
      s = { 'cross window lightspeed forward' },
      S = { 'cross window lightspeed backward' },
    },
    s = {
      name = 'lightspeed forward',
      ['<CR>'] = 'make end of line searchable',
    },
    S = {
      name = 'lightspeed backward',
      ['<CR>'] = 'make end of line searchable',
      ['<Tab>'] = 'switch search direction',
      ['<Backspace>'] = 'Repeat previous input',
    },
    y = {
      -- this applies to all actions like d, c, etc but only put here for documentation purpose
      a = {
        name = 'textObjects documentation',
        a = { 'arguments' },
        c = { 'call' },
        d = { 'statement' },
        f = { 'function' },
        i = { 'conditional' },
        j = { 'loop' },
        m = { 'comment' },
        o = { 'code block' },
        q = { 'quotes: ", \' or `' },
        r = { 'params' },
        t = { 'tag' },
        u = { 'class' },
        ['?'] = { 'user prompt' },
      },
    },
  })
end

return M
