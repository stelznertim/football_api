require './lib/app'
require 'rack/test'
require 'rspec'

RSpec.describe 'app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /' do
    
    it 'return 200' do
      get '/'
      expect(last_response.status).to eq(200)
    end
    it ' return Welcome to the League!' do
      get '/'
      expect(last_response.body).to eq('Welcome to the Football API!')
    end
  end
end
