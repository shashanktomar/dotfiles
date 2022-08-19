require("project_nvim").setup({
  patterns = {
    ".git",
    ".terraform",
    "go.mod",
  },
  -- detection_methods = { "lsp", "pattern" },
  detection_methods = { "pattern" },
})
