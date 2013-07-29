require 'spec_helper'
require 'phantom/manager'

module Phantom
  describe Manager do

    subject {Manager}

    describe :start do

      let(:p) { generate_process }
      let(:processes) {[generate_process, generate_process, generate_process ]}

      it "should start new phantom process" do
        processes.each {|p| p.should_receive :start}
        subject.start(processes)
      end

      it "should add port to nginx conf" do
        Nginx::Manager.should_receive(:add).with(processes.map(&:port)).once
        subject.start(processes)
      end
    end
  end
end
