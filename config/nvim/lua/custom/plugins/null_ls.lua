local ok, null_ls = pcall(require, "null-ls")

if not ok then
	return
end

local acgroup = vim.api.nvim_create_augroup("LspFormatting", {})
local flags = require("custom.flags")

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
	formatting.codespell,

	-- diagnostics.eslint_d,
	diagnostics.shellcheck,
	diagnostics.codespell,
	diagnostics.vale,

	completion.spell.with({
		filetypes = { "markdown", "text" },
	}),
}

local format_on_save = function(client, bufnr)
	if not client.supports_method("textDocument/formatting") then
		return
	end

	vim.api.nvim_clear_autocmds({ group = acgroup, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = acgroup,
		buffer = bufnr,
		callback = function()
			if not flags.format_on_save then
				return
			end
			vim.lsp.buf.formatting({})
		end,
	})
end

null_ls.setup({ sources = sources, on_attach = format_on_save })
