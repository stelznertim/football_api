# frozen_string_literal: true

require 'sequel'

class Team < Sequel::Model
  plugin :validation_helpers
  def validate
    super
    validates_presence %i[team_id name league]
  end
end
