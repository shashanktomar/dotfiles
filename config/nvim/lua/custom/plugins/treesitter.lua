local M = {}

M.ensure_installed = {
  "bash",
  "comment",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gowork",
  "graphql",
  "help",
  "html",
  "http",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "kotlin",
  "lua",
  "make",
  "markdown",
  "pug",
  "python",
  "r",
  "regex",
  "rego",
  "rust",
  "scss",
  "sql",
  "toml",
  "typescript",
  "vim",
  "yaml"
}

M.indent = {
  enable = true,
  disable = { "yaml" }
}

M.incremental_selection = {
  enable = true
}

M.playground = {
  enable = true,
}

return M
