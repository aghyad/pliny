require "sequel"
require "sequel/extensions/migration"

module Pliny::Commands::DB
  class Destroyer
    include Pliny::Commands::Common

    def initialize(args={})
      @args = args
    end

    def run!
      chroot!
      envs.each do |env_file, env|
        begin
          name = URI.parse(env["DATABASE_URL"]).path[1..-1]
          puts "Dropping database #{name}"
          db = Sequel.connect("postgres://localhost/postgres")
          db.run(%{DROP DATABASE IF EXISTS "#{name}"})
        end
      end
    end
  end
end
