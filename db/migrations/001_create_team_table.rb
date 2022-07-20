# frozen_string_literal: true

require 'pg'
require 'sequel'

Sequel.migration do
  up do
    create_table(:teams) do
      primary_key :id, null: false
      column :name, String, null: false
      column :league, String, null: false
    end
  end
  down { drop_table(:books) }
end
