local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local code_actions = null_ls.builtins.code_actions
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
-- local hover = null_ls.builtins.hover
-- local completion = null_ls.builtins.completion

local sources = {
	code_actions.eslint_d,
	-- code_actions.prettierd,
	code_actions.gitsigns,
	code_actions.shellcheck,

	formatting.eslint_d,
	-- formatting.perttierd,
	formatting.stylua,

	-- diagnostics.eslint_d,
	diagnostics.shellcheck,
}

null_ls.setup({ sources = sources })
