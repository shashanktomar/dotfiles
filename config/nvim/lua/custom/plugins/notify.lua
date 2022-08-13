local notify = require("notify")

local options = {
	stages = "fade_in_slide_out",
	timeout = 2000,
}

notify.setup(options)
vim.notify = notify
