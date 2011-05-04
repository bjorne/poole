require 'spec_helper'

module Poole
  describe "Browsing" do
    include Rack::Test::Methods
    include Webrat::Matchers

    def app
      Poole::App
    end

    describe "an album" do
      before(:each) do
        @album = create_album(:title => "Album", :photos => ["bar.jpg"])
        @photo = @album.photos.first
      end

      after(:each) do
        clean_albums
      end

      it "shows the thumbnails" do
        get '/albums/album'
        last_response.should have_selector(%Q{#album_photos .thumb img[src*="#{@photo.src_path(:thumb)}"]})
      end
    end
  end
end
