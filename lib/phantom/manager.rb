require "phantom/manager/version"
require 'utils/logger'
require 'utils/cfg'
require 'nginx/manager'

module Phantom
  module Manager
    class << self

      def restart(processes)
        processes = [*processes]
        $logger.info "restarting process #{processes}"
        stop processes
        start processes
      end

      def start(processes)
        processes = [*processes]
        $logger.info "starting process #{processes}"
        processes.each(&:start)
        Nginx::Manager.add(processes.map(&:port))
      end

      private 

      def stop(processes)
        processes = [*processes]
        $logger.info "stopping process #{processes}"
        Nginx::Manager.remove(processes.map(&:port))
        sleep Cfg.phantom_termination_grace
        processes.each(&:kill)
      end

    end
  end
end

