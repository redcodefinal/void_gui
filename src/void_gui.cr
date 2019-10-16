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

  CSI            = "\e["
  CURSOR_MOVE_TO = "H"
  CLEAR_SCREEN   = "\e[H\e[2J"
  SHOW_CURSOR    = CSI + "?25h"
  HIDE_CURSOR    = CSI + "?25l"
  GET_CURSOR     = CSI + "6n"
  
  class_property? always_draw_now = false

  @@draw_instructions = String::Builder.new(256)

  def self.clear
    @@draw_instructions = String::Builder.new(256)
  end

  def self.draw
    print @@draw_instructions.to_s
  end

  def self.clear_screen
    print CLEAR_SCREEN
  end

  def self.loop(delay = 0.01)
    ::loop do 
      screen_size = get_screen_size
      keys = peek_key
      clear_screen      
      yield(screen_size, keys)
      draw
      sleep delay
      clear
    end
  end

  def self.hide_cursor
    print HIDE_CURSOR
  end

  def self.show_cursor
    print SHOW_CURSOR
  end

  def self.get_cursor : Point
    print GET_CURSOR

    string = ""
    STDIN.raw do |stdin|
      while (char = stdin.read_char) != 'R'
        string += char.to_s unless char == '\e' || char == '['
      end
    end
    
    split = string.split(";")

    Point.new(x: split[1].to_i, y: split[0].to_i)
  end

  def self.get_screen_size : Point
    save_cur_pos = get_cursor

    move_to(999, 999, now: true)

    cur_pos = get_cursor

    move_to(save_cur_pos, now: true)

    cur_pos
  end

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

  def self.move_to(point : Point, now = false)
    move_to(point.x, point.y, now: now)
  end

  def self.jump_to(rx = 0, ry = 0, now = false)
    cur_pos = get_cursor
    cur_pos.x += rx
    cur_pos.y == ry
    move_to(cur_pos, now: now)
  end

  def self.jump_to(point : Point, now = false)
    jump_to(point.x, point.y, now: now)
  end

  def self.pixel(px, py, shade = :full, fg = :default, bg = :default, mode = :default, now = false)
    move_to(px, py)

    type = (shade == :full) ? :block : :shade
    io = VoidGui::UNICODE[type][shade].colorize.fore(fg).back(bg).to_s
    io.colorize.mode(mode) if mode != :default
    if now || always_draw_now?
      print io
    else
      @@draw_instructions << io.to_s
    end
  end

  def self.char(px, py, char = "X", fg = :default, bg = :default, mode = :default, now = false)
    move_to(px, py)

    io = char.colorize.fore(fg).back(bg)
    io.mode(mode) if mode != :default
    if now || always_draw_now?
      print io
    else
      @@draw_instructions << io.to_s
    end
  end

  def self.line(x1, y1, x2, y2, shade = :full, fg = :default, bg = :default, mode = :default, now = false)
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
        pixel(y, x, shade: shade, fg: fg, bg: bg, mode: mode, now: now)
      else
        pixel(x, y, shade: shade, fg: fg, bg: bg, mode: mode, now: now)
      end
      error -= deltay
      if error < 0
        y += ystep
        error += deltax
      end
    end
  end

  def self.box(x1, y1, x2, y2, shade = :full, fg = :default, bg = :default, mode = :default, filled = false, now = false)
    # flip everything if needed
    y1, y2 = y2, y1 if y2 < y1
    x1, x2 = x2, x1 if x2 > x1

    if filled      
      y1.upto(y2) do |y|
        line(x1, y, x2, y, shade: shade, fg: fg, bg: bg, mode: mode, now: now)
      end
    else
      line(x1, y1, x2, y1, shade: shade, fg: fg, bg: bg, mode: mode, now: now)
      line(x1, y2, x2, y2, shade: shade, fg: fg, bg: bg, mode: mode, now: now)
      line(x2, y1, x2, y2, shade: shade, fg: fg, bg: bg, mode: mode, now: now)
      line(x1, y1, x1, y2, shade: shade, fg: fg, bg: bg, mode: mode, now: now)
    end
  end
end
