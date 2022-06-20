require 'sinatra'
require 'sinatra/namespace'
require 'sequel'
require_relative '../models/team'
require_relative '../'

namespace 'api/v1' do
  before do
    content_type 'application/json'
  end

  get '/teams' do
    Team.all
  end
end
