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
  init = function()
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
  opts = {
    servers = {
      pyright = {
        enabled = false,
      },
      ruff = {
        enabled = true,
      },
      ruff_lsp = {
        enabled = false,
      },
      pylance = {},
      gopls = {},
      rust_analyzer = {},
    },
    setup = {
      pylance = function(_, opts)
        local cmp_lsp = require("cmp_nvim_lsp")
        opts.capabilities =
          vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
      end,
      ruff = function(_, opts)
        local cmp_lsp = require("cmp_nvim_lsp")
        opts.capabilities =
          vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
        opts.cmd = { "/home/ohasanli/.pyenv/shims/ruff", "server", "--preview" } -- Add the --preview option
        opts.on_attach = function(client, bufnr)
          if client.name == "ruff" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = true })
              end,
            })
          end
        end
      end,
      lua_ls = function(_, opts)
        local cmp_lsp = require("cmp_nvim_lsp")
        opts.capabilities =
          vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
        opts.settings = {
          Lua = {
            runtime = { version = "Lua 5.1" },
            diagnostics = {
              globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
            },
          },
        }
      end,
    },
  },
  config = function(_, opts)
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    require("fidget").setup({})
    -- require("mason").setup()
    -- require("mason-lspconfig").setup({
    --   ensure_installed = {
    --     "lua_ls",
    --     "rust_analyzer",
    --     "gopls",
    --     "ruff",
    --   },
    -- })

    local lspconfig = require("lspconfig")
    for server, server_opts in pairs(opts.servers) do
      if server_opts.enabled ~= false then
        local final_opts = vim.tbl_deep_extend("force", {}, server_opts)
        if opts.setup[server] then
          opts.setup[server](nil, final_opts)
        end
        lspconfig[server].setup(final_opts)
      end
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
      }),
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
