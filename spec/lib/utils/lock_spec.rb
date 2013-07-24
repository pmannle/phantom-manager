require 'spec_helper'
require 'utils/lock'

module Utils

  describe Lock do
    describe :initialize do
      it "should be unlocked" do
        subject.should_not be_locked
      end
    end

    describe :lock do
      it "should be locked" do
        subject.lock.should be_locked
      end
    end

    describe :unlock do
      it "should be unlocked" do
        subject.lock.unlock.should_not be_locked
      end
    end

    describe :acquire do
      before do
        @lock = Lock.new
      end
      context "new lock" do
        it "should run method" do
          passed = false
          @lock.acquire do
            passed = true
          end

          passed.should be_true
        end
      end

      context "acquired lock" do
        it "should not run method" do
          passed = false
          @lock.acquire do
            @lock.acquire do
              passed = true
            end
          end

          passed.should be_false
        end
      end

      context "unlocking after done" do
        it "should be available" do
          passed = false
          @lock.acquire do
            passed = false
          end

          @lock.acquire do
            passed = true
          end

          passed.should be_true
        end
      end
    end
  end
end
