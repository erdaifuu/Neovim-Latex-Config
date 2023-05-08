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
  -- subscript
  s({trig = "([%a%)%]%}]);", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex_utils.in_mathzone }
  ),
  -- superscript
  s({trig = "([%a%)%]%}]):", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex_utils.in_mathzone }
  ),
  -- super and subscript
  s({trig = "([%w%)%]%}])__", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>^{<>}_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    {condition = tex_utils.in_mathzone}
  ),
  -- euler
  s({trig = '([^a-z])ee', regTrig = true, wordTrig = false, snippetType = "autosnippet"},
    fmta(
      "<>e^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual)
      }
    ),
    {condition = tex_utils.in_mathzone} 
  ),
  --fraction 
  s({trig = "ff", snippetType = "autosnippet"},
    fmta(
      "\\frac{<>}{<>}",
      {
        i(1),
        i(2),
      }
    ),
    {condition = tex_utils.in_mathzone}  
  ),
  --dfraction
  s({trig = "df", snippetType = "autosnippet"},
    fmta(
      "\\dfrac{<>}{<>}",
      {
        i(1),
        i(2),
      }
    ),
    {condition = tex_utils.in_mathzone}  
  ),
  --limit
  s({trig = "lim", snippetType = "autosnippet"}, 
    fmta(
      "\\lim{<>}", 
      {
        i(1), 
      }
    ),
    {condition = tex_utils.in_mathzone}
  ),
  --sqrt
  s({trig = "sq", snippetType = "autosnippet"},
    fmta(
      "\\sqrt{<>}",
      {
        i(1), 
      }
    ),
    {condition = tex_utils.in_mathzone}
  ),
}