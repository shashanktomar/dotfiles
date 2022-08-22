local ok, illuminate = pcall(require, "illuminate")

if not ok then
	return
end

illuminate.configure({
	delay = 200,
	under_cursor = false,
	filetypes_denylist = {
		"NvimTree",
		"packer",
	},
})
