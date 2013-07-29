require 'utils/logger'
require 'utils/cfg'
require 'utils/shell'

module Nginx
  class Manager
    class << self

      def remove(ports)
        ports = [*ports]
        $logger.info "removing #{ports} from nginx"
        modify_nginx do |ofile, iline|
          ofile.puts(iline) if !line_matches_ports(iline, ports)
        end
      end

      def add(ports)
        ports = [*ports]
        $logger.info "adding #{ports} to nginx"
        modify_nginx do |ofile, iline|
          ofile.puts(iline)
          if iline =~ /upstream phantomjs/
            ports.each do |port|
              ofile.puts(phantom_upstream(port)) unless port_defined?(port)
            end
          end
        end
      end

      private

      def phantom_upstream(port)
        "  server 127.0.0.1:#{port} fail_timeout=0; # #{Time.now}"
      end

      def port_defined?(port)
        File.readlines(Cfg.nginx_conf).grep(/#{port}/).size > 0
      end

      def switch_nginx_configs
        $logger.info "switching nginx configurations"
        `mv #{Cfg.new_nginx_conf} #{Cfg.nginx_conf}`
      end

      def reload_nginx
        $logger.info "reloading nginx"
        Utils::Shell.execute "nginx -s reload"
      end

      def modify_nginx
        File.open(Cfg.new_nginx_conf, "w") do |ofile|
          File.foreach(Cfg.nginx_conf) do |iline|
            yield ofile, iline
          end
        end
        switch_nginx_configs
        reload_nginx
      end

      def line_matches_ports(line, ports)
        line =~ ports_regexp(ports)
      end

      def ports_regexp(ports)
        /#{ports.join("|")}/
      end

    end
  end
end
