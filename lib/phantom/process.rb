require 'utils/logger'
require 'utils/cfg'
require 'utils/shell'

module Phantom
  class Process
    attr_accessor :pid, :memory_usage, :command, :port

    class << self

      def from_string(str)
        args = parse_string(str)
        new(*args)
      end

      private
      
      def parse_string(str)
        parts = str.split
        pid = parts[0].to_i
        memory_usage = parts[1].to_i
        command = parts[2..-1].join(" ")
        port = parts.last.to_i

        [pid, memory_usage, command, port]
      end

    end

    def initialize(pid = nil, memory_usage = nil, command = nil, port = nil)
      @pid = pid
      @memory_usage = memory_usage
      @command = command
      @port = port
    end

    def kill
      $logger.info "killing #{self}"
      Utils::Shell.execute "kill #{pid}"
    end

    def start
      $logger.info "starting phantomjs on port #{port}"
      Utils::Shell.execute start_command
    end

    def to_s
      inspect
    end

    def inspect
      "pid: #{pid}, port: #{port}, memory_usage: #{memory_usage}, command: #{command}"
    end
    private

    def start_command
      "cd #{Cfg.rails_root} && phantomjs rndrme.js #{port} >>#{Cfg.phantom_log_path} 2>&1 &"
    end

  end
end
