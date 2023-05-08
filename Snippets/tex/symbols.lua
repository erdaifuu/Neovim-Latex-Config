local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else  -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local tex_utils = {}
tex_utils.in_mathzone = function()  -- math context detection
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex_utils.in_text = function()
  return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function()  -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end
tex_utils.in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex_utils.in_equation = function()  -- equation environment detection
    return tex_utils.in_env('equation')
end
tex_utils.in_itemize = function()  -- itemize environment detection
    return tex_utils.in_env('itemize')
end
tex_utils.in_tikz = function()  -- TikZ picture environment detection
    return tex_utils.in_env('tikzpicture')
end

return {
  -- Basic Symbols That are commonly used
  s({trig = ";a", snippetType = "autosnippet"}, { t("\\alpha"), } ),
  s({trig = ";b", snippetType = "autosnippet"}, { t("\\beta"), } ),
  s({trig = ";g", snippetType = "autosnippet"}, { t("\\gamma"), } ), 
  s({trig = ";G", snippetType = "autosnippet"}, { t("\\Gamma"), } ), 
  s({trig = ";d", snippetType = "autosnippet"}, { t("\\delta"), } ), 
  s({trig = ";D", snippetType = "autosnippet"}, { t("\\Delta"), } ),
  s({trig = ";e", snippetType = "autosnippet"}, { t("\\epsilon"), } ), 
  s({trig = ";ve", snippetType = "autosnippet"}, { t("\\varepsilon"), } ),
  s({trig = ";z", snippetType = "autosnippet"}, { t("\\zeta"), } ),
  s({trig = ";h", snippetType = "autosnippet"}, { t("\\eta"), } ), 
  s({trig = ";o", snippetType = "autosnippet"}, { t("\\theta"), } ),
  s({trig = ";vo", snippetType = "autosnippet"}, { t("\\vartheta"), } ),
  s({trig = ";O", snippetType = "autosnippet"}, { t("\\Theta"), } ),
  s({trig = ";k", snippetType = "autosnippet"}, { t("\\kappa"), } ), 
  s({trig = ";l", snippetType = "autosnippet"}, { t("\\lambda"), } ),
  s({trig = ";L", snippetType = "autosnippet"}, { t("\\Lambda"), } ),
  s({trig = ";m", snippetType = "autosnippet"}, { t("\\mu"), } ),
  s({trig = ";n", snippetType = "autosnippet"}, { t("\\nu"), } ),
  s({trig = ";x", snippetType = "autosnippet"}, { t("\\xi"), } ), 
  s({trig = ";i", snippetType = "autosnippet"}, { t("\\pi"), } ),
  s({trig = ";I", snippetType = "autosnippet"}, { t("\\Pi"), } ), 
  s({trig = ";r", snippetType = "autosnippet"}, { t("\\rho"), } ), 
  s({trig = ";s", snippetType = "autosnippet"}, { t("\\sigma"), } ), 
  s({trig = ";S", snippetType = "autosnippet"}, { t("\\Sigma"), } ), 
  s({trig = ";t", snippetType = "autosnippet"}, { t("\\tau"), } ), 
  s({trig = ";f", snippetType = "autosnippet"}, { t("\\phi"), } ), 
  s({trig = ";vf", snippetType = "autosnippet"}, { t("\\varphi"), } ), 
  s({trig = ";F", snippetType = "autosnippet"}, { t("\\Phi"), } ), 
  s({trig = ";c", snippetType = "autosnippet"}, { t("\\chi"), } ), 
  s({trig = ";p", snippetType = "autosnippet"}, { t("\\psi"), } ), 
  s({trig = ";P", snippetType = "autosnippet"}, { t("\\Psi"), } ), 
  s({trig = ";w", snippetType = "autosnippet"}, { t("\\omega"), } ), 
  s({trig = ";W", snippetType = "autosnippet"}, { t("\\Omega"), } ), 
}
