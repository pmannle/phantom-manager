require 'phantom/manager'
require 'utils/logger'
require 'utils/cfg'


module Monitors
  class RestartListener
    class << self

      def run
        @restarting = false
        Signal.trap("USR2") do
          respond_to_signal
        end
      end

      private

      def respond_to_signal
        lock do
          $logger.info "Initiating restart sequence"

          Phantom::Collector.get_running_instances.each do |p|
            $logger.info "Restarting process on port #{p.port}"
            Phantom::Manager.restart(p)

            sleep $cfg.phantom_termination_grace
          end

          @restarting = false
        end
      end

      def lock
        if !@restarting
          @restarting = true
          yield
          @restarting = false
        else
          $logger.info "Already working"
        end
      end
    end
  end
end
