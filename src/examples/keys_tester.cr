require "../void_gui"

Signal::INT.trap do
  puts "CTRL-C INTERRUPT!"
  # close
  VoidGui.clear_screen
  VoidGui.show_cursor
  exit
end

VoidGui.hide_cursor
print VoidGui::DISABLE_ECHO

loop do
  VoidGui.clear_screen

  # Drawing goes here
  keys = VoidGui.peek_key
  puts keys
  sleep 0.1

  if keys == [VoidGui::Key::Ctrl, VoidGui::Key::C]
    exit
  end
end

VoidGui.show_cursor
