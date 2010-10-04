# require "color"

require "lib/base_concrete_region"

#text class definition
module PDFRegion
  #text that might be rendered to the PDF document
  class Caption < BaseConcreteRegion
    #initialization
    def initialize(parent)
      super parent

      @text = ""
      @template = @text

      @justification = :left
      @bold = false

      @font_size = document.pdf.font_size
    end

    #text
    attr_reader :text

    def text=(value)
      if value && @text != value
        @text = value
        @template = value
        clear_minimal_height
      end
    end

    attr_reader :text_color

    def text_color=(value)
      if value && @text_color != value
        @text_color = value
        clear_minimal_height
      end
    end

    #justification
    attr_reader :justification

    def justification=(value)
      if value && @justification != value
        @justification = value
        clear_minimal_height
      end
    end

    #bold
    attr_reader :bold

    def bold= (value)
      if value && @bold != value
        @bold = value
        clear_minimal_height
      end
    end

    #font_size
    attr_reader :font_size

    def font_size=(value)
      if value && @font_size != value
        @font_size = value
        clear_minimal_height
      end
    end

    #returns minimal height for the current caption

    def calculate_minimal_height
      add_text_wrap
    end

    #writes text. return actual text height

    def add_text_wrap(x = 0, y = document.pdf.y, test = true)
      res = document.pdf.font_height + pad_top
      txt = bold ? "<b>#{text}</b>" : text

      document.pdf.save_state
      document.pdf.fill_color text_color if text_color
      while !(txt = document.pdf.add_text_wrap(x + pad_left, y - res, width - pad_left - pad_right, txt, font_size, justification, 0, test)).empty?
        res += document.pdf.font_height
      end
      document.pdf.restore_state

      res + pad_bottom
    end

    private :add_text_wrap


    #renders specified text at the specified position
    #returns real position that caption was generated on

    def render(x, y, test=false)
      new_x, new_y = 0, 0
      new_x, new_y = super x, y, test

      add_text_wrap(new_x, new_y, test) if new_x and new_y
    end

    def apply_values(values = {})
      @text = @template
      values.each_pair {|key, value| @text = @text.sub("<!#{key}!>", value.to_s)}
    end

  end #Text

  module CaptionContainer

     #adds new caption with initialization block
    def caption(text = nil, style = nil, &initialization_block)

      caption = Caption.new self

      caption.text = text if text
      caption.set_properties style unless style.nil?

      caption.instance_eval(&initialization_block) if initialization_block
      self.add_region(caption)
    end
  end
end

