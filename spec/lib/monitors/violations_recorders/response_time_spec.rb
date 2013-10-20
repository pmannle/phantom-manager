require 'spec_helper'
require 'monitors/violations_recorders/response_time'

module Monitors
  module ViolationsRecorders

    RESPONSE_TIME_THRESHOLD = 2

    describe ResponseTime do

      subject {ResponseTime}

      describe :process_is_violating? do

        before do
          Cfg.stub(:response_time_threshold).and_return(RESPONSE_TIME_THRESHOLD)
        end

        context "timeout" do
          before do
            subject.stub(:check_response_time).and_raise(Timeout::Error)
          end

          it "should return true" do
            subject.process_is_violating?(stub).should be_true
          end
        end

        context "fast response time" do
          before do
            subject.stub(:check_response_time).and_return(RESPONSE_TIME_THRESHOLD - 1)
          end

          it "should return false" do
            subject.process_is_violating?(stub).should be_false
          end
        end

        context "slow response time" do
          before do
            subject.stub(:check_response_time).and_return(RESPONSE_TIME_THRESHOLD + 1)
          end

          it "should return true" do
            subject.process_is_violating?(stub).should be_true
          end
        end
      end

    end
  end
end
