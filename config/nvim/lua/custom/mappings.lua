local M = {}

local utils = require('custom.utils')

M.disabled = {
  n = {
    ['<C-s>'] = '', -- unmap save file
    ['<leader>/'] = '', -- unmap comment
    ['<leader>D'] = '', -- unmap lsp type-definition
    ['<leader>ca'] = '', -- unmap lsp code action
    ['<leader>cm'] = '', -- unmap git commits
    ['<leader>f'] = '', -- unmap floating diagnostic
    ['<leader>fb'] = '', -- unmap find buffers
    ['<leader>fm'] = '', -- unmap lsp formatting
    ['<leader>fo'] = '', -- unmap telescope open old files
    ['<leader>fw'] = '', -- unmap find live_grep
    ['<leader>gt'] = '', -- unmap git status
    ['<leader>h'] = '', -- unmap new horizontal term
    ['<leader>ls'] = '', -- unmap lsp signature help
    ['<leader>n'] = '', -- unmap toggle line numbers
    ['<leader>pt'] = '', -- unmap hidden term
    ['<leader>q'] = '', -- unmap diagnostic setloclist
    ['<leader>ra'] = '', -- unmap lsp rename
    ['<leader>rn'] = '', -- unmap relative line number
    ['<leader>th'] = '', -- unmap change theme
    ['<leader>tk'] = '', -- unmap telescope keymaps
    ['<leader>tt'] = '', -- unmap toggle theme
    ['<leader>uu'] = '', -- unmap update nvchad
    ['<leader>v'] = '', -- unmap new vertical term
    ['<leader>wK'] = '', -- unmap which-key
    ['<leader>wk'] = '', -- unmap which-key
    ['[d'] = '', -- unmap lsp goto previous diagnostic
    [']d'] = '', -- unmap lsp goto next diagnostic
    ['d]'] = '', -- unmap lsp goto buggy next diagnostic
    ['gd'] = '', -- unmap go to definition
    ['gi'] = '', -- unmap go to implementation
    ['gr'] = '', -- unmap go to references
  },

  v = {
    ['<leader>/'] = '', -- unmap comment
  },
}

M.global = {
  n = {
    ['<C-M-q>'] = { '<cmd> quitall <CR>', 'quit all' },
    [';'] = { ':', 'command mode' },
  },
}

M.editing = {
  i = {
    -- Press jj fast to exit insert mode
    ['jk'] = { '<Esc>', ' exit insert mode', { nowait = true } },
    ['<Esc>'] = { '<Nop>' },
  },

  n = {
    -- Use space only as leader key
    ['<Space>'] = { '<Nop>' },

    ['<leader>s'] = { '<cmd> w <CR>', 'save buffer' },
    ['<leader>S'] = { '<cmd> wa <CR>', 'save all buffers' },

    ['<A-p>'] = { '"0p', 'p from yank register' },
    ['<A-P>'] = { '"0P', 'P from yank register' },
  },
}

M.movement = {
  n = {
    -- also check treesitter config

    -- remember that swap lines is `ddp`
    ['<C-M-j>'] = { '<Esc>:m .+1<CR>', ' move line down' },
    ['<C-M-k>'] = { '<Esc>:m .-2<CR>', ' move line up' },
    ['<M-o>'] = { 'o<Esc>', '↵ insert a new line down' },
    ['<M-O>'] = { 'O<Esc>', '↵ insert a new line up' },
    ['H'] = { '^', 'goto beginning of line' },
    ['L'] = { '$', 'goto end of line' },

    ['<leader>a'] = { '<cmd> b# <CR>', 'last buffer' },
  },
}

M.lsp = {
  n = {
    ['gd'] = { '<cmd> Telescope lsp_definitions <CR>', 'definition [lsp]' },
    ['gr'] = { '<cmd> Telescope lsp_references show_line=false <CR>', 'references [lsp]' },
    ['gi'] = { '<cmd> Telescope lsp_implementations <CR>', 'references [lsp]' },
    ['gh'] = { '<cmd> Lspsaga lsp_finder <CR>', 'lsp finder [lsp-saga]' },
    ['<leader>ca'] = { '<cmd> Lspsaga code_action <CR>', 'code action [lsp-saga]' },
    ['<leader>r'] = {
      function()
        require('nvchad_ui.renamer').open()
      end,
      'rename [LSP]',
    },

    ['<leader>D'] = { '<cmd> Telescope diagnostics <CR>', 'workspace diagnostic' },
    ['<leader>d'] = { '<cmd> Telescope diagnostics bufnr=0 heme=ivy height=30 <CR>', 'buffer diagnostic' },

    ['[d'] = { '<cmd> Lspsaga diagnostic_jump_prev <CR>', 'previous diagnostic [lsp-saga]' },
    [']d'] = { '<cmd> Lspsaga diagnostic_jump_next <CR>', 'next diagnostic [lsp-saga]' },

    ['<leader>cf'] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      'format [LSP]',
    },

    ['<leader>ci'] = {
      function()
        local ts = utils.is_ts_lsp_attached()
        if not ts then
          utils.notify('Command Unavailable', 'error', 'No tsserver attached')
          return
        end
        vim.lsp.buf.execute_command({ command = '_typescript.organizeImports', arguments = { vim.fn.expand('%:p') } })
      end,
      'organize imports [LSP]',
    },

    ['<leader>cs'] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      'signature help [LSP]',
    },

    ['gt'] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      'type definition [LSP]',
    },

    ['go'] = {
      function()
        vim.lsp.buf.outgoing_calls()
      end,
      'outgoing clls [LSP]',
    },

    ['gp'] = {
      function()
        vim.lsp.buf.incoming_calls()
      end,
      'incoming clls [LSP]',
    },
  },
}

