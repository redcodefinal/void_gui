class VoidGui::Control
  getter position : Point = Point.new

  property? enabled : Bool = true
  property? visible : Bool = true
  property? selectable : Bool = false

  getter on_press_events = [] of Proc(Nil)
  getter on_release_events = [] of Proc(Nil)
  getter on_down_events = [] of Proc(Nil)

  def initialize
  end

  def press
    on_press_events.each(&:call)
  end

  def release
    on_release_events.each(&:call)
  end

  def down
    on_down_events.each(&:call)
  end
end
