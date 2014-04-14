require "sequel"
require "sequel/extensions/migration"

module Pliny::Commands::DB
  class Creator
    include Pliny::Commands::Common

    def initialize(args={})
      @args = args
    end

    def run!
      chroot!
      envs.each do |env_file, env|
        begin
          name = URI.parse(env["DATABASE_URL"]).path[1..-1]
          puts "Creating database #{name}"
          db = Sequel.connect("postgres://localhost/postgres")
          db.run(%{CREATE DATABASE "#{name}"})
        rescue Sequel::DatabaseError
          raise unless $!.message =~ /already exists/
        end
      end
    end
  end
end
