require 'spec_helper'

module Poole
  describe Photo do
    before(:each) do
      @album = create_album(:title => "Album")
    end
    
    after(:each) do
      clean_albums
    end

    it "has a filename" do
      Photo.new("x.jpg", @album).filename.should == "x.jpg"
    end

    it "has an album" do
      Photo.new("x.jpg", @album).album.should == @album
    end

    describe "#src_path" do

      before(:each) do
        App.set :image_dirs, { :thumb => "small", :medium => "medium" }
      end
      
      it "returns the base photo path with no arguments" do
        Photo.new("x.jpg", @album).src_path.should == @album.path + "/x.jpg"
      end
      
      it "returns a subdired path for a named size" do
        Photo.new("x.jpg", @album).src_path(:thumb).should == @album.path + "/small/x.jpg"
      end
      
      it "returns nil for unknown size" do
        Photo.new("x.jpg", @album).src_path(:xyz).should be_nil
        # lambda { Photo.new("x.jpg", @album).src_path(:xyz) }.should_not raise_error
      end
      
    end

  end
end
