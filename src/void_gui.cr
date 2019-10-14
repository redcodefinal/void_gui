# TODO: Write documentation for `VoidGui`
module VoidGui
  extend self

  VERSION = "0.1.0"

  CSI = "\e["
  CURSOR_MOVE_TO = "H"
  CLEAR_SCREEN = "\e[H\e[2J"

  LETTERS = 'A'..'Z'
  NUMBERS = "NUM0".."NUM9"

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
    ParenClosed
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

    CtrlC

    {% LETTERS.each do |x| %}
    {{x.id}}
    {% end %}

    {% NUMBERS.each do |x| %}
    {{x.id}}
    {% end %}

    Other
  end

  def clear_screen
    print CLEAR_SCREEN
  end

  def move_to(x = 0, y = 0)
    print CSI + y.to_s + ";" + x.to_s + CURSOR_MOVE_TO
  end

  def peek_key
    key = nil
    begin
      STDIN.read_timeout = 0.1
      key = get_key
    ensure
      STDIN.read_timeout = nil
    end

    key
  end

  def get_key_raw
    STDIN.raw do |io|
      b = Bytes.new(3)
      String.new(b[0, io.read(bytes)])
    end
  end

  def get_key : Key
    case get_key_raw
    when "\\e[A"
      Key::Up
    when "\\e[B"
      Key::Down
    when "\\e[C"
      Key::Right
    when "\\e[D"
      Key::Left
    when "\\r", "\\n"
      Key::Enter
    when "\\u{7f}", "\\b"
      Key::Backspace
    when "\\e"
      Key::Escape
    when "\\u{3}"
      Key::CtrlC
    else
      Key::Other
    end
  end
end
