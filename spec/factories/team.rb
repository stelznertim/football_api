# frozen_string_literal: true

require_relative '../../lib/models/team'

FactoryBot.define do
  factory :team do
    sequence(:team_id)
    name { 'Mock Team Name' }
    league { 'Super League' }
  end
end
