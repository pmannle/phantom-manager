require 'spec_helper'
require 'monitors/response_time'

module Monitors

  describe ResponseTime do

    subject {ResponseTime}

    before do
      @process1 = Phantom::Process.new(1, 1, "", 1)
      @process2 = Phantom::Process.new(3, 3, "", 3)
      subject.stub running_instances: [@process1, @process2]
      Cfg.response_time_threshold = 2
      Cfg.response_time_check_retries = 2
    end

    describe :perform_check do
      context "violating process" do
        before do
          ViolationsRecorders::ResponseTime.stub(:is_violating?).with(@process1).and_return(true)
          ViolationsRecorders::ResponseTime.stub(:is_violating?).with(@process2).and_return(false)
        end

        it "should restart violating process" do
          Phantom::Manager.should_receive(:restart).with(@process1).once
          subject.perform_check
        end

        it "should not restart non violating process" do
          Phantom::Manager.should_not_receive(:restart).with(@process2)
          subject.perform_check
        end
      end
    end

  end
end
