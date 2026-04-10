return {
  -- add onedarkpro
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },

  -- Configure LazyVim to load onedarkpro with auto dark/light switching
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- vim.schedule ensures vim.o.background is set by Neovim's OSC 11 detection
        vim.schedule(function()
          if vim.o.background == "light" then
            vim.cmd("colorscheme onelight")
          else
            vim.cmd("colorscheme onedark")
          end
        end)
      end,
    },
  },
}
