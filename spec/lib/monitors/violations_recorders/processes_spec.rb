require 'spec_helper'
require 'monitors/violations_recorders/processes'

module Monitors
  module ViolationsRecorders

    describe Processes do

      subject {Processes}

      before :each do
        subject.reset
      end

      describe :is_violating? do

        before do
          Phantom::Collector.stub(:missing_ports).and_return([8004])
          @p = Phantom::Process.new
          @p.port = 8004
          $cfg.processes_check_retries = 3
        end

        context "below retries limit" do
          let(:retries) {$cfg.processes_check_retries - 1}

          it "should return false" do
            retries.times do
              subject.is_violating?(@p).should be_false
            end
          end

        end

        context "equals retries limit" do

          let(:retries) {$cfg.processes_check_retries}

          it "should return false" do
            (retries-1).times do
              subject.is_violating?(@p).should be_false
            end
            subject.is_violating?(@p).should be_true
          end
        end

      end

    end
  end
end
