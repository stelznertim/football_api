# frozen_string_literal: true

require_relative '../../lib/models/team'

FactoryBot.define do
  factory Team do
    name { 'Mock Team Name' }
    league { 'Super League' }
  end
end
