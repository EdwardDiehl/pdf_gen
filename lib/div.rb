require "lib/base_region"
require "lib/container"
require "lib/caption"
require "lib/span"

module PDFRegion
  class Div < BaseRegion
    include Container, CaptionContainer, SpanContainer

    #initialization

    def initialize parent
      super parent

      @gorizontal_interval = 0
      @gorizontal_align = false
    end

    #gorizontal interval
    attr_accessor :gorizontal_interval

    #gorizontal alignment
    attr_accessor :gorizontal_align


    #renders inner regions
    def render_regions(x, y, test = true)

      content_height = 0
      last = regions.last

      document.pdf.y = y

      regions.each do |region|

        unless test
          if (region.height >= (document.pdf.y - document.pdf.bottom_margin))
            document.break_page
          end

          region.width = width if gorizontal_align
          region.render([x, document.pdf.y])
          
          document.pdf.y -= region.height
          document.pdf.y -= gorizontal_interval unless region == last
        end

        content_height += region.height
        content_height += gorizontal_interval unless region == last
      end

      content_height
    end

    private :render_regions

    #gets minimal region height

    def calculate_minimal_height
      0
    end
  end

  def self.div(pdf, &initialization_block)
    div = Div.new(pdf)
    div.instance_eval(&initialization_block)
    div.render([0, pdf.y])
  end
end