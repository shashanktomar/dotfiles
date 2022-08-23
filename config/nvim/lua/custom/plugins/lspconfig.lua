local present, lsp = pcall(require, "lspconfig")

if not present then
	return
end

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

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
		before_init = function(_, config)
			if lsp == "pyright" then
				config.settings.python.pythonPath = get_python_path(config.root_dir)
			end
		end,
		capabilities = capabilities,
		root_dir = lsp.util.root_pattern(".git"),
		settings = {
			json = {
				format = {
					enable = false, -- let null-ls handle the formatting
				},
				schemas = require("schemastore").json.schemas {
          select = {
            '.eslintrc',
            'package.json'
          }
        },
				validate = { enable = true },
			},
			yaml = {
				schemaStore = {
					enable = true,
					url = "https://www.schemastore.org/api/json/catalog.json",
				},
				schemas = {
					kubernetes = "*.yaml",
					["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
					["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
					["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
					["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
					["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
					["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
					["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
					["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
					["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
				},
				format = { enabled = false },
				validate = false, -- TODO: conflicts between Kubernetes resources and kustomization.yaml
				completion = true,
				hover = true,
			},
			dagger = {
				-- This is not working :(.
				-- Check https://github.com/dagger/cuelsp/blob/main/docs/vim.md
				-- and https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dagger
				cmd = { "dagger", "cuelsp" },
				filetypes = { "cue" },
			},
		},
	})
end
