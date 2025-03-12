return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
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
        local cmp = require("blink.cmp")
        opts.capabilities =
          vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp.get_lsp_capabilities())
      end,
      ruff = function(_, opts)
        local cmp = require("blink.cmp")
        opts.capabilities =
          vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp.get_lsp_capabilities())
        opts.cmd = { "/home/ohasanli/.pyenv/shims/ruff", "server", "--preview" }
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
        local cmp = require("blink.cmp")
        opts.capabilities =
          vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp.get_lsp_capabilities())
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
    require("fidget").setup({})

    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    -- Try to load pylance config
    local ok, pylance_config = pcall(require, "lspconfig.server_configurations.pylance")

    -- Register pylance if needed
    if not configs.pylance and ok then
      configs.pylance = pylance_config
    end

    -- Debug: Print servers that will be set up

    for server, server_opts in pairs(opts.servers) do
      if server_opts.enabled ~= false then
        local final_opts = vim.tbl_deep_extend("force", {}, server_opts)
        if opts.setup[server] then
          opts.setup[server](nil, final_opts)
        end

        -- Check if server config exists
        if lspconfig[server] then
          lspconfig[server].setup(final_opts)
        end
      end
    end

    vim.diagnostic.config({
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
