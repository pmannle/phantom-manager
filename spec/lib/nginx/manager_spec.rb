require 'spec_helper'
require 'nginx/manager'

INITIAL_CONF=<<-CONF
upstream unicorn {
  server 127.0.0.1:8001;
}

upstream phantomjs {
  server 127.0.0.1:8002;
  server 127.0.0.1:8003;
  server 127.0.0.1:8004;
  server 127.0.0.1:8005;
  server 127.0.0.1:8006;
  server 127.0.0.1:8007;
  server 127.0.0.1:8008;
  server 127.0.0.1:8009;
  server 127.0.0.1:8010;
  server 127.0.0.1:8011;
}

server {
  server_name _

  location / {
    proxy_pass http://phantomjs;
  }
  blah
  bli
  omo
}
CONF

module Nginx
  describe Manager do
    let :ports do
      (8002..8011).to_a
    end

    subject {Manager}

    def port_defined?(port)
      File.readlines(Cfg.nginx_conf).grep(/#{port}/).size > 0
    end

    before do
      File.open(Cfg.nginx_conf, "w") do |f|
        f.puts(INITIAL_CONF)
      end

      subject.stub :reload_nginx
    end



    describe :remove do
      context "existing port" do
        it "should be removed" do
          expect {
            subject.remove(8003)
          }.to change{port_defined?(8003)}.from(true).to(false)
        end
      end

      context "multiple ports" do
        it "should be removed" do
          ports_to_remove = [8002, 8003, 8006]
          ports.each {|p| port_defined?(p).should be_true}
          subject.remove(ports_to_remove)
          ports_to_remove.each {|p| port_defined?(p).should be_false}
          (ports-ports_to_remove).each {|p| port_defined?(p).should be_true}
        end
      end
    end

    describe :add do
      context "not - existing port" do
        it "should be added" do
          expect {
            subject.add(8020)
          }.to change{port_defined?(8020)}.from(false).to(true)
        end
      end

      context "existing port" do
        it "should not be added" do
          expect {
            subject.add(8003)
          }.not_to change{port_defined?(8003)}
        end
      end

      context "multiple ports" do
        it "should add them all" do
          ports_to_add = [8012, 8013]
          ports.each {|p| port_defined?(p).should be_true}
          subject.add(ports_to_add)
          ports_to_add.each {|p| port_defined?(p).should be_true}
        end
      end
    end
  end
end
