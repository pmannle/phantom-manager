require 'spec_helper'
require 'phantom/collector'

module Phantom
  describe Collector do
    subject {Collector}

    before do
      $cfg.phantom_processes_number = 5
      $cfg.phantom_base_port = 8002
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


  end
end
