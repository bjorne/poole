require 'sinatra/base'

# Explicit require recommended for thread-safety
require 'haml'
require 'sass'

module Poole
  class App < Sinatra::Base

    # defaults
    set :image_dirs, { :thumb => "photos/small", :large => "photos/large" }
    set :public, Album.albums_dir
    
    get '/' do
      @albums = Album.root.children
      haml :index
    end

    get '/albums/*' do
      @album = Album.find_by_path!(params[:splat].first)
      @albums = @album.children
      haml :show_album
    end

    get '/stylesheets/site.css' do
      scss :site
    end
    
    helpers do
      def link_to(title, url)
        %Q[<a href="#{url}">#{title}</a>]
      end
    end

    error AlbumNotFoundException do
      halt 404
    end

    error do
      haml :"500"
    end

    not_found do
      haml :"404"
    end
  end
  
end