M.telescope = {
  n = {
    ['<leader>fc'] = { '<cmd> Telescope command_history <CR>', 'command history' },
    ['<leader>fe'] = { '<cmd> Telescope file_browser <CR>', 'explore file system' },
    ['<leader>fg'] = { '<cmd> Telescope live_grep <CR>', 'live grep' },
    ['<leader>fm'] = { '<cmd> Telescope marks <CR>', 'marks' },
    ['<leader>fo'] = { '<cmd> Telescope oldfiles cwd_only=true <CR>', 'old files' },
    ['<leader>fp'] = { '<cmd> Telescope resume <CR>', 'resume previous' },
    ['<leader>fr'] = { '<cmd> Telescope registers <CR>', 'registers' },
    ['<leader>fs'] = { '<cmd> Telescope search_history <CR>', 'search history' },
    ['<leader>fu'] = { '<cmd> Telescope current_buffer_fuzzy_find <CR>', 'fuzzy search in current buffer' },
    ['<leader>fw'] = { '<cmd> Telescope grep_string <CR>', 'grep word under cursor' },
    ['<leader>fxa'] = { '<cmd> Telescope autocommands <CR>', 'vim autocommands' },
    ['<leader>fxc'] = { '<cmd> Telescope commands <CR>', 'vim commands' },
    ['<leader>fxe'] = { '<cmd> Telescope env <CR>', 'environment vars' },
    ['<leader>fxf'] = { '<cmd> Telescope filetypes <CR>', 'available filetypes' },
    ['<leader>fxh'] = { '<cmd> Telescope highlights <CR>', 'highlights' },
    ['<leader>fxk'] = { '<cmd> Telescope keymaps <CR>', 'normal mode keymaps' },
    ['<leader>fxj'] = { '<cmd> Telescope jumplist <CR>', 'jumplist' },
    ['<leader>fxl'] = { '<cmd> Telescope loclist <CR>', 'current window loclist' },
    ['<leader>fxm'] = { '<cmd> Telescope man_pages <CR>', 'man pages' },
    ['<leader>fxo'] = { '<cmd> Telescope vim_options <CR>', 'vim options' },
    ['<leader>fxp'] = { '<cmd> Telescope project <CR>', 'projects' },
    ['<leader>fxq'] = { '<cmd> Telescope quickfix <CR>', 'quickfix' },
    ['<leader>fxs'] = { '<cmd> Telescope quickfixhistory <CR>', 'quickfix history' },
    ['<leader>fxw'] = { '<cmd> Telescope spell_suggest <CR>', 'spell suggest for word under cursor' },
    ['<leader>fxx'] = { '<cmd> Telescope symbols <CR>', 'emojis' },

    ['<leader>p'] = { '<cmd> Telescope buffers <CR>', 'find buffers', { nowait = true } },
  },
}

M.git = {
  n = {
    ['<leader>ga'] = { '<cmd> Gitsigns stage_buffer <CR>', 'stage buffer' },
    ['<leader>ghs'] = { '<cmd> Gitsigns stage_hunk <CR>', 'stage hunk' },
    ['<leader>ghS'] = { '<cmd> Gitsigns undo_stage_hunk <CR>', 'unstage hunk' },
    ['<leader>ghr'] = { '<cmd> Gitsigns reset_hunk <CR>', 'reset hunk' },
    ['<leader>gx'] = { '<cmd> Gitsigns reset_buffer <CR>', 'reset buffer' },
    ['<leader>gt'] = {
      function()
        require('custom.plugins.toggleterm').lazygit_toggle()
      end,
      'open lazygit',
    },
  },
}

