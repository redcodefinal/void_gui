require "colorize"

require "./point"
require "./control"
require "./window"
require "./controls/*"


# TODO: Write documentation for `VoidGui`
module VoidGui
  extend self

  VERSION = "0.1.0"

  CSI = "\e["
  CURSOR_MOVE_TO = "H"
  CLEAR_SCREEN = "\e[H\e[2J"
  SHOW_CURSOR = CSI + "?25h"
  HIDE_CURSOR = CSI + "?25l"

  GUI_CHARS = {
    single_line: {
      up_down: 179,
      left_up_down: 180,
      left_down: 191,
      up_right: 192,
      left_up_right: 193,
      left_down_right: 194,
      up_down_right: 195,
      left_right: 196,
      intersection: 197,
      up_left: 217,
      down_right: 218
    },

    double_line: {
      up_down: 186,
      left_up_down: 185,
      left_down: 187,
      up_right: 200,
      left_up_right: 202,
      left_down_right: 203,
      up_down_right: 204,
      left_right: 205,
      intersection: 206,
      up_left: 188,
      down_right: 201
    },

    block: {
      full_char: 219,
      lh_char: 220,
      uh_char: 223,
      square: 254
    },
    
    dotted: {
      low: 176,
      medium: 177,
      high: 178,
    },

    space: {
      normal: 32,
      nbsp: 255
    },

    special: {
      x: 158,
      upper_slash_zero: 157,
      lower_slash_zero: 155,
      double_arrow_left: 174,
      double_arrow_right: 175,
      small_o: 167,
      degree: 248,
      double_dot: 249,
      space_dot: 250,
      sub1: 251,
      sub2: 252,
      sub3: 253,
      threequals: 240,
      high_line: 238,
      vert_broken_bar: 221,
      double_underscore: 242,
    }
  }

  enum Key
    Up
    Down
    Left
    Right
    Enter
    Tab
    Backspace
    Escape
    Space

    Backtick
    Tilde
    Exclamation
    Atsign
    Hash
    Dollar
    Percent
    Caret
    Ampersand
    Asterisk
    ParenOpen
    ParenClose
    Minus
    Underscore
    Equals
    Plus
    Pipe
    Backslash
    Comma
    LessThan
    Period
    GreaterThan
    ForwardSlash
    QuestionMark
    SquareBracketOpen
    SquareBracketClose
    CurlyBracketOpen
    CurlyBracketClose
    Semicolon
    Colon
    SingleQuote
    DoubleQuote

    A
    B
    C
    D
    E
    F
    G
    H
    I
    J
    K
    L
    M
    N
    O
    P
    Q
    R
    S
    T
    U
    V
    W
    X
    Y
    Z

    Num0
    Num1
    Num2
    Num3
    Num4
    Num5
    Num6
    Num7
    Num8
    Num9

    Ctrl
    Shift

    Other
  end

  def clear_screen
    print CLEAR_SCREEN
  end

  def hide_cursor
    print HIDE_CURSOR
  end

  def show_cursor
    print SHOW_CURSOR
  end


  def move_to(x = 0, y = 0)
    print CSI + y.to_s + ";" + x.to_s + CURSOR_MOVE_TO
  end

  def peek_key
    key = nil
    begin
      STDIN.read_timeout = 0.1
      key = get_key
    rescue e
    ensure
      STDIN.read_timeout = nil
    end

    key
  end

  def peek_key_raw
    key = nil
    begin
      STDIN.read_timeout = 0.1
      key = get_key_raw
    rescue e
    ensure
      STDIN.read_timeout = nil
    end

    key
  end


  def get_key_raw
    STDIN.raw do |io|
      b = Bytes.new(3)
      String.new(b[0, io.read(b)])
    end
  end

  def get_key : Array(Key)
    case get_key_raw
    when "\e[A"
      [Key::Up]
    when "\e[B"
      [Key::Down]
    when "\e[C"
      [Key::Right]
    when "\e[D"
      [Key::Left]
    when "\r", "\n"
      [Key::Enter]
    when "\u{7f}", "\b"
      [Key::Backspace]
    when "\e"
      [Key::Escape]
    when "\u{3}"
      [Key::Ctrl, Key::C]
    when " "
      [Key::Space]
    when "`"
      [Key::Backtick]
    when "~"
      [Key::Tilde]
    when "!"
      [Key::Exclamation]
    when "@"
      [Key::Atsign]
    when "#"
      [Key::Hash]
    when "$"
      [Key::Dollar]
    when "%"
      [Key::Percent]
    when "^"
      [Key::Caret]
    when "&"
      [Key::Ampersand]
    when "*"
      [Key::Asterisk]
    when "("
      [Key::ParenOpen]
    when ")"
      [Key::ParenClose]
    when "-"
      [Key::Minus]
    when "_"
      [Key::Underscore]
    when "="
      [Key::Equals]
    when "+"
      [Key::Plus]
    when "|"
      [Key::Pipe]
    when "\\"
      [Key::Backslash]
    when ","
      [Key::Comma]
    when "<"
      [Key::LessThan]
    when "."
      [Key::Period]
    when ">"
      [Key::GreaterThan]
    when "/"
      [Key::ForwardSlash]
    when "?"
      [Key::QuestionMark]
    when "["
      [Key::SquareBracketOpen]
    when "]"
      [Key::SquareBracketClose]
    when "{"
      [Key::CurlyBracketOpen]
    when "}"
      [Key::CurlyBracketClose]
    when ";"
      [Key::Semicolon]
    when ":"
      [Key::Colon]
    when "\'"
      [Key::SingleQuote]
    when "\""
      [Key::DoubleQuote]
    when "a"
      [Key::A]
    when "A"
      [Key::A, Key::Shift]
    when "b"
      [Key::B]
    when "B"
      [Key::B, Key::Shift]
    when "c"
      [Key::C]
    when "C"
      [Key::C, Key::Shift]
    when "d"
      [Key::D]
    when "D"
      [Key::D, Key::Shift]
    when "e"
      [Key::E]
    when "E"
      [Key::E, Key::Shift]
    when "f"
      [Key::F]
    when "F"
      [Key::F, Key::Shift]
    when "g"
      [Key::G]
    when "G"
      [Key::G, Key::Shift]
    when "h"
      [Key::H]
    when "H"
      [Key::H, Key::Shift]
    when "i"
      [Key::I]
    when "I"
      [Key::I, Key::Shift]
    when "j"
      [Key::J]
    when "J"
      [Key::J, Key::Shift]
    when "k"
      [Key::K]
    when "K"
      [Key::K, Key::Shift]
    when "l"
      [Key::L]
    when "L"
      [Key::L, Key::Shift]
    when "m"
      [Key::M]
    when "M"
      [Key::M, Key::Shift]
    when "n"
      [Key::N]
    when "N"
      [Key::N, Key::Shift]
    when "o"
      [Key::O]
    when "O"
      [Key::O, Key::Shift]
    when "p"
      [Key::P]
    when "P"
      [Key::P, Key::Shift]
    when "q"
      [Key::Q]
    when "Q"
      [Key::Q, Key::Shift]
    when "r"
      [Key::R]
    when "R"
      [Key::R, Key::Shift]
    when "s"
      [Key::S]
    when "S"
      [Key::S, Key::Shift]
    when "t"
      [Key::T]
    when "T"
      [Key::T, Key::Shift]
    when "u"
      [Key::U]
    when "U"
      [Key::U, Key::Shift]
    when "v"
      [Key::V]
    when "V"
      [Key::V, Key::Shift]
    when "w"
      [Key::W]
    when "W"
      [Key::W, Key::Shift]
    when "x"
      [Key::X]
    when "X"
      [Key::X, Key::Shift]
    when "y"
      [Key::Y]
    when "Y"
      [Key::Y, Key::Shift]
    when "z"
      [Key::Z]
    when "Z"
      [Key::Z, Key::Shift]
    when "0"
      [Key::Num0]
    when "1"
      [Key::Num1]
    when "2"
      [Key::Num2]
    when "3"
      [Key::Num3]
    when "4"
      [Key::Num4]
    when "5"
      [Key::Num5]
    when "6"
      [Key::Num6]
    when "7"
      [Key::Num7]
    when "8"
      [Key::Num8]
    when "9"
      [Key::Num9]
    else
      [Key::Other]
    end
  end
end
