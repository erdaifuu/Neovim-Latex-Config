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
  -- Word bar 
  s({trig = "(%w+)bar", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    f(function(args, snip) return
		  "\\overline{" .. snip.captures[1] .. "}" end, {}),
    { condition = tex_utils.in_mathzone }
  ),

  -- bar 
  s({trig = "bar", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "\\overline{<>}",
      {
        i(1)
      }
    ),
    { condition = tex_utils.in_mathzone }
  ),

  -- Quadratic Fields
  s({trig = "Qf(%a)", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    f(function(args, snip) return
      "\\QQ\\left(\\sqrt{" .. snip.captures[1] .. "}\\right)" end, {}),
    { condition = tex_utils.in_mathzone }
  ), 

  -- Continued fractions
  s({trig = "cf", snippetType = "autosnippet"},
    fmta(
      "\\cfrac{<>}{<>}",
      {
        i(1),
        i(2),
      }
    ),
    {condition = tex_utils.in_mathzone}  
  ),

  -- Modulo
  s({trig = "mdl", snippetType = "autosnippet"},
    fmta(
      "<> \\equiv <> \\pmod{<>}",
      {
        i(1),
        i(2),
        i(3),
      }
    ),
    {condition = tex_utils.in_mathzone}  
  ),
}