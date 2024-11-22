return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  config = function(_, opts)
    local ss = require("smart-splits")
    ss.setup({})
  end,
}
