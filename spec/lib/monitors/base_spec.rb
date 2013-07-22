require 'spec_helper'
require 'monitors/base'

module Monitors
  describe Base do
    context "perform_check not implemented" do
      it "should raise NotImplementedError" do
        expect {
          Base.run
        }.to raise_exception(NotImplementedError)
      end
    end
  end
end
