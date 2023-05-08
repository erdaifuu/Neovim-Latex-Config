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
  -- Enviroments
  -- Generic Enviroment
  s({trig="env", snippetType = "autosnippet"},
    fmta(
      [[
        \begin{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    ),
    {condition = tex_utils.line_begin}
  ),
  -- Generic Enviroment with 2 arguments
  s({trig="e2", snippetType = "autosnippet"},
    fmta(
      [[
        \begin{<>}{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual), 
        rep(1),
      }
  ),
    {condition = tex_utils.line_begin}
  ),
  -- Generic Enviroment with 3 arguments
  s({trig="e3", snippetType = "autosnippet"},
    fmta(
      [[
        \begin{<>}{<>}{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        i(3),
        d(4, get_visual), 
        rep(1),
      }
    ),
    {condition = tex_utils.line_begin}
  ),
  --equation
  s({trig="beq", snippetType = "autosnippet"},
    fmta(
      [[
        \begin{equation*}
          <>
        \end{equation*}
      ]],
      { d(1, get_visual), }
    ),
    {condition = tex_utils.line_begin}
  ),
  --align
  s({trig="ebal", snippetType = "autosnippet"},
    fmta(
      [[
        \begin{align*}
          <>
        \end{align*}
      ]],
      { d(1, get_visual), }
    ),
    {condition = tex_utils.line_begin}
  ),
  s({trig = "([^%l])mm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>$<>$",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
}
