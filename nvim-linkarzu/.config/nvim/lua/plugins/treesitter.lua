return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "html", "css", "scss", "javascript", "typescript", "tsx",
        "vue", "svelte", "json", "jsonc", "yaml", "markdown",
        "markdown_inline", "graphql", "prisma", "lua", "bash",
        "dockerfile", "gitignore", "regex",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Automatyczne zamykanie/zmiana tagów HTML/JSX
  -- (nowe wersje wymagają samodzielnego setup(), rejestrowanie przez
  -- nvim-treesitter.configs jako "autotag = {enable=true}" jest deprecated)
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
