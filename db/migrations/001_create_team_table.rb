require 'pg'
require 'sequel'

Sequel.migration do
  up do
    create_table(:teams) do
      primary_key :team_id, null: false
      String :name, null: false
      String :league, null: false
      Array :players
    end
  end
  down do
    drop_table(:books)
  end
end
