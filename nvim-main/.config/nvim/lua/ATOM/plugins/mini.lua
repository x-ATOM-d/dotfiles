return {
    -- Mini Nvim
    { "echasnovski/mini.nvim", version = false },
    -- Comments
    {
        'echasnovski/mini.comment',
        version = false,
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            -- diable the autocommand from ts-context-commentstring
            require('ts_context_commentstring').setup {
                enable_autocmd = false,
            }
            require("mini.comment").setup {
                -- tsx, jsx, html, svelte comment support
                options = {
                    custom_commentstring = function()
                        return require('ts_context_commentstring.internal').calculate_commentstring({ key =
                            'commentstring' })
                            or vim.bo.commentstring
                    end,
                },
            }
        end

    },

    -- File explorer (this works properly with oil unlike nvim-tree)
    {
        'echasnovski/mini.files',
        config = function()
            local MiniFiles = require("mini.files")
            MiniFiles.setup({
                mappings = {
                    go_in = "<CR>", -- Map both Enter and L to enter directories or open files
                    go_in_plus = "L",
                    go_out = "-",
                    go_out_plus = "H",
                },
            })
            vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini files explorer" }) -- toggle file explorer
            vim.keymap.set("n", "<leader>ef", function()
                MiniFiles.open(vim.api.nvim_buf_get_home(0), false)
                MiniFiles.reveal_cwd()
            end, { desc = "Toggle into currently opened file" })
        end
    },
    {
        'echasnovski/mini.surround',
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            -- Add custom surroundings to be used on top of builtin ones. For more
            -- information with examples, see `:h MiniSurround.config`.
            custom_surroundings = nil,

            -- Duration (in ms) of highlight when calling `MiniSurround.highligh()`
            highlight_duration = 300,

            -- Module mappings. Use `''` (empty string) to disable one.
            -- INFO
            -- saw surround with no whitespace
            -- saw surround with whitespace
            mappings = {
                add = 'sa',              -- Add surrounding in Normal and Visual modes
                delete = 'ds',           -- Delete surrounding 
                find = 'sf',             -- Find surrounding (to the right)
                find_left = 'sF',        -- Find surrounding (to the left)
                highlight = 'sh',        -- Highlight surrounding 
                replace = 'sr',          -- Replace surrounding
                update_n_lines = 'sn',   -- Update `n_lines`

                suffix_last = 'l',       -- Suffix to search with "prev" method
                suffix_next = 'n',       -- Suffix to search with "next" method
            }
        }
    }
}
