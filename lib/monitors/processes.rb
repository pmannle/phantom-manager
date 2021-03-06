require 'monitors/base'
require 'monitors/violations_recorders/processes'

module Monitors
  class Processes < Base

    class << self
      def perform_check
        missing_processes = Phantom::Collector.missing_ports.map do |port|
          p = Phantom::Process.new
          p.port = port
          p
        end

        missing_processes.each do |p|
          if ViolationsRecorders::Processes.is_violating?(p)
            log "found missing phantom on port #{p.port}"
            Phantom::Manager.start(p)
          end
        end

        log "All processes are running OK" if missing_processes.empty?
      end

      def check_interval
        Cfg.processes_check_interval
      end
    end

  end
end
