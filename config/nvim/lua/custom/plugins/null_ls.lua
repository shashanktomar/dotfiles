local ok, null_ls = pcall(require, 'null-ls')

if not ok then return end

local code_actions = null_ls.builtins.code_actions
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion
-- local hover = null_ls.builtins.hover

local sources = {
  code_actions.eslint_d,
  -- code_actions.prettierd,
  -- code_actions.gitsigns,
  code_actions.shellcheck,

  formatting.eslint_d,
  formatting.shfmt,
  formatting.prettierd,
  formatting.stylua,

  -- diagnostics.eslint_d,
  diagnostics.shellcheck,
  diagnostics.vale,

  completion.spell.with({
    filetypes = { 'markdown', 'text' },
  }),
}

local on_attach = function(client, bufnr)
  require('custom.autocmd').format_on_save(client, bufnr)
end

null_ls.setup({ sources = sources, on_attach = on_attach, debug = true })
