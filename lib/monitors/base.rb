require 'utils/cfg'
require 'utils/logger'
require 'phantom/manager'
require 'phantom/collector'

module Monitors
  class Base
    extend Logging

    class << self
      def run(custom_logger = $logger)
        @logger = custom_logger

        loop do
          log "Performing Check..."
          perform_check
          sleep check_interval
        end
      end

      protected

      def perform_check
        raise NotImplementedError.new
      end

      def check_interval
        raise NotImplementedError.new
      end
      
      def running_instances
        Phantom::Collector.get_running_instances
      end

    end

  end
end
