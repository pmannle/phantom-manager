require 'monitors/violations_recorders/base'
require 'timeout'

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
          res = `curl -o /dev/null -s -w %{time_total}@%{http_code} --header "X-Backend-Host: #{Cfg.response_time_check_host}" --header "X-Phantom: true" #{process_url(process)}`
          res.split("@").first.to_f
        end

        def process_url(process)
          "http://localhost:#{process.port}#{Cfg.response_time_check_path}"
        end
      end
    end
  end
end
