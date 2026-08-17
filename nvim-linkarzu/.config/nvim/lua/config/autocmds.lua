-- Drobne automatyzacje
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Podświetlenie skopiowanego tekstu
autocmd("TextYankPost", {
  group = augroup("HighlightYank", { clear = true }),
  callback = function()
    -- vim.highlight jest deprecated (usunięte w Nvim 2.0) - używamy vim.hl
    local hl = vim.hl or vim.highlight
    hl.on_yank({ timeout = 200 })
  end,
})

-- Usuwanie białych znaków na końcu linii przy zapisie
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Przywracanie pozycji kursora przy otwarciu pliku
autocmd("BufReadPost", {
  group = augroup("RestoreCursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Automatyczne zamykanie okna quickfix klawiszem q
autocmd("FileType", {
  pattern = { "qf", "help", "lspinfo", "checkhealth" },
  group = augroup("CloseWithQ", { clear = true }),
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
