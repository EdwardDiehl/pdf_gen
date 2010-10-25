require "lib/base_region"
require "lib/modules/container"
require "lib/containers/div_container"
require "lib/containers/span_container"
require "lib/containers/caption_container"
require "lib/containers/image_container"
require "lib/containers/table_container"


module PDFRegion

  class Div < BaseRegion

    include Container, CaptionContainer, SpanContainer, DivContainer, \
 ImageContainer, TableContainer

    def initialize parent
      super

      @gorizontal_interval = 0
      @gorizontal_align = false
      @optional_border = false
      @is_breakable = true
      @count_rendered_region = 0
      @rendered_height = 0
    end

    attr_accessor :gorizontal_interval, :gorizontal_align, :optional_border

    def add_border_top(x, y)
      add_border(x, y, x + width, y) if border_top
    end

    def add_border_bottom(x, y)
      add_border(x, y, x + width, y) if border_bottom
    end

    #border left and right
    def add_border_sides(x, y, y_new)
      add_border(x, y, x, y_new) if border_left
      add_border(x + width, y, x + width, y_new) if border_right
    end

    def add_border(x, y, x1, y1)
      document.pdf.save_state
      document.pdf.stroke_style! border_params()
      document.pdf.line(x, y, x1, y1).stroke
      document.pdf.restore_state
    end

    def add_optional_border(x, y)
      add_border(x, y, x + width, y)
    end

    def calculate_minimal_height
      height = 0
      regions.each do |region|
        height += region.height
      end
      height + pad_top + pad_bottom
    end

    def render(pos, av_height, test=false)
      remain_height = av_height
      remain_regions = regions.slice(@count_rendered_region..regions.size)
      if @count_rendered_region == 0 && @rendered_height == 0
        @rendered_height += pad_top
        remain_height -= pad_top
        
        add_border_top(pos[0],pos[1])
        
        pos[1] -= pad_top
        pos[0] += pad_left 
      end
      remain_regions.each do |region|
        if (remain_height >= region.height)
          @count_rendered_region += 1

          self.fit_width(region)

          region_height = region.render(pos, remain_height)[0]
          @rendered_height += region_height
          pos[1] -= region_height

          remain_height -= region_height
          if region == regions.last
            remain_height -= pad_bottom
            @rendered_height += pad_bottom
          end
        else
          if region.breakable?
            status = region.render(pos, remain_height)
            @rendered_height += status[0]
            return [av_height - remain_height - status[0], status[1]]
          else
            return [av_height - remain_height, false]
          end
        end
      end

      [av_height - remain_height, true]
    end

    def fit_width(region)
      if (region.width > (width - pad_left - pad_right)) or gorizontal_align
        region.width = width - pad_left - pad_right
      end
    end

  end

end
