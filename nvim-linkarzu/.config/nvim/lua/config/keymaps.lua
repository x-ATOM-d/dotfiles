-- Globalne skróty klawiszowe (leader = spacja)
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Zapis / wyjście
map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>q", "<cmd>q<cr>", opts)
map("n", "<leader>Q", "<cmd>qa!<cr>", opts)

-- Nawigacja między oknami
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Zmiana rozmiaru okien
map("n", "<C-Up>", "<cmd>resize +2<cr>", opts)
map("n", "<C-Down>", "<cmd>resize -2<cr>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", opts)

-- Przełączanie buforów
map("n", "<S-l>", "<cmd>bnext<cr>", opts)
map("n", "<S-h>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>bd", "<cmd>bdelete<cr>", opts)

-- Lepsze indentowanie w trybie wizualnym
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Przenoszenie zaznaczonych linii
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Neo-tree (eksplorator plików)
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", opts)

-- Telescope (szukanie plików/tekstu)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

-- Przeglądanie plików konfiguracyjnych Neovima (~/.config/nvim)
map("n", "<leader>fc", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, opts)

-- Diagnostyka LSP
map("n", "<leader>cd", vim.diagnostic.open_float, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)

-- Lazy (menadżer pluginów) - lista/aktualizacja/status pluginów
map("n", "<leader>L", "<cmd>Lazy<cr>", opts)

-- Terminal - Esc wychodzi z trybu terminala do trybu normalnego
-- (samo otwieranie terminala obsługuje teraz toggleterm.nvim, patrz plugins/terminal.lua)
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Usuwanie zaznaczenia po yank w trybie paste
map("x", "<leader>p", '"_dP', opts)
