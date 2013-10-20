require 'monitors/base'
require 'monitors/violations_recorders/response_time'

module Monitors
  class ResponseTime < Base

    class << self
      def perform_check
        log "Perfoming response time check..."

        all_processes_ok = true
        running_instances.each do |p|
          if ViolationsRecorders::ResponseTime.is_violating?(p)
            all_processes_ok = false
            log "process #{p} had a response time violation"
            Phantom::Manager.restart(p)
          end
        end

        log "All response time are ok" if all_processes_ok
      end

      def check_interval
        Cfg.response_time_check_interval
      end
    end

  end
end
