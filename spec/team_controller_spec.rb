# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/app'
require_relative '../lib/controller/team_controller'
require_relative '../lib/models/team'

RSpec.describe TeamController do
  def app
    Application
  end

  describe 'GET /teams' do
    let!(:team_one) { create(:team) }
    let!(:team_two) { create(:team) }
    let(:expected_teams_arr) do
      Oj.dump(
        [
          {
            id: team_one.id,
            type: 'team',
            name: team_one.name,
            league: team_one.league,
          },
          {
            id: team_two.id,
            type: 'team',
            name: team_two.name,
            league: team_two.league,
          },
        ],
      )
    end
    it 'returns all team objects' do
      get '/teams'
      expect(last_response.body).to eq(expected_teams_arr)
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
    let(:team_object) do
      Oj.dump(
        {
          id: team_one.id,
          type: 'team',
          name: team_one.name,
          league: team_one.league,
        },
      )
    end
    let!(:team_one) { create(:team) }
    let(:id) { team_one.id }

    it 'returns 201 and team object' do
      get "/teams/#{id}"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(team_object)
    end

    context 'when the id is not found' do
      it 'returns 404 and error message' do
        get "/teams/#{id + 1}"
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'POST /teams' do
    let(:team_one) do
      build(:team, name: 'SV Hafen Rostock', league: 'Landesliga')
    end
    let(:team_object) do
      { type: 'team', name: team_one.name, league: team_one.league }
    end

    let(:request_body) { { name: team_one.name, league: team_one.league } }
    let(:invalid_request_body) { { name: 'SV Hafen Rostock' } }

    it 'returns 201 & team object' do
      post '/teams', request_body.to_json
      expect(last_response.status).to eq(201)
      expect(Oj.load(last_response.body, symbol_keys: true)).to include(
        team_object,
      )
    end

    context 'with invalid request_body' do
      it 'returns 422 and error message' do
        post '/teams', invalid_request_body.to_json
        expect(last_response.status).to eq(422)
        # expect(last_response.error).to include('Wrong request body format.')
      end
    end
  end

  describe 'PATCH /teams/:id' do
    let!(:team) { create(:team) }
    let(:team_object) { { type: 'team', name: team.name, league: team.league } }
    let(:id) { team.id }
    let(:request_body) { { name: 'SG Olympia Leipzig', league: 'Landesliga' } }
    it ' returns 201 and updates team' do
      patch "/teams/#{id}", request_body.to_json
      expect(last_response.status).to eq(200)
      expect(Oj.load(last_response.body, symbol_keys: true)).to include(
        team_object,
      )
    end

    context 'with invalid params' do
      let(:request_body) { { food: 'Hot Dog' } }
      it 'returns 422' do
        patch "/teams/#{id}", request_body.to_json
        expect(last_response.status).to eq(200)
        expect(Oj.load(last_response.body, symbol_keys: true)).to include(
          team.values,
        )
      end
    end
  end

  describe 'DELETE /teams/:id' do
    let!(:team) { create(:team) }
    let(:id) { team.id }
    context 'when team exists' do
      it 'returns 204 and is deleted' do
        get "/teams/#{id}"
        expect(last_response.status).to eq(200)
        delete "/teams/#{id}"
        expect(last_response.status).to eq(204)
        get "/teams/#{id}"
        expect(last_response.status).to eq(404)
      end
    end

    context 'when team does not exist' do
      let!(:team) { create(:team) }
      let(:id) { team.id }
      it 'returns 204' do
        delete "/teams/#{id}"
        expect(last_response.status).to eq(204)
      end
    end
  end
end
