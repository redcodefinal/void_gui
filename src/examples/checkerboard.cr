require "../void_gui"

Signal::INT.trap do
  puts "CTRL-C INTERRUPT!"
  # close
  VoidGui.clear_screen
  VoidGui.show_cursor
  exit
end

VoidGui.hide_cursor

checker_width = 8
checker_height = 4

BOARD_START = 6

max_height = 10
max_width = 10

color_schemes = {
  original:  {a: :white, b: :black},
  inverse:   {a: :black, b: :white},
  clash:     {a: :blue, b: :red},
  clash_inv: {a: :red, b: :blue},
  royal:     {a: :yellow, b: :blue},
  royal_inv: {a: :blue, b: :yellow},
}

color_scheme = :original

filled = true

VoidGui.loop(1) do |screen_size, keys|
  VoidGui.clear_screen(now: true)
  if keys == [VoidGui::Key::Up]
    checker_height += 1 if checker_height < max_height
  elsif keys == [VoidGui::Key::Down]
    checker_height -= 1 if checker_height > 1
  end

  if keys == [VoidGui::Key::Right]
    checker_width += 1 if checker_width < max_width
  elsif keys == [VoidGui::Key::Left]
    checker_width -= 1 if checker_width > 2
  end

  VoidGui.move_to(2, 1)
  print "Checkerboard Example - Use Arrow Keys to modify checkerboard size, Enter key changes color scheme, and Space to flip the board\n"
  print "  Last update #{Time.now}\n"
  print "  Screen Size = #{screen_size.inspect}"

  # Move to the start of the checker board
  max = Point.new(x: screen_size.x - BOARD_START, y: screen_size.y - BOARD_START)

  checker_x1 = BOARD_START
  checker_y1 = BOARD_START
  checker_x2 = checker_x1 + checker_width - 1
  checker_y2 = checker_y1 + checker_height - 1

  VoidGui.move_to(BOARD_START, BOARD_START)

  while (checker_y2) < max.y
    while (checker_x2) < max.x
      checker_color = (((checker_x1-BOARD_START)/checker_width) % 2) == (((checker_y1-BOARD_START)/checker_height) % 2)
      color = (checker_color ? color_schemes[color_scheme][:a] : color_schemes[color_scheme][:b])

      VoidGui.box(checker_x1, checker_y1, checker_x2, checker_y2, fg: color, filled: filled)
      
      checker_x1 += checker_width
      checker_x2 = checker_x1 + checker_width - 1
    end
    checker_y1 += checker_height
    checker_y2 = checker_y1 + checker_height - 1
    checker_x1 = BOARD_START
    checker_x2 = checker_x1 + checker_width - 1
  end
end

VoidGui.show_cursor
