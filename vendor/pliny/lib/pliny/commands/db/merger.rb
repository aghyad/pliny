require "sequel"
require "sequel/extensions/migration"

module Pliny::Commands::DB
  class Merger
    include Pliny::Commands::Common

    def initialize(args={})
      @args = args
    end

    def run!
      chroot!
      Destroyer.run
      Creator.run
      Loader.run
      Migrator.run
      Dumper.run
      display "Removing migrations"
      FileUtils.rm Dir["#{migrations_path}/*.rb"]
    end

    private

    def migrations_path
      File.expand_path("db/migrate", Dir.pwd)
    end
  end
end
