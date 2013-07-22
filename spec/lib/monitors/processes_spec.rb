require 'spec_helper'
require 'monitors/processes'

module Monitors
  describe Processes do

    subject {Processes}

    describe :perform_check do

      before do
        ViolationsRecorders::Processes.reset
      end

      context "no missing ports" do
        before do
          Phantom::Collector.stub(:missing_ports).and_return([])
        end

        it "should not create instances" do
          Phantom::Manager.should_not_receive(:start)
          subject.perform_check
        end
      end
      
      context "two missing ports" do

        before do
          @p1 = Phantom::Process.new
          @p1.port = 8004
          @p2 = Phantom::Process.new
          @p2.port = 8005
          Phantom::Collector.stub(:missing_ports).and_return([@p1, @p2].map(&:port))
        end

        it "should create two new instances" do
          Phantom::Manager.should_receive(:start).twice
          $cfg.processes_check_retries.times {subject.perform_check}
        end
      end

    end

  end
end
