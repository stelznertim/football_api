require_relative 'spec_helper'
require_relative '../lib/app'
require_relative '../lib/controller/team_controller'
require_relative '../lib/models/team'

RSpec.describe TeamController do
  def app
    Application
  end

  describe 'GET /teams' do
    context 'with many teams in the db' do
      let!(:team_one) { create(:team) }
      let!(:team_two) { create(:team) }
      let(:expected_teams_arr) do
        Oj.dump([{ id: team_one.id, type: 'team', name: team_one.name, league: team_one.league },
                 { id: team_two.id, type: 'team', name: team_two.name, league: team_two.league }])
      end
      it 'returns all team objects' do
        get '/teams'
        expect(last_response.body).to eq(expected_teams_arr)
      end
    end

    context 'with no team in the db' do
      let(:expected_response) { '[]' }
      it 'returns empty array' do
        get '/teams'
        expect(last_response.body).to eq(expected_response)
      end
    end
  end

  describe 'GET teams/{id}' do
    let(:team_object) { Oj.dump({ id: team_one.id, type: 'team', name: team_one.name, league: team_one.league }) }
    let!(:team_one) { create(:team) }
    let(:id) { team_one.id }
    context 'when the id is not found' do
      it 'returns 404 and error message' do
        get "/teams/#{id + 1}"
        expect(last_response.status).to eq(404)
      end
    end

    context 'when id is found' do
      it 'returns 201 and team object' do
        get "/teams/#{id}"
        expect(last_response.status).to eq(201)
        expect(last_response.body).to eq(team_object)
      end
    end
  end

  describe 'POST teams/' do
    let(:team_object) { { id: team_one.id, type: 'team', name: request_body.name, league: team_one.league } }
    let(:request_body) { { name: 'SV Hafen Rostock', league: 'Landesliga' } }
    let(:invalid_request_body) { { name: 'SV Hafen Rostock' } }
    context 'with correct request_body' do
      it 'returns 201 & team object' do
        post '/', request_body
        expect(last_response.body).to eq(team_object)
        expect(last_response.status).to eq(201)
      end
    end

    context 'with invalid request_body' do
      it 'returns 422 and error message' do
        post '/', invalid_request_body
        expect(last_response.status).to eq(422)
        # expect(last_response.error).to include('Wrong request body format.')
      end
    end
  end
end
