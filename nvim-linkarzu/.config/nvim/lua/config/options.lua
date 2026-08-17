-- Podstawowe, sensowne ustawienia edytora
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Wcięcia (2 spacje - standard w web dev)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true

-- Wyszukiwanie
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Podział okien
opt.splitright = true
opt.splitbelow = true

-- Schowek systemowy
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Undo/backup
opt.undofile = true
opt.backup = false
opt.swapfile = false
opt.updatetime = 200
opt.timeoutlen = 400

-- UI
opt.showmode = false
opt.pumheight = 12
opt.conceallevel = 0
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Format plików
vim.opt.fileencoding = "utf-8"

-- Foldy oparte o treesitter (przydatne w dużych plikach JSX/TSX)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99
