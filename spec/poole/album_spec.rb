require 'spec_helper'

module Poole
  describe Album do
    it "#path_to_dir converts a path to a dir" do
      Album.path_to_dir("hello").should == File.expand_path(File.join(Album.albums_dir, "hello"))
    end

    describe ".root" do
      it "is the base albums path" do
        Album.root.dir.should == Album.albums_dir
      end

      it "'s children are the root level albums" do
        album1 = create_album(:title => "One")
        Album.root.children.should == [album1]
        clean_albums
      end

      it "has no direct parent" do
        Album.root.parent.should be_nil
      end

      it "has empty parents array" do
        Album.root.parents.should == []
      end
    end

    describe "#children" do
      it "loads albums only once" do
        pending "Determine good way of disabling/enabling caching"
        album = create_album(:title => "One")
        album2 = create_album(:title => "Two")

        Album.root.children
        Album.should_not_receive(:new)
        Album.root.children

        clean_albums
      end
    end
    
    describe ".load_albums!" do
      it "loads and returns all albums" do
        # pending "Error?"
        # WTF!?
        album = create_album(:title => "One")
        album2 = create_album(:title => "Two")
        album3 = create_album(:title => "Three", :inside => "Two")
        Album.load_albums!.sort.should == [album, album2, album3].sort
        clean_albums
      end
    end
    
    describe ".find_by_path" do
      it "finds an album by path" do
        album = create_album(:title => "album")
        Album.reset
        Album.find_by_path("album").should == album
        clean_albums
      end

      it "uses cached albums on sequential finds" do
        Album.reset
        Album.should_receive(:load_albums!).and_return([])
        Album.find_by_path("hello")
        Album.should_not_receive(:load_albums!)
        Album.find_by_path("hello")
      end
    end

    describe "a nested album" do
      before(:each) do
        @outer = create_album(:title => "Outer")
        @inner = create_album(:title => "Inner", :inside => "Outer")
      end

      after(:each) do
        clean_albums
      end

      it "'s path includes the parents path" do
        @inner.dir.should match(/#{@outer.dir}/)
      end
    end


    describe ".new" do
      before(:each) do
        @yml = "xyz/abc"
      end
      
      it "reads its yaml file" do
        YAML.should_receive(:load_file).with(@yml).and_return(Hash.new)
        album = Album.new(@yml)
      end

      it "stores the metadata" do
        config = { :x => 1, :y => 2 }
        YAML.should_receive(:load_file).with(@yml).and_return(config)
        album = Album.new(@yml)
        album.config.should == config
      end

      it "symbolizes hash keys in config" do
        config = { "x" => 1, :y => 2, "z" => { "a" => 3, :b => 4 } }
        YAML.should_receive(:load_file).with(@yml).and_return(config)
        album = Album.new(@yml)
        album.config.should == { :x => 1, :y => 2, :z => { :a => 3, :b => 4 } }
      end
    end

    describe "instance" do
      before(:each) do
        @album = create_album(:title => "Hello World", :description => "Description")
      end

      after(:each) do
        clean_albums
      end

      describe "#title" do
        it "is read from yaml" do
          @album.title.should == "Hello World"
        end

        it "defaults to missing title constant" do
          @album.config[:title] = nil
          @album.title.should == Album::MISSING_TITLE
        end
      end

      describe "#description" do
        it "is read from yaml" do
          @album.description.should == "Description"
        end

        it "defaults to nil" do
          @album.config[:description] = nil
          @album.description.should be_nil
        end
      end

      it "has a path without leading slash" do
        @album.path.should_not =~ /^\//
      end
    end

    describe "#photos" do
      it "returns array of photos in the album" do
        photos = ["image1.jpg", "image2.jpg"]
        album = create_album(:title => "Hello", :photos => photos)
        album.photos.sort.should == photos.sort
        clean_albums
      end

      it "does not include files that are not photos" do
        photos = ["notimage.rb", "notimage.py", "image.jpg"]
        album = create_album(:title => "Hello", :photos => photos)
        album.photos.should == ["image.jpg"]
        clean_albums
      end
    end
  end
end
