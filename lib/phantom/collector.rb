require 'phantom/process'

module Phantom
  class Collector
    class << self

      def get_running_instances
        lines = running_phantoms_shell_output.split("\n")
        lines.map {|l| Phantom::Process.from_string(l) }
      end

      def missing_ports
        required_ports - get_running_instances.map(&:port)
      end

      private

      def running_phantoms_shell_output
        `ps -e -www -o pid,rss,command | grep 'phantomjs' | grep -v sh | grep -v grep`
      end

      def required_ports
        ($cfg.phantom_base_port..($cfg.phantom_base_port+$cfg.phantom_processes_number-1)).to_a
      end
    end
  end
end
