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

VoidGui.clear_screen
VoidGui.always_draw_now = true
VoidGui::UNICODE.each do |k, v|
  v.each do |kk, vv|
    key = "#{k} -> #{kk}".ljust(60, ' ')
    puts "#{key} #{vv}"
  end
end