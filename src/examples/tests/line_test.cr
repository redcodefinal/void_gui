require "../../void_gui"

Signal::INT.trap do
  puts "CTRL-C INTERRUPT!"
  # close
  VoidGui.clear_screen
  VoidGui.show_cursor
  exit
end

VoidGui.hide_cursor
VoidGui.always_draw_now = true
VoidGui.clear_screen

types = [:full, :light, :medium, :heavy]
colors = [:white, :red, :green, :blue]
modes = [:default, :bold, :bright, :dim]

lines_vert = {
  { x1: 4, y1: 4, x2: 4, y2: 14},
  { x1: 6, y1: 4, x2: 6, y2: 14},
  { x1: 9, y1: 4, x2: 9, y2: 14},
  { x1: 14, y1: 4, x2: 14, y2: 14},
}

lines_hori = {
  { x1: 4, y1: 4, x2: 14, y2: 4},
  { x1: 4, y1: 6, x2: 14, y2: 6},
  { x1: 4, y1: 9, x2: 14, y2: 9},
  { x1: 4, y1: 14, x2: 14, y2: 14},
}

lines_diag = {
  { x1: 4, y1: 4, x2: 14, y2: 14},
  { x1: 14, y1: 4, x2: 4, y2: 14},
  { x1: 4, y1: 9, x2: 9, y2: 14},
  { x1: 9, y1: 4, x2: 14, y2: 9},
}

4.times do |x|
  line = lines_vert[x]
  VoidGui.line(line[:x1], line[:y1], line[:x2], line[:y2], char: VoidGui::UNICODE[:block][types[x]], fg: colors[x], mode: modes[x])
  sleep 1
end

4.times do |x|
  line = lines_hori[x]
  VoidGui.line(line[:x1], line[:y1], line[:x2], line[:y2], char: VoidGui::UNICODE[:block][types[x]], fg: colors[x], mode: modes[x])
  sleep 1
end

4.times do |x|
  line = lines_diag[x]
  VoidGui.line(line[:x1], line[:y1], line[:x2], line[:y2], char: VoidGui::UNICODE[:block][types[x]], fg: colors[x], mode: modes[x])
  sleep 1
end

VoidGui.show_cursor