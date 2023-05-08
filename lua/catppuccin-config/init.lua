require("catppuccin").setup({
  flavour = "frappe", -- latte, frappe, macchiato, mocha
  transparent_background = true,
  integrations = {
      nvimtree = true,
      telescope = true,
      notify = true,
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"