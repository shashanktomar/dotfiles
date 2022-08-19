local ok, null_ls = pcall(require, "null-ls")

if not ok then
	return
end

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

	completion.spell.with({
		filetypes = { "markdown", "text" },
	}),
}

null_ls.setup({ sources = sources })
