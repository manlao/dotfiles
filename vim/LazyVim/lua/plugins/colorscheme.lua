return {
  -- add onedarkpro
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },

  -- Configure LazyVim to load onedarkpro
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  }
}
