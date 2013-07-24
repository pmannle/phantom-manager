require 'phantom/manager'
require 'utils/logger'
require 'utils/cfg'
require 'utils/lock'


module Monitors
  class RestartListener
    class << self

      def run
        Signal.trap("USR2") do
          respond_to_signal
        end
      end

      def respond_to_signal
        lock.acquire do
          $logger.info "Initiating restart sequence"

          Phantom::Collector.get_running_instances.each do |p|
            $logger.info "Restarting process on port #{p.port}"
            Phantom::Manager.restart(p)

            sleep $cfg.phantom_termination_grace
          end

        end
      end

      private

      def lock
        @lock ||= Utils::Lock.new
      end

    end
  end
end
