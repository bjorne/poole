# Generated by cucumber-sinatra. (2011-05-01 13:40:51 +0200)

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/app.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app = Poole::App

class AppWorld
  include Capybara
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  AppWorld.new
end
