require 'spec_helper'

describe Spree::Slide do 
	it { should belong_to :product }

  it "should be published by default" do 
    slider = Spree::Slide.new
    slider.published.should == true
  end
end