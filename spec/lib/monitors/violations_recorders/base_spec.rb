require 'spec_helper'
require 'monitors/violations_recorders/base'

module Monitors
  module ViolationsRecorders
    describe Base do

      subject {Base}

      describe "abstract methods" do
        [:retries_limit, :process_attr].each do |method|
          it "should raise NotImplementedError on #{method}" do
            expect {subject.send(method)}.to raise_exception(NotImplementedError)
          end
        end

        it "should raise NotImplementedError on process_is_violating?" do
          expect {subject.send(:process_is_violating?,nil)}.to raise_exception(NotImplementedError)
        end
      end

      context "inheriting recorder" do

        RETRIES = 3
        PROCESS_ATTR = :attr
        VALUE_ATTR = :val
        VIOLATING_VALUE = 5

        class DummyRecorder < Base
          class << self
            def retries_limit
              RETRIES
            end

            def process_attr
              PROCESS_ATTR
            end

            def process_is_violating?(process)
              process.send(VALUE_ATTR) > VIOLATING_VALUE
            end
          end
        end

        describe :is_violating? do

          before do
            DummyRecorder.reset
            @p = Object.new
            @p.stub(PROCESS_ATTR).and_return(1)
          end


          context "non violating process" do

            before do
              @p.stub(VALUE_ATTR).and_return(VIOLATING_VALUE - 1)
            end

            it "should indicate not violating" do
              RETRIES.times do
                DummyRecorder.is_violating?(@p).should be_false
              end
            end
          end

          context "violating process" do

            before do
              @p.stub(VALUE_ATTR).and_return(VIOLATING_VALUE + 1)
            end

            context "below retry limit" do

              it "should indicate not violating" do
                (RETRIES-1).times do
                  DummyRecorder.is_violating?(@p).should be_false
                end
              end
            end

            context "equals retry limit" do

              it "should indicate violating" do
                (RETRIES-1).times do
                  DummyRecorder.is_violating?(@p)
                end
                DummyRecorder.is_violating?(@p).should be_true
              end

              it "should reset count after violation" do
                (RETRIES-1).times do
                  DummyRecorder.is_violating?(@p)
                end
                DummyRecorder.is_violating?(@p).should be_true
                (RETRIES-1).times do
                  DummyRecorder.is_violating?(@p).should be_false
                end
                DummyRecorder.is_violating?(@p).should be_true
              end
            end

            describe "count after check passed" do
              it "should be reset" do
                (RETRIES-1).times do
                  DummyRecorder.is_violating?(@p)
                end

                @p.stub(VALUE_ATTR).and_return(VIOLATING_VALUE-1)
                DummyRecorder.is_violating?(@p)

                @p.stub(VALUE_ATTR).and_return(VIOLATING_VALUE+1)

                (RETRIES-1).times do
                  DummyRecorder.is_violating?(@p).should be_false
                end

              end
            end
          end
        end

      end
    end
  end
end
