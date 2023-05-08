require("nvim-autopairs").setup({
    ignored_next_char = [=[[%w%%%'%[%"%.%`]]=]
  })
  require("nvim-autopairs").get_rule("'")[1].not_filetypes = { "tex" }