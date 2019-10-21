require "colorize"

require "./keys"
require "./chars"
require "./point"
require "./control"
require "./window"
require "./controls/*"

# TODO: Write documentation for `VoidGui`
# TODO: Add method for detecting mouse

# TODO: Instead of tradional screen buffer, what about a "drawing operation" queue?

module VoidGui
  VERSION = "0.1.0"

  # Control Sequence Identifier
  CSI = "\e["
  # Used in the command \e[<y>;<x>H
  CURSOR_MOVE_TO = "H"
  # Clears the screen
  CLEAR_SCREEN = "\e[H\e[2J"
  SHOW_CURSOR  = CSI + "?25h"
  HIDE_CURSOR  = CSI + "?25l"
  # Gets the cursor
  GET_CURSOR = CSI + "6n"

  DISABLE_ECHO =  CSI + "12l"
  ENABLE_ECHO =    CSI + "12h"

  # Controls if the system should store items that will be drawn, or immeadiately draw them
  # (This includes move_to, )
  class_property? always_draw_now = false
  
  class_getter screen_size = Point.new(0,0)
  class_getter last_screen_size = Point.new(0,0)


  # A list of instructions to be executed to the screen
  @@draw_instructions = String::Builder.new(256)

  # Clears the list of drawing instructions
  def self.clear
    @@draw_instructions = String::Builder.new(256)
  end

  # Draws the drawing instructions
  def self.draw
    print @@draw_instructions.to_s
  end

  # Clears the screen.
  #  *now* controls if this should be done right away, or queued in @@drawing_instructions
  def self.clear_screen(now = true)
    if now || always_draw_now?
      print CLEAR_SCREEN
    else
      @@draw_instructions << CLEAR_SCREEN
    end
  end

  # Loops through an update block supplied by the user. Block takes a *screen_size* and *keys* argument.
  # *delay* : How long the program should `sleep` inbetween frames
  # *move_home*: Should the cursor be moved home after every iteration? (Allows for cool iterative animation)
  def self.loop(delay = 0.01, move_home = true)
    ::loop do
      ss = get_screen_size
      keys = peek_key
      yield(screen_size, keys)
      move_to(0, 0) if move_home
      draw
      clear
      sleep delay
    end
  end

  # Hides the cursor. (Keeps it from blinking or chaning color layout)
  def self.hide_cursor
    print HIDE_CURSOR
  end

  # Shows the cursor.
  def self.show_cursor
    print SHOW_CURSOR
  end

  def self.get_cursor_position_raw : String
    string = ""
    STDIN.raw do |stdin|
      until stdin.read_char == '\e'
      end

      until (char = stdin.read_char) == 'R'
        # A key was pressed or some other dumb shit happened.
        if char == '\e'
          # Bleed the [ and char
          stdin.read_char
          stdin.read_char
        else
          string += char.to_s unless char == '['
        end
      end
    end
    string
  end

  # Get the cursor position. This sends a control sequenece and then reads the cursor position from STDIN.raw, This method should be used sparingly
  # TODO: Fix bug where if user holds down a key when getting position, it causes a complete meltdown
  # TODO: Add some sort of "sanity check"
  #         If there is an error use cached (key pressed)
  #         If there is a discrepency check again and use cache temporarily (number pressed or resized)
  def self.get_cursor_position : Point
    print GET_CURSOR

    success = false
    position = Point.new(-1,-1)
    until success
      begin
        string = get_cursor_position_raw
        split = string.split(";")
        position = Point.new(x: split[1].to_i, y: split[0].to_i)
        success = true
      rescue
      end
    end

    position
  end

  # Gets the screen size. This method should be used sparingly.
  def self.get_screen_size : Point
    save_cur_pos = get_cursor_position

    move_to(999, 999, now: true)

    cur_pos = get_cursor_position

    move_to(save_cur_pos, now: true)
    cur_pos
  end

  # Moves to an x y position.
  #  *now* controls if this should be done right away, or queued in @@drawing_instructions
  def self.move_to(mx = 0, my = 0, now = false)
    @@x = mx
    @@y = my
    int = CSI + my.to_s + ";" + mx.to_s + CURSOR_MOVE_TO
    if now || always_draw_now?
      print int
    else
      @@draw_instructions << int
    end
  end

  # Moves to an x y position.
  #  *now* controls if this should be done right away, or queued in @@drawing_instructions
  def self.move_to(point : Point, now = false)
    move_to(point.x, point.y, now: now)
  end

  # Jumps to a relative x y position.
  #  *now* controls if this should be done right away, or queued in @@drawing_instructions
  def self.jump_to(rx = 0, ry = 0, now = false)
    cur_pos = get_cursor_position
    cur_pos.x += rx
    cur_pos.y += ry
    move_to(cur_pos, now: now)
  end

  # Jumps to a relative x y position.
  #  *now* controls if this should be done right away, or queued in @@drawing_instructions
  def self.jump_to(point : Point, now = false)
    jump_to(point.x, point.y, now: now)
  end

  # Renders a char at an x y location.
  def self.pixel(px, py, char = '\u{2588}', fg = :default, bg = :default, mode = :default, now = false)
    move_to(px, py)

    io = char.colorize.fore(fg).back(bg)
    io.mode(mode) if mode != :default
    if now || always_draw_now?
      print io
    else
      @@draw_instructions << io.to_s
    end
  end

  # Renders a line between two points
  def self.line(x1, y1, x2, y2, char = '\u{2588}', fg = :default, bg = :default, mode = :default, now = false)
    # Some shit i ripped off rosetta code
    steep = (y2 - y1).abs > (x2 - x1).abs

    if steep
      x1, y1 = y1, x1
      x2, y2 = y2, x2
    end

    if x1 > x2
      x1, x2 = x2, x1
      y1, y2 = y2, y1
    end

    deltax = x2 - x1
    deltay = (y2 - y1).abs
    error = deltax / 2
    ystep = y1 < y2 ? 1 : -1

    y = y1
    x1.upto(x2) do |x|
      if steep
        pixel(y, x, char: char, fg: fg, bg: bg, mode: mode, now: now)
      else
        pixel(x, y, char: char, fg: fg, bg: bg, mode: mode, now: now)
      end
      error -= deltay
      if error < 0
        y += ystep
        error += deltax
      end
    end
  end

  def self.box(x1, y1, x2, y2, char = '\u{2588}', fg = :default, bg = :default, mode = :default, filled = false, now = false)
    # flip everything if needed
    y1, y2 = y2, y1 if y2 < y1
    x1, x2 = x2, x1 if x2 > x1

    if filled
      y1.upto(y2) do |y|
        line(x1, y, x2, y, char: char, fg: fg, bg: bg, mode: mode, now: now)
      end
    else
      line(x1, y1, x2, y1, char: char, fg: fg, bg: bg, mode: mode, now: now)
      line(x1, y2, x2, y2, char: char, fg: fg, bg: bg, mode: mode, now: now)
      line(x2, y1, x2, y2, char: char, fg: fg, bg: bg, mode: mode, now: now)
      line(x1, y1, x1, y2, char: char, fg: fg, bg: bg, mode: mode, now: now)
    end
  end
end
