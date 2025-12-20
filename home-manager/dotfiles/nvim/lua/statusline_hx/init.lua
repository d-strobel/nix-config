local M = {}

local palette = {
  normal  = { fg = "#c7a2ff", bg = "#410175" },
  insert  = { fg = "#7bac62", bg = "#162c0b" },
  visual  = { fg = "#d9a8ff", bg = "#670175" },
  command = { fg = "#c8935d", bg = "#3f240a" },
}

local mode_map = {
  n        = { text = "NOR", color = palette.normal },
  i        = { text = "INS", color = palette.insert },
  v        = { text = "VIS", color = palette.visual },
  V        = { text = "VIS", color = palette.visual },
  ["\022"] = { text = "VIS", color = palette.visual },
  c        = { text = "CMD", color = palette.command },
}

-- Public: statusline mode function
function _G.statusline_mode()
  local mode = vim.api.nvim_get_mode().mode
  local entry = mode_map[mode] or { text = mode, color = palette.normal }

  vim.api.nvim_set_hl(0, "StatusLineMode", {
    fg = entry.color.fg,
    bg = entry.color.bg,
    bold = false,
  })

  return entry.text
end

-- Public: returns active and inactive statuslines
function M.statuslines()
  local active = table.concat({
    '%#StatusLineMode# %{%v:lua.statusline_mode()%} %#StatusLine#',
    '%=',
    '%<%t',
    '%h%w%m%r',
    '%=',
    '[%l,%c]',
    '%{&fileencoding}',
    '%#StatusLineMode# %{&filetype} %#StatusLine#'
  }, ' ')

  local inactive = '%= %<%t %='

  return active, inactive
end

return M
