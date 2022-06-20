# server.rb
require 'sinatra'
require 'sinatra/namespace'
require 'sequel'

DATABASE_NAME = "football_api_#{ENV.fetch('RACK_ENV', 'test')}".freeze
DB = Sequel.connect("postgres://postgres:postgres@localhost:5432/#{DATABASE_NAME}")

get '/' do
  'Welcome to the Football API!'
end
