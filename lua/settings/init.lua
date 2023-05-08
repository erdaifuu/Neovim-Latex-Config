local opt = vim.opt

vim.notify = require("notify")

opt.wrap = true
opt.linebreak = true

opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.shiftwidth = 2
opt.tabstop = 2

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.splitbelow = true
opt.splitright = true
opt.wrap = false
opt.scrolloff = 5
opt.fileencoding = 'utf-8'
opt.termguicolors = true

opt.backspace= "indent,eol,start"
opt.clipboard:append("unnamedplus")
opt.iskeyword:append("-")

opt.relativenumber = true
opt.cursorline = true
opt.number = true

opt.hidden = true

-- to change from plaintex to latex
vim.g.tex_flavor = "latex"
opt.conceallevel = 2
