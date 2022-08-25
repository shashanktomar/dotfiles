local ok, illuminate = pcall(require, "illuminate")

if not ok then
	return
end

illuminate.configure({
	delay = 200,
	under_cursor = false,
   -- filetype of a current buffer can be found by running `:set ft?`
	filetypes_denylist = {
		"NvimTree",
		"packer",
    "Outline", -- filetype for symbol outlines
    "help",
    "lspsagafinder"
	},
})
