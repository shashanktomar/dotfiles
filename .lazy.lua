local autocmd = vim.api.nvim_create_autocmd
local patterns = {
	["*.toml.tmpl"] = "toml",
	["*.sh.tmpl"] = "bash",
	["bin/**"] = "bash",
	["*.zsh.tmpl"] = "zsh",
	["dot_inputrc"] = "readline",
	["dot_zshrc"] = "zsh",
	["dot_zprofile*"] = "zsh",
	["dot_tmux.conf"] = "tmux",
	["*gitconfig*"] = "gitconfig",
}

for pattern, filetype in pairs(patterns) do
	autocmd({ "BufRead", "BufNewFile" }, { pattern = pattern, command = "set filetype=" .. filetype })
end

return {}
