require 'phantom/process'

module Phantom
  class Collector
    class << self

      def on_port(port)
        get_running_instances.find {|p| p.port == port}
      end

      def get_running_instances
        lines = running_phantoms_shell_output.split("\n")
        parse_processes lines
      end

      def missing_ports
        required_ports - get_running_instances.map(&:port)
      end

      def required_ports
        (Cfg.phantom_base_port..(Cfg.phantom_base_port+Cfg.phantom_processes_number-1)).to_a
      end

      private

      def parse_processes(lines)
        processes = lines.map {|l| Phantom::Process.from_string(l) }
        bad_processes = processes.select {|p| !required_ports.include?(p.port)}
        log_error(bad_processes, lines) if bad_processes.any?
        processes.select {|p| required_ports.include?(p.port)}
      end

      def running_phantoms_shell_output
        `#{running_phantoms_shell_command}`
      end

      def running_phantoms_shell_command
        "ps -e -www -o pid,rss,command | grep 'phantomjs' | grep -v sh | grep -v grep"
      end

      def log_error(processes, lines)
        $logger.error "Collector got bad process!"
        $logger.error "Processes were #{processes}"
        $logger.error "lines were: #{lines}"
      end

    end
  end
end
