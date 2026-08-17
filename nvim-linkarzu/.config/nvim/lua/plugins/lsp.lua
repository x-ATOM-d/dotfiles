return {
  -- Mason: menadżer LSP servers / linters / formatters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { border = "rounded" },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "ts_ls",        -- TypeScript / JavaScript
        "html",         -- HTML
        "cssls",        -- CSS/SCSS
        "tailwindcss",  -- Tailwind CSS
        "jsonls",       -- JSON
        "emmet_ls",     -- Emmet (szybkie pisanie HTML/JSX)
        "eslint",       -- ESLint
        "vue_ls",       -- Vue 3 (dawniej "volar" - nazwa zmieniona w nvim-lspconfig/mason)
        "svelte",       -- Svelte
        "graphql",      -- GraphQL
        "lua_ls",       -- Lua (do konfigu Neovima)
        "prismals",     -- Prisma
      },
      automatic_installation = true,
      -- Serwery odpalamy sami niżej (vim.lsp.enable / lspconfig.setup),
      -- więc wyłączamy automatyczne włączanie przez mason-lspconfig, żeby się nie dublowało.
      automatic_enable = false,
    },
  },

  -- Automatyczna instalacja formatterów/linterów (binarki, nie LSP)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "prettier",
        "eslint_d",
        "stylua",
        "js-debug-adapter",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} }, -- lepsze podpowiedzi dla configu Lua/Neovim
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Wspólny on_attach: skróty klawiszowe aktywne tylko gdy LSP działa w buforze
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "Idź do definicji")
        map("n", "gD", vim.lsp.buf.declaration, "Idź do deklaracji")
        map("n", "gr", vim.lsp.buf.references, "Znajdź referencje")
        map("n", "gi", vim.lsp.buf.implementation, "Idź do implementacji")
        map("n", "K", vim.lsp.buf.hover, "Dokumentacja (hover)")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Zmień nazwę (rename)")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Formatuj plik")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Sygnatura funkcji")
      end

      -- Konfiguracje poszczególnych serwerów (bez capabilities/on_attach - dokładane niżej)
      local servers = {
        html = {},
        cssls = {},
        jsonls = {},
        emmet_ls = {},
        eslint = {},
        svelte = {},
        graphql = {},
        prismals = {},

        -- TypeScript / JavaScript
        ts_ls = {
          settings = {
            javascript = { inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionLikeReturnTypeHints = true,
            } },
            typescript = { inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionLikeReturnTypeHints = true,
            } },
          },
        },

        -- Tailwind CSS (działa też wewnątrz className w JSX/TSX)
        tailwindcss = {
          filetypes = {
            "html", "css", "scss", "javascript", "javascriptreact",
            "typescript", "typescriptreact", "vue", "svelte",
          },
        },

        -- Vue 3 (serwer nazywa się teraz "vue_ls", nie "volar")
        vue_ls = {},

        -- Lua (pod sam config Neovima)
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      }

      if vim.lsp.config then
        -- Neovim >= 0.11: nowe, natywne API (require('lspconfig')[x].setup() jest deprecated)
        vim.lsp.config("*", {
          capabilities = capabilities,
          on_attach = on_attach,
        })
        for name, cfg in pairs(servers) do
          vim.lsp.config(name, cfg)
          vim.lsp.enable(name)
        end
      else
        -- Starsze Neovim (< 0.11): stare API lspconfig, jako fallback
        local lspconfig = require("lspconfig")
        for name, cfg in pairs(servers) do
          cfg.capabilities = capabilities
          cfg.on_attach = on_attach
          lspconfig[name].setup(cfg)
        end
      end

      -- Ładniejsze ikonki w kolumnie diagnostyki
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        severity_sort = true,
        float = { border = "rounded" },
      })
    end,
  },
}
