require 'ostruct'
require 'yaml'

class Cfg
  class << self

    def method_missing(method_sym, *arguments, &block)
      cfg.send(method_sym, *arguments, &block)
    end
     
    def cfg
      @cfg ||= Cfg.load
    end

    def load
      cfg =  File.expand_path($options[:config])
      env = $options[:env]
      hash = YAML.load(File.open(cfg))[env]
      hash.each do |k,v|
        hash[k] = v.to_i if v =~ /^\d+$/
      end
      obj = OpenStruct.new hash
      obj.new_nginx_conf = "#{obj.nginx_conf}.new"

      @cfg = obj
    end
  end
end
