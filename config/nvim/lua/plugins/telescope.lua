return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        }
    },
    keys = function()
        return {
            { "<leader>pf", "<cmd>Telescope find_files<cr>", mode = "n", desc = "Find Files" },
            { "<C-p>", "<cmd>Telescope git_files<cr>", mode = "n", desc = "Git Files" },
            { "<leader>pws", function()
                local word = vim.fn.expand("<cword>")
                require("telescope.builtin").grep_string({ search = word })
            end, mode = "n", desc = "Grep Word under Cursor" },
            { "<leader>pWs", function()
                local word = vim.fn.expand("<cWORD>")
                require("telescope.builtin").grep_string({ search = word })
            end, mode = "n", desc = "Grep WORD under Cursor" },
            { "<leader>ps", function()
                require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
            end, mode = "n", desc = "Grep String" },
            { "<leader>vh", "<cmd>Telescope help_tags<cr>", mode = "n", desc = "Help Tags" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", mode = "n", desc = "Live Grep" },
        }
    end,
    config = function()
        local telescope = require('telescope')
        telescope.setup({})

        -- Enable telescope fzf native
        telescope.load_extension('fzf')
    end,
} 