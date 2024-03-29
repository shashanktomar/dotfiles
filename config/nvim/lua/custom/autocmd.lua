local autocmd = vim.api.nvim_create_autocmd
local createGroup = vim.api.nvim_create_augroup

local utils = require('custom.utils')
local flags = require('custom.flags')
local acgroup = createGroup('LspFormatting', {})

local M = {

  register_autocmds = function()
    -- Close nvim if NvimTree is only running buffer
    -- autocmd(
    --   "BufEnter",
    --   { command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]] }
    -- )

    -- Highlight on yank
    autocmd('TextYankPost', {
      command = 'silent! lua vim.highlight.on_yank()',
      group = createGroup('YankHighlight', { clear = true }),
    })

    -- Go to last loc when opening a buffer
    autocmd(
      'BufReadPost',
      { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
    )

    -- Windows to close with "q"
    autocmd('FileType', {
      pattern = { 'help', 'startuptime', 'qf', 'lspinfo', 'fugitive', 'null-ls-info' },
      command = [[nnoremap <buffer><silent> q :close<CR>]],
    })
    autocmd('FileType', { pattern = 'man', command = [[nnoremap <buffer><silent> q :quit<CR>]] })

    -- Enable spell checking for certain file types
    -- autocmd(
    --   { "BufRead", "BufNewFile" },
    --   { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
    -- )
  end,

  format_on_save = function(lsp_client, bufnr)
    if not lsp_client.supports_method('textDocument/formatting') then return end

    vim.api.nvim_clear_autocmds({ group = acgroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = acgroup,
      buffer = bufnr,
      callback = function()
        if not flags.format_on_save then return end
        utils.async_formatting(bufnr)
        -- vim.lsp.buf.format({ bufnr = bufnr, async = true })
      end,
    })
  end,
}

return M
