require "../document"


result = PDFRegion::document PDF::Writer.new, 2.cm do
      caption 'test text'*50, :width=>5.cm, :pad_left => 1.cm #block with text
end

File.open("#{File.basename(__FILE__, ".rb")}.pdf", 'wb') {|f| f.write result}

