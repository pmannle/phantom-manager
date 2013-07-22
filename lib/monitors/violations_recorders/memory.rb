require 'monitors/violations_recorders/base'

module Monitors
  module ViolationsRecorders
    class Memory < Base
      class << self

        def retries_limit
          $cfg.memory_retries
        end

        def process_attr
          :pid
        end

        def process_is_violating?(process)
          process.memory_usage > $cfg.memory_limit
        end

      end
    end
  end
end
