local augroups = {
  {
    "TextYankPost",
    function()
      vim.highlight.on_yank({
        higroup = "IncSearch",
        timeout = 40,
      })
    end,
    description = "Highlight yanked text",
  },
}

return {
  "mrjones2014/legendary.nvim",
  version = "v2.13.9",
  -- since legendary.nvim handles all your keymaps/commands,
  -- its recommended to load legendary.nvim before other plugins
  priority = 10000,
  lazy = false,
  config = function()
    require("legendary").setup({
      keymaps = {
        -- Map keys to a function
        {
          "<leader>vwm",
          function()
            require("vim-with-me").StartVimWithMe()
          end,
          description = "Start Vim With Me",
        },
        {
          "<leader>svwm",
          function()
            require("vim-with-me").StopVimWithMe()
          end,
          description = "Stop Vim With Me",
        },
        -- Greatest remap ever
        { "<leader>p", [["_dP]], mode = "x", description = "Paste without yanking" },
        -- Next greatest remap ever
        { "<leader>y", [["+y]], mode = { "n", "v" }, description = "Yank to clipboard" },
        { "<leader>Y", [["+Y]], mode = "n", description = "Yank line to clipboard" },
        -- Delete without yanking
        { "<leader>d", [["_d]], mode = { "n", "v" }, description = "Delete without yanking" },
        -- Map Ctrl-C to Escape in insert mode
        { "<C-c>", "<Esc>", mode = "i", description = "Map Ctrl-C to Escape" },
        -- Disable Q
        { "Q", "<nop>", mode = "n", description = "Disable Q" },
        -- Open a new tmux window
        { "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", mode = "n", description = "Open a new tmux window" },
        -- Navigate quickfix list
        { "<C-k>", "<cmd>cnext<CR>zz", mode = "n", description = "Next quickfix item" },
        { "<C-j>", "<cmd>cprev<CR>zz", mode = "n", description = "Previous quickfix item" },
        { "<leader>k", "<cmd>lnext<CR>zz", mode = "n", description = "Next location list item" },
        { "<leader>j", "<cmd>lprev<CR>zz", mode = "n", description = "Previous location list item" },
        -- Substitute word under cursor
        {
          "<leader>s",
          [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
          mode = "n",
          description = "Substitute word under cursor",
        },
        -- Make file executable
        {
          "<leader>x",
          "<cmd>!chmod +x %<CR>",
          mode = "n",
          opts = { silent = true },
          description = "Make file executable",
        },
        -- Insert error handling
        {
          "<leader>ee",
          "oif err != nil {<CR>}<Esc>Oreturn err<Esc>",
          mode = "n",
          description = "Insert error handling",
        },
        -- Source current file
        {
          "<leader><leader>",
          function()
            vim.cmd("so")
          end,
          mode = "n",
          description = "Source current file",
        },
      },
      autocmds = augroups,
      require("dressing").setup({
        select = {
          get_config = function(opts)
            if opts.kind == "legendary.nvim" then
              return {
                telescope = {
                  sorter = require("telescope.sorters").fuzzy_with_index_bias({}),
                },
              }
            else
              return {}
            end
          end,
        },
      }),
      extensions = {
        -- lazy_nvim = true,
        smart_splits = {
          directions = { "h", "j", "k", "l" },
          mods = {
            -- for moving cursor between windows
            move = "<C>",
            -- for resizing windows
            resize = "<A>",
            -- for swapping window buffers
            swap = false, -- false disables creating a binding
          },
        },
      },
    })
  end,
}
