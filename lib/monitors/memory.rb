require 'monitors/base'
require 'monitors/violations_recorders/memory'

module Monitors
  class Memory < Base

    class << self

      def perform_check
        logger.info "Perfoming memory check..."

        running_instances.each do |p|
          if ViolationsRecorders::Memory.is_violating?(p)
            logger.info "process #{p.pid} was found bad!"
            Phantom::Manager.restart(p)
          end
        end

      end

      def check_interval
        Cfg.memory_check_interval
      end
    end

  end
end
