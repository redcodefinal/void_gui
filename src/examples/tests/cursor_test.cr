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

  VoidGui.move_to(0, 0)

  print VoidGui.get_cursor.inspect
  puts
  print VoidGui.get_cursor.inspect
  puts
  print VoidGui.get_cursor.inspect
  puts
  print VoidGui.get_cursor.inspect
  puts


  sleep 0.5
end

VoidGui.show_cursor
