require "lib/span"
include PDFRegion


module CaptionContainer
  
  def caption(text = nil, style = nil, &initialization_block)
    caption = Caption.new self
    caption.text = text if text
    caption.width = self.width - self.pad_left - self.pad_right
    caption.set_properties style unless style.nil?
    caption.instance_eval(&initialization_block) if initialization_block
    self.add_region(caption)
  end
  
end