ENV['RACK_ENV'] = 'test'

require 'rspec'

require 'rack/test'
# require 'capybara'
# require 'capybara/rspec'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

APP_ROOT = File.expand_path(File.dirname(__FILE__), '..')
require File.join(File.dirname(__FILE__), '..', 'lib', 'poole')

Poole::App.set :environment, :test

# Set albums dir here.
Poole::Album.albums_dir = "/home/bjorne/sandbox" # File.expand_path(File.join(File.join(File.dirname(__FILE__), '..', 'sandbox')))

$: << File.join(File.dirname(__FILE__), 'factories')
require 'album_factory'
