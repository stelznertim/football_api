# frozen_string_literal: true

require 'sequel'

DATABASE_NAME = "football_api_#{ENV.fetch('RACK_ENV', 'test')}".freeze
DB = Sequel.connect("postgres://postgres:postgres@localhost:5432/#{DATABASE_NAME}")

class Team < Sequel::Model
  plugin :validation_helpers
  def validate
    super
    validates_presence %i[ name league]
  end
end
