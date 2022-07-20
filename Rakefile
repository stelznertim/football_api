# frozen_string_literal: true

require 'rake'
require 'sequel'

DATABASE = "football_api_#{ENV.fetch('RACK_ENV', 'test')}".freeze

def connect_string
  "postgres://postgres:postgres@localhost:5432/#{DATABASE}"
end

def with_database(&block)
  Sequel.connect(connect_string, &block)
end

def with_postgres(&block)
  Sequel.connect(File.dirname(connect_string), &block)
end

def database_exists?(database)
  cmd = "SELECT 1 FROM pg_database WHERE datname='#{DATABASE}'"
  database.execute(cmd) == 1
end

namespace :db do
  desc 'Create database'
  task :create do
    with_postgres do |db|
      if database_exists?(db)
        warn "Database #{DATABASE} already exists"
      else
        begin
          db.execute("CREATE DATABASE #{DATABASE}")
          puts "Database #{DATABASE} successfully created"
        rescue Sequel::DatabaseError => e
          warn e.message
        end
      end
    end
  end

  desc 'Run database migrations'
  task :migrate, [:version] do |_, args|
    version = args[:version].to_i if args[:version]
    with_database do |db|
      directory = 'db/migrations'
      if Dir.exist?(directory) && !Dir.empty?(directory)
        db.extension(:pg_enum)
        db.extension :pg_array, :pg_json
        db.wrap_json_primitives = true
        Sequel.extension(:migration)
        Sequel::Migrator.run(db, directory, target: version)
        puts 'Database successfully migrated'
      end
    end
  end

  desc 'Drop database'
  task :drop do
    with_postgres do |db|
      if database_exists?(db)
        db.execute("DROP DATABASE #{DATABASE}")
        puts "Database #{DATABASE} successfully dropped"
      else
        warn "Database #{DATABASE} not found"
      end
    end
  end
end
