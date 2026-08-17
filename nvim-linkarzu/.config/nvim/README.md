# Neovim config — Web Development

Gotowy config pod React / Vue / Next / TypeScript / JavaScript / HTML / CSS / Tailwind.

## Wymagania (muszą być zainstalowane w systemie)

- **Neovim ≥ 0.9** (najlepiej najnowszy stabilny)
- **git**
- **Node.js + npm** (potrzebne dla serwerów LSP: ts_ls, tailwindcss, eslint, prettier itd.)
- **ripgrep** (`rg`) — do wyszukiwania w Telescope
- **make** i kompilator C (gcc/clang) — do zbudowania `telescope-fzf-native`
- Font typu **Nerd Font** ustawiony w terminalu (ikonki w UI, np. `JetBrainsMono Nerd Font`)

## Instalacja

1. Zrób kopię zapasową obecnego configu (jeśli masz):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   mv ~/.local/state/nvim ~/.local/state/nvim.bak
   mv ~/.cache/nvim ~/.cache/nvim.bak
   ```

2. Wypakuj zawartość paczki bezpośrednio do `~/.config/nvim`:
   ```bash
   unzip nvim-web-dev-config.zip -d ~/.config/nvim
   ```
   (Upewnij się, że plik `init.lua` leży bezpośrednio w `~/.config/nvim/init.lua`, a nie w podfolderze).

3. Uruchom Neovima:
   ```bash
   nvim
   ```
   Przy pierwszym starcie `lazy.nvim` **automatycznie** ściągnie wszystkie pluginy.
   Poczekaj, aż okno instalacji się zamknie / napisze "done".

4. Zainstaluj serwery LSP i narzędzia (jednorazowo):
   ```
   :Mason
   ```
   Serwery i narzędzia z listy `ensure_installed` (ts_ls, html, cssls, tailwindcss, jsonls,
   emmet_ls, eslint, vue_ls, svelte, graphql, prismals, prettier, eslint_d, stylua)
   zainstalują się same — obserwuj pasek postępu. Jeśli coś nie zainstaluje się
   automatycznie, zaznacz je w oknie Mason i naciśnij `i`.

5. Sprawdź, czy wszystko działa:
   ```
   :checkhealth
   ```

## Najważniejsze skróty (leader = spacja)

| Skrót | Akcja |
|---|---|
| `<space>e` | Toggle eksploratora plików (Neo-tree) |
| `<space>ff` | Szukaj plików (Telescope) |
| `<space>fg` | Szukaj tekstu w projekcie (live grep) |
| `<space>fb` | Lista otwartych buforów |
| `gd` | Idź do definicji |
| `gr` | Znajdź referencje |
| `K` | Dokumentacja pod kursorem (hover) |
| `<space>rn` | Zmień nazwę zmiennej/funkcji (rename) |
| `<space>ca` | Code action (np. auto-import) |
| `<space>cf` | Formatuj plik (Prettier) |
| `[d` / `]d` | Poprzedni / następny błąd |
| `<space>t` | Otwórz terminal na dole |
| `<F5>` | Start debuggera (Node/Chrome) |
| `<space>db` | Ustaw breakpoint |
| `<space>L` | Otwórz Lazy (lista/status/aktualizacja pluginów) |
| `<space>fc` | Szukaj plików w configu Neovima (~/.config/nvim) |
| `Ctrl+\` | Przełącz pływający terminal (z dowolnego miejsca, też w insert mode) |
| `<space>tt` | Terminal pływający |
| `<space>th` | Terminal - poziomy split |
| `<space>tv` | Terminal - pionowy split |

## Co jest w środku

- **lazy.nvim** — menadżer pluginów
- **mason.nvim** — automatyczna instalacja LSP/linterów/formatterów
- **nvim-lspconfig** — LSP: TypeScript, HTML, CSS, Tailwind, JSON, Emmet, ESLint, Vue (vue_ls), Svelte, GraphQL, Prisma, Lua
- **nvim-cmp + LuaSnip** — autouzupełnianie + gotowe snippety (friendly-snippets)
- **conform.nvim** — formatowanie Prettier przy zapisie
- **nvim-lint** — linting ESLint na żywo
- **nvim-treesitter + nvim-ts-autotag** — podświetlanie składni i auto-zamykanie tagów JSX/HTML
- **telescope.nvim** — fuzzy finder plików/tekstu
- **neo-tree.nvim** — eksplorator plików z ikonami i statusem git
- **gitsigns.nvim** — zmiany git na marginesie
- **catppuccin + lualine + bufferline + indent-blankline** — wygląd
- **nvim-dap + dap-vscode-js** — debugger dla Node.js i Chrome
- **toggleterm.nvim** — pływający/split terminal, przełączany z dowolnego miejsca (`Ctrl+\`)

## Aktualizacja pluginów

```
:Lazy sync
```

## Coś nie działa?

- `:checkhealth` — pokaże braki (np. brakujący `rg`, Node.js, kompilator).
- `:Mason` — sprawdź, czy serwery LSP się zainstalowały (kolumna po prawej: ✓ zainstalowany).
- `:LspInfo` — pokaże, jaki LSP jest aktywny w bieżącym pliku.
