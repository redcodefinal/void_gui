require "../void_gui"

Signal::INT.trap do
  puts "CTRL-C INTERRUPT!"
  # close
  VoidGui.clear_screen
  VoidGui.show_cursor

  exit
end

VoidGui.hide_cursor

current_item = 0
max_items = 10

loop do
  color = :red
  key = VoidGui.peek_key
  VoidGui.clear_screen
  VoidGui.move_to(0, 0)
  print key

  if key
    if key.includes? VoidGui::Key::Up
      current_item -= 1 if current_item > 0
    elsif key.includes? VoidGui::Key::Down
      current_item += 1 if current_item < (max_items - 1)
    elsif key.includes? VoidGui::Key::Enter
      color = :green
    elsif key == [VoidGui::Key::Ctrl, VoidGui::Key::C]
      exit
    end
  end

  max_items.times do |x|
    VoidGui.move_to(3, x + 3)

    if x == current_item
      print "#{VoidGui::UNICODE[:arrow][:right_rounded]} Test #{x}".colorize(color)
    else
      print "  Test #{x}".colorize(:white)
    end
  end

  sleep 0.05
end
