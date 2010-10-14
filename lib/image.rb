require "pdf/writer"
require 'lib/base_region'


module PDFRegion
  class Image < BaseRegion
    def initialize(parent, image_res)
      super parent

      @image = image_res
      @info = PDF::Writer::Graphics::ImageInfo.new(@image)
    end

    attr_accessor :image

    def set_properties props = {}

      super props

      case true
        when (width == 0 and height == 0)
          self.width = @info.width
          self.height = @info.height
        when width == 0
          self.width = height / @info.height.to_f * @info.width
        when height == 0
          self.height = width * @info.height / @info.width.to_f
      end
    end

    #TODO: need to refactoring
    def render(x, y, test=false)
      document.pdf.add_image(@image, x, y - height, width, height)
      add_border x, y
    end
  end
end