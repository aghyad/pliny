require "sequel"
require "sequel/extensions/migration"

module Pliny::Commands::DB
  class Loader
    include Pliny::Commands::Common

    def initialize(args={})
      @args = args
    end

    def run!
      chroot!
      envs.each do |env_file, env|
        display "Loading schema for #{env_file}"
        db = Sequel.connect(env["DATABASE_URL"])
        db.run(File.read(schema_path))
      end
    end

    private

    def schema_path
      File.expand_path("db/schema.sql", Dir.pwd)
    end
  end
end
