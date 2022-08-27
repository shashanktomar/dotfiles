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
	"eslint-lsp",
	"eslint_d",
	"prettierd",
	"typescript-language-server",

	-- yaml
	"yaml-language-server",
	"yamlfmt",
	"yamllint",

	--other
	"codespell",
	"dockerfile-language-server",
	"jq",
	"json-lsp",
	"markdownlint",
	"marksman",
	"vale",
}

return M
