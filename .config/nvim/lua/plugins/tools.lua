return {
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
    },
  },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require("grug-far").setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
        -- be specified
      })
    end,
  },
}
