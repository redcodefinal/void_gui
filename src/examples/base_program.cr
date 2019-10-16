require "../void_gui"

Signal::INT.trap do
  puts "CTRL-C INTERRUPT!"
  # close
  VoidGui.clear_screen
  VoidGui.show_cursor
  exit
end

VoidGui.hide_cursor

loop do
  VoidGui.clear_screen

  # Drawing goes here
end

VoidGui.show_cursor
