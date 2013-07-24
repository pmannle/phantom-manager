require 'spec_helper'
require 'monitors/restart_listener'

module Monitors
  describe RestartListener do

    subject {RestartListener}

    describe :respond_to_signal do
      before do
        subject.stub :sleep
        Phantom::Collector.stub(:running_phantoms_shell_output).and_return(phantoms_ps_shell_output)
      end

      it "should restart each phantom" do
        instances = Phantom::Collector.get_running_instances
        Phantom::Collector.stub get_running_instances: instances

        instances.each {|i| Phantom::Manager.should_receive(:restart).with(i).once }

        subject.respond_to_signal
      end


    end

  end
end
