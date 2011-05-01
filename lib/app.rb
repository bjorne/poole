require 'sinatra/base'

module Poole
  class App < Sinatra::Base
    get '/' do
      "hello worlds"
    end
  end
  
end

