ENV['RACK_ENV'] = 'test'

require 'rspec'

require 'rack/test'
# require 'capybara'
# require 'capybara/rspec'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

Rspec.configure do |config|
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end

APP_ROOT = File.expand_path('..', File.dirname(__FILE__))
require File.join(File.dirname(__FILE__), '..', 'lib', 'poole')
require File.join(File.dirname(__FILE__), '..', 'lib', 'poole', 'cli')

# App config for test
Poole::App.set :environment, :test
Poole::App.albums_dir = "/tmp/poole-sandbox"
Poole::App.album_template_dir = File.join(APP_ROOT, "spec", "fixtures", "template")

# Ensure albums dir exists
unless File.exists? Poole::App.albums_dir
  FileUtils.mkdir Poole::App.albums_dir
end

$: << File.join(File.dirname(__FILE__), 'factories')
require 'album_factory'
