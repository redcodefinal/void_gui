require "../void_gui"

Signal::INT.trap do
  puts "CTRL-C INTERRUPT!"
  # close
  VoidGui.clear_screen
  VoidGui.show_cursor
  exit
end

colors = [
  :red,
  :green,
  :yellow,
  :blue,
  :magenta,
  :cyan,
  :light_gray,
  :light_red,
  :light_green,
  :light_yellow,
  :light_blue,
  :light_magenta,
  :light_cyan,
  :white,
]

modes = [:default, :bold, :bright, :dim, :underline, :blink, :reverse, :hidden]

pos_x = 10
pos_y = 10

vel_x = 1
vel_y = 1

box_size = 6

current_color = 0
mode = :dim
collision_occured = false


last_collision = Time.now

VoidGui.hide_cursor

screen_size = VoidGui.get_screen_size

collide_x = ->(clamp_value : Int32) do
  pos_x = clamp_value
  vel_x = -vel_x
  last_collision = Time.now
  collision_occured = true
end

collide_y = ->(clamp_value : Int32) do 
  pos_y = clamp_value
  vel_y = -vel_y
  last_collision = Time.now
  collision_occured = true
end

VoidGui.loop do
  VoidGui.clear_screen

  # detect collision and change velocity
  collision_occured = false
  if pos_x <= 2
    collide_x.call(2)
  elsif (pos_x + (box_size*2)) >= (screen_size.x - 2)
    collide_x.call(pos_x = (screen_size.x - 2 - (box_size*2)))
  end

  if pos_y <= 2
    collide_y.call(2)
  elsif (pos_y + box_size) >= (screen_size.y - 2)
    collide_y.call(screen_size.y - 2 - box_size)
  end

  # Detect if a collision has occured recently for color and mode change

  if collision_occured
    collision_occured = false
    mode = :bright
    current_color += 1
    current_color = 0 if current_color >= colors.size
  end

  mode = :dim if (Time.now - last_collision) > 200.milliseconds

  VoidGui.box(pos_x, pos_y, pos_x + (box_size*2), pos_y + box_size, fg: colors[current_color], mode: mode, filled: true)

  pos_x += vel_x
  pos_y += vel_y

  #sleep 0.01
end
