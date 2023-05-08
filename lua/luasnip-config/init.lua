ls = require("luasnip")

ls.config.set_config({
  history = true,
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
  region_check_events = "CursorMoved",
})

require("luasnip.loaders.from_lua").load({paths = {"~/.config/nvim/Snippets/", "~/Documents/UniNotes/Snippets/"}})
vim.cmd([[silent command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()]])

M = {}
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap("i", "<C-F>", "<Plug>luasnip-next-choice", {})
keymap("s", "<C-f>", "<Plug>luasnip-next-choice", {})
keymap("i", "<C-d>", "<Plug>luasnip-prev-choice", {})
keymap("s", "<C-d>", "<Plug>luasnip-prev-choice", {})

return M