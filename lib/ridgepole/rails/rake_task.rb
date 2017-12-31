require 'rake'
require 'rake/tasklib'
require 'shellwords'
require 'ridgepole/rails/restore_extensions_on_purge'

module Ridgepole
  module Rails
    class RakeTask < ::Rake::TaskLib
      def initialize(name=default_task_name)
        task name, :rails_env do |_t, args|
          yield self if block_given?
          command = build_command(args[:rails_env])
          options = {out: IO::NULL}
          command.execute(options)
        end
      end

      private

      def default_task_name
        self.class.name.demodulize.downcase
      end

      def operation
        self.class.name.demodulize.downcase
      end

      def build_command(env)
        Command.build(operation, env)
      end

      class Apply < self; end
      class Export < self; end
    end

    class Command
      RIDGEPOLE_COMMAND = 'bundle exec ridgepole'.shellsplit

      include FileUtils

      class << self
        def build(operation, env)
          const_get(operation.classify).new(env)
        end
      end

      def execute(options={})
        sh command, options
      end

      private

      def initialize(env)
        @env = env || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
      end

      def ignore_tables
        ActiveRecord::SchemaDumper.ignore_tables.map(&:source)
      end

      def options
        options_hash = {'-E' => @env, '-c' => 'config/database.yml'}
        options_hash['--ignore-tables'] = ignore_tables.join(',') if ignore_tables.present? # rubocop:disable Metrics/LineLength
        options_hash.to_a.flatten
      end

      class Export < self
        def command
          [*RIDGEPOLE_COMMAND, *%w(--export -o Schemafile), *options].shelljoin # rubocop:disable Lint/UnneededSplatExpansion
        end
      end

      class Apply < self
        def command
          [*RIDGEPOLE_COMMAND, *%w(--apply), *options].shelljoin # rubocop:disable Lint/UnneededSplatExpansion
        end
      end
    end
  end
end
