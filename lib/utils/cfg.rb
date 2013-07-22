require 'ostruct'
require 'yaml'

class Cfg
  def self.load
    cfg =  File.expand_path($options[:config])
    env = $options[:env]
    hash = YAML.load(File.open(cfg))[env]
    hash.each do |k,v|
      hash[k] = v.to_i if v =~ /^\d+$/
    end
    obj = OpenStruct.new hash
    obj.new_nginx_conf = "#{obj.nginx_conf}.new"

    $cfg = obj
  end
end
Cfg.load
