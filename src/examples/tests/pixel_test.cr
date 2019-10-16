require "colorize"
require "../../void_gui"

Signal::INT.trap do
  puts "CTRL-C INTERRUPT!"
  # close
  VoidGui.clear_screen
  VoidGui.show_cursor
  exit
end

colors = [
  :red,
  :green,
  :yellow,
  :blue,
  :magenta,
  :cyan,
  :light_gray,
  :dark_gray,
  :light_red,
  :light_green,
  :light_yellow,
  :light_blue,
  :light_magenta,
  :light_cyan,
  :white
]

modes = [:default, :bold, :bright, :dim, :underline, :blink, :reverse, :hidden]

VoidGui.hide_cursor



test_1_start = Time.now

VoidGui.clear_screen
50.times do |y|
  40.times do |x|
    VoidGui.char((x * 1) + 4 + y, (x * 1) + 4, char: VoidGui::UNICODE[:block][:full], fg: colors[(x + (y * 3)) % colors.size], mode: modes[x % modes.size])
  end
end

VoidGui.draw
VoidGui.clear

test_1_stop = Time.now

sleep 3

test_2_start = Time.now

VoidGui.clear_screen
VoidGui.always_draw_now = true
50.times do |y|
  40.times do |x|
    VoidGui.char((x * 1) + 4 + y, (x * 1) + 4, char: VoidGui::UNICODE[:block][:full], fg: colors[(x + (y * 3)) % colors.size], mode: modes[x % modes.size])
  end
end

VoidGui.draw

test_2_stop = Time.now


VoidGui.show_cursor

VoidGui.clear_screen
puts "Test 1 Time: #{test_1_stop - test_1_start}"
puts "Test 2 Time: #{test_2_stop - test_2_start}"
sleep 10