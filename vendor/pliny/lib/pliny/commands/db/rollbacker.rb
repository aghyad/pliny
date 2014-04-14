require "sequel"
require "sequel/extensions/migration"

module Pliny::Commands::DB
  class Rollbacker
    include Pliny::Commands::Common

    def initialize(args={})
      @args = args
    end

    def run!
      chroot!
      envs.each do |env_file, env|
        display "Rolling back #{env_file}"
        db = Sequel.connect(env["DATABASE_URL"])
        # always just roll back one step for now
        Sequel::Migrator.apply(db, migrations_path, -1)
      end
    end

    private

    def migrations_path
      File.expand_path("db/migrate", Dir.pwd)
    end
  end
end
