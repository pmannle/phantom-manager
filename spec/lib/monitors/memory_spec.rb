require 'spec_helper'
require 'monitors/memory'

module Monitors

  describe Memory do

    subject {Memory}

    before do
      Phantom::Collector.stub(:running_phantoms_shell_output).and_return(phantoms_ps_shell_output)
      Cfg.memory_limit = 110000
      Cfg.memory_retries = 3
    end

    describe :perform_check do
      context "below memory_retries" do
        it "should not restart processes" do
          Phantom::Manager.should_not_receive(:restart)
          ( Cfg.memory_retries - 1 ).times { subject.perform_check }
        end
      end

      context "at memory_retries" do
        it "should restart process" do
          Phantom::Manager.should_receive(:restart).once
          Cfg.memory_retries.times { subject.perform_check }
        end
      end
    end

  end
end
