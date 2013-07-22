require 'spec_helper'
require 'utils/shell'

module Utils
  describe Shell do
    subject {Shell}

    describe :execute do
      it "should run command" do
        cmd = "echo blah"
        Shell.should_receive(:system).with(cmd).once

        Shell.execute cmd
      end
    end

  end
end
