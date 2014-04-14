require "sequel"
require "sequel/extensions/migration"

module Pliny::Commands::DB
  class Migrator
    include Pliny::Commands::Common

    def initialize(args={})
      @args = args
    end

    def run!
      chroot!
      envs.each do |env_file, env|
        display "Migrating #{env_file}"
        db = Sequel.connect(env["DATABASE_URL"])
        Sequel::Migrator.apply(db, migrations_path)
      end
    end

    private

    def migrations_path
      File.expand_path("db/migrate", Dir.pwd)
    end
  end
end
