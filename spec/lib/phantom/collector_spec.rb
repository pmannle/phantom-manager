require 'spec_helper'
require 'phantom/collector'

module Phantom
  describe Collector do
    subject {Collector}

    before do
      Cfg.phantom_processes_number = 5
      Cfg.phantom_base_port = 8002
      subject.stub(:running_phantoms_shell_output).and_return(phantoms_ps_shell_output)
    end

    describe :get_running_instances do

      it "should generate correct instances" do
        generated_phantoms = subject.get_running_instances
        
        generated_phantoms.size.should eq 3
        generated_phantoms.all? {|p| p.instance_of? Phantom::Process}.should be_true

        phantoms_data.each_with_index do |data, i|
          data.each do |attr, val|
            generated_phantoms[i].send(attr).should eq val
          end
        end

      end
    end

    describe :missing_ports do
      it "should return required ports which phantoms do not run at" do
        subject.missing_ports.should =~ [8004, 8005]
      end
    end

    describe :required_ports do
      it "should return all ports from configuration as array" do
        subject.required_ports.should =~ [8002, 8003, 8004, 8005, 8006]
      end
    end

    describe :on_port do
      before do
        subject.stub(:running_phantoms_shell_output).and_return(phantoms_ps_shell_output)
        @data = phantoms_data.first
      end

      it "should return right process" do
        p = subject.on_port(@data[:port])
        @data.each do |attr, val|
          p.send(attr).should eq val
        end
      end
    end


  end
end
