return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps")
    keys[#keys + 1] = { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to definition" }
    keys[#keys + 1] = { "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Declaration" }
    keys[#keys + 1] = { "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Implementation" }
    keys[#keys + 1] = { "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "References" }
    keys[#keys + 1] = { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover" }
    keys[#keys + 1] =
      { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", mode = { "n", "v" }, desc = "Code action" }
    keys[#keys + 1] = { "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename Symbol" }
  end,
  -- opts = {
  --   servers = {
  --     pyright = {
  --       enabled = false,
  --     },
  --     pylsp = {
  --       plugins = {
  --         pyflakes = {
  --           enabled = false,
  --         },
  --         mccabe = {
  --           enabled = false,
  --         },
  --         rope = {
  --           enabled = true,
  --         },
  --         ruff = {
  --           enabled = true,
  --           executable = "ruff",
  --           formatEnabled = true,
  --           format = { "I" },
  --           unsafeFixes = false,
  --           lineLength = 120,
  --           targetVersion = "py311",
  --         },
  --         pycodestyle = {
  --           enabled = false,
  --         },
  --       },
  --     },
  --   },
  -- },
  config = function()
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities =
      vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "zk",
        "ruff",
        "pylsp",
        -- "pylyzer",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["pylsp"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.pylsp.setup({
            capabilities = capabilities,
            settings = {
              pylsp = {
                plugins = {
                  mccabe = {
                    enabled = false,
                  },
                  pyflakes = {
                    enabled = false,
                  },
                  pycodestyle = {
                    enabled = false,
                  },
                  rope = {
                    enabled = true,
                  },
                  -- ruff = {
                  --   enabled = true,
                  --   executable = "ruff",
                  --   formatEnabled = true,
                  --   format = { "I" },
                  --   unsafeFixes = false,
                  --   lineLength = 120,
                  --   targetVersion = "py311",
                  -- },
                },
              },
            },
          })
        end,
        -- ["pylyzer"] = function()
        --   local lspconfig = require("lspconfig")
        --
        --   lspconfig.pylyzer.setup({
        --     name = "pylyzer",
        --     cmd = { "pylyzer", "--server" },
        --     filetypes = { "python" },
        --     root_dir = function()
        --       return vim.env.ATT
        --     end,
        --   })
        -- end,
      },
    })
  end,
}
