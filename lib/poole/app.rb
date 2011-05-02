require 'sinatra/base'

# Explicit require recommended for thread-safety
require 'haml'
require 'sass'

module Poole
  class App < Sinatra::Base
    get '/' do
      @albums = Album.root.children
      haml :index
    end

    get '/albums/*' do
      @album = Album.find_by_path(params[:splat].first)
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
    
  end
  
end

