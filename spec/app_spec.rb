require './lib/app'
require 'rack/test'
require 'rspec'
require 'database_cleaner-sequel'
require 'oj'
require 'json'

RSpec.describe 'app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /' do
    it 'return 200' do
      expect(last_response.status).to eq(200)
    end
    it ' return Welcome to the League!' do
      expect(last_response.body).to eq('Welcome to the League!')
    end
  end
end
