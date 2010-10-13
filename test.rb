#!/usr/bin/ruby ruby
$: << File.dirname(__FILE__)
require "rubygems"
require "pdf/writer"
require "lib/document"
require "lib/fixnum"
require "lib/float"
require 'ruby-debug'

result = PDFRegion::document PDF::Writer.new, 1.cm do

#  debugger
  span :pad_left => 2.cm, :width => 6.cm do
    div :width=> 6.cm, :border=> 1.cm do
      caption 'test text'*60, :width=>5.cm
      caption 'test text'*60, :width=>5.cm
      caption 'test text'*60, :width=>5.cm
      caption 'test text'*60, :width=>5.cm
    end
#  debugger
  end
end


File.open("#{File.dirname(__FILE__)}/../doc_test.pdf", 'wb') {|f| f.write result}