local M = {}

M.ensure_installed = {
  -- cue
  'cuelsp',

  -- lua stuff
  'lua-language-server',
  'stylua',

  -- go
  'delve',
  'gopls',
  'golangci-lint',
  'gofumpt',
  'goimports',
  'golines',
  'revive',
  'staticcheck',

  -- rust
  'rust-analyzer',
  'codelldb',

  -- python
  'pyright',

  --shell
  'bash-language-server',
  'shfmt',
  'shellcheck',

  --web dev
  'eslint-lsp',
  'eslint_d',
  -- 'prettier', # we don't need this, pick a local prettier
  'typescript-language-server',

  -- yaml
  'yaml-language-server',
  'yamlfmt',
  'yamllint',

  --other
  'dockerfile-language-server',
  'jq',
  'json-lsp',
  'markdownlint',
  'marksman',
  'misspell',
  'vale',
}

return M