M.terminal = {
  n = {
    ['<leader>ta'] = { '<cmd> ToggleTermToggleAll <CR>', 'toggle all' },
    ['<leader>to'] = {
      function()
        require('custom.plugins.toggleterm').htop_toggle()
      end,
      'htop',
    },
    ['<leader>tm'] = {
      function()
        require('custom.plugins.toggleterm').glow_toggle()
      end,
      'glow markdown preview',
    },
    ['<leader>tn'] = {
      function()
        require('custom.plugins.toggleterm').neofetch_toggle()
      end,
      'neofetch',
    },
    ['<leader>tw'] = {
      function()
        require('custom.plugins.toggleterm').wtf_toggle()
      end,
      'wtf',
    },
    ['<leader>tt'] = {
      function()
        require('custom.plugins.toggleterm').tz_toggle()
      end,
      'tz',
    },
  },
  t = {
    ['<C-c>'] = { [[<C-\><C-n>]], 'quit terminal', { buffer = 0 } },
    ['<C-h>'] = { [[<Cmd>wincmd h<CR>]], 'move to left window', { buffer = 0 } },
    ['<C-j>'] = { [[<Cmd>wincmd j<CR>]], 'move to bottom window', { buffer = 0 } },
    ['<C-k>'] = { [[<Cmd>wincmd k<CR>]], 'move to top window', { buffer = 0 } },
    ['<C-l>'] = { [[<Cmd>wincmd l<CR>]], 'move to right window', { buffer = 0 } },
  },
}
M.window = {
  n = {
    ['<M-s>'] = { '<cmd> SymbolsOutline <CR>', 'symbols window' },
  },
}

M.toggles = {
  n = {
    ['<leader>zc'] = { '<cmd> ColorizerToggle <CR>', 'toggle colors' },
    ['<leader>zd'] = { require('custom.flags').toggle_diagnostic, 'toggle diagnostic' },
    ['<leader>zf'] = { require('custom.flags').toggle_format_on_save, 'toggle format on save' },
    ['<leader>zl'] = { '<cmd> set rnu! <CR>', 'toggle relative line numbers' },
    ['<leader>zs'] = { '<cmd> Gitsigns toggle_current_line_blame <CR>', 'current git line blame' },
    ['<leader>zy'] = { require('custom.flags').toggle_list_chars, 'toggle list chars' },
  },
}

M.test = {
  n = {
    ['<leader>vn'] = {
      function()
        require('neotest').run.run()
      end,
      'run test: neartest',
    },
    ['<leader>vs'] = {
      function()
        require('neotest').run.stop()
      end,
      'stop test: nearest',
    },
    ['<leader>va'] = {
      function()
        require('neotest').run.attach()
      end,
      'attach to test: nearest',
    },
    ['<leader>vf'] = {
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      'run test: in current file',
    },
    ['<leader>vl'] = {
      function()
        require('neotest').run.run_last()
      end,
      'run test: last',
    },
    ['<leader>vd'] = {
      function()
        require('neotest').run.run({ strategy = 'dap' })
      end,
      'debug test: nearest with dap',
    },
    ['<leader>vo'] = {
      function()
        require('neotest').output.open()
      end,
      'open test output',
    },
    ['<leader>vu'] = {
      function()
        require('neotest').summary.toggle()
      end,
      'toggle summary window',
    },
    ['<leader>v]'] = {
      function()
        require('neotest').jump.next({ status = 'failed' })
      end,
      'jump to next failed test',
    },
    ['<leader>v['] = {
      function()
        require('neotest').jump.prev({ status = 'failed' })
      end,
      'jump to previous failed test',
    },
  },
}

M.dap = {
  n = {
    ['<F5>'] = {
      function()
        require('dap').continue()
      end,
      'debug: start',
    },
    ['<F10>'] = {
      function()
        require('dap').step_over()
      end,
      'debug: step over',
    },
    ['<F11>'] = {
      function()
        require('dap').step_into()
      end,
      'debug: step into',
    },
    ['<F12>'] = {
      function()
        require('dap').step_out()
      end,
      'debug: step out',
    },
    ['<leader>ub'] = {
      function()
        require('dap').toggle_breakpoint()
      end,
      'debug: toggle breakpoint',
    },
    ['<leader>uB'] = {
      function()
        require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end,
      'debug: conditional breakpoint',
    },
    ['<leader>ue'] = {
      function()
        require('dapui').eval()
      end,
      'debug: eval expression',
    },
    ['<leader>ul'] = {
      function()
        require('dap').run_last()
      end,
      'debug: run last',
    },
    ['<leader>up'] = {
      function()
        require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
      end,
      'debug: log breakpoint',
    },
    ['<leader>ur'] = {
      function()
        require('dap').repl.open()
      end,
      'debug: repl open',
    },
    ['<leader>ut'] = {
      function()
        require('dapui').toggle()
      end,
      'debug: toggle ui',
    },
  },
}

M.other = {
  n = {
    ['<leader>]t'] = {
      function()
        require('base46').toggle_theme()
      end,
      'toggle theme',
    },
    ['<leader>]c'] = { '<cmd> Telescope themes <CR>', 'change nvchad themes' },
    ['<leader>]u'] = { '<cmd> :NvChadUpdate <CR>', 'update nvchad' },
  },
}

return M
