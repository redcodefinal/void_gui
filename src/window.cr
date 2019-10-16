class VoidGui::Window
  getter controls = [] of VoidGui::Control

  property x : Int32 = 0
  property y : Int32 = 0

  property width : Int32 = 0
  property height : Int32 = 0

  
  
  def initialize(x, y, width, height)
  end

  def draw
    controls.each(&:draw)
  end
  
  def add_control(control : VoidGui::Control)
    controls << control
    controls.sort {|a,b| a.layer <=> b.layer }
  end

  def <<(control : Control)
    add_control control
  end
end