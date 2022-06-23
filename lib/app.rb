require 'sinatra'
require 'sinatra/base'
require 'sequel'
require_relative 'models/team'
require_relative 'controller/team_controller'

Application = Rack::Builder.new do
  get '/' do
    'Welcome to the Football API!'
  end

  map '/teams' do
    run TeamController
  end
end
