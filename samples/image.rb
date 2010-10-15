$: << File.expand_path("../")
require "rubygems"
require "pdf/writer"
require "lib/document"
require "lib/fixnum"
require "lib/float"


result = PDFRegion::document PDF::Writer.new, 2.cm do
  image_data = open(File.expand_path('../test_image.jpg'), "rb") { |file| file.read }
  image image_data, :width => 250
end


File.open("doc_test.pdf", 'wb') {|f| f.write result}

