return {
  -- Motyw kolorystyczny
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        telescope = true,
        treesitter = true,
        which_key = true,
        indent_blankline = { enabled = true },
        native_lsp = { enabled = true },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Ikony plików
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Pasek statusu
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        -- "auto" dopasowuje kolory do aktywnego colorscheme (catppuccin) -
        -- bezpieczniejsze niż wpisywanie nazwy motywu na sztywno (zależność od kolejności ładowania pluginów)
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
      },
    },
  },

  -- Górny pasek zakładek (bufferline)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        offsets = {
          { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left" },
        },
      },
    },
  },

  -- Linie wcięć
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  -- Podświetlanie kolorów HEX/RGB/Tailwind
  -- (catgoose/nvim-colorizer.lua = aktywnie utrzymywany fork norcalli/nvim-colorizer.lua,
  -- naprawia deprecation "vim.tbl_flatten" i dodaje natywne wsparcie klas Tailwind)
  {
    "catgoose/nvim-colorizer.lua",
    name = "colorizer-catgoose", -- unikalna nazwa: norcalli i catgoose mają ten sam nazwę repo,
                                  -- bez tego lazy.nvim mylił oba pluginy i nie podmieniał folderu
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = {
        "css", "scss", "html", "javascript", "javascriptreact",
        "typescript", "typescriptreact", "vue", "svelte", "json",
      },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        names = false, -- nie podświetlaj nazw typu "red", "blue" - za duży szum
        css = true,
        tailwind = true, -- podświetla kolory klas Tailwind, np. bg-red-500
      },
    },
  },

  -- Which-key: podpowiedzi skrótów
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Szybkie komentowanie (gcc, gc w visual)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- Wskaźnik wcięcia zakresu (nawiasy, taga JSX)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
}
