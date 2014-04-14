require "sequel"
require "sequel/extensions/migration"

module Pliny::Commands::DB
  class Dumper
    include Pliny::Commands::Common

    def initialize(args={})
      @args = args
    end

    def run!
      chroot!
      env_file, env = envs.first
      display "Dumping schema for #{env_file}"
      `pg_dump -i -s -x -O -f #{schema_path} #{env["DATABASE_URL"]}`
    end

    private

    def schema_path
      File.expand_path("db/schema.sql", Dir.pwd)
    end
  end
end
