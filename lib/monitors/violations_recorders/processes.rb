require 'monitors/violations_recorders/base'

module Monitors
  module ViolationsRecorders
    class Processes < Base
      class << self
        def retries_limit
          Cfg.processes_check_retries
        end

        def process_attr
          :port
        end

        def process_is_violating?(process)
          Phantom::Collector.missing_ports.include?(process.port)
        end
      end
    end
  end
end
