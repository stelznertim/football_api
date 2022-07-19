require 'sinatra/base'
require 'oj'
require_relative '../models/team'

class TeamController < Sinatra::Application
  after do
    content_type 'application/json'
  end

  get '/' do
    teams = Team.all.map do |team|
      { id: team.id, type: 'team', name: team.name, league: team.league }
    end
    Oj.dump(teams)
  end

  get '/:id' do |id|
    halt 404 unless Team.find(id:)
    status 201
    team = Team.find(id:)
    Oj.dump({ id: team.id, type: 'team', name: team.name, league: team.league })
  end

  post '/' do
    team = Team.new(json_params)

    halt 422 unless team.save({ raise_on_failure: false })
    response.headers['Location'] = "/teams/#{team.id}"
    status 201
    Oj.dump({ id: team.id, type: 'team', name: team.name, league: team.league })
  end

  def json_params
    JSON.parse(request.body.read)
  rescue JSON::ParserError # kleinstes scope nutzen zum fehler abfangen JSON::ParserError
    halt 400, { message: 'Invalid JSON' }.to_json
  end
end
