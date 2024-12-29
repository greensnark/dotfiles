local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function (cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  enable_wayland = false,
  font = wezterm.font('Fira Code'),
  cell_width = 0.9,
  cursor_thickness = 4,
  font_size = 13.5,
  color_scheme = 'AtomOneLight',
  hide_tab_bar_if_only_one_tab = true,
  initial_cols = 400,
  initial_rows = 150,
  window_close_confirmation = 'NeverPrompt',
  window_padding = { left = 3, right = 3, top = 2, bottom = 2 },
}
