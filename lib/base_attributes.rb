module BaseAttributes

  attr_accessor :background_color

  def var_init
    @width = 0 #document.pdf.page_width - document.pdf.left_margin - document.pdf.right_margin
    @height = 0

    @pad_top = 0
    @pad_bottom = 0
    @pad_left = 0
    @pad_right = 0

    @border_top = false
    @border_left = false
    @border_right = false
    @border_bottom = false
    @border_style = PDF::Writer::StrokeStyle::SOLID
    @border_color = Color::RGB::Black

    @background_color = nil
  end

  attr_writer :height

  def height
    [minimal_height, @height].max
  end

  #padding from the page top after page break
  attr_accessor :page_pad_top

  def common_setter(var_name, value)
    if value && var_name != value
      self.instance_variable_set(var_name, value)
      clear_minimal_height
    end
  end

  attr_reader :width

  def width=(value)
    common_setter(:@width, value)
  end

  attr_accessor :border_top, :border_bottom, :border_left, :border_right, :border_style, :border_color

  def border= value
    self.border_top = value
    self.border_bottom = value
    self.border_left = value
    self.border_right = value
  end

  attr_reader :pad_top, :pad_bottom, :pad_left, :pad_right

  def pad_top=(value)
    common_setter(:@pad_top, value)
  end

  def pad_bottom=(value)
    common_setter(:@pad_bottom, value)
  end

  def pad_left=(value)
    common_setter(:@pad_left, value)
  end

  def pad_right=(value)
    common_setter(:@pad_right, value)
  end

end