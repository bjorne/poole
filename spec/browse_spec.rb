require 'spec_helper'

module Poole
  describe "Browsing" do
    include Rack::Test::Methods

    def app
      Poole::App
    end

    describe "an album path" do
      it "should find album by path" do
        Album.should_receive(:find_by_path!).with('outer/inner/innerinner').and_raise(Exception)
        get '/albums/outer/inner/innerinner'
      end

      it "shows a 404 page if the album cannot be found" do
        get '/albums/does/not/exist'
        last_response.status.should be(404)
      end
    end

    describe "an album" do
      before(:each) do
        create_album(:title => "Album 1")
      end
      after(:each) { clean_albums }

      it "finds the album by path" do
        Album.should_receive(:find_by_path).with("album_1").and_return(double('album').as_null_object)
        get '/albums/album_1'
        last_response.status.should be(200)
      end
    end
    
    describe "an album without children" do
      before(:each) do
        create_album(:title => "Album 1")
        create_album(:title => "Album 2")
      end

      after(:each) do
        clean_albums
      end

      it "does not show the subalbums header" do
        get '/albums/album_1'
        last_response.status.should be(200)
        last_response.body.should_not =~ /Subalbums/
      end
    end
    
    describe "an album with children" do
      before(:each) do
        @outer = create_album(:title => "Outer")
        @inner = create_album(:title => "Inner", :inside => "Outer")
        get '/albums/outer'
      end

      after(:each) do
        clean_albums
      end

      it "shows the subalbums header" do
        last_response.status.should be(200)
        last_response.body.should =~ /Subalbums/
      end

      it "shows the inner album" do
        last_response.status.should be(200)
        last_response.body.should =~ /Inner/
      end

      it "does not show the outer album inside itself" do
        pending "Fix this"
        get '/albums/outer'
        last_response.status.should be(200)
        last_response.body.should_not =~ /Outer/
      end
    end

    describe "the front page" do
      it "finds the root's children" do
        Album.root.should_receive(:children).and_return([])
        get '/'
        last_response.status.should be(200)
      end

      describe "with existing albums in root" do
        before(:each) do
          create_album(:title => "Album 1")
          create_album(:title => "Album 2")
        end

        after(:each) do
          clean_albums
        end
        
        it "renders the albums titles" do
          get '/'
          last_response.status.should be(200)
          last_response.body.should =~ /Album 1/
          last_response.body.should =~ /Album 2/
        end
      end
    end
  end
end
