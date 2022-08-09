local M = {}

M.ensure_installed = {
  -- cue
  "cuelsp",

  -- lua stuff
  "lua-language-server",
  "stylua",

  --shell
  "bash-language-server",
  "shfmt",
  "shellcheck",

  --web dev
  "typescript-language-server",
  "prettierd",
  "eslint_d",
  "eslint-lsp",

  --other
  "dockerfile-language-server",
  "markdownlint",
  "json-lsp",
  "jq",
}

return M
