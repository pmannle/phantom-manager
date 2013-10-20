require 'monitors/violations_recorders/base'

module Monitors
  module ViolationsRecorders
    class ResponseTime < Base
      class << self
        def retries_limit
          Cfg.response_time_check_retries
        end

        def process_attr
          :pid
        end

        def process_is_violating?(process)
          time = Cfg.response_time_threshold 
          begin 
            Timeout.timeout(Cfg.response_time_threshold) do 
              time = check_response_time(process)
            end
          rescue Timeout::Error
            return true
          end
          time > Cfg.response_time_threshold
        end

        private

        def check_response_time(process)
          `curl -o /dev/null -s -w %{time_total} #{process_url(process)}`.to_f
        end

        def process_url(process)
          "http://localhost:#{process.port}"
        end
      end
    end
  end
end
