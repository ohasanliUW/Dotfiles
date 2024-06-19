return {
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    -- opts = function()
    --
    --   local cmp_select = { behavior = cmp.SelectBehavior.Select }
    --   return {
    --     mapping = cmp.mapping.preset.insert({
    --       ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    --       ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    --       ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    --       ["<C-Space>"] = cmp.mapping.complete(),
    --     }),
    --   }
    -- end,
    config = function()
      local cmp = require("cmp")

      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },
}
