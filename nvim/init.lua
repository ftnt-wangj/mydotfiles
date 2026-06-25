vim.env.GOPATH = vim.fn.expand("$HOME/go")
vim.env.GOBIN = vim.fn.expand("$HOME/go/bin")
vim.env.GOROOT = nil

require("config.options")
require("config.keymaps")
require("config.lazy")

vim.opt.number = true
vim.opt.relativenumber = false
