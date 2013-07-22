require 'spec_helper'
require 'utils/limited_array'

describe LimitedArray do

  describe :initialize do
    it "should have stated limit" do
      arr = LimitedArray.new(5)
      arr.limit.should eq 5
    end
  end

  describe :full? do
    context "zero length array" do
      it "should return true" do
        LimitedArray.new(0).should be_full
      end
    end

    context "non-zero length array" do
      subject { LimitedArray.new(1) }

      it "should return false" do
        subject.should_not be_full
      end

      context "filled array" do
        it "should return true" do
          subject << :item
          subject.should be_full
        end

      end
    end
  end

  describe :<< do
    subject { LimitedArray.new(3) }

    it "should allow 3 items" do
      3.times {subject << :item}
      subject.should =~ [:item, :item, :item ]
    end

    it "should keep only 3 items" do
      5.times { |i| subject << "item#{i}"}
      subject.should =~ ["item2", "item3", "item4"]
    end
  end

  describe :sum do
    subject {LimitedArray.new(3)}

    it "sum correctly" do
      subject << 5
      subject << 4
      subject << 3
      subject.sum.should eq 12
    end
  end

  describe :average do

    subject {LimitedArray.new(3)}

    it "average correctly" do
      subject << 5
      subject << 4
      subject << 3
      subject.average.should eq 4
    end
  end
end
