require 'rake'
require 'rake/tasklib'
require 'shellwords'

module Ridgepole
  module Rails
    class RakeTask < ::Rake::TaskLib
      def initialize(name)
        task name, :rails_env do |_t, args|
          self.operation = name
          yield self if block_given?
          sh Command.build(operation, args[:rails_env]).command
        end
      end

      attr_accessor :operation
    end

    class Command
      RIDGEPOLE_COMMAND = 'bundle exec ridgepole'.shellsplit

      class << self
        def build(operation, env)
          const_get(operation.classify).new(env)
        end
      end

      def initialize(env)
        @env = env || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
      end

      private

      def ignore_tables
        ActiveRecord::SchemaDumper.ignore_tables.map(&:source)
      end

      def options
        options_hash = { '-E' => @env, '-c' => 'config/database.yml' }
        options_hash['--ignore-tables'] = ignore_tables.join(',') if ignore_tables.size > 0
        options_hash.to_a.flatten
      end

      class Export < self
        def command
          [*RIDGEPOLE_COMMAND, *%w(--export -o Schemafile), *options].shelljoin
        end
      end

      class Apply < self
        def command
          [*RIDGEPOLE_COMMAND, *%w(--apply), *options].shelljoin
        end
      end
    end
  end
end
