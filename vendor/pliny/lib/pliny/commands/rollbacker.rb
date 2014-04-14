require "sequel"
require "sequel/extensions/migration"

module Pliny::Commands
  class Rollbacker
    include Common

    def self.run(args, stream=$stdout)
      new(args).run!
    end

    def initialize(args={}, stream=$stdout)
      @args = args
      @stream = stream
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

    attr_accessor :args

    def migrations_path
      File.expand_path("db/migrate", Dir.pwd)
    end
  end
end
