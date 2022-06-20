require_relative '../lib/controller/team_controller'
require_relative '../lib/models/team'
require_relative 'spec_helper'

RSpec.describe 'team_controller' do
  def app
    Sinatra::Application
  end

  describe 'GET /teams' do
    context 'with many teams in the db' do
      let(:team_one) { create(:team) }
      let(:team_two) { create(:team) }
      before do
        team_one
        team_two
      end
      it 'returns all team objects' do
        get 'api/v1/teams'
        expect(last_response.body).to eq([team_one, team_two])
      end
    end

    context 'with no team in the db' do
      let(:empty_hash) { { data: nil } }
      xit 'returns empty data hash' do
        get 'api/v1/teams'
        expect(last_response.body).to eq(empty_hash)
      end
    end
  end
end
