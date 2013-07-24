require 'spec_helper'
require 'monitors/restart_listener'

module Monitors
  describe RestartListener do

    subject {RestartListener}

    describe :respond_to_signal do
      before do
        subject.stub :sleep
      end


    end

  end
end
