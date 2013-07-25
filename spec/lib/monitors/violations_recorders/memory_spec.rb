require 'spec_helper'
require 'monitors/violations_recorders/memory'

module Monitors
  module ViolationsRecorders
  describe Memory do

      subject {Memory}

      before :each do
        subject.reset
      end

      describe :is_violating? do

        let(:violating_memory) { Cfg.memory_limit + 10}
        let(:valid_memory) { Cfg.memory_limit - 10}

        context "violating process" do

          before do
            @p = generate_process
            @p.memory_usage = violating_memory
          end

          it "should return true" do
            (Cfg.memory_retries-1).times do
              subject.is_violating?(@p).should be_false
            end

            subject.is_violating?(@p).should be_true
          end
        end

        context "not violating process" do

          before do
            @p = generate_process
            @p.memory_usage = valid_memory
          end

          it "should return false" do
            Cfg.memory_retries.times do
              subject.is_violating?(@p).should be_false
            end
          end

          describe "violations reset" do

            it "reset violations if valid memory detected one" do
              @p.memory_usage = violating_memory
              (Cfg.memory_retries-1).times do
                subject.is_violating?(@p).should be_false
              end

              @p.memory_usage = valid_memory

              subject.is_violating?(@p).should be_false

              @p.memory_usage = violating_memory
              (Cfg.memory_retries-1).times do
                subject.is_violating?(@p).should be_false
              end
              subject.is_violating?(@p).should be_true
            end

          end

        end
      end
  end
  end
end
