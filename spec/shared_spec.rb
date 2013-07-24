require 'utils/logger'
require 'utils/cfg'
$cfg.nginx_conf = File.expand_path('../files/nginx.conf', __FILE__)
$cfg.new_nginx_conf = File.expand_path('../files/nginx.conf.new', __FILE__)

$logger = Logger.new(nil)

def generate_memory
  50000 + rand(50000)
end

def generate_process
  Phantom::Process.new(rand(1000), generate_memory, "phantomjs rndrme.js #{rand(2000)}", 8000 + rand(10))
end

def phantoms_data
  [
    {
      pid: 1000,
      memory_usage: 100000,
      command: "phantomjs rndrme.js 8002",
      port: 8002
    },
    {
      pid: 2000,
      memory_usage: 130000,
      command: "phantomjs rndrme.js 8003",
      port: 8003
    },
    {
      pid: 3000,
      memory_usage: 80000,
      command: "phantomjs rndrme.js 8006",
      port: 8006
    }
  ]
end

def data_to_ps(p)
 "#{p[:pid]} #{p[:memory_usage]} #{p[:command]}"
end

def phantoms_ps_shell_output
  phantoms_data.map {|p| data_to_ps(p) }.join("\n")
end
