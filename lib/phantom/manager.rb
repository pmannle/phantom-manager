require "phantom/manager/version"
require 'utils/logger'
require 'utils/cfg'
require 'nginx/manager'

module Phantom
  module Manager
    class << self

      def restart(process)
        $logger.info "restarting process #{process}"
        stop process
        start process
      end

      def start(process)
        $logger.info "starting process #{process.port}"
        process.start
        Nginx::Manager.add(process.port)
      end

      private 

      def stop(process)
        $logger.info "stopping process #{process}"
        Nginx::Manager.remove(process.port)
        sleep Cfg.phantom_termination_grace
        process.kill
      end

    end
  end
end

