require 'phantom/process'

module Phantom
  class Collector
    class << self

      def on_port(port)
        get_running_instances.find {|p| p.port == port}
      end

      def get_running_instances
        lines = running_phantoms_shell_output.split("\n")
        lines.map {|l| Phantom::Process.from_string(l) }
      end

      def missing_ports
        required_ports - get_running_instances.map(&:port)
      end

      def required_ports
        ($cfg.phantom_base_port..($cfg.phantom_base_port+$cfg.phantom_processes_number-1)).to_a
      end

      private

      def running_phantoms_shell_output
        `#{running_phantoms_shell_command}`
      end

      def running_phantoms_shell_command
        "ps -e -www -o pid,rss,command | grep 'phantomjs' | grep -v sh | grep -v grep"
      end

    end
  end
end
