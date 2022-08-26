local g = vim.g

g.webdevicons_enable_startify = 1
g.startify_change_to_vcs_root = 1
g.startify_enable_special = 0
g.startify_fortune_use_unicode = 1

g.startify_bookmarks = {
	{ pd = "~/.dotfiles" },
	{ ph = "~/Documents/personal/vim-myhelp" },
	{ pn = "~/.config/nvim" },
	{ po = "~/Documents/projects/data-migration-monorepo" },
}

g.startify_commands = {
  { rs = ":PackerSync" },
  { rc = ":PackerCompile" }
}

g.startify_lists = {
	{
		type = "bookmarks",
		header = { "   Bookmarks" },
	},
	{
		type = "commands",
		header = { "   Commands" },
	},
	{
		type = "dir",
		header = { "   Current Directory " .. vim.fn.getcwd() .. ":" },
	},
}
