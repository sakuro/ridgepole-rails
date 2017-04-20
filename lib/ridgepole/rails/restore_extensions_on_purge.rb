require 'active_record/base'
require 'active_record/tasks/database_tasks'
require 'active_support/core_ext/module/delegation'

module Ridgepole
  module Rails
    module RestoreExtensionsOnPurge
      delegate :establish_connection, :connection, to: ActiveRecord::Base

      # Restore extensions to recreated database if any
      def purge(configuration)
        establish_connection(configuration)
        saved_extensions = connection.extensions

        super

        # Re-establish connection since the last one is closed by super#purge
        establish_connection(configuration)
        saved_extensions.each do |extension|
          connection.enable_extension(extension)
        end
      end

      def self.prepended(mod)
        mod.extend(self)
      end
    end
  end
end

module ActiveRecord
  module Tasks
    module DatabaseTasks
      prepend Ridgepole::Rails::RestoreExtensionsOnPurge
    end
  end
end
