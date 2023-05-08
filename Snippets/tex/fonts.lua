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
  --fonts 
  -- TypeWriter
  s({trig = "ttt", snippetType = "autosnippet"},
    fmta(
      "\\texttt{<>}",
      { d(1, get_visual), }
    ),
    {condition = tex_utils.in_text}  
  ),
  -- Italic
  s({trig = "tii", snippetType = "autosnippet"},
    fmta(
      "\\textit{<>}",
      { d(1, get_visual), }
    ),
    {condition = tex_utils.in_text}  
  ),
  -- Bold 
  s({trig = "tbt", snippetType = "autosnippet"},
    fmta(
      "\\textbf{<>}",
      { d(1, get_visual), }
    ),
    {condition = tex_utils.in_text}  
  ),
  -- Roman Math
  s({trig = "rmm", snippetType = "autosnippet"},
    fmta(
      "\\mathrm{<>}",
      { d(1, get_visual), }
    ),
    {condition = tex_utils.in_mathzone}  
  ),
  -- Math Calig
  s({trig = "mcc", snippetType = "autosnippet"},
    fmta(
      "\\mathcal{<>}",
      { d(1, get_visual), }
    ),
    {condition = tex_utils.in_mathzone}  
  ),
  -- Math BoldFace
  s({trig = "mbf", snippetType = "autosnippet"},
    fmta(
      "\\mathbf{<>}",
      { d(1, get_visual), }
    ),
    {condition = tex_utils.in_mathzone}  
  ),
  -- Math BlackBoard
  s({trig = "mbb", snippetType = "autosnippet"},
    fmta(
      "\\mathbb{<>}",
      { d(1, get_visual), }
    ),
    {condition = tex_utils.in_mathzone}  
  ),
  -- Regular Text in math mode
  s({trig = "tee", snippetType = "autosnippet"},
    fmta(
      "\\text{<>}",
      { d(1, get_visual), }
    ),
    {condition = tex_utils.in_mathzone}  
  ),
}
