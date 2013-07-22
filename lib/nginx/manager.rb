require 'utils/logger'
require 'utils/cfg'

module Nginx
  class Manager
    class << self

      def remove(port)
        $logger.info "removing #{port} from nginx"
        modify_nginx do |ofile, iline|
          ofile.puts(iline) unless iline =~ /#{port}/
        end
      end

      def add(port)
        $logger.info "adding #{port} to nginx"
        if !port_defined?(port)
          modify_nginx do |ofile, iline|
            ofile.puts(iline)
            ofile.puts(phantom_upstream(port)) if iline =~ /upstream phantomjs/
          end
        else
          $logger.info "port #{port} already defined"
        end
      end

      private

      def phantom_upstream(port)
        "  server 127.0.0.1:#{port} fail_timeout=0; # #{Time.now}"
      end

      def port_defined?(port)
        File.readlines($cfg.nginx_conf).grep(/#{port}/).size > 0
      end

      def switch_nginx_configs
        $logger.info "switching nginx configurations"
        `mv #{$cfg.new_nginx_conf} #{$cfg.nginx_conf}`
      end

      def reload_nginx
        $logger.info "reloading nginx"
        `nginx -s reload`
      end

      def modify_nginx
        File.open($cfg.new_nginx_conf, "w") do |ofile|
          File.foreach($cfg.nginx_conf) do |iline|
            yield ofile, iline
          end
        end
        switch_nginx_configs
        reload_nginx
      end

    end
  end
end
