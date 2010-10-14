require 'rubygems'
require 'lib/writer.rb'
require 'pdf/writer'
require "lib/fixnum"
require 'lib/document.rb'
require 'lib/containers/div_container'
require "test/helpers_for_testing"
include HelpersForTesting
include PDFRegion
include Container

describe "calculating div height" do
  context "when there is only caption in the div" do
    it "should calculate div height as caption height" do
      div = create_div
      caption = create_caption
      caption.height = 100

      add_region div
      regions[0].add_region caption

      div.send(:render_regions, 0, 0).should == 100
    end
  end
  context "when there is div with two captions in the main div" do
    it "should calculate height as summary of the captions height" do
      div = create_div
      div1 = create_div

      caption = create_caption
      caption.height = 100
      caption1 = create_caption
      caption1.height = 100

      add_region div
      regions[0].add_region div1
      regions[0].add_region caption
      regions[0].add_region caption1

      div.send(:render_regions, 0, 0).should == 200
    end
  end
end
