require 'spec_helper'
require 'phantom/manager'

module Phantom
  describe Manager do

    subject {Manager}

    describe :start do

      let(:p) {generate_process}

      it "should start new phantom process" do
        p.should_receive :start
        subject.start(p)
      end

      it "should add port to nginx conf" do
        Nginx::Manager.should_receive(:add).with(p.port).once
        subject.start(p)
      end
    end

  end
end
