local present, lsp = pcall(require, "lspconfig")

if not present then
	return
end

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

-- detect python venv
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
local util = require("lspconfig/util")
local path = util.path
local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end
  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({ "*", ".*" }) do
    local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
    if match ~= "" then
      return path.join(path.dirname(match), "bin", "python")
    end
  end
  -- Fallback to system Python.
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

local servers = {
	"bashls",
	"csharp_ls",
	"cssls",
	"dagger",
	"dockerls",
	"eslint",
	"html",
	"jsonls",
	"kotlin_language_server",
	"marksman",
	"tsserver",
	"yamlls",
}

for _, plugin in ipairs(servers) do
	lsp[plugin].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		root_dir = lsp.util.root_pattern(".git"),
	})
end

-- This is not working :(.
-- Check https://github.com/dagger/cuelsp/blob/main/docs/vim.md
-- and https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dagger
-- dagger needs special setup for now
lsp.dagger.setup({
	cmd = { "dagger", "cuelsp" },
	filetypes = { "cue" },
	on_attach = on_attach,
	capabilities = capabilities,
})
