require 'sinatra/base'

module Poole
  class App < Sinatra::Base
    get '/' do
      @albums = Album.root.children
      erb :index
    end

    get '/albums/*' do
      @album = Album.find_by_path(params[:splat].first)
      @albums = @album.children
      erb :show_album
    end
  end
  
end

