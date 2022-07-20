# frozen_string_literal: true

require 'sinatra/base'
require 'oj'
require_relative '../models/team'

# Manages the endpoints for the teams
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
    team = Team.find(id:)
    halt_if_not_found unless team
    status 200
    Oj.dump({ id: team.id, type: 'team', name: team.name, league: team.league })
  end

  post '/' do
    team = Team.new(json_params)

    halt 422 unless team.save({ raise_on_failure: false })
    response.headers['Location'] = "/teams/#{team.id}"
    status 201
    Oj.dump({ id: team.id, type: 'team', name: team.name, league: team.league })
  end

  patch '/:id' do |id|
    team = Team.find(id:)
    halt_if_not_found unless team
    status 200
    new_attributes = json_params
    team.name = new_attributes['name'] unless new_attributes[:name].nil?
    team.league = new_attributes['league'] unless new_attributes[:league].nil?
    Oj.dump({ id: team.id, type: 'team', name: team.name, league: team.league })
  end

  delete '/:id' do |id|
    team = Team.find(id:)
    team&.destroy
    status 204
  end

  def json_params
    JSON.parse(request.body.read)
  rescue JSON::ParserError # kleinstes scope nutzen zum fehler abfangen JSON::ParserError
    halt 400, { message: 'Invalid JSON' }.to_json
  end

  def halt_if_not_found
    halt(404, { message: 'Team Not Found' }.to_json)
  end
end
