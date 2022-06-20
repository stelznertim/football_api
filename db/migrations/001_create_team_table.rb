require 'pg'
require 'sequel'

Sequel.migration do
  up do
    create_table(:teams) do
      primary_key :team_id, null: false
      column :name, String, null: false
      column :league, String, null: false
    end
  end
  down do
    drop_table(:books)
  end
end
